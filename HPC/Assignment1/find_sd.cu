#include "assignmentHPC1.cuh"

#include <iostream>
#include <cstdlib>
#include <chrono>
#include <cmath>

using namespace std;
using namespace std::chrono;


double find_sd_cpu(double *arr_host, unsigned int N) {

    double mean = 0.0f;

    for(unsigned int i = 0; i < N; i++) {
        mean += arr_host[i];
    }

    mean /= N;

    double result = 0.0f;

    for(unsigned int i = 0; i < N; i++) {
        result += pow(arr_host[i] - mean, 2);
    }

    result = sqrt(result/N);

    return result;
}


void find_sd(double *arr_host, unsigned int N) {

    // ----------------------------------------- CPU Code -------------------------------------------------

    auto startCPU = high_resolution_clock::now();
    double result = find_sd_cpu(arr_host, N);
    auto stopCPU = high_resolution_clock::now();

    cout<<"\n\n--------------- CPU ---------------\n"<<endl;
    cout<<"Answer CPU : "<<result<<endl;
    cout<<"\nTime on CPU : "<<duration_cast<microseconds>(stopCPU - startCPU).count()/1000<<" milli seconds\n\n"<<endl;
}