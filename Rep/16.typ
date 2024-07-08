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

= 霍夫曼树`Huffman-tree`
\
#text(
  font:"KaiTi",
  size: 15pt
)[
课程名称#underline[#text("      数据结构      ")]成绩评定#underline[#text("       ")]\
实验项目名称#underline[#text(" ") 霍夫曼树`Huffman-tree` #text(" ")]指导老师#underline[#text("   干晓聪   ")]\
实验项目编号#underline[#text("  16  ")]实验项目类型#underline[#text("  设计性  ")]实验地点#underline[#text(" 数学系机房 ")]\
学生姓名#underline[#text("   郭彦培   ")]学号#underline[#text("   2022101149   ")]\
学院#underline[#text(" 信息科学技术学院 ")]系#underline[#text(" 数学系 ")]专业#underline[#text(" 信息管理与信息系统 ")]\
实验时间#underline[#text(" 2024年6月13日上午 ")]#text("~")#underline[#text("  2024年7月13日中午  ")]\
]
#set heading(
  numbering: "1.1."
  )
  

= 实验目的

实现一个霍夫曼树并提供初始化后的编解码

= 实验环境

计算机：PC X64

操作系统：Windows + Ubuntu20.0LTS

编程语言：C++：GCC std20

IDE：Visual Studio Code


= 程序原理

定义$w_i$为节点$i$的权值，$l_i$为深度，则有Huffman tree $s.t. min "WPL" = sum_(i =  1)^n w_i l_i$

构造时循环地将权值最小的两棵树连接到新的节点即可，容易证明本贪心过程可以构造霍夫曼树。

将霍夫曼树视作只有0，1的字典树，并维护叶节点与原字符的对应关系即可进行编解码。

#pagebreak()

= 程序代码

== `Huffman_tree.hpp`
#sourcecode[```cpp
#ifndef _HUFFMAN_TREE_HPP
#define _HUFFMAN_TREE_HPP

#include <functional>
#include <string>
#include <map>
#include <vector>
#include <queue>

namespace myDS {
    class huffmanTree {
    protected:
        std::vector<int> pa;
        std::vector<int> wei;
        std::vector<std::pair<int,int>> s2code;

        bool comp(std::pair<char,int> a,std::pair<char,int> b)
        {
            return a > b;
        }

        std::size_t cap = 0;
        std::size_t MEX = 0;

        void link(int a,int b) {
            pa[a] = cap,pa[b] = cap;
            s2code[cap] = {a,b};
        }

    public:
        huffmanTree() { }

        huffmanTree(std::vector<int> _wei) {buildup(_wei);}
        
        void buildup(std::vector<int> _wei) {
            wei = _wei;
            MEX = wei.size()-1;
            pa.resize(MEX * 2 + 2);
            s2code.resize(MEX * 2 + 2);
            std::priority_queue<std::pair<int,int>,std::vector<std::pair<int,int>>,std::greater<std::pair<int,int>>> values;
            cap = MEX;
            for(int i = 1;i <= MEX;i ++) {
                values.push({wei[i],i});
            }
            while(values.size()) {
                cap ++;
                auto a = values.top();
                values.pop();
                if (values.size() == 0) 
                    break;
                auto b = values.top();
                values.pop();
                link(a.second,b.second);
                values.push({a.first + b.first,cap});
            }
        }

        int getWPL() {
            int t = 0;
            for(int i = 1;i <= MEX;i ++) t += wei[i] * (getPath(i).size());
        }

        std::vector<char> getPath(std::size_t n) {
            std::vector<char> rt;
            int t = n;
            while(pa[t]) {
                rt.push_back(s2code[pa[t]].first == t);
                t = pa[t];
            }
            std::vector<char> path;
            for(int i = 0;i < rt.size();i ++) path.push_back(rt[rt.size()-1-i]);
            return path;
        }

        std::vector<int> getC(std::vector<char> t) {
            int ori = cap-1;
            std::vector<int> rt;
            for(auto x:t) {
                if(s2code[ori] == std::pair<int,int>()){
                    rt.push_back(ori);
                    ori = cap-1;
                }
                if(x == 0) ori = s2code[ori].second;
                else ori = s2code[ori].first;
            } 
            if(s2code[ori] == std::pair<int,int>()){
                rt.push_back(ori);
                ori = cap;
            }
            return rt;
        }
        
    };

    class huffmanEncoder : huffmanTree {
    private:
        
        std::map<char,int> wordCounter;
        std::map<char,int> c2i;
        std::map<int,char> i2c;
        std::string init;

    public:
        huffmanEncoder(std::string _init) : huffmanTree(){
            init = _init;
            for(auto x:_init) wordCounter[x] ++;
            pa.resize(wordCounter.size()*2+1);
            std::vector<std::pair<char,int>> gt(1);
            for(auto x:wordCounter) gt.push_back(x);
            for(int i = 1;i < gt.size();i ++) c2i[gt[i].first] = i;
            for(int i = 1;i < gt.size();i ++) i2c[i] = gt[i].first;
            std::vector<int> wei;
            for(auto x:gt) wei.push_back(x.second);
            buildup(wei);
        };

        std::vector<char> encode(std::string s) {
            std::vector<char> rt;
            auto add = [&](std::vector<char> addit) -> void{
                for(int i = 0;i < addit.size();i ++) rt.push_back(addit[i]);
            };
            for(auto x:s) add(this->getPath(c2i[x]));
            return rt;
        }

        std::string decode(std::vector<char> r) {
            std::string rt;
            for(auto x:getC(r)) rt.push_back(i2c[x]);
            return rt;
        }

    };

};

#endif
```]
== `_PRIV_TEST.cpp`
#sourcecode[```cpp
#include <iostream>
#define __PRIVATE_DEBUGE
#include <Dev\16\Huffman_tree.hpp>
using namespace std;

int main()
{
    string s;
    cin >> s;
     myDS::huffmanEncoder hfe(s);
    for(auto x:hfe.encode(s)) cout << (bool)x << " ";
    cout << "\n";
    for(auto x:hfe.decode(hfe.encode(s))) cout << x << " ";
    cout << "\n";
    system("pause");
}


```]



= 测试数据与运行结果

运行上述`_PRIV_TEST.cpp`测试代码中的正确性测试模块，得到以下内容：

```

aaaaaabbbcccd
1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 0 1
a a a a a a b b b c c c d

```


可以看出，代码运行结果与预期相符，可以认为代码正确性无误。
