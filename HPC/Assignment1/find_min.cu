#include "assignmentHPC1.cuh"

#include <iostream>
#include <cstdlib>
#include <chrono>

using namespace std;
using namespace std::chrono;


double find_min_cpu(double *arr_host, unsigned int N) {

    double result = numeric_limits<int>::max();

    for(unsigned int i = 0; i < N; i++) {
        if(arr_host[i] < result) {
            result = arr_host[i];
        }
    }

    return result;
}


void find_min(double *arr_host, unsigned int N) {
    
    
    // ----------------------------------------- CPU Code -------------------------------------------------

    auto startCPU = high_resolution_clock::now();
    double result = find_min_cpu(arr_host, N);
    auto stopCPU = high_resolution_clock::now();

    cout<<"\n\n--------------- CPU ---------------\n"<<endl;
    cout<<"Answer CPU : "<<result<<endl;
    cout<<"\nTime on CPU : "<<duration_cast<microseconds>(stopCPU - startCPU).count()/1000<<" milli seconds\n\n"<<endl;


    // ----------------------------------------- GPU Code -------------------------------------------------

    
}