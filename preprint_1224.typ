#import "./preprint_format.typ": *
#show: preprint.with(
  presentation: "中間発表",
  title: "分子動力学シミュレーションと機械学習を利用した固液界面熱流束ゆらぎの予測",
  author: "川口 達也",
  university: "機械工学科目",
  department: "マイクロ熱工学領域",
  laboratory: "芝原・藤原研究室",
  bibliography-file: "bib/reference_sotsuron.bib",
)

= 諸言

#h(9.5pt) // 段落空けがうまくいかなかったのでここでやる
近年，ナノスケールにおける熱伝導特性の理解は，次世代の高度な材料やデバイスの設計において極めて重要な課題となっている．特に電子デバイスや半導体デバイスなどのさらなる小型化に伴い，ナノスケールでの効率的な熱管理がデバイスの性能に大きく影響する．このナノスケールでの熱伝導特性を明らかにするため，古典分子動力学シミュレーションや第一原理計算を用いた熱量の計算が行われてきた．

#h(9.5pt)
しかし，例えばナノスケールでの熱輸送現象において，界面の熱抵抗は無視できない．この界面熱抵抗を計算するためには熱流束の自己相関関数を収束させる必要があり，これには．膨大な計算時間がかかる．これらの計算コストを削減しつつ，高精度な予測を可能にするために，MD（Molecular Dynamics）シミュレーションと機械学習を融合させるアプローチが注目されている@gan_heatflux．

#h(9.5pt)
さらに，熱流束ゆらぎの予測が可能になると，熱伝導率の異方性や局所的な熱輸送特性をより詳細に評価できるようになる．熱流束の時間的・空間的変動を考慮した材料設計が実現すれば，熱管理の効率化や，次世代デバイスの信頼性向上に寄与できる．特に，熱流束ゆらぎの理解は，従来のマクロスケールモデルでは捉えきれなかった現象の解明にもつながり，これに基づく新しい理論やモデルの構築が期待されている@nano_device．

#h(9.5pt)
そこで本研究では，GAN（Generative Adversarial Network）を用いて，少量のサンプルデータから統計的にAr - Pt系の熱流束ゆらぎを予測することを目的とする．
#v(10pt)

= 計算方法
== MDシミュレーションモデル

#h(9.5pt)
本研究ではMDシミュレーションのモデルとして，Ar液体分子の上下をPt壁面で挟んだAr - Pt壁面系を用いた．
まず系の大きさを3.92 $times$ 3.92 $times$ 8.70 $"nm"^3$とし，x, y方向にのみ周期境界条件を適用し，分子間相互作用には12 - 6 Lennard-Jones ポテンシャルを用いた．
Ar - Pt間のパラメータについては，Lorentz-Berthelot則に基づいて計算し，@eq1 のように，相互作用強さを表すパラメータ $alpha$ を0.1としてポテンシャル関数に乗じている．また，数値積分法は蛙跳び法，時間刻みは1.0 fsとし，Ptの温度制御にはLangevin法を用いている．

$
  italic(Phi)(r_(i j)) =
  4 alpha epsilon_(i j) {((sigma_(i j)) / r_(i j))^12 - ((sigma_(i j)) / r_(i j))^6}
$ <eq1>

#h(9.5pt)
計算時間については，速度スケーリング時間を0.1 ns，緩和計算時間を1.0 ns，本計算時間を10.0 nsとしている．ここで，熱流束の算出に関しては，以下の@eq2 のように分子間に働く相互作用力により算出する．

$
  bold(J) (t) =
  1 / A (sum_(i in "Pt")^N sum_(j in "Ar")^M bold(F)_(i j) dot bold(v)_i)
$ <eq2>

#h(9.5pt)
ここで，$J_z (t)$ は時刻 $t$ における瞬間的なz方向の熱流束， $A$ はPt壁面の断面積，$bold(F)_(i j)$ はPtがArから受ける相互作用力のz方向成分，$bold(v)_i$ はPt原子のz方向の速度である．得られた熱流束を用いて，EMD（Equilibrium Molecular Dynamics）における界面熱抵抗を以下の@eq3 により算出する．

$
  1 / R =
  A / (k_" B" T_0^2) integral_0^infinity angle.l J_z (t) dot J_z (0) angle.r d t
$ <eq3>

#h(9.5pt)
ここで，$R$ は界面熱抵抗，$k_" B"$ はボルツマン定数，$T_0$ は平衡時の系内の温度，$J_z (0)$ は時刻0における瞬間的なz方向の熱流束である．また，$angle.l square angle.r$ はアンサンブル平均を表す．本研究では，$T_0 = 100" K"$，相関時間を10psとした．今回のMDシミュレーションは$10^7$ ステップ計算を回し，10ステップごとに熱流束のデータ記録して$10^6$ 個のデータセットを用意した．

#v(10pt)
== 機械学習モデル

