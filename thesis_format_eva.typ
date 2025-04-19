
// 定理環境の番号付けのためのカウンターを保存
#let thmcounters = state(
  "thm",
  (
    "counters": ("heading": ()),
    "latest": (),
  ),
)

// 定理環境を設定
#let thmenv(identifier, base, base_level, fmt) = {
  let global_numbering = numbering

  return (
    ..args,
    body,
    number: auto,
    numbering: "1.1",
    refnumbering: auto,
    supplement: identifier,
    base: base,
    base_level: base_level,
  ) => {
    let name = none
    if args != none and args.pos().len() > 0 {
      name = args.pos().first()
    }
    if refnumbering == auto {
      refnumbering = numbering
    }
    let result = none
    if number == auto and numbering == none {
      number = none
    }
    if number == auto and numbering != none {
      result = locate(loc => {
        return thmcounters.update(thmpair => {
          let counters = thmpair.at("counters")
          // ヘッダーカウンターを手動で更新
          counters.at("heading") = counter(heading).at(loc)
          if not identifier in counters.keys() {
            counters.insert(identifier, (0,))
          }

          let tc = counters.at(identifier)
          if base != none {
            let bc = counters.at(base)

            // ベースカウントの長さを調整（不足を埋めるまたは余剰を削る）
            if base_level != none {
              if bc.len() < base_level {
                bc = bc + (0,) * (base_level - bc.len())
              } else if bc.len() > base_level {
                bc = bc.slice(0, base_level)
              }
            }

            // ベースカウンターが更新された場合にカウンターをリセット
            if tc.slice(0, -1) == bc {
              counters.at(identifier) = (..bc, tc.last() + 1)
            } else {
              counters.at(identifier) = (..bc, 1)
            }
          } else {
            // ベースカウンターがない場合、単一レベルでカウント
            counters.at(identifier) = (tc.last() + 1,)
            let latest = counters.at(identifier)
          }

          let latest = counters.at(identifier)
          return (
            "counters": counters,
            "latest": latest,
          )
        })
      })

      number = thmcounters.display(x => {
        return global_numbering(numbering, ..x.at("latest"))
      })
    }

    return figure(
      result
        + // 臨時措置
        fmt(name, number, body, ..args.named())
        + [#metadata(identifier) <meta:thmenvcounter>],
      kind: "thmenv",
      outlined: false,
      caption: none,
      supplement: supplement,
      numbering: refnumbering,
    )
  }
}

