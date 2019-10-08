#include "assignmentHPC2.cuh"

#include <iostream>
#include <cstdlib>
#include <chrono>

using namespace std;
using namespace std::chrono;

#define VEC_SIZE 1024*1024*256


__global__ void vec_add_kernel(float *a, float *b, float *c) {

        unsigned int index = blockIdx.x + threadIdx.x;
        
        if(index < VEC_SIZE) {
            c[index] = a[index] + b[index];
        }

}


void vec_add_cpu(float *a, float *b, float *c) {
    for(unsigned int i = 0; i < VEC_SIZE; i++) {
        c[i] = a[i] + b[i];
    }
}


void vec_add() {


    // declare variables
    float *a_host, *b_host, *c_host;
    float *a_device, *b_device, *c_device;

    // allocate memory to host variables
    a_host = (float *)malloc(VEC_SIZE * sizeof(float));
    b_host = (float *)malloc(VEC_SIZE * sizeof(float));
    c_host = (float *)malloc(VEC_SIZE * sizeof(float));

    // initialize host variables
    for(int i = 0; i < VEC_SIZE; i++) {
        a_host[i] = 1.0f ;//1024*1024 * float(rand())/RAND_MAX;
        b_host[i] = 1.0f ;//1024*1024 * float(rand())/RAND_MAX;
    }
    

    cout<<"INPUT SIZE "<<endl;
    cout<<"Vector A : "<<VEC_SIZE<<" * "<<1<<endl;


    // ----------------------------------------- CPU Code -------------------------------------------------
    

    // call vec_add_cpu function
    auto startCPU = high_resolution_clock::now();
    vec_add_cpu(a_host, b_host, c_host);
    auto stopCPU = high_resolution_clock::now();

    // Display Results
    cout<<"\n\n--------------- CPU ---------------\n"<<endl;
    cout<<"Answer CPU : \n"<<endl;
    for(int i = 0; i < 5; i++) {
        cout<<a_host[i]<<" + "<<b_host[i]<<" = "<<c_host[i]<<endl;
    }
    cout<<"\nTime on CPU : "<<duration_cast<microseconds>(stopCPU - startCPU).count()/1000<<" milli seconds\n\n"<<endl;

    free(c_host);




    // ----------------------------------------- GPU Code -------------------------------------------------


    // allocate memory to device vairables
    cudaMalloc(&a_device, VEC_SIZE * sizeof(float));
    cudaMalloc(&b_device, VEC_SIZE * sizeof(float));
    cudaMalloc(&c_device, VEC_SIZE * sizeof(float));

    // copy data from host to device
    cudaMemcpy(a_device, a_host, VEC_SIZE * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(b_device, b_host, VEC_SIZE * sizeof(float), cudaMemcpyHostToDevice);

    // set up timing variables
	float gpu_elapsed_time;
	cudaEvent_t gpu_start, gpu_stop;

	cudaEventCreate(&gpu_start);
	cudaEventCreate(&gpu_stop);


	// call kernel
	cudaEventRecord(gpu_start, 0);

    // call Kernel
    dim3 blockSize(1024);
    dim3 gridSize(1024);

    auto startGPU = high_resolution_clock::now();
    vec_add_kernel<<<gridSize, blockSize>>>(a_device, b_device, c_device);

    cudaEventRecord(gpu_stop, 0);
	cudaEventSynchronize(gpu_stop);
	cudaEventElapsedTime(&gpu_elapsed_time, gpu_start, gpu_stop);

	cudaEventDestroy(gpu_start);
	cudaEventDestroy(gpu_stop);

    // copy results from device to host
    c_host = (float *)malloc(VEC_SIZE * sizeof(float));
    cudaMemcpy(c_host, c_device, VEC_SIZE * sizeof(float), cudaMemcpyDeviceToHost);

    // Display Results
    cout<<"--------------- GPU ---------------\n"<<endl;
    cout<<"Answer GPU : \n"<<endl;
    for(int i = 0; i < 5; i++) {
        cout<<a_host[i]<<" + "<<b_host[i]<<" = "<<c_host[i]<<endl;
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
