#include <iostream>

int gcd(int p, int q);

int main() {
    int g1 = gcd(105, 24);
    int g2 = gcd(111111, 1234567);
    std::cout << "-------" << std::endl;
    std::cout << g1 << " " << g2 << std::endl;
}

int gcd(int p, int q) {
    std::cout << p << " " << q << std::endl;
    if (!q) {
        return p;
    } else {
        return gcd(q, p % q);
    }
}
