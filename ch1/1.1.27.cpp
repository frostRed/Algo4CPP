// not complete
#include <iostream>
using std::cout;
using std::endl;
double binomial(int N, int k, double p);

static int i = 0;
double binomial(int N, int k, double p) {
    ++i;
    if (N == 0 && k == 0) {
        return 1.0;
    }
    if (N < 0 || k < 0) {
        return 0.0;
    }
    return (1.0 - p) * binomial(N - 1, k, p) + 
        p * binomial(N - 1, k - 1, p);
}

int main() {
    double ret = binomial(100, 50, 0.25);
    cout << i << endl;

}
