#include "copy.cuh"
#include <iostream>
#include <cstdlib>
#include <ctime>
#include <float.h>

using namespace std;


__global__ void find_minimum_kernel(float *array, float *min, int *mutex, unsigned int N,float *min_arr)
{
	unsigned int index = threadIdx.x + blockIdx.x*blockDim.x;
	unsigned int stride = gridDim.x*blockDim.x;
	unsigned int offset = 0;

    __shared__ float cache[256];
	
	/*
	for(int i=0; i<N; i++)
    	cache[i] = FLT_MAX;
	//__syncthreads();
	*/

	float temp = FLT_MAX;
	while(index + offset < N){
		temp = fminf(temp, array[index + offset]);
		min_arr[index]=temp;
		offset += stride;
	}

	cache[threadIdx.x] = temp;

	__syncthreads();


	// reduction
	unsigned int i = blockDim.x/2;
	while(i != 0){
		if(threadIdx.x < i){
			cache[threadIdx.x] = fminf(cache[threadIdx.x], cache[threadIdx.x + i]);
		}

		__syncthreads();
		i /= 2;
	}

	if(threadIdx.x == 0){
		while(atomicCAS(mutex,0,1) != 0);  //lock
		*min = fminf(*min, cache[0]);
		atomicExch(mutex, 0);  //unlock
	}
}


void find_min_gpu(float* h_array, unsigned int N){
	cout<<"\n\n************** Computing Min using GPU *****************\n\n";

	float *d_array;
	float *h_min;
	float *d_min;
	float *min_arr;
	int *d_mutex;

    float *h_min_arr;

	// allocate memory
	h_min = (float*)malloc(sizeof(float));
    h_min_arr = (float*)malloc(N*sizeof(float));

	cudaMalloc((void**)&d_array, N*sizeof(float));
    cudaMalloc((void**)&d_min, sizeof(float));
    cudaMalloc((void**)&min_arr, N*sizeof(float));
	cudaMalloc((void**)&d_mutex, sizeof(int));

	// initialize values
	cudaMemset(d_min, 0, sizeof(float));
	cudaMemset(d_mutex, 0, sizeof(float));

	// copy from host to device
	cudaMemcpy(d_array, h_array, N*sizeof(float), cudaMemcpyHostToDevice);

	// set up timing variables
	float gpu_elapsed_time;
	cudaEvent_t gpu_start, gpu_stop;

	cudaEventCreate(&gpu_start);
	cudaEventCreate(&gpu_stop);


	// call kernel
	cudaEventRecord(gpu_start, 0);

	dim3 gridSize = 256;
	dim3 blockSize = 256;

	find_minimum_kernel<<< gridSize, blockSize >>>(d_array, d_min, d_mutex, N,min_arr);

	// copy from device to host
	cudaMemcpy(h_min, d_min, sizeof(float), cudaMemcpyDeviceToHost);
    cudaMemcpy(h_min_arr, min_arr, N*sizeof(float), cudaMemcpyDeviceToHost);


	cudaEventRecord(gpu_stop, 0);
	cudaEventSynchronize(gpu_stop);
	cudaEventElapsedTime(&gpu_elapsed_time, gpu_start, gpu_stop);

	cudaEventDestroy(gpu_start);
	cudaEventDestroy(gpu_stop);


	//report results
	cout<<"Minimum number found on gpu was: "<<*h_min<<endl;
	cout<<"The gpu took: "<<gpu_elapsed_time<<" milli-seconds"<<endl;

    for(int i=0;i<N;i++)
    {
        cout<<min_arr[i]<<" ";
    }
	// free memory
    free(h_min);
    free(h_min_arr);

	cudaFree(d_array);
	cudaFree(d_min);
    cudaFree(d_mutex);
    cudaFree(min_arr);
    
    
	
}


void find_min_cpu(float* h_array, unsigned int N){
	cout<<"\n\n************** Computing Min using CPU *****************\n\n";

	float* h_min = (float*)malloc(sizeof(float));


	clock_t cpu_start = clock();

	*h_min = 3.40282e+38f;
	for(unsigned int i=0;i<N;i++){
		if(h_array[i] < *h_min){
			*h_min = h_array[i];
		}
	}

	clock_t cpu_stop = clock();
	clock_t cpu_elapsed_time = 1000*(cpu_stop - cpu_start)/CLOCKS_PER_SEC;


	cout<<"Minimum number found on cpu was: "<<*h_min<<endl;
	cout<<"The cpu took: "<<cpu_elapsed_time<<" milli-seconds\n"<<endl;

	// free memory
	free(h_min);
}
