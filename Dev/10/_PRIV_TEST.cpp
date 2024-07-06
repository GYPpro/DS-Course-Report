#include <iostream>
#include <Dev\10\mySet.h>

using namespace std;

int main()
{
    myDS::set<int> testST;
    while(1)
    {
        string s;
        cin >> s;
        if(s == "i") {
            int t;
            cin >> t;
            testST.insert(t);
        } else if(s == "p") {
            for(auto x:testST) cout << x << " ";
            cout << "\n";
        } else if(s == "d") {
            int t;
            cin >> t;
            cout << testST.erase(t) << "\n"; 
        } else if(s == "f") {
            int t;
            cin >> t;
            cout << testST.find(t) << "\n";
        }
    }
}
/*

i 1
i 2
i 3
i 6
i 5
p
i 6
i 5
p
d 3
d 4
f 2
f 3
f 4


*/