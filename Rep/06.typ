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

= 树上dfs（基础信息）
\
#text(
  font:"KaiTi",
  size: 15pt
)[
课程名称#underline[#text("      数据结构      ")]成绩评定#underline[#text("       ")]\
实验项目名称#underline[#text(" ") 树上dfs（基础信息） #text(" ")]指导老师#underline[#text("   干晓聪   ")]\
实验项目编号#underline[#text("  06  ")]实验项目类型#underline[#text("  设计性  ")]实验地点#underline[#text(" 数学系机房 ")]\
学生姓名#underline[#text("   郭彦培   ")]学号#underline[#text("   2022101149   ")]\
学院#underline[#text(" 信息科学技术学院 ")]系#underline[#text(" 数学系 ")]专业#underline[#text(" 信息管理与信息系统 ")]\
实验时间#underline[#text(" 2024年6月13日上午 ")]#text("~")#underline[#text("  2024年7月13日中午  ")]\
]
#set heading(
  numbering: "1.1."
  )
  

= 实验目的

在树上进行dfs

= 实验环境

计算机：PC X64

操作系统：Windows + Ubuntu20.0LTS

编程语言：C++：GCC std20

IDE：Visual Studio Code


= 程序原理

统计树每个节点的子树大小、节点深度 与 子树节点权值和。

对于节点$i$，其子节点列表$S_i$，父节点$p_i$，有状态转移：
$ "subTreeSize"_n = sum_{"all" i in S_n} "subTreeSize"_i $
$ "depth"_n = "depth"_p_n + 1 $
$ "subTreeSum"_n = sum_{"all" i in S_n} "subTreeSum"_i + "Wei"_n $ 

#pagebreak()

= 程序代码

== `dfs.cpp`
#sourcecode[```cpp
#include <iostream>
#include <vector>
#include <stdlib.h>
#include <map>
#include <algorithm>

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

// 子树大小 节点深度 子树节点值和
void solve()
{
    int n;
    cin >> n;
    vector<vector<int>> cnj(n+1);
    vector<int> wei(n+1);
    vector<int> subTreeSize(n+1),depth(n+1),subTreeSum(n+1);
    loop(i,n-1)
    {
        int u,v;
        cin >> u >> v;
        cnj[u].pb(v);
        cnj[v].pb(u);
    }
    loop(i,n) cin >> wei[i+1];
    auto dfs = [&](auto self,int p,int f) -> pii {
        int size = 1;
        int sum = wei[p];
        depth[p] = depth[f] + 1;
        for(auto &x : cnj[p])
        {
            if(x == f) continue;
            auto [subSize,subSum] = self(self,x,p);
            size += subSize;
            sum += subSum;
        }
        subTreeSize[p] = size;
        subTreeSum[p] = sum;
        return {size,sum};
    };
    dfs(dfs,1,0);
    cout << "subTreeSize \n";
    loop(i,n) cout << subTreeSize[i+1] << " ";
    cout << "\n";
    cout << "depth \n";
    loop(i,n) cout << depth[i+1] << " ";
    cout << "\n";
    cout << "subTreeSum \n";
    loop(i,n) cout << subTreeSum[i+1] << " ";
    cout << "\n";
}

signed main()
{
    // std::ios::sync_with_stdio(false);
    // std::cin.tie(nullptr);
    // std::cout.tie(nullptr);

    int T = 1;
    cin >> T;
    while(T--)
        solve();
    return 0;
}


```]



= 测试数据与运行结果

运行上述`_PRIV_TEST.cpp`测试代码中的正确性测试模块，得到以下内容：

```

2
8
1 2
1 3
1 4
3 5
3 6
6 7
6 8
9 4 3 1 15 7 3 7
subTreeSize
8 1 5 1 1 3 1 1
depth
1 2 2 2 3 3 4 4
subTreeSum
49 4 35 1 15 17 3 7
6
1 2
2 3
3 4
4 5
5 6
1 1 4 5 1 4
subTreeSize
6 5 4 3 2 1
depth
1 2 3 4 5 6
subTreeSum
16 15 14 10 5 4

```


可以看出，代码运行结果与预期相符，可以认为代码正确性无误。
