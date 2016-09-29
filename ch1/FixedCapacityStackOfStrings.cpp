#include <string>
using std::string;
#include <cassert>

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
    FixedCapacityStackOfStrings fStack(20);
    assert(fStack.isEmpty());

    fStack.push("abc");
    assert(!fStack.isEmpty());

    fStack.push("edf");
    assert(fStack.size() == 2);
    assert(fStack.pop() == "edf");
}
