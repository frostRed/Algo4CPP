#include <iostream>

int main() {
    int f = 0;
    int g = 1;
    for (int i = 0; i != 16; ++i) {
        std::cout << f << std::endl;
        f = f + g;
        g = f - g;
    }
}
