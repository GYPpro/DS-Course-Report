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

= 基于R-BTree实现`set`
\
#text(
  font:"KaiTi",
  size: 15pt
)[
课程名称#underline[#text("      数据结构      ")]成绩评定#underline[#text("       ")]\
实验项目名称#underline[#text(" ") 基于R-BTree实现`set` #text(" ")]指导老师#underline[#text("   干晓聪   ")]\
实验项目编号#underline[#text("  10  ")]实验项目类型#underline[#text("  设计性  ")]实验地点#underline[#text(" 数学系机房 ")]\
学生姓名#underline[#text("   郭彦培   ")]学号#underline[#text("   2022101149   ")]\
学院#underline[#text(" 信息科学技术学院 ")]系#underline[#text(" 数学系 ")]专业#underline[#text(" 信息管理与信息系统 ")]\
实验时间#underline[#text(" 2024年6月13日上午 ")]#text("~")#underline[#text("  2024年7月13日中午  ")]\
]
#set heading(
  numbering: "1.1."
  )
  

= 实验目的

基于已有的`RB_Tree`结构实现`set`


= 实验环境

计算机：PC X64

操作系统：Windows + Ubuntu20.0LTS

编程语言：C++：GCC std20

IDE：Visual Studio Code


= 程序原理

`set`要求元素不重合，因此选择直接使用红黑树维护，提供`insert`和`erase`操作。

由红黑树性质易得，插入复杂度$OO(log_2 n)$，删除复杂度$OO(log_2 n)$

#pagebreak()

= 程序代码

== `mySet.h`
#sourcecode[```cpp
#ifndef PRVLIBCPP_SET_HPP
#define PRVLIBCPP_SET_HPP

#include <Dev\08\RB_Tree.h>

namespace myDS
{
    template<typename VALUE_TYPE>
    class set{
    private:
         myDS::RBtree<VALUE_TYPE> dataST;

    public:
        set(){ }

        ~set(){ }

        void insert(VALUE_TYPE _d) {dataST.insert(_d);}
        bool erase(VALUE_TYPE _d) {return dataST.erase(_d);}
        bool find(VALUE_TYPE _d) {return dataST.find(_d);}
        auto begin() {return dataST.begin();}
        auto end() {return dataST.end();}
    };  
} // namespace myDS
#endif

```]
== `_PRIV_TEST.cpp`
#sourcecode[```cpp
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

```]



= 测试数据与运行结果

运行上述`_PRIV_TEST.cpp`测试代码中的正确性测试模块，得到以下内容：

```

i 1
i 2
i 3
i 6
i 5
p
1 2 3 5 6
i 6
i 5
p
1 2 3 5 6
d 3
1
d 4
0
p
1 2 5 6
f 2
1
f 3
0
f 4
0


```


可以看出，代码运行结果与预期相符，可以认为代码正确性无误。
