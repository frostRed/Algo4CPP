#include <iostream>
using std::cout;
using std::endl;

template <size_t N>
void print_T_mat(const int[][N], size_t M);

int main() {
    int bMat[][4] = {{1, 1, 0, 0},
                    {0, 1, 0, 1},
                    {1, 1, 1, 0},
                    {0 , 0 , 1, 0}};
    print_T_mat(bMat, 4);
}

template <size_t N>
void print_T_mat(const int arr[][N], size_t M) {
    for (size_t i = 0; i != M; ++i) {
        for (size_t j = 0; j != N; ++j) {
                cout << arr[j][i];
        }
        cout << endl;
    }

}
