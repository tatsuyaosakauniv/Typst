
// Define a global image counter
#let global_equation_counter = counter("global-equation")
#let global_image_counter = counter("global-image")
#let global_table_counter = counter("global-table")

// 数式のナンバリング
#let equation_num(_) = {
  locate(loc => {
    // let chapt = counter(heading).at(loc).at(0)
    let c = counter(math.equation)
    let n = c.at(loc).at(0)
    "(" + str(n) + ")"
  })
}

// 表のナンバリング
#let table_num(_) = {
  locate(loc => {
    let chapt = counter(heading).at(loc).at(0)
    let c = counter("table-chapter" + str(chapt))
    let n = c.at(loc).at(0)
    str(n + 1)
  })
}

// 表形式
#let tbl(tbl, caption: "") = {
  figure(
    tbl,
    caption: caption,
    supplement: [Table.],
    numbering: table_num,
    kind: "table",
  )
}

// 画像のナンバリング
#let image_num(_) = {
  locate(loc => {
    let n = global_image_counter.at(loc).at(0) + 1
    str(n)
  })
}

// キャプション
#let styled_caption(caption) = {
  text(caption, size: 7.5pt)
}

// 画像形式
#let img(img, caption: "") = {
  figure(
    img,
    caption: styled_caption(caption),
    supplement: [Fig.],
    numbering: image_num,
    kind: "image",
  )
}

// コンテンツを文字列に変換
#let to-string(content) = {
  if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(to-string).join("")
  } else if content.has("body") {
    to-string(content.body)
  } else if content == [ ] {
    " "
  }
}

// 空白行
#let empty_par() = {
  v(-0.72em)
  box()
}

#let preprint(
  presentation: "",
  title: "",
  author: "",
  university: "",
  faculty: "",
  department: "",
  major: "",
  field: "",
  laboratory: "",
  date: ("", "", ""),
  paper-size: "a4",
  bibliography-file: none,
  body,
) = {
  // 引用番号
  show ref: it => {
    if it.element != none and it.element.func() == figure {
      let el = it.element
      let loc = el.location()
      // let chapt = counter(heading).at(loc).at(0)

      link(loc)[#if el.kind == "image" or el.kind == "table" {
          // 番号付け
          let num = global_image_counter.at(loc).at(0) + 1
          it.element.supplement
          " "
          str(num)
        } else if el.kind == "thmenv" {
          let thms = query(selector(<meta:thmenvcounter>).after(loc), loc)
          let number = thmcounters.at(thms.first().location()).at("latest")
          it.element.supplement
          " "
          numbering(it.element.numbering, ..number)
        } else {
          it
        }
      ]
    } else if it.element != none and it.element.func() == math.equation {
      let el = it.element
      let loc = el.location()
      // let chapt = counter(heading).at(loc).at(0)
      let num = counter(math.equation).at(loc).at(0)
      it.element.supplement
      " ("
      // str(chapt)
      // "."
      str(num)
      ")"
    } else if it.element != none and it.element.func() == heading {
      let el = it.element
      let loc = el.location()
      let num = numbering(el.numbering, ..counter(heading).at(loc))
      if el.level == 1 {
        str(num)
        "章"
      }
    } else {
      it
    }
  }

  // キャプション番号のカウント
  show figure: it => {
    set align(center)
    if it.kind == "image" {
      set text(size: 7.5pt)
      it.body
      it.supplement
      " " + it.counter.display(it.numbering)
      " " + it.caption.body
      locate(loc => {
        // Increment the global image counter
        global_image_counter.step()
      })
    } else if it.kind == "table" {
      set text(size: 7.5pt)
      it.supplement
      " " + it.counter.display(it.numbering)
      " " + it.caption.body
      set text(size: 7.5pt)
      it.body
      locate(loc => {
        let chapt = counter(heading).at(loc).at(0)
        global_table_counter.step()
      })
    } else {
      it
    }
  }

  // ドキュメントのメタデータを設定
  set document(title: title, author: author)

  // 本文フォントを設定
  set text(
    font: (
      "Times New Roman",
      "Hiragino Mincho ProN",
    ),
    size: 9.3pt,
  )

  // ページのプロパティを設定
  context {
    set page(
      columns: 2,
      paper: paper-size,
      margin: (bottom: 15mm, top: 15mm, left: 15mm, right: 15mm),
      footer: [
        #align(center)[#counter(page).display("1")]
      ],
    )
  }

  counter(page).update(1)

  // Configure paragraph properties.
  set par(spacing: 0.88em, leading: 0.78em, first-line-indent: 1em, justify: true)

  // 章見出しを設定
  set heading(
    numbering: (..nums) => {
      nums.pos().map(str).join(".") + " "
    },
  )

  show heading.where(level: 1): it => (
    {
      // counter(math.equation).update(0)
      set text(weight: "bold", size: 11pt, font: ("Hiragino Kaku Gothic ProN", "Times New Roman"))
      let pre_chapt = if it.numbering != none {
        text()[
          #numbering(it.numbering, ..counter(heading).at(it.location()))
          #h(0.5em)
        ]
      } else { none }
      text(
        align(left)[
          #pre_chapt
          #it.body \
        ],
      )
    }
      + empty_par()
  )

  show heading.where(level: 2): it => {
    set text(weight: "bold", size: 10.5pt, font: ("Hiragino Kaku Gothic ProN", "Times New Roman"))
    let pre_chapt = {
      text()[
        #numbering(it.numbering, ..counter(heading).at(it.location()))
        #h(0.5em)
      ]
    }
    align(left)[
      #pre_chapt
      #it.body \
    ]
  }

  show heading: it => {
    set par(leading: 0.78em, first-line-indent: 0em, justify: true)
    set block(above: 1.5em, below: 1.5em)
    it
  }

  place(
    top,
    float: true,
    scope: "parent",
    text(size: 9.5pt)[
      #presentation #h(1fr) #date.at(0) 年 #date.at(1) 月 #date.at(2) 日
    ],
  )
  place(
    top + center,
    float: true,
    scope: "parent",
    text(font: "Hiragino Kaku Gothic ProN", size: 12pt, weight: "bold")[
      #v(20pt)
      #title
    ],
  )
  place(
    top,
    float: true,
    scope: "parent",
    text(size: 9.5pt)[
      #v(10pt)
      #h(1fr) #major #field #laboratory #author
      #v(10pt)
    ],
  )

  set math.equation(supplement: [Eq.], numbering: equation_num, number-align: bottom)

  body

  // 参考文献
  if bibliography-file != none {
    show bibliography: set text(7pt, lang: "en")
    bibliography(bibliography-file, title: "参考文献", style: "ieee")
  }
}
