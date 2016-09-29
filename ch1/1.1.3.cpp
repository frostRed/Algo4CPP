#include <iostream>
using std::stoi;

int main(int argc, char* argv[]) {
    int i1 = stoi(argv[1]);
    int i2 = stoi(argv[2]);
    int i3 = stoi(argv[3]);
    if (i1 == i2 && i2 == i3) {
        std::cout << "equal" << std::endl;
    } else {
        std::cout << "not equal" << std::endl;
    }
    return 0;
}
