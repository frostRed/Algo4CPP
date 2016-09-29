#include <iostream>
using std::cout;
using std::cin;
using std::endl;
#include <string>
using std::string;
#include <sstream>
using std::istringstream;


class FixedCapacityStackOfStrings {
public:
    FixedCapacityStackOfStrings(int cap): a(new string[cap]), N(0), capacity(cap) {}
    FixedCapacityStackOfStrings(const FixedCapacityStackOfStrings& stack): a(new string[stack.capacity]),
        N(stack.N), capacity(stack.capacity) {
            for (int i = 0; i != stack.N; ++i) {
                a[i] = stack.a[i];
            }
    }
    FixedCapacityStackOfStrings& operator=(const FixedCapacityStackOfStrings& stack) {
        string* tmp = new string[stack.capacity];
        for (int i = 0; i != stack.N; ++i) {
            tmp[i] = stack.a[i];
        }
        delete [] a;
        a = tmp;
        N = stack.N;
        capacity = stack.capacity;
        return *this;
    }
    
    bool isEmpty() {return N == 0;}
    int size() {return N;}
    void push(const string s) {a[N++] = s;}
    string pop() {return a[--N];}

    ~FixedCapacityStackOfStrings() {delete [] a;}

private:
    string* a = nullptr;
    int N = 0;
    int capacity = 0;
};


int main() {
    FixedCapacityStackOfStrings* s;
    s = new FixedCapacityStackOfStrings(100);

    string line;
    getline(cin, line);
    istringstream is(line);
    string item;
    while (is >> item) {
        if (item != "-") {
            s->push(item);
        } else if (!s->isEmpty()) {
            cout << s->pop() + " ";
        }
    }
    cout << "(" + std::to_string(s->size()) + " left on stack)" << endl;
}
