#include <iostream>
#define __PRIVATE_DEBUGE
#include <Dev\11\map.hpp>

using namespace std;

int main()
{
    myDS::map<int,int> testMP;
    while(1)
    {
        cout << ">>>";
        string s;
        cin >> s;
        if(s == "im") {
            int t;
            cin >> t;
            testMP.insert(t);
        } else if(s == "is") {
            int t,v;
            cin >> t >> v;
            testMP.insert(t,v);
        } else if(s == "p") {
            std::cout << "===DFS  Order===\n";
            testMP.printDfsOrder();
            std::cout << "===Iter Order===\n";
            testMP.printIterOrder();
            for(auto x:testMP) cout << "[" <<  x.first << " " << x.second << "] ";
            cout << "\n";
        } else if(s == "d") {
            int t;
            cin >> t;
            cout << testMP.erase(t) << "\n"; 
        } else if(s == "f") {
            int t;
            cin >> t;
            cout << testMP[t] << "\n";
        } else if(s == "m") {
            int t,v;
            cin >> t >> v;
            testMP[t] = v;
        }
    }
}
/*
>>>is 1 3
>>>is 2 5
>>>is 3 7
>>>im 4
>>>p
===DFS  Order===
[2 : 5] [1 : 3] [NIL]
[NIL]
[3 : 7] [NIL]
[4 : 0] [NIL]
[NIL]
===Iter Order===
[NIL]
[1 : 3] [NIL]
[2 : 5] [NIL]
[3 : 7] [NIL]
[4 : 0] [NIL]
[1 3] [2 5] [3 7] [4 0]
>>>f 2
5
>>>m 2 1145
>>>p
===DFS  Order===
[2 : 1145] [1 : 3] [NIL]
[NIL]
[3 : 7] [NIL]
[4 : 0] [NIL]
[NIL]
===Iter Order===
[NIL]
[1 : 3] [NIL]
[2 : 1145] [NIL]
[3 : 7] [NIL]
[4 : 0] [NIL]
[1 3] [2 1145] [3 7] [4 0]
>>>d 2
1
>>>p
===DFS  Order===
[3 : 7] [1 : 3] [NIL]
[NIL]
[4 : 0] [NIL]
[NIL]
===Iter Order===
[NIL]
[1 : 3] [NIL]
[3 : 7] [NIL]
[4 : 0] [NIL]
[1 3] [3 7] [4 0]

*/