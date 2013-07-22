#include <iostream>
#include <random>
#include <string>

using namespace std;

string makeChars()
{
    string rval;
    for (char c='a'; c<='z'; ++c) rval+=c;
    for (char c='A'; c<='Z'; ++c) rval+=c;
    for (char c='0'; c<='9'; ++c) rval+=c;
    rval+="_-+";
    return rval;
}

char randomChar()
{
    static mt19937 rng{random_device{}()};
    static string chars = makeChars();
    static uniform_int_distribution<int> dist(0,chars.size()-1);
    return chars[dist(rng)];
}

int main(int argc, char** argv)
{
    for (int i=0; i<8; ++i) cout << randomChar();
    cout << endl;
}
