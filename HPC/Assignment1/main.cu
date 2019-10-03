#include "findmax.cuh"
#include "findmin.cuh"
#include "copy.cuh"

#include <iostream>
#include <cstdlib>

using namespace std;


int main(){
	unsigned int N = 1024*1024*1024;
	float *h_array;

	// allocate memory
	cout<<"\n\n**************      Loading  Data      *****************\n"<<endl;
	cout<<"Array Size : "<<N<<endl;

	h_array = (float*)malloc(N*sizeof(float));

	// fill host array with data
	for(unsigned int i=0;i<N;i++){
		h_array[i] = 10.0f + N*float(rand()) / RAND_MAX;
	}

	// run find_max gpu version
	find_max_gpu(h_array, N);

	// run find_max cpu version
	find_max_cpu(h_array, N);

	// run find_min gpu version
	find_min_gpu(h_array, N);

	// run find_min cpu version
	find_min_cpu(h_array, N);

	// free memory
	free(h_array);

}


