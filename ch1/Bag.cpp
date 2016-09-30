#include <string>
using std::string;
#include <cassert>
#include <memory>
using std::shared_ptr;
using std::make_shared;

//class Ite;

template <typename T>
class Bag {
    //friend class Ite;
public:
    Bag(): first(nullptr), N(0) {}

    bool isEmpty() {return first == nullptr;}
    int size() {return N;}
    void add(T item) {
        shared_ptr<Node> oldfirst = first;
        first = make_shared<Node>(Node());
        first->item = item;
        first->next = oldfirst;
        ++N;
    }

    //Ite begin();
    //Ite end();

private:
    struct Node {
        T item;
        shared_ptr<Node> next;
    };
    shared_ptr<Node> first;
    int N = 0;
};

/*
class Ite {
    friend bool operator== (const Ite&, const Ite&);
    friend bool operator!= (const Ite&, const Ite&);
public:
    Ite(): current(nullptr) {};
    Ite(const Node* cur): current(cur) {};
    Ite& operator++() {
        current = current->next;
        return *this;
    }
    Ite operator++(int) {
        Ite ret = *this;
        ++*this;
        return ret;
    }
    Node& operator*() const {
        return *(this->current);
    }

private:
    Node* current;
};
bool Ite::operator== (const Ite& lhs, const Ite& rhs) {
    return lhs.current == rhs.current;
}
bool Ite::operator!= (const Ite& lhs, const Ite& rhs) {
    return !(lhs == rhs);
}


template<typename T>
Ite Bag<T>::begin() {
    return Ite(first);
}
template<typename T>
Ite Bag<T>end() {
    return Ite();
}
*/



int main() {
    Bag<string> bag;
    assert(bag.isEmpty());

    bag.add("abc");
    assert(!bag.isEmpty());

    bag.add("edf");
    assert(bag.size() == 2);
}
