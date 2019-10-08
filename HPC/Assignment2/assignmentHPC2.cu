#include "assignmentHPC2.cuh"

#include <iostream>

using namespace std;


int main() {

    cout<<"\n\n--------------------------- RESULTS -------------------------------\n"<<endl;

    // Vector Addition on CPU & GPU
    cout<<"\n\n--------------------------- VECT ADD\n\n"<<endl;
    vec_add();


    // Matrix Vector Multiplication on CPU & GPU
    cout<<"\n\n--------------------------- MAT VECT MUL\n\n"<<endl;
    mat_vec_mul();


    // Matrix Multiplication
    cout<<"\n\n--------------------------- MAT MUL\n\n"<<endl;
    mat_mul();

    return 0;

}
