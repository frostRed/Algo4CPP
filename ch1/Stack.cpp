#include <iostream>
using std::cout;
using std::cin;
using std::endl;
#include <string>
using std::string;
#include <sstream>
using std::istringstream;



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
    Stack<string>* s = new Stack<string>();

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

    delete s;
}
