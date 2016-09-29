#include <iostream>
using std::cout;
using std::cin;
using std::endl;
#include <iomanip>
using std::setprecision;
#include <string>
using std::string;
#include <vector>
using std::vector;
#include <sstream>
using std::istringstream;

int main() {
    vector<string> content;
    string name, line;
    int val1 = 0, val2 = 0;
    while (getline(cin, line)) {
        content.push_back(line);
    }
    for (auto &l: content) {
        istringstream in(l);
        in >> name >> val1 >> val2;
        cout << name << "\t" << val1 << "\t" << val2 << "\t";
        cout << setprecision(3) << (val1+0.0)/val2 << endl;
    }

}
