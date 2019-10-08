#include "assignmentHPC1.cuh"

#include <iostream>
#include <cstdlib>

using namespace std;

int main() {

    unsigned int N = 1024*1024*512;

    double *arr_host = (double *)malloc(N * sizeof(double));

    for(unsigned int i = 0; i < N; i++) {
        arr_host[i] = 1 ;//rand()%(1024*1024) + 10;
    }


    cout<<"\n\n---------------------------------- RESULTS --------------------------------------\n"<<endl;

    cout<<"INPUT SIZE "<<endl;
    cout<<"Vector Size : "<<N<<" * "<<1<<endl;

    // Vector Maximun on CPU & GPU
    cout<<"\n\n---------------------------------- MAX\n\n"<<endl;
    find_max(arr_host, N);

    // Vector Minimum on CPU & GPU
    cout<<"\n\n---------------------------------- MIN\n\n"<<endl;
    find_min(arr_host, N);

    // Vector Sum on CPU & GPU
    cout<<"\n\n---------------------------------- SUM\n\n"<<endl;
    find_sum(arr_host, N);

    // Standard Deviation on CPU & GPU
    cout<<"\n\n---------------------------------- SD\n\n"<<endl;
    find_sd(arr_host, N);

    return 0;
}