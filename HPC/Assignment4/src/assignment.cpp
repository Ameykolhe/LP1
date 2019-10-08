#include <iostream>
#include <vector>
#include <cstdlib>
#include <algorithm>
#include <chrono>

#include "tree.h"
#include "binary_search.h"
#include "bfs.h"
#include "dfs.h"

using namespace std;
using namespace std::chrono;

int main() {

    int N = 1024*1024;

    vector<int> arr;

    for(int i =0; i < N; i++) {
        arr.push_back(i);
    }

    random_shuffle(arr.begin(), arr.end());

    Tree tree;

    for(int i = 0; i < N; i++) {
        tree.insertNode(arr[i]);
    }

    sort(arr.begin(), arr.end());

    cout<<"------------------------------------------------------------------------\n\n"<<endl;
    cout<<"------------------- Binary Search\n"<<endl;

    auto timer_start = high_resolution_clock::now();
    if(binary_search_serial(arr, 1000)) {
        cout<<"Found"<<endl;
    }
    else {
        cout<<"Not Found"<<endl;
    }
    auto timer_stop = high_resolution_clock::now();
    cout<<"\nTime Serial : "<<duration_cast<microseconds>(timer_stop - timer_start).count()<<" micro seconds\n"<<endl;



    return 0;
}