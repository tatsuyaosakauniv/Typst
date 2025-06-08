#import "./preprint_format.typ": *
// #import "@preview/physica:0.9.2": *
// #import "@preview/chem-par:0.0.1": *

// #show: chem-style

#show: preprint.with(
  presentation: [卒業論文発表会],
  title: "分子動力学シミュレーションと機械学習を利用した固液界面熱流束ゆらぎの予測",
  author: "川口 達也",
  university: [大阪大学],
  faculty: [工学部],
  department: [応用理工学科],
  major: [機械工学科目],
  field: [マイクロ熱工学領域],
  laboratory: [芝原・藤原研究室],
  date: ("2025", "2", "17"),
  bibliography-file: "bib/reference_maezuri.bib",
)

= 緒言

// ナノスケールにおける熱伝導特性の理解は，次世代の高度な材料やデバイスの熱設計において極めて重要な課題となっている．特に，トランジスタや集積回路のさらなる小型化と高密度化が進む中で，デバイスやシステムレベルでの電力消費と熱管理の課題が浮き彫りになっている @nano_electronics．こういったナノスケールでの熱伝導特性を明らかにするため，古典分子動力学シミュレーションを用いた界面熱輸送の計算が行われてきた @nemd ．このような界面における熱伝導特性の評価には，界面熱抵抗（Interfacial thermal resistance : ITR）という物理量がしばしば使われる．界面熱抵抗とは，同種や異種物質間界面に生じる，熱の伝わりにくさを表す指標である @ITR．特に，微小なスケールにおけるエネルギー伝達では，この界面熱抵抗が熱伝導特性に大きな影響を及ぼすため無視することができない @ITR_siba．界面熱抵抗の求め方にはいくつか方法があり，中でも熱平衡状態の系においては，熱流束の自己相関関数（Autocorrelation function : ACF）を求めて，Green – Kubo式から界面熱抵抗を計算する方法がある．自己相関関数とは，ある物理量が時間的相関をもつかどうかを示した関数であり，この自己相関関数が0に収束した場合，この物理量は周期性を持たないことを意味する @ACF．界面熱抵抗を求めるためには，熱流束の自己相関関数を0に収束させなければならないが，これには膨大なアンサンブル数が必要であり，それに伴い計算コストが非常に高くなる @EMD_ITR．近年では，計算コストを削減しつつ高精度な予測を可能にするために，分子動力学シミュレーションに機械学習を援用した手法が検討されている．先行研究 @gan_heatflux では，敵対的生成ネットワーク（Generative Adversarial Networks : GANs）を用いて，アルミニウムと銅原子のバルク系において熱流束ゆらぎのデータを生成し，膨大なアンサンブルを獲得することに成功している．しかしながら，機械学習によって固液界面における熱流束を予測する研究例はまだない．

// そこで本研究では，Ar - Pt壁面系で分子動力学シミュレーションを行い，得られた界面熱流束のデータをGANsに学習させ，界面熱流束ゆらぎを統計的に予測させて界面熱抵抗を計算することで，GANsの予測精度を定量的に評価することを目的とする．

トランジスタや集積回路デバイスのさらなる小型化と高密度化が進む中でナノスケールでの界面熱伝導特性を明らかにするため，分子動力学シミュレーション（Molecular Dynamics Simulation : MD）を用いた界面熱流束の計算が行われてきた．界面熱伝導特性の評価には，界面熱抵抗（Interfacial thermal resistance : ITR）が使われる@ITR．特に，ナノメートルの微小なスケールにおいて，このITRが界面熱伝導特性に大きな影響を及ぼす@ITR_siba．ITRの求め方にはいくつか方法があり，中でも熱平衡状態の系においては， 熱流束の自己相関関数（Autocorrelation function : ACF）を求めることで算出できる．ITRを求めるためには，このACFを0に収束させなければならないが，これには膨大なアンサンブル数が必要であり，それに伴い計算コストが非常に高くなる@EMD_ITR．近年では，計算コストを削減しつつ高精度な予測を可能にするために，分子動力学シミュレーションに機械学習を援用した手法が検討されている．先行研究 @gan_heatflux では，敵対的生成ネットワーク（Generative Adversarial Networks : GANs）を用いて，アルミニウムと銅原子のバルク系において熱流束ゆらぎのデータを生成し，膨大なアンサンブルを獲得することに成功している．しかしながら，機械学習によって固液界面における熱流束を予測する研究例はまだない．

