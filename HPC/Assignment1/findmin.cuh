#ifndef __FINDMIN_CUH__
#define __FINDMIN_CUH__

__global__ void find_minimum_kernel(float *array, float *min, int *mutex, unsigned int N);

void find_min_cpu(float* h_array, unsigned int N);

void find_min_gpu(float* h_array, unsigned int N);

#endif