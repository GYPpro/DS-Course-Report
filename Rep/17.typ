#import "@preview/tablex:0.0.6": tablex, hlinex, vlinex, colspanx, rowspanx
#import "@preview/codelst:2.0.1": sourcecode
// Display inline code in a small box
// that retains the correct baseline.
#set text(font:("Times New Roman","Source Han Serif SC"))
#show raw: set text(
    font: ("consolas", "Source Han Serif SC")
  )
#show raw.where(block: false): box.with(
  fill: luma(230),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)
#set page(
  paper: "a4",
)
#set text(
    font:("Times New Roman","Source Han Serif SC"),
    style:"normal",
    weight: "regular",
    size: 13pt,
)

#let nxtIdx(name) = box[ #counter(name).step()#counter(name).display()]
#set math.equation(numbering: "(1)")

#show raw.where(block: true): block.with(
  fill: luma(240),
  inset: 10pt,
  radius: 4pt,
)

#set math.equation(numbering: "(1)")

#set page(
  paper:"a4",
  number-align: right,
  margin: (x:2.54cm,y:4cm),
  header: [
    #set text(
      size: 25pt,
      font: "KaiTi",
    )
    #align(
      bottom + center,
      [ #strong[暨南大学本科实验报告专用纸(附页)] ]
    )
    #line(start: (0pt,-5pt),end:(453pt,-5pt))
  ]
)

/*----*/

= 算数表达式求值（栈）
\
#text(
  font:"KaiTi",
  size: 15pt
)[
课程名称#underline[#text("      数据结构      ")]成绩评定#underline[#text("       ")]\
实验项目名称#underline[#text(" ") 算数表达式求值（栈） #text(" ")]指导老师#underline[#text("   干晓聪   ")]\
实验项目编号#underline[#text("  17  ")]实验项目类型#underline[#text("  设计性  ")]实验地点#underline[#text(" 数学系机房 ")]\
学生姓名#underline[#text("   郭彦培   ")]学号#underline[#text("   2022101149   ")]\
学院#underline[#text(" 信息科学技术学院 ")]系#underline[#text(" 数学系 ")]专业#underline[#text(" 信息管理与信息系统 ")]\
实验时间#underline[#text(" 2024年6月13日上午 ")]#text("~")#underline[#text("  2024年7月13日中午  ")]\
]
#set heading(
  numbering: "1.1."
  )
  

= 实验目的

基于逆波兰式求算术表达式值 

= 实验环境

计算机：PC X64

操作系统：Windows + Ubuntu20.0LTS

编程语言：C++：GCC std20

IDE：Visual Studio Code


= 程序原理

逆波兰式指的是不包含括号，运算符放在两个运算对象的后面，所有的计算按运算符出现的顺序，严格从左向右进行的运算式。

将前缀表达式转换为逆波兰式，使用两个栈，按以下流程：
+ 数字：入临时栈
+ 左括号：入符号栈
+ 右括号：重复弹出符号栈内容插入临时栈，直到遇到左括号
+ 其他运算符：重复弹出栈内符号直到栈顶运算符优先级不低于自身，入符号栈

#pagebreak()

= 程序代码

== `linnerCaculate.cpp`
#sourcecode[```cpp
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

```]



= 测试数据与运行结果

运行上述`_PRIV_TEST.cpp`测试代码中的正确性测试模块，得到以下内容：

```

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

```


可以看出，代码运行结果与预期相符，可以认为代码正确性无误。
