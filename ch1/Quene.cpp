#include <iostream>
using std::cout;
using std::cin;
using std::endl;
#include <string>
using std::string;
#include <sstream>
using std::istringstream;



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
    Quene<string>* q = new Quene<string>();

    string line;
    getline(cin, line);
    istringstream is(line);
    string item;
    while (is >> item) {
        if (item != "-") {
            q->enqueue(item);
        } else if (!q->isEmpty()) {
            cout << q->dequeue() + " ";
        }
    }
    cout << "(" + std::to_string(q->size()) + " left on stack)" << endl;
    
    delete q;
}
