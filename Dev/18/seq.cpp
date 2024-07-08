#include <iostream>
#include <vector>
#include <stack>
using namespace std;

void solve()
{
    string s;
    cin >> s;
    stack<char> c;
    for(auto x:s) if(c.size()) if((x == ')') && c.top() == '(') c.pop(); else c.push(x); else c.push(x);
    cout << (c.size() == 0 ? "yes" : "no") << "\n";
}

signed main()
{
    while(1)
        solve();
    return 0;
}
/*
()()
yes
()(
no
()())
no
(())
yes
())(
no
(())((()()))
yes
*/