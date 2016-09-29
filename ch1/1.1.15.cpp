#include <iostream>
using std::cout;
using std::endl;

#include <algorithm>
using std::count;
#include <vector>
using std::vector;

vector<int> histogram(const vector<int>&, int M);

int main() {
    vector<int> arr{1, 2, 3, 3, 4, 6};
    auto ret = histogram(arr, 8);
    for (auto i: ret)
        cout << i << endl;
}

vector<int> histogram(const vector<int>& arr, int M) {
    vector<int> ret;
    for (int i = 0; i != M; ++i) {
        ret.push_back(count(arr.cbegin(), arr.cend(), i));
    }
    return ret;
}
