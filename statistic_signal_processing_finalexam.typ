#import "report_format.typ": *
#import "@preview/numbly:0.1.0": numbly
#import "@preview/codelst:2.0.0": sourcecode

// #import "@preview/physica:0.9.2"
#show: master_thesis.with(
  title: "統計的信号処理特論",
  subtitle: "期末テスト問題",
  author: "川口 達也",
  id: "2510414",
  university: "JAIST",
  bibliography-file: "",
)

= 
#h(1.2em)
確率変数を
$
    X_1, X_2, ..., X_n ~^(i i d) N(mu, sigma^2)
$
#h(1.2em)
とする. また, 標本平均, 推定量を
$
    overline(X)_n &= 1/n sum_(i=1)^n X_i \
    hat(theta) &= overline(X)_n
$

(1) $hat(theta)$ は不偏推定量か?

(2) $hat(theta)$ は一致性を持つか?

#pagebreak()

= 
#h(1.2em)
確率変数を
$
    X ~ U[-1/2, 1/2]
$
#h(1.2em)
とし, 推定量を $ theta = sin(2 pi X) $
#h(1.2em)
と定義する.
このとき, 線形推定量 $ &hat(theta) = a X $
#h(1.2em)
を考える.

(1) $E[X^2], E[theta^2], E[theta X]$ を求めよ.

(2) LMMSE（最小二乗線形推定量）を求め, 最適な $a$ を求めよ.

(3) BMSE（最小平均二乗誤差） を求めよ.

#pagebreak()

=

$
    "観測データ": {y_1, y_2, ..., y_n}
$
#h(1.2em)
が次のモデルで得られるとする.
$
    y_i = A r + w_i #h(1em) (i=1, 2, ..., n)
$
#h(1.2em)
ただし,
$
    w_1, w_2, ..., w_n ~^(i i d) N(0, sigma^2) #h(2em) (r "は既知")\
$

(1) 尤度関数 $p(y|A)$ と対数尤度 $ln(p(y|A))$ を求めよ.

(2)
$
    E[(partial ln(p(y|A)))/(partial A)]=0
$
#h(1.2em)
スコア関数の期待値が0になることを示せ.

(3) パラメータ $A$ の $"Cramér-Rao"$ 下限（CRLB）を求めよ.

(4) 最尤推定量（MLE） $hat(A)$ を求めよ.

(5) 次の表現をFisher情報 $I(A)$, 真値 $A$, 推定値 $hat(A)$ を用いて表せ.
$
    display((partial ln(p(y|A)))/(partial A)) =... ?
$

#pagebreak()

= 
#h(1.2em)
時系列 $S(t)$ が与えられたとき,
$
    hat(S)(t + tau) = a S(t)
$
#h(1.2em)
という線形予測を行う.

(1) 最適な $a$ を自己相関関数 $R_S (tau)$ を用いて求めよ.

(2) このときの最小平均二乗誤差（BMSE）を求めよ.

#pagebreak()

= 
#h(1.2em)
周波数領域において次のモデルを考える.
$
    D(omega) &= L(omega)S(omega) + N(omega) \
    hat(S)(omega) &= W(omega)D(omega)
$
#h(1.2em)
ただし,
$
    cases(
        E[S(omega)N^*(omega)] = 0,
        E[N(omega)S^*(omega)] = 0
    ) \

    cases(
        P_S &= E[ |S(omega)|^2],
        P_N &= E[ |N(omega)|^2]
    )
    :"パワースペクトル" \
$
#h(1.2em)
である. 推定誤差
$
    J = E[ |S(omega) - hat(S)(omega)|^2]
$
#h(1.2em)
を最小にする $W(omega)$ を求める.

(1) $J$ を $L(omega), W(omega), P_S, P_N$ を用いて表せ.

