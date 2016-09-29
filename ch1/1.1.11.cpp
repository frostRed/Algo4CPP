#include <iostream>
using std::cout;
using std::endl;

template <size_t SIZE>
void print_bool_mat(const bool[SIZE][SIZE]);
int main() {
    bool bMat[][4] = {{1, 1, 0, 0},
                    {0, 1, 0, 1},
                    {1, 1, 1, 0},
                    {0 , 0 , 1, 0}};
    print_bool_mat(bMat);
}
template <size_t SIZE>
void print_bool_mat(const bool arr[SIZE][SIZE]) {
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
