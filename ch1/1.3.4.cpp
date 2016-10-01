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
#include <map>
using std::map;


template <typename T>
class Stack {
public:
    Stack(): first(nullptr), N(0) {}

    bool isEmpty() {return first == nullptr;}
    int size() {return N;}
    void push(T item) {
        shared_ptr<Node> oldfirst = first;
        first = make_shared<Node>(Node());
        first->item = item;
        first->next = oldfirst;
        ++N;
    }
    T pop() {
        if (isEmpty()) {

        } else {
            T item = first->item;
            shared_ptr<Node> oldfirst = first;
            first = first->next;
            --N;
            return item;
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
    Stack<char> a = Stack<char>();
    map<char, char> m{
                        {'}', '{'},
                        {']', '['},
                        {')', '('} };
    char item;
    while ((item = cin.get()) != EOF) {
        if (item == '{' || item == '[' || item == '(') {
            a.push(item);
        } else if (item == '}' || item == ']' || item == ')') {
            if (m[item] != a.pop()) {
                cout << "false" << endl;
                return 0;
            }

        }
    }
    cout << "true" << endl;
    return 0;
}
