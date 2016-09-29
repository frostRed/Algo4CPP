#include <string>
using std::string;
#include <cassert>


template <typename T>
class Quene {
public:
    Quene(): first(nullptr), last(nullptr), N(0) {}

    bool isEmpty() {return first == nullptr;}
    int size() {return N;}
    void enqueue(T item) {
        Node* oldlast = last;
        last = new Node;
        last->item = item;
        last->next = nullptr;
        if (isEmpty()) {
            first = last;
        } else {
            oldlast->next = last;
        }
        ++N;
    }
    T dequeue() {
        T item = first->item;
        Node* oldfirst = first;
        first = first->next;
        if (isEmpty()) {
            last = nullptr;
        }
        --N;
        delete oldfirst;
        return item;
    }

private:
    struct Node {
        T item;
        Node* next;
    };
    Node* first;
    Node* last;
    int N = 0;

};


int main() {
    Quene<string> quene;
    assert(quene.isEmpty());

    quene.enqueue("abc");
    assert(!quene.isEmpty());

    quene.enqueue("def");
    assert(quene.size() == 2);

    quene.enqueue("hij");
    assert(quene.size() == 3);
    assert(quene.dequeue() == "abc");
    assert(quene.dequeue() == "def");
    assert(quene.dequeue() == "hij");
    assert(quene.isEmpty());
}
