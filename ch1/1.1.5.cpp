#include <iostream>
using std::stod;

int main(int argc, char* argv[]) {
    double x = stod(argv[1]);
    double y = stod(argv[2]);
    if (x > 0 && x < 1 &&
            y > 0 && y < 1) {
        std::cout << "true" << std::endl;
    } else {
        std::cout << "false" << std::endl;
    }
    return 0;
}
