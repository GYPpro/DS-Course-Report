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

= 基于Heap实现`priority_queue`
\
#text(
  font:"KaiTi",
  size: 15pt
)[
课程名称#underline[#text("      数据结构      ")]成绩评定#underline[#text("       ")]\
实验项目名称#underline[#text(" ") 基于Heap实现`priority_queue` #text(" ")]指导老师#underline[#text("   干晓聪   ")]\
实验项目编号#underline[#text("  15  ")]实验项目类型#underline[#text("  设计性  ")]实验地点#underline[#text(" 数学系机房 ")]\
学生姓名#underline[#text("   郭彦培   ")]学号#underline[#text("   2022101149   ")]\
学院#underline[#text(" 信息科学技术学院 ")]系#underline[#text(" 数学系 ")]专业#underline[#text(" 信息管理与信息系统 ")]\
实验时间#underline[#text(" 2024年6月13日上午 ")]#text("~")#underline[#text("  2024年7月13日中午  ")]\
]
#set heading(
  numbering: "1.1."
  )
  

= 实验目的

基于Heap实现`priority_queue`

= 实验环境

计算机：PC X64

操作系统：Windows + Ubuntu20.0LTS

编程语言：C++：GCC std20

IDE：Visual Studio Code


= 程序原理
\
`priority_queue`要求实时维护序列中最大（或最小）的值，刚好符合堆的性质。

代码实现的`priority_queue`中提供了可选模板参数`typename Compare = std::less<VALUE_TYPE>`，若传入`std::greater`则为最大值优先，反之为最小值优先。

#pagebreak()

= 程序代码

== `priority_queue.h`
#sourcecode[```cpp
#ifndef PRIORITY_QUEUE_HPP
#define PRIORITY_QUEUE_HPP

#include <vector>
#include <functional>

#ifdef __PRIVATE_DEBUGE
#include <iostream>
#endif

namespace myDS {
    template<typename VALUE_TYPE, typename Compare = std::less<VALUE_TYPE>>
    class priority_queue {
    private:
        std::vector<VALUE_TYPE> h;
        Compare comp;

        void floow(std::size_t x) {
            while (x > 1 && comp(h[x / 2], h[x])) {
                std::swap(h[x], h[x / 2]);
                x >>= 1;
            }
        }

        void drown(std::size_t x) {
            while (x * 2 <= h.size() - 1) {
                int t = x * 2;
                if (t + 1 <= h.size() - 1 && comp(h[t], h[t + 1])) t++;
                if (!comp(h[x], h[t])) break;
                std::swap(h[x], h[t]);
                x = t;
            }
        }

    public:
        explicit priority_queue(const Compare& comp = Compare()) : comp(comp) { h.push_back(VALUE_TYPE()); }

        ~priority_queue() { }

        void push(const VALUE_TYPE& t) {
            h.push_back(t);
            floow(h.size() - 1);
        }

        const VALUE_TYPE& top() const {
            return h[1];
        }

        VALUE_TYPE pop() {
            auto t = this->top();
            std::swap(h[1], h[h.size() - 1]);
            h.pop_back();
            drown(1);
            return t;
        }

#ifdef __PRIVATE_DEBUGE
        void innerPrint() {
            for (auto x : h) std::cout << x << " ";
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
#include <Dev\15\priority_queue.h>
using namespace std;

int main()
{
     myDS::priority_queue<int,greater<int>> piq;
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
