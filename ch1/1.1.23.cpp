#include <iostream>
#include <vector>
using std::vector;
#include <iterator>
#include <fstream>
using std::ifstream;
#include<string>
using std::string;
#include <algorithm>
using std::sort;


int rank(int key, vector<int>::const_iterator, vector<int>::const_iterator);

int main(int argc, char* argv[]) {
    ifstream in(argv[1]);
    vector<int> vi;
    string num;
    if (in) {
        while (in >> num) {
            vi.push_back(std::stoi(num));
        }
    }
    sort(vi.begin(), vi.end());
    int key;
    while (std::cin >> key) {
        if (rank(key, vi.cbegin(), vi.cend()) == key) {
            std::cout << "-" << key << std::endl;
        } else {
            std::cout << "+" << key << std::endl;
        }

    }
}
int rank(int key, vector<int>::const_iterator lo, vector<int>::const_iterator hi) {
    if (lo > hi) return -1;
    auto mid = lo + (hi - lo) / 2;
    if (key < *mid) {
        return rank(key, lo, mid - 1);
    } else if (key > *mid) {
        return rank(key, mid + 1, hi);
    } else {
        return *mid;
    }
}