(2) $J$ を最小化するWienerフィルタ
$
    W(omega) = op("argmin", limits: #true)_W(omega) J
$

#h(1.2em)
を求め, $L(omega), P_S, P_N$ で表せ.

#pagebreak()

Hint: 

$
    J = |1-W(omega)L(omega)|^2 P_S + |W(omega)|^2 P_N
$
$
    J_1 &= |1-W(omega)L(omega)|^2 \
    J_2 &= |W(omega)|^2 P_N
$

$
    (partial J)/(partial omega^*) = 0, #h(1em) (partial J)/(partial omega^*) = 0 \

    cases(
        W(omega) &= Re(W(omega)) + i Im(W(omega)),
        W^*(omega) &= Re(W(omega)) - i Im(W(omega))
    )
$
$
    J_1 = |1-W(omega)L(omega)|^2
    &= (1-W(omega)L(omega))(1-W(omega)L(omega))^* \
    &= (1-W(omega)L(omega))(1-W^*(omega)L^*(omega))
$
$
    (partial J_1)/(partial W^*) = -(1-W(omega)L(omega))L^*(omega)
$
$
    J_2 = W(omega)W^*(omega)P_N \
    (partial J_2)/(partial W^*) = W(omega)P_N
$
$
    cases(
        display((partial W)/(partial omega^*) &= 0),
        display((partial W^*)/(partial omega^*) &= 1)
    )
$

#pagebreak()

= カルマンフィルタ

$
    cases(
        x_n = 1/2 x_(n-1) + v_n #h(2em) &: v_n ~ N(0, 1) \, x_0 ~ N(0, 1),
        y_n = x_n + w_n &: w_n ~ N(0, 1)
    )\
$
$
    Y_n = {y_0, y_1, ..., y_n}
$
$
    "条件付期待値": x_(n+m|n) &= E[x_(n+m)|Y_n] \
    : V_(n+m|n) &= "Var"[x_(n+m)|Y_n] \
    &= E[(x_(n+m) - x_(n+m|n))^2|Y_n]
$

(1) 条件付期待値および分散を求めよ.
$
    x_(n|n-1) &= E[x_n|Y_(n-1)] \
    V_(n|n-1) &= "Var"[x_n|Y_(n-1)]
$

(2) カルマンゲイン $K_n$ を用いた推定値および分散を求めよ.
$
    x_(n|n) &= x_(n|n-1) + K_n (y_n - x_(n|n-1)) \
    V_(n|n) &= "Var"[x_n|Y_n]
$

(3) 平均二乗誤差 $V_(n|n)$ を最小化するようにカルマンゲイン $K_n$ を求めよ.

#h(1.2em)
ヒント: 
$
    (partial V_(n|n))/(partial K_n) = 0 \
$

(4) 更新後の分散 $V_(n|n)$ を用いて予測分散
$
    V_(n+1|n) &= 1/4 V_(n|n) + 1 \
$
#h(1.2em)
を計算し,
$
    V_infinity :&= lim_(n -> infinity) V_(n+1|n) \
$
#h(1.2em)
を求めよ.さらに,
$
    lim_(n -> infinity) K_n
$
#h(1.2em)
も求めよ.

#pagebreak()

Hint:

(1)
$
    x_(n|n-1) &= E[X_n|Y_(n-1)] \
    &= E[{1/2 x_(n-1)+v_n}|Y_(n-1)] \
    &= 1/2 E[x_(n-1)|Y_(n-1)] + E[v_n|Y_(n-1)] = 1/2 x_(n-1|n-1) \
    V_(n|n-1) &= E[(x_n - x_(n|n-1))^2|Y_(n-1)] \
    &= ... \
    &= 1/4 V_(n-1|n-1) + 1
$

(2)
$
    x_(n|n) &= x_(n|n-1) + K_n (y_n - x_(n|n-1)) \
    V_(n|n) &= E[(x_n - x_(n|n))^2|Y_n] \
    &= ... \
    &= (1 - K_n)^2 V_(n|n-1) + K_n^2
$

(3)
$
    & #h(2em) (partial V_(n|n))/(partial K_n) = 0 \
    &<=> ...  \
    &<=> K_n = (V_(n|n-1))/(V_(n|n-1) + 1)
$

(4)
$
    V_(n+1|n) &= 1/4 V_(n|n) + 1 \
    &= 1/4 (V_(n|n-1)/(V_(n|n-1) + 1)) + 1 \
    V_infinity :&= lim_(n -> infinity) V_(n+1|n) \
    &= 1/4 ((display(lim_(n -> infinity)) V_(n|n-1))/(display(lim_(n -> infinity)) V_(n|n-1) + 1)) \
    &= 1/4 V_infinity/(V_infinity+1) + 1 \
    lim_(n -> infinity) K_n &= V_infinity/(V_infinity + 1)
$