#import "@preview/tablex:0.0.6": tablex, hlinex, vlinex, colspanx, rowspanx
#import "@preview/codelst:2.0.1": sourcecode
// Display inline code in a small box
// that retains the correct baseline.
#set text(font:("Times New Roman","Source Han Serif SC"))
#show raw.where(block: false): box.with(
  fill: luma(230),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)
#show raw: set text(
    font: ("consolas", "Source Han Serif SC")
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

= 线段树`segTree`
\
#text(
  font:"KaiTi",
  size: 15pt
)[
课程名称#underline[#text("      数据结构      ")]成绩评定#underline[#text("       ")]\
实验项目名称#underline[#text(" ") 线段树`segTree` #text(" ")]指导老师#underline[#text("   干晓聪   ")]\
实验项目编号#underline[#text("  13  ")]实验项目类型#underline[#text("  设计性  ")]实验地点#underline[#text(" 数学系机房 ")]\
学生姓名#underline[#text("   郭彦培   ")]学号#underline[#text("   2022101149   ")]\
学院#underline[#text(" 信息科学技术学院 ")]系#underline[#text(" 数学系 ")]专业#underline[#text(" 信息管理与信息系统 ")]\
实验时间#underline[#text(" 2024年6月13日上午 ")]#text("~")#underline[#text("  2024年7月13日中午  ")]\
]
#set heading(
  numbering: "1.1."
  )
  

= 实验目的

实现一个泛型线段树`segTree`库

= 实验环境

计算机：PC X64

操作系统：Windows + Ubuntu20.0LTS

编程语言：C++：GCC std20

IDE：Visual Studio Code


= 程序原理

线段树可以在 $OO(log n)$ 的时间复杂度内实现单点修改、区间修改、区间查询等操作。

定义合并运算符 “$plus.circle$” 及其高阶运算 “$times.circle$”

对于一个连续的序列$a$递归地对连续两个区域进行合并，形成新序列$t $ $ s.t. forall i in t, s_i = s_(i*2) plus.circle s_(i*2 
+1) $ 其中 $ forall i in a , exists f , s.t. s_(f+i) =  a_i $

则整个s序列形成二叉搜索树形结构。

定义运算符$a_i^T$为递归地向上访问所经过的所有节点集合，
$s_i^L,s_i^R$分别为：$ s_i^L = "Val"^(a_i)min(i in NN s.t. s_i in a_i^T) $
$ s_i^R = "Val"^(a_i)max(i in NN s.t. s_i in a_i^T) $
则可以描述：

对于区间求合并值：给定区间$[l,r]$

$ sum_(i in [l,r])^(plus.circle) a_i arrow.r.l.double sum_(k in {i | i in a_i^T})^(plus.circle)(s_k^R - s_k^L) times.circle s_k $

易得上式$k$的规模为$OO(log_2 NN)$

对于区间合并修改，保留懒惰标记$L_i$

对于修改：区间$[l,r]$均$plus.circle c$

$ forall i in [l,r] , s_i plus.circle c \ arrow.r.l.double forall k in {a_i^T,i in [l,r]} s.t. [s_k^R,s_k^L] ,L_k plus.circle (s_k^R - s_k^L)times.circle c $

则每次查询改为

$ sum_(i in [l,r])^(plus.circle) a_i arrow.r.l.double sum_(k in {i | i in a_i^T})^(plus.circle)((s_k^R - s_k^L) times.circle s_k + sum_(i in a_k^T) L_i) $

易得两者规模均为$OO(log_2 NN)$

在每次搜索时按$L_(i*2) times.circle (s_(i*2)^R - s_(i*2)^L) plus.circle L_(i*2+1) times.circle  (s_(i*2 + 1)^R - s_(i*2 + 1)^L) = (s_i^R - s_i^L) $，则可以证明，维护懒惰标记的均摊复杂度为$OO(1)$

具体实现参考代码，没这么复杂（只是用数学语言描述比较麻烦而已）

#pagebreak()

= 程序代码

== `segTree.h`
#sourcecode[```cpp
#include <template_overAll.h>