// 定理ボックスを定義
#let thmbox(
  identifier,
  head,
  ..blockargs,
  supplement: auto,
  padding: (top: 0.5em, bottom: 0.5em),
  namefmt: x => [(#x)],
  titlefmt: strong,
  bodyfmt: x => x,
  separator: [#h(0.1em):#h(0.2em)],
  base: "heading",
  base_level: none,
) = {
  if supplement == auto {
    supplement = head
  }
  let boxfmt(name, number, body, title: auto) = {
    if not name == none {
      name = [ #namefmt(name)]
    } else {
      name = []
    }
    if title == auto {
      title = head
    }
    if not number == none {
      title += " " + number
    }
    title = titlefmt(title)
    body = bodyfmt(body)
    pad(
      ..padding,
      block(
        width: 100%,
        inset: 1.2em,
        radius: 0.3em,
        breakable: false,
        ..blockargs.named(),
        [#title#name#separator#body],
      ),
    )
  }
  return thmenv(
    identifier,
    base,
    base_level,
    boxfmt,
  ).with(supplement: supplement)
}

// プレーン版の設定
#let thmplain = thmbox.with(
  padding: (top: 0em, bottom: 0em),
  breakable: true,
  inset: (top: 0em, left: 1.2em, right: 1.2em),
  namefmt: name => emph([(#name)]),
  titlefmt: emph,
)

// 数式の番号付け
#let equation_num(_) = {
  locate(loc => {
    let chapt = counter(heading).at(loc).at(0)
    let sec = counter(heading).at(loc).at(1)
    let c = counter(math.equation)
    let n = c.at(loc).at(0)
    "(" + str(chapt) + "." + str(sec) + "." + str(n) + ")"
  })
}

// 表の番号付け
#let table_num(_) = {
  locate(loc => {
    let chapt = counter(heading).at(loc).at(0)
    let c = counter("table-chapter" + str(chapt))
    let n = c.at(loc).at(0)
    str(chapt) + "." + str(n + 1)
  })
}

// 画像の番号付け
#let image_num(_) = {
  locate(loc => {
    let chapt = counter(heading).at(loc).at(0)
    let c = counter("image-chapter" + str(chapt))
    let n = c.at(loc).at(0)
    str(chapt) + "." + str(n + 1)
  })
}

// 表形式の定義
#let tbl(tbl, caption: "") = {
  // let frame(stroke) = (x, y) => (
  //   left: if x > 0 { 0pt } else { stroke },
  //   right: stroke,
  //   top: stroke,
  //   bottom: stroke,
  // )
  figure(
    tbl,
    caption: caption,
    supplement: [Table],
    numbering: table_num,
    kind: "table",
  )
}

// 画像形式の定義
#let img(img, caption: "") = {
  figure(
    img,
    caption: caption,
    supplement: [Fig.],
    numbering: image_num,
    kind: "image",
  )
}

// // Definition of abstruct page
// #let abstract_page(abstract_ja, abstract_en, keywords_ja: (), keywords_en: ()) = {
//   if abstract_ja != [] {
//     show <_ja_abstract_>: {
//       align(center)[
//         #text(size: 20pt, "概要")
//       ]
//     }
//     [= 概要 <_ja_abstract_>]

//     v(30pt)
//     set text(size: 12pt)
//     h(1em)
//     abstract_ja
//     par(first-line-indent: 0em)[
//       #text(weight: "bold", size: 12pt)[
//         // キーワード:
//         // #keywords_ja.join(", ")
//       ]
//     ]
//   } else {
//     show <_en_abstract_>: {
//       align(center)[
//         #text(size: 18pt, "Abstruct")
//       ]
//     }
//     [= Abstract <_en_abstract_>]

//     set text(size: 12pt)
//     h(1em)
//     abstract_en
//     par(first-line-indent: 0em)[
//       #text(weight: "bold", size: 12pt)[
//         Key Words:
//         #keywords_en.join("; ")
//       ]
//     ]
//   }
// }

// コンテンツを文字列に変換する定義
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

// 目次の定義
#let toc() = {
  align(left)[
    #text(font: "Hiragino Mincho ProN", size: 25pt, weight: "bold")[
      #v(-10pt)
      目次
      #v(10pt)
    ]
  ]

  set text(size: 1em)
  set par(leading: 1.35em, first-line-indent: 0pt)
  locate(loc => {
    let elements = query(heading.where(outlined: true), loc)
    for el in elements {
      let before_toc = (
        query(heading.where(outlined: true).before(loc), loc).find(one => {
          one.body == el.body
        })
          != none
      )
      let page_num = if before_toc {
        numbering("i", counter(page).at(el.location()).first())
      } else {
        counter(page).at(el.location()).first()
      }

      link(el.location())[#{
          // 謝辞には番号付けがない
          let chapt_num = if el.numbering != none {
            numbering(el.numbering, ..counter(heading).at(el.location()))
          } else { none }

          if el.level == 1 {
            set text(font: "Hiragino Mincho ProN", weight: "black")
            if chapt_num == none { } else {
              chapt_num
              "  "
            }
            let rebody = to-string(el.body)
            rebody
          } else if el.level == 2 {
            h(1em)
            chapt_num
            " "
            let rebody = to-string(el.body)
            rebody
          } else {
            h(2.5em)
            chapt_num
            " "
            let rebody = to-string(el.body)
            rebody
          }
        }]
      box(width: 1fr, h(0.5em) + box(width: 1fr, repeat[$dot$]) + h(0.5em))
      [#page_num]
      linebreak()
    }
  })
}

// // Definition of image outline
// #let toc_img() = {
//   align(left)[
//     #text(size: 20pt, weight: "bold")[
//       #v(30pt)
//       図目次
//       #v(30pt)
//     ]
//   ]

//   set text(size: 12pt)
//   set par(leading: 1.24em, first-line-indent: 0pt)
//   locate(loc => {
//     let elements = query(figure.where(outlined: true, kind: "image"), loc)
//     for el in elements {
//       let chapt = counter(heading).at(el.location()).at(0)
//       let num = counter(el.kind + "-chapter" + str(chapt)).at(el.location()).at(0) + 1
//       let page_num = counter(page).at(el.location()).first()
//       let caption_body = to-string(el.caption.body)
//       str(chapt)
//       "."
//       str(num)
//       h(1em)
//       caption_body
//       box(width: 1fr, h(0.5em) + box(width: 1fr, repeat[.]) + h(0.5em))
//       [#page_num]
//       linebreak()
//     }
//   })
// }

