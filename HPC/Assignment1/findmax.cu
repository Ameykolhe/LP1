#include "findmax.cuh"

#include<float.h>
#include <iostream>
#include <cstdlib>
#include <ctime>
#include <limits>

using namespace std;


__global__ void find_maximum_kernel(float *array, float *max, int *mutex, unsigned int N)
{
	unsigned int index = threadIdx.x + blockIdx.x*blockDim.x;
	unsigned int stride = gridDim.x*blockDim.x;
	unsigned int offset = 0;

	__shared__ float cache[256];


	float temp = FLT_MIN;
	while(index + offset < N){
		temp = fmaxf(temp, array[index + offset]);

		offset += stride;
	}

	cache[threadIdx.x] = temp;

	__syncthreads();


	// reduction
	unsigned int i = blockDim.x/2;
	while(i != 0){
		if(threadIdx.x < i){
			cache[threadIdx.x] = fmaxf(cache[threadIdx.x], cache[threadIdx.x + i]);
		}

		__syncthreads();
		i /= 2;
	}

	if(threadIdx.x == 0){
		while(atomicCAS(mutex,0,1) != 0);  //lock
		*max = fmaxf(*max, cache[0]);
		atomicExch(mutex, 0);  //unlock
	}
}


void find_max_gpu(float* h_array, unsigned int N){
	cout<<"\n\n************** Computing Max using GPU *****************\n\n";

	float *d_array;
	float *h_max;
	float *d_max;
	int *d_mutex;


	// allocate memory
	h_max = (float*)malloc(sizeof(float));

	cudaMalloc((void**)&d_array, N*sizeof(float));
	cudaMalloc((void**)&d_max, sizeof(float));
	cudaMalloc((void**)&d_mutex, sizeof(int));

	// initialize values
	cudaMemset(d_max, 0, sizeof(float));
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

	find_maximum_kernel<<< gridSize, blockSize >>>(d_array, d_max, d_mutex, N);

	// copy from device to host
	cudaMemcpy(h_max, d_max, sizeof(float), cudaMemcpyDeviceToHost);


	cudaEventRecord(gpu_stop, 0);
	cudaEventSynchronize(gpu_stop);
	cudaEventElapsedTime(&gpu_elapsed_time, gpu_start, gpu_stop);

	cudaEventDestroy(gpu_start);
	cudaEventDestroy(gpu_stop);


	//report results
	cout<<"Maximum number found on gpu was: "<<*h_max<<endl;
	cout<<"The gpu took: "<<gpu_elapsed_time<<" milli-seconds"<<endl;

	// free memory
	free(h_max);

	cudaFree(d_array);
	cudaFree(d_max);
	cudaFree(d_mutex);
	
}


void find_max_cpu(float* h_array, unsigned int N){
	cout<<"\n\n************** Computing Max using CPU *****************\n\n";

	float* h_max = (float*)malloc(sizeof(float));


	clock_t cpu_start = clock();

	*h_max = 1.17549e-38;
	for(unsigned int i=0;i<N;i++){
		if(h_array[i] > *h_max){
			*h_max = h_array[i];
		}
	}

	clock_t cpu_stop = clock();
	clock_t cpu_elapsed_time = 1000*(cpu_stop - cpu_start)/CLOCKS_PER_SEC;


	cout<<"Maximum number found on cpu was: "<<*h_max<<endl;
	cout<<"The cpu took: "<<cpu_elapsed_time<<" milli-seconds\n"<<endl;

	// free memory
	free(h_max);
}
