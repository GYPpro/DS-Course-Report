#import "@preview/tablex:0.0.6": tablex, hlinex, vlinex, colspanx, rowspanx
#import "@preview/codelst:2.0.1": sourcecode
// Display inline code in a small box
// that retains the correct baseline.
#set text(font:("Times New Roman","Source Han Serif SC"))
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
#show raw.where(block: false): box.with(
  fill: luma(230),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
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

= 堆`Heap`
\
#text(
  font:"KaiTi",
  size: 15pt
)[
课程名称#underline[#text("      数据结构      ")]成绩评定#underline[#text("       ")]\
实验项目名称#underline[#text(" ") 堆`Heap` #text(" ")]指导老师#underline[#text("   干晓聪   ")]\
实验项目编号#underline[#text("  14  ")]实验项目类型#underline[#text("  设计性  ")]实验地点#underline[#text(" 数学系机房 ")]\
学生姓名#underline[#text("   郭彦培   ")]学号#underline[#text("   2022101149   ")]\
学院#underline[#text(" 信息科学技术学院 ")]系#underline[#text(" 数学系 ")]专业#underline[#text(" 信息管理与信息系统 ")]\
实验时间#underline[#text(" 2024年6月13日上午 ")]#text("~")#underline[#text("  2024年7月13日中午  ")]\
]
#set heading(
  numbering: "1.1."
  )
  

= 实验目的

实现一个基础堆结构

= 实验环境

计算机：PC X64

操作系统：Windows + Ubuntu20.0LTS

编程语言：C++：GCC std20

IDE：Visual Studio Code


= 程序原理

堆是一个完全二叉树，满足任意节点$a_i$，其子节点值均小于它，这是小根堆。大根堆反之。

插入时 ，在整棵树右下角插入，并且按照大小逐个上浮。可以证明，这样操作过后堆依然满足其性质。

删除时，将根与右下角对换，并按照左右大小下压根节点，最后删除右下角节点即可。

可以证明两者复杂度均为$OO(log_2 n)$


#pagebreak()

= 程序代码

== `big_root_heap.h`
#sourcecode[```cpp
#ifndef PRIORITY_QUEUE_HPP
#define PRIORITY_QUEUE_HPP

#include <vector>

#ifdef __PRIVATE_DEBUGE
#include <iostream>
#endif

namespace myDS
{
    template<typename VALUE_TYPE>
    class big_root_heap{
    private:
        std::vector<VALUE_TYPE> h;

        void floow(std::size_t x) {
            while(x > 1 && h[x] > h[x/2]) {
                std::swap(h[x],h[x/2]);
                x >>= 1;
            }
        }

        void drown(std::size_t x) {
            while(x * 2 <= h.size()-1) {
                int t = x * 2;
                if(t + 1 <= h.size()-1 && h[t + 1] > h[t]) t ++;
                if(h[t] <= h[x]) break;
                std::swap(h[x],h[t]);
                x = t;
            }
        }

    public:

        big_root_heap() {h.push_back(0);}

        ~big_root_heap() { }

        void push(VALUE_TYPE t)
        {
            h.push_back(t);
            floow(h.size()-1);
        }

        VALUE_TYPE top(){
            return h[1];
        }

        VALUE_TYPE pop(){
            auto t = this->top();
            std::swap(h[1],h[h.size()-1]);
            h.pop_back();
            drown(1);
            return t;
        }

#ifdef __PRIVATE_DEBUGE
        void innerPrint(){
            for(auto x:h) std::cout << x << " ";
            std::cout << "\n";
        }
#endif
    };
} // namespace myDS


#endif
```]
== `_PRIV_TEST.cpp`
#sourcecode[```cpp
#include <iostream>
#define __PRIVATE_DEBUGE
#include <Dev\14\big_root_heap.h>
using namespace std;

int main()
{
     myDS::big_root_heap<int> piq;
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


```]



= 测试数据与运行结果

运行上述`_PRIV_TEST.cpp`测试代码中的正确性测试模块，得到以下内容：

```

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

```


可以看出，代码运行结果与预期相符，可以认为代码正确性无误。
