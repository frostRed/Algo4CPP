#include <algorithm>
using std::sort;

#include <iostream>
using std::cin;
using std::cout;
using std::endl;

#include <vector>
using std::vector;

#include <string>
using std::string;

#include <fstream>
using std::ifstream;


int rank(int key, const vector<int>& a);
int new_rank(int key, const vector<int>& a);
int count(int key, const vector<int>& a);

int main(int argc, char* argv[]) {
    ifstream in(argv[1]);
    vector<int> whitelist;
    string word;
    while (in >> word) {
        whitelist.push_back(stoi(word));
    }

    sort(whitelist.begin(), whitelist.end());
    int key= 0;
    while (cin >> key) {
        int i = new_rank(key, whitelist);
        int j = count(key, whitelist);
        for (int index = 0; index != j; ++index) {
            cout << whitelist[i + index] << endl;
        }
    }
}

int rank(int key, const vector<int>& a) {
    int lo = 0;
    int hi = a.size() - 1;

    while (lo <= hi) {
        int mid = lo + (hi - lo) / 2;
        if (key < a[mid]) {
            hi = mid - 1;
        } else if (key > a[mid]) {
            lo = mid + 1;
        } else {
            return mid;
        }
    }
    return -1;
}

int new_rank(int key, const vector<int>& a) {
    int ret = 0;
    for (auto i: a) {
        if (i < key) {
            ++ret;
        } else {
            break;
        }
    }
    return ret;
}

int count(int key, const vector<int>& a) {
    int resu = rank(key, a);
    int ret = 0;
    if (resu < 0) {
        return ret;
    }
    for (int i = 0; a[resu + i] == key; ++i) {
        ++ret;
    }
    for (int i = 1; a[resu - i] == key; ++i) {
        ++ret;
    }
    return ret;
}
