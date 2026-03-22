#import "report_format.typ": *
#import "@preview/numbly:0.1.0": numbly
#import "@preview/codelst:2.0.0": sourcecode

// #import "@preview/physica:0.9.2"
#show: master_thesis.with(
  title: "統計的信号処理特論",
  subtitle: "中間テスト問題",
  author: "川口 達也",
  id: "2510414",
  university: "JAIST",
  bibliography-file: "",
)

= 病気Cの検査

$ "正しくpositive(陽性)と診断される確率" : 70% $
$ "罹患してないけどpositiveと出る確率" : 30% $
// #h(1.2em)
病気Cに罹患している人は10%である. \
#h(1.2em)
事象を以下のように定義する.
$ "positiveと診断される" : A $
$ "病気Cに罹患する" : C $

(1) $P(C)$ は?

(2) $P(A|overline(C))$ の意味は?

(3) $P(A)$ は?

(4) $P(A|C)P(C) = P(C|A)P(A)$ の証明

(5) 病気Cに罹患してる人がpositiveと診断される確率 $P(C|A)$

#pagebreak()

=

#h(1.2em)
$X$ : 確率変数, $f_X (x)$ : 確率密度関数, $F_X (x)$ : 分布関数とする.
ただし、
$
  F_X (x) = P(X <= x) = integral_(-infinity)^x f_X (v)d v
$

(1) $f_X (x)$ を $F_X (x)$ で表せ.

(2) $Y=L(X)$ とする. ただし, $L$ : 逆 $L^(-1)$ を持つ.（$X = L^(-1)(Y)$）

(i) $Y$ の分布関数$F_Y (y)$ を $f_X (x)$ を用いて表せ.

(ii) $display(f_Y (y) = f_X (L^(-1)(y))(d L^(-1)(y))/(d y))$ を示せ.

(3) $X ~ italic("Exp")(2)$ : 指数分布（$f_X (x) = 2e^(-2x)$）とするとき, $Y = sqrt(x)$ の確率密度関数 $f_Y (y)$ を求めよ

#pagebreak()

= 

(1) $italic("Var")(X) = E(X^2) - {E(X)}^2$ を示せ.

(2) $phi_X (t) = E[e^(j t X)]$ : 特性関数
$
  phi^((n))_X (t) = (d^n phi_X (t))/(d t^n)
$
#h(1.2em)
とするとき, $E(X)$, $E(X^2)$, $italic("Var")(X)$ を $phi^((n))_X$ を用いて示せ.

(3) $X_1, X_2, dots, X_n ~^(i i d) N(mu, sigma^2)$とする. ただし, 
$
  S := sum_(i=1)^n X_i \
  N(mu, sigma^2) ->phi_X (t) = exp(j mu t-(sigma^2 t^2)/2)
$

(i) $phi_S (t)$ は?

(ii) $E(S)$, $italic("Var")(S)$ は?

#pagebreak()

= 

$
  S(omega) = (25 omega^2 + 49)/(omega^4 + 10 omega^2 + 9)
$

(1) 白色フィルタ : $Gamma(s)$, イノベーションフィルタ : $L(s)$ を求めよ.

(2) 最小位相フィルタとは?

(3) $Gamma(s)$, $L(s)$ は最小位相フィルタであることを確認せよ.

(4) $L(s)$ のLaplace変換から $l(t)$ を求めよ.


#pagebreak()

=

$ 
  "線形時不変システム" &: h(t) \
  "広義定常過程 (入力)" &: X(t) \
  "出力" &: Y(t)
$ 

(1) $Y(t) = X(t) * h(t)$ をFourier変換せよ.

(2)
$
 "自己相関" &: R_(X X)(tau) = E[X(t + tau)X^*(t)] \
 "相互相関" &: R_(X Y)(tau) = E[X(t + tau)Y^*(t)]
$
#h(1.2em)
このとき, 
$
  R_(Y Y)(tau) &= R_(X Y)(tau)*h(tau) \
  R_(X Y)(tau) &= R_(X X)(tau)*h^*(-tau)
$
#h(1.2em)
を示せ.

(3)
$
  S_(Y Y)(omega) &= S_(X Y)(omega)H(omega) \
  S_(X Y)(omega) &= S_(X X)(omega)H^*(omega)
$
#h(1.2em)
を示せ.

(4)
$
  Y'(t) + c Y(t) = X(t), italic("where") c in RR : "線形システム"
$
#h(1.2em)
このシステムの伝達関数 $H(omega)$ は?

(5) (4)のシステムに白色ノイズ $W(t)$ を入力したとき、出力のパワースペクトル $S_(Y Y)(omega)$ は? \
#h(1.2em)
ただし、
$
  E[W(t)] &= 0\
  R_(W W)(tau) &= q delta(tau)
$

(6) $R_(Y Y)(tau)$ を求めよ.