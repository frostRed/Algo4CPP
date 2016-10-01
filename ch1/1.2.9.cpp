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
using std::to_string;

#include <fstream>
using std::ifstream;


class Counter;
int rank(int key, const vector<int>& a, Counter&);

class Counter {
public:
    Counter() = default;
    Counter(const string& s): name(s), count(0) {}

    void increment() { ++count; }
    int tally() {return count;}
    string toString() {
        return to_string(0) + " " + name;
    }

private:
    string name;
    int count = 0;
};


int main(int argc, char* argv[]) {
    ifstream in(argv[1]);
    vector<int> whitelist;
    string word;
    while (in >> word) {
        whitelist.push_back(stoi(word));
    }
    sort(whitelist.begin(), whitelist.end());

    int key= 0;
    Counter c;
    while (cin >> key) {
        if (rank(key, whitelist, c) < 0) {
            cout << key << endl;
        }
    }
    cout << "querry " << c.tally() << " times" << endl;
}

int rank(int key, const vector<int>& a, Counter& c) {
    c.increment();
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

