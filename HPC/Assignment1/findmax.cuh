#ifndef __FINDMAX_CUH__
#define __FINDMAX_CUH__

__global__ void find_maximum_kernel(float *array, float *max, int *mutex, unsigned int N);

void find_max_cpu(float* h_array, unsigned int N);

void find_max_gpu(float* h_array, unsigned int N);

#endif



