#include <string>
using std::string;
#include <cassert>

template <typename T>
class Stack {
public:
    Stack(): first(nullptr), N(0) {}

    bool isEmpty() {return first == nullptr;}
    int size() {return N;}
    void push(T item) {
        Node* oldfirst = first;
        first = new Node();
        first->item = item;
        first->next = oldfirst;
        ++N;
    }
    T pop() {
        if (isEmpty()) {

        } else {
            T item = first->item;
            Node* oldfirst = first;
            first = first->next;
            --N;
            delete oldfirst;
            return item;
        }
    }

private:
    struct Node {
        T item;
        Node* next;
        /*
        Node(): item(T()), next(nullptr) {}
        ~Node() {delete next;}
        Node(const Node&) = delete;
        Node& operator=(const Node&) = delete;
        Node(Node&& n): item(n.item), next(n.next) {n.next = nullptr;}
        Node& operator=(Node&& n) {
            if (this != &rhs) {
                delete next;
                item = n.item;
                next = n.next;
                n.next = nullptr;
            }
            return *this;
        }
        */
    };

    Node* first;
    int N = 0;
};

int main() {
    Stack<string> fStack;
    assert(fStack.isEmpty());

    fStack.push("abc");
    assert(!fStack.isEmpty());

    fStack.push("edf");
    assert(fStack.size() == 2);

    fStack.push("hij");
    assert(fStack.size() == 3);
    assert(fStack.pop() == "hij");
    assert(fStack.pop() == "edf");
    assert(fStack.pop() == "abc");
    assert(fStack.isEmpty());
}
