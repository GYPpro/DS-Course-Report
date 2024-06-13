#import "@preview/tablex:0.0.6": tablex, hlinex, vlinex, colspanx, rowspanx

// Display inline code in a small box
// that retains the correct baseline.
#set text(font:("Times New Roman","Source Han Serif SC"))
#show raw.where(block: false): box.with(
  fill: luma(230),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)
// #set raw(align: center)
#show raw: set text(
    font: ("consolas", "Source Han Serif SC")
  )
#set page(
  // flipped: true,
  paper: "a4",
//   background: [#image("background.png")]
)
#set text(
    font:("Times New Roman","Source Han Serif SC"),
    style:"normal",
    weight: "regular",
    size: 13pt,
)

#let nxtIdx(name) = box[ #counter(name).step()#counter(name).display()]

// Display block code in a larger block
// with more padding.
#show raw.where(block: true): block.with(
  fill: luma(230),
  inset: 7pt,
  radius: 4pt,
)
#set par(
  // first-line-indent: 1cm
)
#set math.equation(numbering: "(1)")



// Display block code in a larger block
// with more padding.
#show raw.where(block: true): block.with(
  fill: luma(240),
  inset: 10pt,
  radius: 4pt,
)

#set math.equation(numbering: "(1)")

#pagebreak()
#[
    #set text(
      font:("Times New Roman","Source Han Serif SC"),
      style:"normal",
      weight:"regular",
      size: 22pt,
  )


  #[
    #set align(
      left+horizon
    )
    = 写在前面
    #smallcaps[Overall]
    #line(start: (0pt,-11pt),end:(300pt,-11pt))
    #set text(
      font:("Times New Roman","Source Han Serif SC"),
      style:"normal",
      weight:"regular",
      size: 15pt,
    )

    本实验报告的基本结构如下（按逻辑顺序）：

    #tablex(
      columns: 3,
      [模块],[编号],[内容],
      rowspanx(8)[STL风格的\ 泛型的\ 基础数据结构\ 容器实现],[1],[基于双向链表的`linkedList`],
      (),[2],[基于增长数组的`vector`],
      (),[19],[基于块状数组的`dataBlock`],
      (),[3],[实现基于循环增长数组的`deque`],
      (),[4],[基于`vector`实现`stack`],
      (),[9],[基于R-BTree实现`set`],
      (),[10],[基于R-BTree实现`map`],
      (),[14],[基于Heap实现`priority_queue`],
      rowspanx(4)[基础树结构],[5],[树上dfs],
      (),[6],[树上bfs],
      (),[7],[二叉树三序遍历],
      (),[8],[R-BTree的基本实现],
      rowspanx(4)[特殊结构\ 及其应用],[11],[字典树`Trie`],
      (),[12],[线段树`segTree`],
      (),[13],[堆`Heap`],
      (),[15],[霍夫曼树`Huffman-tree`],
      rowspanx(3)[在算法中应用],[16],[算数表达式求值（栈）],
      (),[17],[括号匹配（栈）],
      (),[18],[高精度计算],
    )

    // 老师辛苦了，感谢您一学期的付出！

    本实验报告的可运行文件、commit记录等已经在#smallcaps[Github]上同步了所有相关资料:
    `https://github.com/GYPpro/DS-Course-Report`
    
    仓库会在7月1日前保持`private`

    // #[
    //   #set align(bottom)
    //   #line(start: (0pt,11pt),end:(270pt,11pt))
    //   #set text(19pt)
    //   信息管理与信息系统 郭彦培\
    //   #set text(15pt)
    //   暨南大学
    // ]
  ]
]
#pagebreak()
    #set text(
      font:("Times New Roman","Source Han Serif SC"),
      style:"normal",
      weight:"regular",
      size: 22pt,
  )


  #[
    #set align(
      left+horizon
    )
    = 容器设计原则
    #smallcaps[Interface Reference]
    #line(start: (0pt,-11pt),end:(300pt,-11pt))
    #set text(
      font:("Times New Roman","Source Han Serif SC"),
      style:"normal",
      weight:"regular",
      size: 15pt,
    )

    ```
    Many containers have several member functions in common, and share functionalities. The decision of which type of container to use for a specific need does not generally depend only on the functionality offered by the container, but also on the efficiency of some of its members (complexity). This is especially true for sequence containers, which offer different trade-offs in complexity between inserting/removing elements and accessing them.

    stack, queue and priority_queue are implemented as container adaptors. Container adaptors are not full container classes, but classes that provide a specific interface relying on an object of one of the container classes (such as deque or list) to handle the elements. The underlying container is encapsulated in such a way that its elements are accessed by the members of the container adaptor independently of the underlying container class used.
    ```

    在模块`STL风格的、泛型的、基础数据结构容器实现`中所有的数据结构，遵循以下规范：
    
    - 提供增删改查的接口；
    - 提供完整的泛型系统；
    - 提供迭代器用于遍历；
    - 按结构性质提供随机访问

    为了更契合`OOP`中的`SRP`原则，对于原STL中的容器适配器，本实验报告中并不通过接口实现，而是另起一个类。
]