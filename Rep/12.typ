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

= 字典树`Trie`
\
#text(
  font:"KaiTi",
  size: 15pt
)[
课程名称#underline[#text("      数据结构      ")]成绩评定#underline[#text("       ")]\
实验项目名称#underline[#text(" ") 字典树`Trie` #text(" ")]指导老师#underline[#text("   干晓聪   ")]\
实验项目编号#underline[#text("  12  ")]实验项目类型#underline[#text("  设计性  ")]实验地点#underline[#text(" 数学系机房 ")]\
学生姓名#underline[#text("   郭彦培   ")]学号#underline[#text("   2022101149   ")]\
学院#underline[#text(" 信息科学技术学院 ")]系#underline[#text(" 数学系 ")]专业#underline[#text(" 信息管理与信息系统 ")]\
实验时间#underline[#text(" 2024年6月13日上午 ")]#text("~")#underline[#text("  2024年7月13日中午  ")]\
]
#set heading(
  numbering: "1.1."
  )
  

= 实验目的

实现一个字典树

= 实验环境

计算机：PC X64

操作系统：Windows + Ubuntu20.0LTS

编程语言：C++：GCC std20

IDE：Visual Studio Code


= 程序原理

基于一棵每层至多`26`分支的搜索树，实现在已有字典的基础上，查询字符串`s`在字典中是否出现。

规定每个节点$t$一一对应一个字母$c_t$，$t$的子节点列表$S_t$

则$exists t' in S_t arrow.l.r.double $在字典中有$c_t$的后缀为$c_(t')$

因此如果存在路径$t_0 arrow.r t_1 ... t_(|s|) s.t. forall i in [1,|s| ] $ 有 $t_i = s[i]$，则s在字典中出现过。 

容易证明，查询复杂度为$OO(|s|)$，与字典大小无关。

对于字典规模$n$，建立时的时间复杂度为$OO(n)$，字典树空间复杂度为$OO(n log_26 n)$

#pagebreak()

= 程序代码

== `template_overAll.h`
#sourcecode[```cpp
#include <vector>
#include <map>
#include <string>
#include <string.h>
#include <math.h>
#include <set>
#include <algorithm>
#include <iostream>
#include <queue>

using namespace std;

#define ll long long
#define pb push_back
#define ld long double
const ll int maxn = 1E5+10;
const ll int mod1 = 998244353;
const ll int mod2 = 1E9+7;

#define _IN_TEMPLATE_

ll int str2int(string s)
{
    ll int rec = 0;
    ll int pw = 1;
    for(int i = s.length()-1;i >= 0;i --)
    {
        int gt = s[i] - '0';
        if(gt < 0 || gt > 9) return INT64_MAX;
        rec += gt * pw;
        pw *= 10;
    }
    return rec;
}

vector<ll int> testReadLine()
{
    string s;
    getline(cin,s);
    s.push_back(' ');
    vector<ll int> rearr;
    vector<string> substring;
    string ts;
    for(int i = 0;i < s.size();i ++)
    {
        if(s[i] == ' '){
            substring.push_back(ts);
            ts.clear();
        } else ts.push_back(s[i]);
    }
    for(int i = 0;i < substring.size();i ++)rearr.push_back(str2int(substring[i]));
    return rearr;
}
```]
== `trie_Tree.h`
#sourcecode[```cpp
#include <template_overAll.h>

class Trie//AC
{
public:
    vector<map<char, int>> t;
    int root = 0;
    Trie()
    {
        t.resize(1);
    }
    void addedge(string _s)
    {
        int pvidx = root;
        _s.push_back('-');
        for (int i = 0; i < _s.size(); i++)
        {
            if (t[pvidx].find(_s[i]) != t[pvidx].end())
            {
                pvidx = t[pvidx][_s[i]];
            }
            else
            {
                t[pvidx][_s[i]] = t.size();
                t.push_back(map<char, int>());
                pvidx = t[pvidx][_s[i]];
            }
        }
    }
    bool ifcmp(string &s)
    {
        int pvidx = root;
        for(int i = 0;i < s.size();i ++)
        {
            if(t[pvidx].find(s[i]) != t[pvidx].end()) pvidx = t[pvidx][s[i]];
            else return 0;
        }
        return t[pvidx].find('-') != t[pvidx].end();
    }
};
```]



= 测试数据与运行结果

代码通过在线平台`luogu.org`正确性测试

#image("12.png")