// // Definition of table outline
// #let toc_tbl() = {
//   align(left)[
//     #text(size: 20pt, weight: "bold")[
//       #v(30pt)
//       表目次
//       #v(30pt)
//     ]
//   ]

//   set text(size: 12pt)
//   set par(leading: 1.24em, first-line-indent: 0pt)
//   locate(loc => {
//     let elements = query(figure.where(outlined: true, kind: "table"), loc)
//     for el in elements {
//       let chapt = counter(heading).at(el.location()).at(0)
//       let num = counter(el.kind + "-chapter" + str(chapt)).at(el.location()).at(0) + 1
//       let page_num = counter(page).at(el.location()).first()
//       let caption_body = to-string(el.caption.body)
//       str(chapt)
//       "."
//       str(num)
//       h(1em)
//       caption_body
//       box(width: 1fr, h(0.5em) + box(width: 1fr, repeat[.]) + h(0.5em))
//       [#page_num]
//       linebreak()
//     }
//   })
// }

// 空の段落を設定
#let empty_par() = {
  v(-1em)
  box()
}

// 論文の構築
#let master_thesis(
  // 修士論文のタイトル
  title: "ここにtitleが入る",
  // 論文の著者
  author: "ここに著者が入る",
  // 著者の情報
  university: "",
  school: "",
  department: "",
  id: "",
  mentor: "",
  mentor-post: "",
  mentor2: "",
  mentor-post2: "",
  class: "修士",
  date: (datetime.today().year(), datetime.today().month(), datetime.today().day()),
  paper-type: "論文",
  // アブストラクト
  abstract_ja: [],
  abstract_en: [],
  keywords_ja: (),
  keywords_en: (),
  // 使用する紙のサイズ
  paper-size: "a4",
  // 外部の文献を引用する場合、文献ファイルのパス
  bibliography-file: none,
  // 論文の本文
  body,
  // 謝辞
  acknowledgments: none,
) = {
  // 引用番号
  show ref: it => {
    if it.element != none and it.element.func() == figure {
      let el = it.element
      let loc = el.location()
      let chapt = counter(heading).at(loc).at(0)

      link(loc)[#if el.kind == "image" or el.kind == "table" {
          // 番号付け
          let num = counter(el.kind + "-chapter" + str(chapt)).at(loc).at(0) + 1
          it.element.supplement
          " "
          str(chapt)
          "."
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
      let chapt = counter(heading).at(loc).at(0)
      let sec = counter(heading).at(loc).at(1)
      let num = counter(math.equation).at(loc).at(0)

      it.element.supplement
      " ("
      str(chapt)
      "."
      str(sec)
      "."
      str(num)
      ")"
    } else if it.element != none and it.element.func() == heading {
      let el = it.element
      let loc = el.location()
      let num = numbering(el.numbering, ..counter(heading).at(loc))
      if el.level == 1 {
        str(num)
        "章"
      } else if el.level == 2 {
        str(num)
        "節"
      } else if el.level == 3 {
        str(num)
        "項"
      }
    } else {
      it
    }
  }

  // キャプション番号のカウント
  show figure: it => {
    set align(center)
    if it.kind == "image" {
      set text(size: 1em)
      it.body
      it.supplement
      " " + it.counter.display(it.numbering)
      " " + it.caption.body
      locate(loc => {
        let chapt = counter(heading).at(loc).at(0)
        let c = counter("image-chapter" + str(chapt))
        c.step()
      })
    } else if it.kind == "table" {
      set text(size: 10.5pt)
      it.supplement
      " " + it.counter.display(it.numbering)
      " " + it.caption.body
      set text(size: 10.5pt)
      it.body
      locate(loc => {
        let chapt = counter(heading).at(loc).at(0)
        let c = counter("table-chapter" + str(chapt))
        c.step()
      })
    } else {
      it
    }
  }

  // ドキュメントのメタデータを設定
  set document(title: title, author: author)

  // 本文フォントを設定。TeX Gyre PagellaはPalatinoの無料代替フォント
  set text(
    font: (
      "Times New Roman",
      // "Hiragino Mincho ProN",
      "Hiragino Mincho ProN",
    ),
    size: 11pt,
  )

  // ページのプロパティを設定
  set page(
    paper: paper-size,
    margin: (bottom: 1.75cm, top: 3.7cm),
  )

  // 最初のページ
  align(center)[
    #v(80pt)
    #text(size: 20pt)[
      #class#paper-type
    ]
    #v(40pt)
    #text(font: "Hiragino Mincho ProN", weight: "bold", size: 22pt)[
      #title
    ]
    #v(50pt)


    #text(size: 16pt)[
      指導教員 \
      #mentor #mentor-post \
      #mentor2 #mentor-post2

    ]
    #v(40pt)
    #text(size: 16pt)[
      // #date.at(0) 年 #date.at(1) 月 #date.at(2) 日
      2025年2月10日
    ]

    #text(size: 16pt)[
      #university #school #department
    ]
    #v(40pt)
    #text(font: "Hiragino Mincho ProN", weight: "bold", size: 18pt)[
      #author
    ]
    #pagebreak()
  ]

  // set page(
  //   footer: [
  //     #align(center)[#counter(page).display("i")]
  //   ],
  // )

  counter(page).update(1)
  //   // アブストラクトを表示
  //   abstract_page(abstract_ja, abstract_en, keywords_ja: keywords_ja, keywords_en: keywords_en)
  //   pagebreak()

  // 段落のプロパティを設定
  set par(leading: 0.78em, first-line-indent: 1em, justify: true)
  show par: set block(spacing: 0.78em)

  // 章見出しを設定
  set heading(
    numbering: (..nums) => {
      nums.pos().map(str).join(".") + " "
    },
  )
  show heading.where(level: 1): it => {
    pagebreak()
    counter(math.equation).update(0)
    set text(weight: "bold", size: 120pt)
    set block(spacing: 1.5em)
    let pre_chapt = if it.numbering != none {
      text()[
        #v(0pt)
        第 #numbering(it.numbering, ..counter(heading).at(it.location()))章
        #v(-80pt)
      ]
    } else { none }

    if it.numbering != none {
      text()[
        #pre_chapt \
        // #h(20pt)
        #it.body \
        #pagebreak()
      ]
    } else {
      text()[
        #v(-70pt)
        #pre_chapt \
        #it.body \
        // #v(30pt)
      ]
    }
  }
  show heading.where(level: 2): it => {
    counter(math.equation).update(0)
    set text(weight: "bold", size: 16pt)
    set block(above: 1.5em, below: 1.5em)
    it
  }

  show heading.where(level: 3): it => {
    // counter(math.equation).update(0)
    set text(weight: "bold", size: 14pt)
    set block(above: 1.5em, below: 1.5em)
    it
  }

  show heading: it => (
    {
      set text(font: "Hiragino Mincho ProN", weight: "bold", size: 14pt)
      set block(above: 1.5em, below: 1.5em)
      it
    }
      + empty_par()
  )

  // 章の目次を表示
  toc()
  // pagebreak()    // 図目次は省略
  //   toc_img()
  // pagebreak()    // 表目次は省略
  //   toc_tbl()

  set page(
    footer: [
      #align(center)[#counter(page).display("1")]
    ],
  )

  counter(page).update(1)

  set math.equation(supplement: [式], numbering: equation_num)

  set enum(body-indent: 1em, indent: 2em, spacing: 1.3em)
  set list(body-indent: 1em, indent: 2em, spacing: 1.3em)
  body

  // // 謝辞を表示
  // pagebreak()
  // align(left)[
  //   #text(size: 30pt, weight: "bold")[
  //     謝辞
  //   ]
  // ]
  // acknowledgments

  // 参考文献を表示
  if bibliography-file != none {
    show bibliography: set text(1em, lang: "en")
    bibliography(bibliography-file, title: "参考文献", style: "ieee")
  }
}

// LATEX文字を構成する
#let LATEX = {
  [L]
  box(
    move(
      dx: -4.2pt,
      dy: -1.2pt,
      box(scale(65%)[A]),
    ),
  )
  box(
    move(
      dx: -5.7pt,
      dy: 0pt,
      [T],
    ),
  )
  box(
    move(
      dx: -7.0pt,
      dy: 2.7pt,
      box(scale(100%)[E]),
    ),
  )
  box(
    move(
      dx: -8.0pt,
      dy: 0pt,
      [X],
    ),
  )
  h(-8.0pt)
}
