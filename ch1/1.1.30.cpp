#include <iostream>
using std::cout;
using std::endl;
#include <cmath>

template <typename T, size_t SIZE>
void print_bool_mat(const T[SIZE][SIZE]);
bool primer(int i, int j);
int gcd(int a, int b);

int main() {
    constexpr int N = 20;
    bool mat[N][N];
    for (int i = 0; i != N; ++i) {
        for (int j = 0; j != N; ++j) {
            if (primer(i, j)) {
                mat[i][j] = true;
                //cout << "[" << i << "," << j << "]" << endl;
            } else {
                mat[i][j] = false;
            }
        }
    }
    print_bool_mat(mat);

}


template <typename T, size_t SIZE>
void print_bool_mat(const T arr[SIZE][SIZE]) {
    for (size_t i = 0; i != SIZE; ++i) {
        for (size_t j = 0; j != SIZE; ++j) {
            if (arr[i][j]) {
                cout << "*";
            } else {
                cout << " ";
            }
        }
        cout << endl;
    }

}
bool primer(int i, int j) {
    if (i == 0 || j == 0 ||i == j) return false;
    int a = (i > j) ? i : j;
    int b = (a == i) ? j : i;
    if (gcd(a, b) == 1) return true;
    return false;
}

int gcd(int a, int b) {
    if (b == 0) {
        return a;
    }
    return gcd(b, a % b);
}

