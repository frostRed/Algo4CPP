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


template <typename T>
class Quene {
public:
    Quene(): first(nullptr), last(nullptr), N(0) {}

    bool isEmpty() {return first == nullptr;}
    int size() {return N;}
    void enqueue(T item) {
        shared_ptr<Node> oldlast = last;
        last = make_shared<Node>(Node());
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
        shared_ptr<Node> oldfirst = first;
        first = first->next;
        if (isEmpty()) {
            last = nullptr;
        }
        --N;
        return item;
    }

private:
    struct Node {
        T item;
        shared_ptr<Node> next;
    };
    shared_ptr<Node> first;
    shared_ptr<Node> last;
    int N = 0;

};

int main() {
    shared_ptr<Quene<string>> q(new Quene<string>());

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
}
