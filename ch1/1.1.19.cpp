#include <iostream>
using std::cout;
using std::endl;
#include <vector>
using std::vector;

using std::to_string;

long long F(int N);

int main() {
    for (int N = 0; N != 100; ++N) {
        cout << to_string(N) + " " + to_string(F(N)) << endl;
    }
}

long long F(int N) {
    int size = N < 2 ? 2 : N + 1;
    vector<long long> vi(size, 0);
    vi[1] = 1;
    for (auto beg = vi.begin() + 2; beg != vi.end(); ++beg) {
        *beg = *(beg - 1) + *(beg - 2);
    }
    return vi[N];
}
