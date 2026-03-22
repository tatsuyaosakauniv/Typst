#import "report_format.typ": *
#import "@preview/numbly:0.1.0": numbly
#import "@preview/codelst:2.0.0": sourcecode

// #import "@preview/physica:0.9.2"
#show: master_thesis.with(
  title: "計算論",
  subtitle: "期末テスト問題",
  author: "川口 達也",
  id: "2510414",
  university: "JAIST",
  bibliography-file: "",
)

= Problem 1

以下の主張を, 定義に沿って証明せよ.
$
    f(n) = Omicron(g(n)) "かつ" g(n) = Omicron(h(n)) "ならば" f(n) = Omicron(h(n)) "である"
$

#pagebreak()

= Problem 2

任意の平面グラフ $G=(V, E)$ は $|E|<=3|V|-6$ を満たす.

このとき平面グラフ $G$ が次数5以下の頂点を持つことを証明せよ.

#pagebreak()

= Problem 3

計算量クラス $"P"$ に対して自然な計算量クラス $"co-P"$ を定義して, $"P=co-P"$ となることを証明せよ.

#pagebreak()

= Problem 4

$"NP-困難問題"A$ に対して, $A in.not "P"$ を示しても $"P" != "NP"$ を示したことにはならない.

それはなぜか説明せよ.

#pagebreak()

= Problem 5

以下の主張を, 定義に沿って説明せよ.

$
    "co-NP" subset.eq "NP なら NP" = "co-NP である."
$

#pagebreak()

= Problem 6

以下の主張を, 定義に沿って証明せよ.

$
    "あるNP完全問題"A"に対して, P"!="NPなら"A in.not "Pである."
$

#pagebreak()

= Problem 7

2つのグラフ $G_1=(V_1, E_1)$ と $G_2=(V_2, E_2)$ に対して, ある1対1関数 $phi.alt:V_1->V_2$ が存在し, ${u,v} in E_1$ である必要十分条件が 
${phi.alt(u),phi.alt(v)} in E_2$ であるとき, $G_1$ と $G_2$ は *同型* であるという.2つのグラフが同型かどうかを判定する問題がNPに属することを示せ.

#pagebreak()

= Problem 8

計算量クラス $epsilon$ は $epsilon = T I M E_(c>1)(2^(c n))$ で定義される.ただしここで $n$ は入力の長さとする.
多項式時間還元 $"≤"_m^P$ において, 集合 $A,B$ が $A"≤"_m^P B$ を満たすとき, $B in epsilon$ であっても, 必ずしも $A in epsilon$ とは言えない.
なぜか説明せよ.