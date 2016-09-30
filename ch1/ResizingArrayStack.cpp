#include <string>
using std::string;
#include <cassert>
#include <memory>
using std::shared_ptr;
using std::make_shared;

template <typename T>
class ResizingArrayStack {
public:
    ResizingArrayStack(int cap = 0): a(new T[cap], [](T* p) {delete [] p;}), N(0), capacity(cap) {}
    ResizingArrayStack(const ResizingArrayStack& stack): a(new T[stack.capacity], [](T* p) {delete [] p;}), N(stack.N),
        capacity(stack.capacity) {
            for (int i = 0; i != stack.N; ++i) {
                *(a.get() + i) = *(stack.a.get() + i);
            }
    }
    ResizingArrayStack& operator=(const ResizingArrayStack& stack) {
        decltype(a) tmp(new T[stack.capacity], [](T* p) {delete [] p;});
        for (int i = 0; i != stack.N; ++i) {
            *(a.get() + i) = *(stack.a.get() + i);
        }
        a = tmp;
        N = stack.N;
        capacity = stack.capacity;
    }

    bool isEmpty() {return N == 0;}
    int size() {return N;}
    int cap() {return capacity;}
    void resize(int max) {
        decltype(a) tmp(new T[max], [](T* p) {delete [] p;});
        for (int i = 0; i < N; ++i) {
            *(tmp.get() + i) = *(a.get() + i);
        }
        a = tmp;
        capacity = max;
    }
    void push(T item) {
        if (N == capacity) {
            if (capacity == 0) {
                resize(1);
            } else {
                resize(2 * capacity);
            }
        }
        *(a.get() + N) = item;
        ++N;
    }
    T pop() {
        --N;
        T item = *(a.get() + N);
        if (N > 0 && N == capacity / 4) {
            resize (capacity / 2);
        }
        return item;
    }

private:
    shared_ptr<T> a = nullptr;
    int N = 0; 
    int capacity = 0;
};

int main() {
    ResizingArrayStack<string> fStack;
    assert(fStack.isEmpty());

    fStack.push("abc");
    assert(!fStack.isEmpty());

    fStack.push("edf");
    assert(fStack.size() == 2);

    fStack.push("hij");
    assert(fStack.size() == 3);
    assert(fStack.cap() == 4);
    assert(fStack.pop() == "hij");
}