// AC 带懒惰标记线段树 
template <class TYPE_NAME>
class lazyTree
{
    /*
     *  TYPE_NAME需要支持：+ += != 和自定义的合并运算符
     *  实现了懒惰标记，仅支持区间批量增加
     *  区间批量减需要TYPE_NAME支持-，且有-a = 0 - a
     *  额外处理了一个单点修改为对应值的函数，非原生实现，其复杂度为 4logn
     *  不提供在线
     *  不提供持久化
     */
private:
    vector<TYPE_NAME> d;
    vector<TYPE_NAME> a;
    vector<TYPE_NAME> b;
    int n;
    const TYPE_NAME INI = 0; // 不会影响合并运算的初始值，如max取INF，min取0，mti取1

    void subbuild(int s, int t, int p)
    {
        if (s == t)
        {
            d[p] = a[s];
            return;
        }
        int m = s + ((t - s) >> 1); //  (s+t)/2
        subbuild(s, m, p * 2);
        subbuild(m + 1, t, p * 2 + 1);
        d[p] = d[p * 2] + d[p * 2 + 1];
        //    合并运算符 ↑
    }

    TYPE_NAME subGetSum(int l, int r, int s, int t, int p)
    {
        if (l <= s && t <= r)
            return d[p];
        int m = s + ((t - s) >> 1);
        if (b[p] != 0)
        {
            d[p * 2] += b[p] * (m - s + 1); // 合并运算符的高阶运算 此处运算为应用懒惰标记
            d[p * 2 + 1] += b[p] * (t - m); // 合并运算符的高阶运算 此处运算为应用懒惰标记
            b[p * 2] += b[p];               // 下传标记，无需修改
            b[p * 2 + 1] += b[p];           // 下传标记，无需修改
            b[p] = 0;
        }
        TYPE_NAME ansl = INI;
        TYPE_NAME ansr = INI;
        if (l <= m)
            ansl = subGetSum(l, r, s, m, p * 2);
        if (r > m)
            ansr = subGetSum(l, r, m + 1, t, p * 2 + 1);
        return ansl + ansr;
        // 合并运算符↑
    }

    void subUpdate(int l, int r, TYPE_NAME c, int s, int t, int p)
    {
        if (l <= s && t <= r)
        {
            d[p] += (t - s + 1) * c; // 合并运算符的高阶运算 此处运算为修改整匹配区间值
            b[p] += c;               // 记录懒惰标记，无需修改
            return;
        }
        int m = s + ((t - s) >> 1);
        if (b[p] != 0 && s != t)
        {
            d[p * 2] += b[p] * (m - s + 1); // 合并运算符的高阶运算 此处运算为应用懒惰标记
            d[p * 2 + 1] += b[p] * (t - m); // 合并运算符的高阶运算 此处运算为应用懒惰标记
            b[p * 2] += b[p];               // 下传标记，无需修改
            b[p * 2 + 1] += b[p];           // 下传标记，无需修改
            b[p] = 0;
        }
        if (l <= m)
            subUpdate(l, r, c, s, m, p * 2);
        if (r > m)
            subUpdate(l, r, c, m + 1, t, p * 2 + 1);
        d[p] = d[p * 2] + d[p * 2 + 1];
        //    合并运算符 ↑
    }

public:
    lazyTree(TYPE_NAME _n)
    {
        n = _n;
        d.resize(4 * n + 5);
        a.resize(4 * n + 5);
        b.resize(4 * n + 5);
    }

    void build(vector<TYPE_NAME> _a)
    {
        a = _a;
        subbuild(1, n, 1);
    }

    TYPE_NAME getsum(int l, int r)
    {
        return subGetSum(l, r, 1, n, 1);
    }

    void update(int l, int r, TYPE_NAME c) // 修改区间
    {
        subUpdate(l, r, c, 1, n, 1);
    }

    void update(int idx, TYPE_NAME tar)
    { // 修改单点，未测试
        TYPE_NAME tmp = getsum(idx, idx);
        tar -= tmp;
        subUpdate(idx, idx, tar, 1, n, 1);
    }
};


```]
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



= 测试数据与运行结果

代码通过在线平台`LUOGU.org`正确性测试

#image("13.png",width: 60%)