そこで本研究ではMDにおけるITR計算に関する計算負荷を削減するため，敵対的生成ネットワーク（GANs）を用いることを考えた．具体的には，Ar - Pt壁面系でMDシミュレーションを行い，得られた界面熱流束の時系列データをGANsによって学習し，界面熱流束ゆらぎを予測して界面熱抵抗を計算することで，GANsの予測精度を定量的に評価することを目的とする．

// #colbreak()

= 計算方法
== MDシミュレーション

本研究で用いた計算系を@md_model に示す．固体原子を $x y$ 平面に対して平行になるように上下に設置し，壁面に囲まれる領域に液体分子を配置している．固体原子にはPt，液体分子にはArを用いており，Pt壁面は (100) 面においてArと接している．計算系の大きさは $3.92 times 3.92 times 8.70 " nm"^3$となっており，$x$, $y$方向に周期境界条件を適用している．Pt壁面はPtの格子定数に基づき $z$ 方向に6層配置しており，最外層を固定層，その1つ内側の層をPhantom層としている．また，Ptは上下それぞれに1200個，Ar分子はそれぞれ2000個配置しており，上下壁面はLangevin法を用いて100 Kに制御し，Ar分子は速度スケーリング法を用いて，初めの100000ステップを100 Kに制御している．ただし，時間刻み $italic(Delta t)$ は1.0 fsとしている．また本研究では，固液間相互作用強さ $alpha$ を0.01，0.03，0.05，0.07，0.1，0.2に変更し，結果を比較した．
熱流束及び界面熱抵抗の計算方法を@eq1，@eq2 に示す．
ここで，$A$ はPt壁面の断面積，$T_0$ は熱平衡状態における系の温度，$k_upright(B)$ はBoltzmann定数，$q_z (t)$ は時刻 $t$ における $z$ 方向の熱流束，$angle.l q_z (t) dot q_z (0) angle.r$ は熱流束の自己相関関数である．$angle.l square angle.r$ はアンサンブル平均を取ることを意味する．$q_z (t)$ は@eq2 で与えられる
本研究では熱流束データを $3 times 10^7$ 個収集し，自己相関関数のアンサンブル平均を取ることで界面熱抵抗を算出した．

// #v(5pt)
$
  1 / R = A / (T_0^2 k_upright(B)) integral_0^infinity angle.l q (t) dot q (0) angle.r d t
$ <eq1>
#v(10pt)

$
  q(t) = 1 / A sum_(i in upright(P t))^n sum_(j in upright(A r))^m (F_(i j) (t) dot v_i (t))
$ <eq2>
#v(5pt)

#img(
  image("Figures/MD_ortho.png", width: 70%),
  caption: "MD simulation model.",
) <md_model>

#v(1.5em)

== 機械学習モデル

本研究で用いた機械学習モデルGANsについて説明する．GANsとは，一方のネットワーク（生成器G）が本物に近いデータを生成するために目的関数を最大化させ，もう一方のネットワーク（識別器D）はそれを最小にしようと最適化するプロセスを通して，二つのネットワークが互いに競い合いながら学習を進める機械学習モデルである @gan．

本研究では学習が安定しやすいといわれるWGAN-GPというモデルを用いた．WGAN-GPでは損失関数にWasserstein Lossというのを用いており，Gradient Penalty（GP）という補正項を加えている．
// WGAN-GPにおける損失関数を@eq3 に示す．

// #set text(size: 0.9em)
// #v(5pt)
// $
//   min_G max_(norm(D)_L lt.eq 1) (EE_(x~PP_r)[D(x)] - EE_(x~PP_g)[D(x)]) \
//   + lambda EE_(bold(hat(x))~PP_bold(hat(x)))[(norm(nabla_bold(hat(x))D(bold(hat(x))))_2 - 1)^2] " "
// $ <eq3>
// #v(5pt)
// #set text(size: 1em)

また，本研究では，30000000 個の元データのうち，約2%の512000個を訓練データとして用いている．
#colbreak()

