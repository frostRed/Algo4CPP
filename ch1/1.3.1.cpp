#include <iostream>
using std::cout;
using std::cin;
using std::endl;
#include <string>
using std::string;
#include <sstream>
using std::istringstream;
#include <memory>
using std::shared_ptr;
using std::make_shared;


class FixedCapacityStackOfStrings {
public:
    FixedCapacityStackOfStrings(int cap): a(new string[cap], [](string* p) {delete [] p;}),
        N(0), capacity(cap) {}
    FixedCapacityStackOfStrings(const FixedCapacityStackOfStrings& stack):
        a(new string[stack.capacity], [](string* p) {delete [] p;}),
        N(stack.N), capacity(stack.capacity) {
            for (int i = 0; i != stack.N; ++i) {
                *(a.get() + i) = *(stack.a.get() + i);
            }
    }
    FixedCapacityStackOfStrings& operator=(const FixedCapacityStackOfStrings& stack) {
        shared_ptr<string> tmp(new string[stack.capacity], [](string* p) {delete [] p;});
        for (int i = 0; i != stack.N; ++i) {
            *(tmp.get() + i) = *(stack.a.get() + i);
        }
        a = tmp;
        N = stack.N;
        capacity = stack.capacity;
        return *this;
    }
    
    bool isEmpty() {return N == 0;}
    bool isFull() {return N == capacity;}
    int size() {return N;}
    void push(const string s) {
        *(a.get() + N) = s;
        ++N;
    }
    string pop() {
        --N;
        return *(a.get() + N);
    }

private:
    shared_ptr<string> a = nullptr;
    int N = 0;
    int capacity = 0;
};


int main() {
    shared_ptr<FixedCapacityStackOfStrings> s(new FixedCapacityStackOfStrings(100));

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
