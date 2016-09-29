#include <iostream>
#include <string>

int main(int argc, char* argv[]) {
    int val = std::stoi(argv[1]);
    std::string s;
    for (; val != 0; val /= 2)
        s = std::to_string(val % 2) + s;
    std::cout << "0x" + s << std::endl;
}
