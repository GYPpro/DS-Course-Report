#include <iostream>
#define __PRIVATE_DEBUGE
#include <Dev\14\priority_queue.h>
using namespace std;

int main()
{
    myDS::priority_queue<int> piq;
    while(1) {
        string s;
        cin >> s;
        if(s == "push") {
            int t;
            cin >> t;
            piq.push(t);
        } else if(s == "pop") {
            cout << piq.pop() << "\n";
        } else if(s == "top") {
            cout << piq.top() << "\n";
        } else if(s == "p") {
            piq.innerPrint();
        }
    }
}

/*
push 5
push 4
push 1
push 3
push 2
p
0 5 4 1 3 2
pop
5
p
0 4 3 1 2
top
4
pop
4
pop
3
pop
2
pop
1
p
0
*/