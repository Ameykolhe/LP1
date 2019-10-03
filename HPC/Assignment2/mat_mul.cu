#include "assignmentHPC2.cuh"

#include <iostream>
#include <cstdlib>
#include <chrono>

using namespace std;
using namespace std::chrono;

/*

Matrix A Size : A x B
Matrix B Size : B x C
Matrix C Size : A x C

*/

#define A 3
#define B 2
#define C 4

#define BLOCKSIZE 16


__global__ void mat_mul_kernel(float *a, float *b, float *c) {

    unsigned int row = blockIdx.y * blockDim.y + threadIdx.y;
    unsigned int col = blockIdx.x * blockDim.x + threadIdx.x;
    for (unsigned int e = 0; e < B; e++) {

        c[row * C + col] += a[row * B + e] * b[e * C + col];
    }

}


void mat_mul_cpu(float *a, float *b, float *c) {
   
    for(unsigned int i = 0; i < A; i++) {

        for(unsigned int j = 0; j < C; j++) {
        
            for(unsigned int k = 0; k < B; k++) {
        
                c[C*i + j] += a[B*i + k] * b[k*C + j];
            }
        }
    }

}


void mat_mul() {

    // declare variables
    float *a_host, *b_host, *c_host;
    float *a_device, *b_device, *c_device;

    // allocate memory to host variables
    a_host = (float *)malloc(A * B * sizeof(float));
    b_host = (float *)malloc(B * C * sizeof(float));
    c_host = (float *)malloc(A * C * sizeof(float));

    // initialize host variables
    for(int i = 0; i < A*B; i++) {
        a_host[i] = 1 ;//1024*1024 * float(rand())/RAND_MAX;
    }

    for(int i = 0; i < B*C; i++) {
        b_host[i] = 1 ;//1024*1024 * float(rand())/RAND_MAX;
    }



    // ----------------------------------------- CPU Code -------------------------------------------------
    memset(c_host, 0, A * C * sizeof(float));

    // call vec_add_cpu function
    auto startCPU = high_resolution_clock::now();
    mat_mul_cpu(a_host, b_host, c_host);
    auto stopCPU = high_resolution_clock::now();

    // Display Results
    cout<<"--------------- CPU ---------------\n"<<endl;
    cout<<"Answer CPU : \n"<<endl;
    for(int i = 0; i < A; i++) {
        for(int j = 0; j < C; j++) {
            cout<<c_host[i*A + j]<<" ";
        }
        cout<<endl;
    }
    cout<<"\nTime on CPU : "<<duration_cast<microseconds>(stopCPU - startCPU).count()/1000<<" milli seconds\n\n"<<endl;

    free(c_host);



    // ----------------------------------------- GPU Code -------------------------------------------------


    // allocate memory to device vairables
    cudaMalloc(&a_device, A * B * sizeof(float));
    cudaMalloc(&b_device, B * C * sizeof(float));
    cudaMalloc(&c_device, A * C * sizeof(float));

    // copy data from host to device
    cudaMemcpy(a_device, a_host, A * B * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(b_device, b_host, B * C * sizeof(float), cudaMemcpyHostToDevice);

    cudaMemset(c_device, 2, A * C * sizeof(float));

    // set up timing variables
	float gpu_elapsed_time;
	cudaEvent_t gpu_start, gpu_stop;

	cudaEventCreate(&gpu_start);
    cudaEventCreate(&gpu_stop);
    
    // call kernel
    cudaEventRecord(gpu_start, 0);    

    // call Kernel
    dim3 blockSize(BLOCKSIZE, BLOCKSIZE);
    dim3 gridSize(C / blockSize.x, A / blockSize.y);

    auto startGPU = high_resolution_clock::now();
    mat_mul_kernel<<<gridSize, blockSize>>>(a_device, b_device, c_device);

    cudaEventRecord(gpu_stop, 0);
    cudaEventSynchronize(gpu_stop);
    cudaEventElapsedTime(&gpu_elapsed_time, gpu_start, gpu_stop);

    cudaEventDestroy(gpu_start);
    cudaEventDestroy(gpu_stop);

    cudaEventDestroy(gpu_start);
    cudaEventDestroy(gpu_stop);

    // copy results from device to host
    c_host = (float *)malloc(A * C * sizeof(float));
    cudaMemcpy(c_host, c_device, A * C * sizeof(float), cudaMemcpyDeviceToHost);

    // Display Results
    cout<<"--------------- GPU ---------------\n"<<endl;
    cout<<"Answer GPU : \n"<<endl;
    for(int i = 0; i < A; i++) {
        for(int j = 0; j < C; j++) {
            cout<<c_host[i*A + j]<<" ";
        }
        cout<<endl;
    }
    cout<<"\nTime on GPU : "<<gpu_elapsed_time<<" milli seconds\n\n"<<endl;

    // Free allocated Memory
    free(a_host);
    free(b_host);
    free(c_host);
    cudaFree(a_device);
    cudaFree(b_device);
    cudaFree(c_device);

}

int main() {

    mat_mul();

    return 0;
}