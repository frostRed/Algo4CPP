#include <memory>
using std::shared_ptr;
using std::make_shared;
#include <iostream>
using std::cin;
using std::cout;
using std::endl;

class UF {
public:
    UF(int N = 0): id(new int[N], [](int* p) {delete [] p;}), cnt(N), cap(N) {
        for (int i = 0; i != N; ++i) {
            *(id.get() + i) = i;
        }
    }

    int count() {
        return cnt;
    }
    bool connected(int p, int q) {
        return find(p) == find(q);
    }
    int find(int p);
    void uni(int p, int q);

private:
    shared_ptr<int> id;
    int cnt = 0;
    int cap = 0;
};

int UF::find(int p) {
    while (p != *(id.get() + p)) {
        p = *(id.get() + p);
    }
    return p;
}
void UF::uni(int p, int q) {
    int pRoot = find(p);
    int qRoot = find(q);
    if (pRoot != qRoot) {
        *(id.get() + pRoot) = qRoot;
        --cnt;
    }
}

int main() {
    int n = 0;
    cin >> n;
    shared_ptr<UF> uf = make_shared<UF>(UF(n));
    int p = 0, q = 0;
    while (cin >> p >> q) {
        if (uf->connected(p, q)) {
            continue;
        }
        uf->uni(p, q);
        cout << p << " " << q << endl;
    }
    cout << uf->count() << " components" << endl;
}
