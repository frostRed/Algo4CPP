#include <iostream>
using std::cout;
using std::endl;
#include <string>
using std::string;
#include <algorithm>
#include <cassert>

bool circular(const string&, const string&);

int main() {
    string a("TGACGAC");
    string b("ACTGACG");
    circular(a, b);
    assert(circular(a, b) == true);
}

bool circular(const string& s1, const string& s2) {
    string::size_type pos = 0;
    string first_alph = s2.substr(0, 1);
    while ((pos = s1.find(first_alph, pos)) != string::npos) {
        //cout << s1.substr(pos) + s1.substr(0, pos) << std::endl;
        if (s1.substr(pos) + s1.substr(0, pos) == s2) {
            return true;
        }
        ++pos;
    }
}

