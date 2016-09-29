#include <string>
using std::string;
#include <cassert>

template <typename T>
class ResizingArrayStack {
public:
    ResizingArrayStack(int cap = 0): a(new T[cap]), N(0), capacity(cap) {}
    ~ResizingArrayStack() {delete [] a;}
    ResizingArrayStack(const ResizingArrayStack& stack): a(new T[stack.capacity]), N(stack.N),
        capacity(stack.capacity) {
            for (int i = 0; i != stack.N; ++i) {
                a[i] = stack.a[i];
            }
    }
    ResizingArrayStack& operator=(const ResizingArrayStack& stack) {
        T* tmp = new T[stack.capacity];
        for (int i = 0; i != stack.N; ++i) {
            a[i] = stack.a[i];
        }
        delete [] a;
        a = tmp;
        N = stack.N;
        capacity = stack.capacity;
    }


    bool isEmpty() {return N == 0;}
    int size() {return N;}
    int cap() {return capacity;}
    void resize(int max) {
        T* temp = new T[max];
        for (int i = 0; i < N; ++i) {
            temp[i] = a[i];
        }
        delete [] a;
        a = temp;
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
        a[N++] = item;
    }
    T pop() {
        T item = a[--N];
        if (N > 0 && N == capacity / 4) {
            resize (capacity / 2);
        }
        return item;
    }

private:
    T* a = new T[0];
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
