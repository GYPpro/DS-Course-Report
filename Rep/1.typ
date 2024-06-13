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
#let maintitle() = "maintitle"

=  #maintitle()
\
#text(
  font:"KaiTi",
  size: 15pt
)[
课程名称#underline[#text("      数据结构      ")]成绩评定#underline[#text("       ")]\
实验项目名称#underline[#text(" ")#maintitle()#text(" ")]指导老师#underline[#text("   干晓聪   ")]\
实验项目编号#underline[#text("  1  ")]实验项目类型#underline[#text("  设计性  ")]实验地点#underline[#text(" 数学系机房 ")]\
学生姓名#underline[#text("   郭彦培   ")]学号#underline[#text("   2022101149   ")]\
学院#underline[#text(" 信息科学技术学院 ")]系#underline[#text(" 数学系 ")]专业#underline[#text(" 信息管理与信息系统 ")]\
实验时间#underline[#text(" 2024年6月13日上午 ")]#text("~")#underline[#text("  2024年6月13日中午  ")]\
]
#set heading(
  numbering: "一、"
  )
  
#set par( first-line-indent: 1.8em)

= 实验目的
\
#h(1.8em)学习安装、手工使用编译器


= 实验环境
\
#h(1.8em)计算机：PC X64

操作系统：Windows + Ubuntu20.0LTS

编程语言：C++：GCC std20

IDE：Visual Studio Code


= 程序原理
\

#pagebreak()

= 程序代码

```java
```

= 出现的问题、原因与解决方法
\
#h(1.8em)未出现问题

= 测试数据与运行结果
\
#h(1.8em)