#include <iostream>
#include <vector>
#include <stdlib.h>
#include <map>
#include <algorithm>
#include <stack>
#include <math.h>

using namespace std;
using pii = pair<int,int>;

#define int long long
#define pb push_back
#define F first
#define S second
#define all(x) x.begin(),x.end()
#define loop(i,n) for(int i = 0; i < n; i++)

const int mod = 1e9 + 7;
const int INF = 1e18;

bool ifdigit(string &s){
    if(s.size() >= 2) return 1;
    else return (s[0] > '0' && s[0] < '9');
}

int str2int(string &s) {
    int t = 0;
    for(int i = 0;i < s.size();i ++) {
        t += pow(10LL,i) * (s[s.size()-1-i] - '0');
    } return t;
}

int getPri(string s){
    if(s[0] == '+' || s[0] == '-') return 0;
    else return 1;
}

// 
void solve()
{
    string s;
    cout << ">>>>";
    getline(cin,s);
    // cin.get();
    s.push_back('\n');
    vector<string> RES;
    stack<string> sign,tmpl,rbc;
    string tmp;
    for(auto x:s) {
        if(x == ' ' || x == '\n'){
            if(tmp.size()) RES.push_back(tmp);
            tmp.clear();
        } else tmp.push_back(x);
    }
    for(auto x:RES){
        if(ifdigit(x)) tmpl.push(x);
        else{
            if(x[0] == '(') sign.push(x);
            else if(x[0] == ')') {
                while(sign.top()[0] != '(' && sign.size()){
                    tmpl.push(sign.top());
                    sign.pop();
                }
                sign.pop();
            } else {
                while(1) {
                     if (sign.size() == 0 || sign.top()[0] == '('){ sign.push(x);break;}
                     else {
                        if(getPri(x) > getPri(sign.top())){ sign.push(x);break;}
                        else {tmpl.push(sign.top());sign.pop();}
                     }
                }
            }
        }
    }
    while(sign.size()) {
        tmpl.push(sign.top());
        sign.pop();
    }
    vector<string> gt;
    while(tmpl.size()){
        gt.push_back(tmpl.top());
        tmpl.pop();
    }
    vector<string> cacu;
    for(int i = 0;i < gt.size();i ++)cacu.push_back(gt[gt.size()-1-i]);

    stack<int> nums;
    for(auto x:cacu) {
        if(ifdigit(x)) nums.push(str2int(x));
        else {
            int a = nums.top();
            nums.pop();
            int b = nums.top();
            nums.pop();
            char c = x[0];
            switch (c)
            {
            case '+':
                nums.push(a+b);
                break;
            case '-':
                nums.push(a-b);
                break;
            case '*':
                nums.push(a*b);
                break;
            case 'x':
                nums.push(a*b);
                break;
            case '/':
                nums.push(a/b);
                break;
            
            default:
                break;
            }
        }
    }

    cout << nums.top() << "\n";

}

signed main()
{
    // std::ios::sync_with_stdio(false);
    // std::cin.tie(nullptr);
    // std::cout.tie(nullptr);

    // int T = 1;
    // cin >> T;
    while(1)
        solve();
    return 0;
}
/*
>>>>1 + 1
2
>>>>2 * 3 + 1
7
>>>>2 * ( 3 + 1 )
8
>>>>115 * 514
59110
>>>>( 1 + 1 ) / 2 * 2 + 2
4
>>>>( 1 + 1 ) / 2 * ( 2 + 2 + 2 )
4
>>>>( 1 + 1 ) / 2 * ( 2 + 2 + 2 )
6
*/