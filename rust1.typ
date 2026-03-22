#import "report_format.typ": *
#import "@preview/numbly:0.1.0": numbly
#import "@preview/codelst:2.0.0": sourcecode

// #import "@preview/physica:0.9.2"
#show: master_thesis.with(
  title: "先端情報セキュリティとアルゴリズム",
  number: "1",
  author: "川口 達也",
  id: "2510414",
  university: "JAIST",
  bibliography-file: "bib/reference_sotsuron.bib",
)

#text(weight: "bold", size: 15pt)[
    ② 解説、実行結果
]

ex1.Sの実行結果は以下の通りになる。
\ \
```rust
result: Context {
    cond: Eq,
    x0: 4,
    x1: 1,
    x2: 3,
    x3: 0,
    x4: 0,
    x5: 0,
    x6: 0,
    x7: 0,
    x8: 0,
    x9: 0,
    x10: 0,
    x11: 0,
    x12: 0,
    x13: 0,
    x14: 0,
    x15: 0,
    x16: 0,
    x17: 0,
    x18: 0,
    x19: 0,
    x20: 0,
    x21: 0,
    x22: 0,
    x23: 0,
    x24: 0,
    x25: 0,
    x26: 0,
    x27: 0,
    x28: 0,
    x29: 0,
    x30: 0,
}
```
\ \
これは、レジスタx1に1を代入、レジスタx2に3を代入、x1とx2を足して、それをx0に入れている。

#pagebreak()

ex2.Sの実行結果は以下の通りになる。
\ \
```rust
result: Context {
    cond: Eq,
    x0: 362880,
    x1: 10,
    x2: 1,
    x3: 10,
    x4: 0,
    x5: 0,
    x6: 0,
    x7: 0,
    x8: 0,
    x9: 0,
    x10: 0,
    x11: 0,
    x12: 0,
    x13: 0,
    x14: 0,
    x15: 0,
    x16: 0,
    x17: 0,
    x18: 0,
    x19: 0,
    x20: 0,
    x21: 0,
    x22: 0,
    x23: 0,
    x24: 0,
    x25: 0,
    x26: 0,
    x27: 0,
    x28: 0,
    x29: 0,
    x30: 0,
}
```
\ \
これは、レジスタx1に1を代入、x0に1を代入、x2に1を代入、x3に10を代入し、続いて次の操作をループする。x1とx0をかけてx0に代入、x1とx2を足してx2に代入、x1とx3を比較してctx.condにLt/Eq/Gtをセット、x1 < x3の間は行4にジャンプしてループを継続、そうでない場合は終了、つまり、x3に代入された10回分ループする。
この計算は、9!を計算してx0に代入するコードである。

#pagebreak()

#text(weight: "bold", size: 15pt)[
    ③ ex3.Sの作成と解説
]

実行結果を以下に示す。
\ \
```rust
result: Context {
    cond: Eq,
    x0: 2025,
    x1: 11,
    x2: 184,
    x3: 1,
    x4: 2024,
    x5: 0,
    x6: 0,
    x7: 0,
    x8: 0,
    x9: 0,
    x10: 0,
    x11: 0,
    x12: 0,
    x13: 0,
    x14: 0,
    x15: 0,
    x16: 0,
    x17: 0,
    x18: 0,
    x19: 0,
    x20: 0,
    x21: 0,
    x22: 0,
    x23: 0,
    x24: 0,
    x25: 0,
    x26: 0,
    x27: 0,
    x28: 0,
    x29: 0,
    x30: 0,
}
```
\ \
これは、x0をx1で割った商と余りをそれぞれx2とx3に出力するコード \
採用した理由としては、ex1.Sとex2.Sでまだ割り算と引き算を使っていなかったからです。
