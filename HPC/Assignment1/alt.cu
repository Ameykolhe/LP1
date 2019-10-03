#include <cuda.h>
#include <stdio.h>
#include <time.h>

#define SIZE 1024
__global__ void min(int *a, int *d)
{
    extern __shared__ int sdata[];

    unsigned int tid = threadIdx.x;
    unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;

    sdata[tid] = a[i];

    __syncthreads();
    for(unsigned int s=blockDim.x/2 ; s >= 1 ; s=s/2)
    {
        if(tid < s)
        {
            if(sdata[tid] > sdata[tid + s])
            {
                sdata[tid] = sdata[tid + s];
            }
        }
    __syncthreads();
    }
    if(tid == 0 ) d[blockIdx.x] = sdata[0];
}
////////////////////////////////////////////
__global__ void max(int *a, int *c)
{
    extern __shared__ int sdata[];
    unsigned int tid = threadIdx.x;
    unsigned int i = blockIdx.x*blockDim.x + threadIdx.x;
    sdata[tid] = a[i];

    __syncthreads();

    for(unsigned int s=blockDim.x/2 ; s > 0 ; s>>=1)
    {
        if(tid < s && sdata[tid] < sdata[tid + s])
        {
            sdata[tid] = sdata[tid + s];
        }
        __syncthreads();
    }

    if(tid == 0 ) c[blockIdx.x] = sdata[0];
}
/////////////////////////////////////////

int main()
{
    int i;
    srand(time(NULL));

    int *a;
    a = (int*)malloc(SIZE * sizeof(int));
    int d;
    //int c;

    int *dev_a, *dev_c,*dev_d;

    cudaMalloc((void **) &dev_a, SIZE*sizeof(int));
    cudaMalloc((void **) &dev_c, SIZE*sizeof(int));
    cudaMalloc((void **) &dev_d, SIZE*sizeof(int));

    for( i = 0 ; i < SIZE ; i++)
    {
        a[i] = rand()% 1024 + 1;

    }
    for( i = 0 ; i < SIZE ; i++)
    {
        //printf("%d ",a[i]);

    }
    printf("");

    cudaMemcpy(dev_a , a, SIZE*sizeof(int),cudaMemcpyHostToDevice);
    //max(dev_a,dev_c);
    min<<<1,1024>>>(dev_a,dev_d);

    //cudaMemcpy(&c, dev_c, SIZE*sizeof(int),cudaMemcpyDeviceToHost);
    cudaMemcpy(&d, dev_d, SIZE*sizeof(int),cudaMemcpyDeviceToHost);

    //printf("max  =  %d ",c);
    printf("min  =  %d ",d);

    cudaFree(dev_a);
    //cudaFree(dev_c);
    cudaFree(dev_d);

    printf("");

    return 0;
    }