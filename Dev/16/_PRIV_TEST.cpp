#include <iostream>
#define __PRIVATE_DEBUGE
#include <Dev\16\Huffman_tree.hpp>
using namespace std;

int main()
{
    string s;
    cin >> s;
    myDS::huffmanEncoder hfe(s);
    for(auto x:hfe.encode(s)) cout << (bool)x << " ";
    cout << "\n";
    for(auto x:hfe.decode(hfe.encode(s))) cout << x << " ";
    cout << "\n";
    system("pause");
}

/*
aaaaaabbbcccd
1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 0 1
a a a a a a b b b c c c d
*/