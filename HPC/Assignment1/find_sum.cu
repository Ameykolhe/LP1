#include "assignmentHPC1.cuh"

#include <iostream>
#include <cstdlib>
#include <chrono>

using namespace std;
using namespace std::chrono;

__global__ void reduce(float *input, float *output, unsigned int n) {

    unsigned int block_size = blockDim.x;
    unsigned int thread_id = threadIdx.x;
    unsigned int block_id = blockIdx.x;

    unsigned int block_start = block_id * block_size * 2 + thread_id;

    for (unsigned int stride = block_size; stride > 0; stride /= 2) {
        
        if (thread_id < stride && block_start + stride < n) {
        
            input[block_start] += input[block_start + stride];
        }
        
        __syncthreads();
    }

    if (!thread_id) {
        output[block_id] = input[block_start];
    }
}


double find_sum_cpu(double *arr_host, unsigned int N) {

    double result = 0.0f;

    cout<<"N : "<<N<<endl;

    for(unsigned int i = 0; i < N; i++) {
        result += arr_host[i];
    }

    return result;
}


void find_sum(double *arr_host, unsigned int N) {

    // ----------------------------------------- CPU Code -------------------------------------------------
    
    auto startCPU = high_resolution_clock::now();
    double result = find_sum_cpu(arr_host, N);
    auto stopCPU = high_resolution_clock::now();

    cout<<"\n\n--------------- CPU ---------------\n"<<endl;
    cout<<"Answer CPU : "<<result<<endl;
    cout<<"\nTime on CPU : "<<duration_cast<microseconds>(stopCPU - startCPU).count()/1000<<" milli seconds\n\n"<<endl;


    // ----------------------------------------- GPU Code -------------------------------------------------

}