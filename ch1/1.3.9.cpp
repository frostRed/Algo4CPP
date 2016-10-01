// not complete
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
class Stack {
public:
    Stack(): first(nullptr), N(0) {}

    bool isEmpty() {return first == nullptr;}
    int size() {return N;}
    // add from the first node
    void push(T item) {
        shared_ptr<Node> oldfirst = first;
        first = make_shared<Node>(Node());
        first->item = item;
        first->next = oldfirst;
        ++N;
    }
    T pop() {
        if (!isEmpty()) {
            T item = first->item;
            shared_ptr<Node> oldfirst = first;
            first = first->next;
            --N;
            return item;
        }
    }
    T peek() {
        if (!isEmpty()) {
            return first->item;
        }
    }

private:
    struct Node {
        T item;
        shared_ptr<Node> next;
    };

    shared_ptr<Node> first = nullptr;
    int N = 0;
};

int main() {
    Stack<string> val =Stack<string>();
    Stack<string> ops =Stack<string>();

    string line;
    getline(cin, line);
    istringstream is(line);
    string item;
    while (is >> item) {
        if (item == "+" || item == "-" || item == "*" || item == "/") {
            ops.push(item);
        } else if (item == ")") {
            string v = val.pop();
            string o = ops.pop();
            if (o == "+" || o == "-" || o == "*" || o == "/") {
                v = val.pop() + o + v;
            }
            val.push(v);
        } else if (item == "(") ;
        else {
            val.push(item);
        }
    }
    while (!val.isEmpty()) {
        cout << val.pop();
    }
    cout << endl;
}
