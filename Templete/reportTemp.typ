#import "@preview/tablex:0.0.6": tablex, hlinex, vlinex, colspanx, rowspanx

// Display inline code in a small box
// that retains the correct baseline.
#set text(font:("Times New Roman","Source Han Serif SC"))
#show raw.where(block: false): box.with(
  fill: luma(240),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)

// Display block code in a larger block
// with more padding.
#show raw.where(block: true): block.with(
  fill: luma(240),
  inset: 10pt,
  radius: 4pt,
)
#set par(
  first-line-indent: 1cm
)
#show raw: set text(
    font: ("consolas", "Source Han Serif SC")
  )

#set math.equation(numbering: "(1)")

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
        #heading(outlined: false,level: 1)[标题]
        #smallcaps[Translated Title]
        #line(start: (0pt,11pt),end:(300pt,11pt))
        #[
            #set text(19pt)
            暨南大学
            #set text(15pt)
            \ 信息管理与信息系统 郭彦培
        ]
    ]
]
#pagebreak();
#set text(
    font:("Times New Roman","Source Han Serif SC"),
    style:"normal",
    weight: "regular",
    size: 13pt,
)

#set page(
  paper:"a4",
  number-align: right,
  margin: (x:2cm,y:2.5cm),
  header: [
    #box(baseline:5pt)[#set text(
      size: 11pt,
    )
    #align(
      left+bottom,
      [
        #smallcaps[Translated Title]
        #h(1fr)#text("日期 暨南大学 郭彦培",fill:rgb("#898989"));
      ]
    )]
    #line(start: (0pt,-10pt),end:(483pt,-10pt))
  ],
  numbering: "1/1"
)

#show raw: set text(
    font: ("consolas", "Source Han Serif SC")
  )

#set heading(
  numbering: "1.1.1"
)

#outline(
  title:[#smallcaps("Catalogue")\ #h(1fr)]
);