#h(9.5pt)
本研究では，機械学習モデルとしてGANを用いている．学習フローを以下の @img1 に示す．GANモデルに用いるデータセットとしては，MDシミュレーションで得られた熱流束ゆらぎのデータ$10^6$ セットのうち，$3 times 10^5$ セットを学習させ，学習モデルに$10^6$ セット分の熱流束データを出力させて元データと比較し，最終的には自己相関関数を作成して界面熱抵抗を求めることで，モデルの妥当性を判断する．

#h(9.5pt)
ここで，入力するランダムノイズデータの長さは1000とし，生成器と識別器の学習率はそれぞれ，$2 times 10^(-6)$，$4 times 10^(-7)$ としている@mdgan_msd_vacf． また，バッチサイズは30，イテレーション数は20000としているほか，先行研究 @gan_heatflux に倣って，活性化関数はReLU関数，最適化アルゴリズムはRMSpropを用いており，隠れ層のノードを128としている． \
\
\

#img(
  image("Figures/GANmodel.png", width: 100%),
  caption: [Structure of Generative Adversarial Networks (GAN).],
) <img1>\

#pagebreak()

// ----------------------------------------次のページ------------------------------------------

#img(
  grid(
    columns: 2,
    [#figure(
        image("Figures/heatflux_true.png"),
        supplement: "図",
      )],
    [#figure(
        image("Figures/heatflux_pred.png"),
        supplement: "図",
      )],
  ),
  caption: [
    Time Series of Heat Flux of 100ps \
    by MD Simulation (#text(fill: rgb(100%,0%,0%))[red]), and by GAN (#text(fill: rgb(0%,0%,100%))[blue]).
  ],
) <img2>\

#img(
  grid(
    columns: 2,
    [#figure(
        image("Figures/heatflux_true_0_10.png"),
        supplement: "図",
      )],
    [#figure(
        image("Figures/heatflux_pred_0_10.png"),
        supplement: "図",
      )],
  ),
  caption: [
    ,
  ],
) <img3>\

= 結果・考察

#h(9.5pt)
MDシミュレーションの元のデータ（#text(fill: rgb(100%,0%,0%))[赤色]）とGANに生成させた熱流束（#text(fill: rgb(0%,0%,100%))[青色]）について，10ns全体のデータを @img2 に，その一部の10psのデータを @img3 に示す．
@img2 を見ると，元データよりも予測データの方が，ゆらぎの範囲が少し小さいことがわかる．
また，@img3 を見ると，ゆらぎのブレの大きさがより顕著になり，ゆらぎが上下に変化する頻度も高くなっている．これは損失関数の更新が不安定になっている可能性があるため，改善案としてはバッチサイズを大きくすることが考えられる．

#h(9.5pt)
続いて，元データ（#text(fill: rgb(100%,0%,0%))[赤色]）と生成させたデータ（#text(fill: rgb(0%,0%,100%))[青色]）から作成した自己相関関数を以下の @img4 に示す．
@img4 を見ると，元データの方は10psでおよそ自己相関関数は収束しているが，予測データの方は大きく振動して0に収束する様子はない．

#h(9.5pt)
続いて，@img4 の自己相関関数より計算した界面熱抵抗の，相関時間の長さとの関係を表したグラフを @img5 に示す．
@img5 の元データの方を見ると，界面熱抵抗の値が一定の値に収束していないため，そもそも相関関数が足りない可能性がある．また，グラフが全体的にブレているところから，@img4 のプロット間隔をもう少し増やすことが考えられる．
\
\
\
\
\



#img(
  grid(
    columns: 2,
    [#figure(
        image("Figures/ACF_true.png"),
        supplement: "図",
      )],
    [#figure(
        image("Figures/ACF_pred.png"),
        supplement: "図",
      )],
  ),
  caption: [
    Autocorrelation Function (ACF) \
    by MD Simulation (#text(fill: rgb(100%,0%,0%))[red]), and by GAN (#text(fill: rgb(0%,0%,100%))[blue]).
  ],
) <img4>\

#img(
  grid(
    columns: 2,
    [#figure(
        image("Figures/ITR_true.png"),
        supplement: "図",
      )],
    [#figure(
        image("Figures/ITR_pred.png"),
        supplement: "図",
      )],
  ),
  caption: [
    Interfacial Thermal Resistance (ITR) \
    by MD Simulation (#text(fill: rgb(100%,0%,0%))[red]), and by GAN (#text(fill: rgb(0%,0%,100%))[blue]).
  ],
) <img5>\

= 結言

#h(9.5pt)
本研究では，MDシミュレーションから得たデータを用いてGANの熱流束ゆらぎの予測精度について調査した．
結果として，生成された熱流束は似た形のゆらぎ方にはなったが，自己相関関数や界面熱抵抗は望ましい結果が得られなかったため，
今後の展望としては，引き続きGANモデルの設計条件を変更して，予測精度を向上することを目指す．

#v(10pt)