#img(
  grid(
    columns: 2,
    [#figure(
        image("Figures/gan/0.05/heatflux_true_10ps.svg", width: 100%),
        supplement: "",
      )],
    [#figure(
        image("Figures/gan/0.05/heatflux_pred_10ps.svg", width: 100%),
        supplement: "",
      )],
  ),
  caption: [
    Time histories of interfacial heat flux via \ MD simulation (#text(fill: rgb(100%,0%,0%))[red]), and GANs (#text(fill: rgb(0%,0%,100%))[blue]) at $alpha = 0.05$.
  ],
) <hf_10ps>

#img(
  image("Figures/gan/0.05/histogram_comparison.svg", width: 60%),
  caption: [Comparison of heat flux distribution in \ MD simulation (#text(fill: rgb(100%,0%,0%))[red]) and GANs (#text(fill: rgb(0%,0%,100%))[blue]) at $alpha = 0.05$.],
) <comp_md_gan>
#v(1em)

= 結果・考察
// #set text(size: 9.4pt)

MDシミュレーション及びGANsで得られた界面熱流束のデータを@hf_10ps に示す．左側の赤い線で描かれたグラフは分子動力学シミュレーションで得られた熱流束ゆらぎのデータで，右側の青い線で描かれたグラフはGANsに出力させた熱流束ゆらぎのデータである．また，熱流束データの確率分布を@comp_md_gan に示す．@hf_10ps を見ると，熱流束の振幅や波長はかなり酷似していのがわかる．しかしながら，@comp_md_gan をみると，グラフに示すようにMDシミュレーションとGANsの両方ともおおよそ正規分布に近い分布得られたが，多少ずれていることがわかる．

@acf_itr に自己相関関数及び固液界面の熱抵抗の計算結果を示す．まず自己相関関数について，1 psあたりから0に収束する傾向が見られた．しかし，時刻0から少し経った後の大きな振動のピークがGANsの方が小さかったり，ある程度時間が経っても自己相関関数が少し揺れているといった結果が確認できた．また，相互作用強さによっては，周期性を持ったわずかな振動が見られた．これらの原因としては，GANsが学習できたパターンが少なかったことが考えられる．また，確率分布はかなり近い結果を示していたのに対し，界面熱抵抗にこのような誤差が生じた原因としては，前後の時系列関係をうまく学習できなかったことなどが考えられる．

今後のモデルの改善点としては，多様な学習パターンを増やすために訓練データ量を増やすことや，学習率，バッチサイズなどのハイパーパラメータの変更のほか，時系列の細かい特徴を抽出するため，ニューラルネットワークの層の数を変更したり，隠れ層のノード数を変更することなどが挙げられる．

// #colbreak()

#img(
  grid(
    columns: 2,
    [#figure(
        image("Figures/gan/0.05/ACF_pred_and_true.svg", width: 99%),
        supplement: "",
      )],
    [#figure(
        image("Figures/gan/0.05/ITR_pred_and_true.svg", width: 100%),
        supplement: "",
      )],
  ),
  caption: [ Comparison of ACF and ITR in MD simulation and GANs at $alpha = 0.05$.],
) <acf_itr>
#v(7.5pt)
#img(
  image("Figures/ITR_comparison_e_g.svg", width: 60%),
  caption: [Comparison of ITR in MD simulation and GANs.],
) <comp_itr_e_g>
#v(1.5em)

= 結論

本研究では，Ar – Pt壁面系を用いた平衡分子動力学シミュレーションにおける固液界面の熱流束ゆらぎをGANsを用いて予測し，Green – Kubo式を用いて固液界面熱抵抗を計算，評価をすることで，分子動力学シミュレーションで得られる物理量の予測可能性について検証した．その際，様々な濡れ性を有する壁面系においても予測を可能にするため固液間相互作用強さ $alpha$ を変更して計算を行った．本研究で用いたGANsは， $alpha$ を変更したいずれの系においても固液界面熱抵抗の値に定量的な誤差が見られたが， $alpha$ と固液界面熱抵抗の関係について，相互作用強さを大きくするほど界面熱抵抗が小さくなるという同様の傾向がMDシミュレーションと同様にGANsの予測にも見られたため，定性的には固液界面熱抵抗の予測が可能であるといえる．

#v(2em)

// @RevModPhys.94.025002
// @ZHANG2021114203
