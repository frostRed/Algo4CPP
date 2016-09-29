#include <iostream>
#include <cmath>
using std::abs;

int main() {
    double t = 9.0;
    while (abs(t - 9.0 / t) > 0.001) {
        t = (9.0 / t + t) / 2;
    }
    std::cout << t << std::endl;

    int sum = 0;
    for (int i = 1; i != 1000; ++i) {
        for (int j = 0; j != i; ++j) {
            ++sum;
        }
    }
    std::cout << sum << std::endl;

    sum = 0;
    for (int i = 1; i < 1000; i *= 2) {
        for (int j = 0; j < 1000; ++j) {
            ++sum;
        }
    }
    std::cout << sum << std::endl;

}
