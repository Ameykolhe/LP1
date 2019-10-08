#include "binary_search.h"

bool binary_search_serial(vector<int> arr, int key) {
    int l = 0, r = arr.size()-1;
    while(l <= r) {
        int m = (l + r)/2;
        if(arr[m] == key) {
            return true;
        }
        if(arr[m] < key) {
            l = m + 1;
        }
        else {
            r = m - 1;
        }
    }

    return false;
}

bool binary_search_parallel(int *arr, int key) {

}