#import "thesis_format.typ": *
#import "@preview/numbly:0.1.0": numbly
// #import "@preview/physica:0.9.2"
#show: master_thesis.with(
  title: "分子動力学シミュレーションと
  機械学習を利用した固液界面熱流束ゆらぎの予測",
  author: "川口　達也",
  university: "大阪大学",
  school: "工学部 応用理工学科",
  department: "機械工学科目",
  id: "08B21059",
  mentor: "芝原　正彦",
  mentor-post: "教授",
  mentor2: "藤原　邦夫",
  mentor-post2: "准教授",
  class: "卒業",
  bibliography-file: "bib/reference_sotsuron.bib",
)

= 序論
== 研究背景・目的

ナノスケールにおける熱伝導特性の理解は，次世代の高度な材料やデバイスの熱設計において極めて重要な課題となっている．特に，トランジスタや集積回路のさらなる小型化と高密度化が進む中で，デバイスやシステムレベルでの電力消費と熱管理の課題が浮き彫りになっている @nano_electronics．こういったナノスケールでの熱伝導特性を明らかにするため，古典分子動力学シミュレーションを用いた界面熱輸送の計算が行われてきた @nemd ．このような界面における熱伝導特性の評価には，界面熱抵抗（Interfacial thermal resistance : ITR）という物理量がしばしば使われる．界面熱抵抗とは，同種や異種物質間界面に生じる，熱の伝わりにくさを表す指標である @ITR．特に，微小なスケールにおけるエネルギー伝達では，この界面熱抵抗が熱伝導特性に大きな影響を及ぼすため無視することができない @ITR_siba．界面熱抵抗の求め方にはいくつか方法があり，中でも熱平衡状態の系においては，熱流束の自己相関関数（Autocorrelation function : ACF）を求めて，Green – Kubo式から界面熱抵抗を計算する方法がある．自己相関関数とは，ある物理量が時間的相関をもつかどうかを示した関数であり，この自己相関関数が0に収束した場合，この物理量は周期性を持たないことを意味する @ACF．界面熱抵抗を求めるためには，熱流束の自己相関関数を0に収束させなければならないが，これには膨大なアンサンブル数が必要であり，それに伴い計算コストが非常に高くなる @EMD_ITR．近年では，計算コストを削減しつつ高精度な予測を可能にするために，分子動力学シミュレーションに機械学習を援用した手法が検討されている．先行研究 @gan_heatflux では，敵対的生成ネットワーク（Generative Adversarial Networks : GANs）を用いて，アルミニウムと銅原子のバルク系において熱流束ゆらぎのデータを生成し，膨大なアンサンブルを獲得することに成功している．しかしながら，機械学習によって固液界面における熱流束を予測する研究例はまだない．

そこで本研究では，Ar - Pt壁面系で分子動力学シミュレーションを行い，得られた界面熱流束のデータをGANsに学習させ，界面熱流束ゆらぎを統計的に予測させて界面熱抵抗を計算することで，GANsの予測精度を定量的に評価することを目的とする．

== 本論文の構成

本論文は全6章で構成されている．第1章では研究背景と目的について述べた．第2章では本研究で用いた計算手法や機械学習モデルの説明について述べている．第3章では非平衡分子動力学（Non-equilibrium molecular dynamics : NEMD）における界面熱抵抗の計算と評価について述べている．第4章では平衡分子動力学（Equilibrium molecular dynamics : EMD）における界面熱抵抗の計算と評価について述べている．第5章ではGANsを用いた熱流束の予測と自己相関関数の作成，界面熱抵抗の計算と評価について述べている．第6章では本研究の結論を述べている．

= 計算方法 <chap_cal_method>
== はじめに

古典分子動力学とは，系内の全ての粒子に対してNewtonの運動方程式を適用し，各粒子の位置や速度について数値積分することでそれらを更新していく手法である．本章では，研究で用いた分子動力学シミュレーションの計算手法，物理量の算出方法及び計算モデル，そして最後に機械学習モデルについて説明する．

== 運動方程式

粒子間相互作用を考慮する質点系を考えると，粒子（原子または分子）の3次元位置ベクトル $bold(r)_i$ は@eq2_1 のように表せる．

$ bold(r)_i = (x_i, y_i, z_i) $ <eq2_1>
#v(5pt)

ここで，粒子 $i$ に働く力 $bold(F)_i$ はポテンシャルエネルギー $italic(Phi)_i$ より，@eq2_2 のように計算できる．

#v(5pt)
$
  bold(F)_i = -((partial italic(Phi_i)) / (partial x_i), (partial italic(Phi_i)) / (partial y_i), (partial italic(Phi_i)) / (partial z_i))
$ <eq2_2>
#v(5pt)

ここで，Newtonの運動方程式は@eq2_3 のように表せる．

#v(5pt)
$ m_i (d^2bold(r)_i) / (d t^2) = bold(F)_i $ <eq2_3>

ここで，$m_i$は粒子 $i$ の質量である．


== 数値積分法

@eq2_3 の常微分方程式を近似的に解くための数値積分法として，本研究では蛙跳び法を用いた．蛙跳び法はシンプレティック積分法の一種であり，長時間シミュレーションを行なってもエネルギーの保存性が高い数値積分法である．@eq2_3 を変形すると，@eq3_1，@eq3_2 を得られる．

#v(-5pt)
$ (d bold(v)_i) / (d t) = bold(F)_i / m_i $ <eq3_1>

$ (d bold(r)_i) / (d t) = bold(v)_i $ <eq3_2>
#v(5pt)

ただし，$bold(v)_i$ は粒子 $i$ の速度，$t$ は時刻である．ここで，時間刻みを $italic(Delta t)$ として中心差分法を適用すると，力と速度の関係は@eq3_3 のように表せる．

#pagebreak()

#v(-20pt)
$
  (bold(v)_i (t+display((italic(Delta t)) / 2)) - bold(v)_i (t-display((italic(Delta t) ) / 2))) / italic(Delta t)
  = (bold(F)_i (t)) / m_i
$ <eq3_3>
#v(5pt)

@eq3_3 より，時刻 $t+display(italic(Delta t)/2)$ での速度ベクトルは@eq3_4 のようになる．

#v(5pt)
$
  bold(v)_i (t+italic(Delta t) / 2)
  = bold(v)_i (t-italic(Delta t) / 2) + italic(Delta t) / m_i bold(F)_i (t)
$ <eq3_4>
#v(5pt)

次に，位置と速度の関係についても中心差分法を適用して，位置 $bold(r)_i$ を求めると@eq3_6 のようになる．

$
  (bold(r)_i (t+italic(Delta t))-bold(r)_i (t)) / (italic(Delta t))
  = bold(v)_i (t+italic(Delta t) / 2)
$ <eq3_5>

$
  bold(r)_i (t+italic(Delta t))
  = bold(r)_i (t) + italic(Delta t) bold(v)_i (t+italic(Delta t) / 2)
$ <eq3_6>
#v(5pt)

@eq3_4 と@eq3_6 より粒子の位置と速度を更新する．また，本研究では計算の正確性を重視し，時間刻みを $italic(Delta t) = 1.0$ fsとしている．

== ポテンシャル関数

粒子間の相互作用を表現するポテンシャル関数は，実験データや量子計算の結果を用いて決定されている．本研究ではその簡便さゆえ，希ガスのAr系の分子動力学シミュレーションによく用いられる，12-6 Lennard – Jonesポテンシャル関数を用いた．

#v(5pt)
$
  italic(Phi)(r_(i j))
  = 4 epsilon_(i j) {((sigma_(i j)) / r_(i j))^12 - ((sigma_(i j)) / r_(i j))^6}
$ <eq4_1>
#v(5pt)

ここで，@eq4_1 の $r_(i j)$ は粒子 $i$ と粒子 $j$ の距離，$epsilon_(i j)$ はエネルギーの次元を持ち，ポテンシャルの谷の深さを表すパラメータであり，$sigma_(i j)$ は距離の次元をもち，粒子の見かけの直径を表すパラメータである．これらのパラメータは粒子の種類によって決まっている．また，異なる粒子間では，ポテンシャル関数に固液間相互作用強さ $alpha$ を乗じた@eq4_2 を用いた．

#v(5pt)
$
  italic(Phi)(r_(i j))
  = 4 alpha epsilon_(i j) {((sigma_(i j)) / r_(i j))^12 - ((sigma_(i j)) / r_(i j))^6}
$ <eq4_2>
#v(5pt)

本研究で用いた系は，固体原子にPt，流体分子にArを用いたAr - Pt壁面系である．Pt - Pt間，Ar - Ar間及びAr - Pt間のポテンシャルパラメータを @tb4_1 に示す．ただし，Ar - Pt間のパラメータに関しては，@eq4_3 ，@eq4_4 に示すLorentz – Berthelot則により決定した @LJ．

#v(5pt)
$ sigma_(i j) = (sigma_(i i) + sigma_(j j)) / 2 $ <eq4_3>
$ epsilon_(i j) = sqrt(epsilon_(i i) dot epsilon_(j j)) $ <eq4_4>
#v(5pt)

#pagebreak()
#v(-20pt)

#tbl(
  table(
    stroke: (x, y) => (
      top: if y == 0 { 0.6pt } else if y == 1 { 0.6pt },
      bottom: if y == 3 { 0.6pt } else if y == 0 { 0.6pt },
    ),
    row-gutter: (2.2pt, auto),
    // rows: 20pt,
    columns: (60pt, 80pt, 80pt),
    align: horizon,
    table.header[][$sigma$ nm][$epsilon$ J],
    [Pt - Pt], [$0.2540$], [$1.092 times 10^(-19)$],
    [Ar - Pt], [$0.2970$], [$1.349 times 10^(-20)$],
    [Ar - Ar], [$0.3400$], [$1.666 times 10^(-21)$],
  ),
  caption: [ 12-6 Lennard – Jones potential parameters of Ar and Pt.],
) <tb4_1>

#v(40pt)

== 周期境界条件

分子動力学シミュレーションでは計算できる粒子数や系のサイズに限りがある．そこで，計算コストを現実的な範囲に抑えつつ，無限に広がる系を模擬的に再現するために，本研究では周期境界条件を適用した．周期境界条件のイメージ図を @img_periodic に示す．赤色の領域が基本セルとよばれる計算領域であり，基本セルの境界を飛び出した粒子は対面の境界から入ってくると考える．粒子間相互作用についても同様に，基本セル内の粒子と隣接するセル内の粒子の相互作用を考慮する．

#v(2cm)
#img(
  image("Figures/periodic_per.png", width: 55%),
  caption: [ Schematic diagram of the periodic boundary condition.],
) <img_periodic>

#pagebreak()

== 計算の高速化手法
=== カットオフ

カットオフとは，粒子間がある程度離れている場合，粒子間の相互作用力が非常に小さくなるため無視できることから，特定の距離の範囲内にある粒子のみ計算する手法である．このときの特定の距離をカットオフ距離 $r_"cutoff"$ という．本研究では $r_"cutoff" = 3.3 sigma$としている．

=== 粒子登録法

カットオフのみでは依然として計算コストが高いので，本研究ではこれに加え粒子登録法を適用している．粒子登録法の距離及びカットオフ距離のイメージ図を @img_cutoff に示す．粒子登録法とは，各粒子について，カットオフ距離より大きな範囲 $r_"cutoff" + Delta r $ 離れた位置に存在する他の粒子を記憶させ，しばらくの間記憶させた粒子の組み合わせのみ相互作用の計算をする手法である．$Delta r$については@eq6_1 に示す．

$ Delta r = s(40 dot bold(v)_"max" dot Delta t ) $ <eq6_1>
#v(5pt)

なお，$v_"max"$はAr - Ar間及びAr - Pt間においてはAr分子の最大速度，Pt - Pt間ではPt原子の最大速度としている．また，安全率を $s = 2.0$ とし，計算を行う粒子の記憶は40ステップごとに更新している．

#v(1.4cm)
#img(
  image("Figures/cutoff.png", width: 50%),
  caption: [ Schematic diagram of the cutoff and bookkeep distance.],
) <img_cutoff>

#pagebreak()

== 温度の制御手法
=== 速度スケーリング法

単原子分子の場合，温度 $T$ は分子の運動エネルギーの平均値を用いて@eq7_1 のように計算できる．

$ 3 / 2 k_upright(B) T = 1 / N sum_(i=1)^N 1 / 2 m_i bold(v)_i^2 $ <eq7_1>
#v(5pt)

ここで，$k_upright(B)$ はBoltzmann定数，$T$ は系内の温度，$N$ は分子の総数，$m_i$ は分子の質量，$bold(v)_i$ は分子の速度である．速度スケーリング法は，目標温度 $T_"aim"$ に対応する運動エネルギーになるように，@eq7_1 を用いて粒子の速度を補正する手法である．補正後の粒子の速度は@eq7_1_2 のように表せる．

$ bold(v)_i^' = bold(v)_i sqrt(T_"aim" / T) $ <eq7_1_2>
#v(5pt)

ただし，$bold(v)_i^'$ は補正後の分子の速度，$bold(v)_i$ は補正前の分子の速度，$T$ は時刻 $t$ における温度である．

=== Langevin法

本研究では，固体壁面の温度制御法としてLangevin法を用いる．概略図を @langevin に示す．Langevin法はBoltzmann分布に従うPhantom粒子を用いて，速度に比例するダンパー力 $F_upright(D)$ と，@eq7_4 で説明する標準偏差 $sigma$ の正規分布に従うランダムな力 $F_upright(R)$ をPhantom粒子に加えることで，温度を一定に制御できる方法である．@langevin に示すように，固定層とPhantom層の間にダンパーを仮定し，各粒子間にはばねが存在すると考える．

ダンパの減衰係数 $alpha$ とDebye振動数 $omega_upright(D)$ は@eq7_2 及び@eq7_3 のように表される．

#v(5pt)
$ alpha = m pi / 6 omega_upright(D) $ <eq7_2>
$ omega_upright(D) = (k_upright(B) theta_upright(B)) / planck.reduce $ <eq7_3>
#v(5pt)

ただし，$k_upright(B)$ はBoltzmann定数，$planck.reduce$ はDirac定数，$theta_upright(B)$ はDebye温度である．Debye温度は物質固有の値であり，本研究では固体壁面としてPt原子を用いるため，Debye温度 $theta_upright(B)$ は240 K である．また，Phantom粒子には@eq7_4 に示す標準偏差 $sigma$ を乗じたランダムな力を与える．

#v(5pt)
$ sigma = sqrt((2 alpha k_upright(B) T_"aim")/(Delta t)) $ <eq7_4>
#v(5pt)

#pagebreak()

// #v(-1.5cm)
#img(
  image("Figures/Langevin.png", width: 75%),
  caption: [Schematic diagram of Langevin method.],
) <langevin>
#v(2cm)

== 熱流束の計算方法 <cla_hf>
=== Phantom層における熱輸送

Langevin法により得られた力を用いて，Phantom層を介して伝搬される熱流束を計算することができる．Phantom層に単位面積あたりに輸送される瞬間的な熱輸送量 $Q$ は@eq8_1 で表される．

$
  Q = 1 / A (sum_(i in upright(P t)) bold(F)_upright(D) dot bold(v)_i + sum_(i in upright(P t)) bold(F)_upright(R) dot bold(v)_i)
$ <eq8_1>
#v(5pt)

ここで，$A$ はPt壁面の断面積，$bold(v)_i$ はPhantom粒子の速度，$bold(F)_upright(D)$，$bold(F)_upright(R)$はそれぞれPhantom粒子に与えるダンパー力及びランダム力である．$Sigma$ はPhantom粒子全てで足し合わせることを意味する．本研究において，熱流束は@eq8_1 の $Q$ を毎ステップ積算し，その時間変化率を算出することで求めている．

#pagebreak()

=== 固液界面における熱輸送

固液界面における液体分子と固体原子の相互作用力から熱流束を計算することができる．固液界面に単位面積あたりに輸送される瞬間的な熱輸送量 $Q$ は@eq8_2 で表される．

$
  Q = 1 / A sum_(i in upright(P t)) sum_(j in upright(A r)) (bold(F)_(i j) dot bold(v)_i)
$ <eq8_2>
#v(5pt)

ここで，$A$ はPt壁面の断面積，$bold(F)_(i j)$ はPtがArから受ける相互作用力，$bold(v)_i$ はPt原子の速度である．Phantom層と同様に，@eq8_2 の$Q$ を毎ステップ積算し，その時間変化率を算出することで求めている．

== 固液界面熱抵抗

=== 界面温度差 <sec2_9_1>

本研究における温度の計算方法については@sec_3_2_2 で詳しく説明するが，Arの温度分布の回帰直線と固液界面層が交差する点を固液界面層におけるArの温度とし，固液界面層のPt壁面温度との差をAr - Pt間の界面における温度差 $Delta T$ と定義する．


=== 非平衡分子動力学における界面熱抵抗計算 <sec_itr_nemd>

非平衡分子動力学（Non-Equilibrium Molecular Dynamics : NEMD）における固液界面熱抵抗（Interfacial Thermal Resistance : ITR）は@eq9_1 で計算できる．

#v(5pt)
$ R = (Delta T) / q $ <eq9_1>
#v(5pt)

ここで，$R$ は界面熱抵抗である．$Delta T$については@sec2_9_1 で述べた界面温度差を用いる．また，$q$ は@eq8_1 及び@eq8_2 で求めた熱流束を用いる．

=== 平衡分子動力学における界面熱抵抗計算 <sec_itr_emd>

平衡分子動力学（Equibrium Molecular Dynamics : EMD）における固液界面熱抵抗は@eq9_2 で示されるGreen – Kubo式 @Kubo によって計算できる．

#v(5pt)
$
  1 / R = A / (T_0^2 k_upright(B)) integral_0^infinity angle.l q_z (t) dot q_z (0) angle.r d t
$ <eq9_2>
#v(5pt)

ここで，$A$ はPt壁面の断面積，$T_0$ は熱平衡状態における系の温度，$k_upright(B)$ はBoltzmann定数，$q_z (t)$ は時刻 $t$ における $z$ 方向の熱流束，$angle.l q_z (t) dot q_z (0) angle.r$ は熱流束の自己相関関数である．$angle.l square angle.r$ はアンサンブル平均を取ることを意味する．$q_z (t)$ は@eq9_3 で与えられる．

#v(5pt)
$
  q_z (t) = 1 / A sum_(i in upright(P t))^n sum_(j in upright(A r))^m (F_(i j,z) (t) dot v_(i,z) (t))
$ <eq9_3>
#v(5pt)

ここで，$n,m$ はそれぞれPt原子，Ar分子の総数，$F_(i j,z) (t)$ はPt原子がAr分子から受ける相互作用力の $z$ 方向成分，$v_(i,z) (t)$ はPtの速度の $z$ 方向成分である．本研究で用いた系は， $x y$ 平面に対して平行になるようにPt壁面を配置しているので，界面熱抵抗は $z$ 方向の熱輸送特性のみを考えて算出している．

== 圧力の測定 <cla_press>

本研究で用いた系では@eq10_1 のように，Pt原子がAr分子から受ける力を足し合わせることで圧力を計算することができる．

#v(5pt)
$ P = 1 / A sum_(i in upright(P t))^n sum_(i in upright(A r))^m F_(i j,z) $ <eq10_1>
#v(5pt)

ここで，$P$ は圧力，$A$ はPt壁面の断面積，$n,m$ はそれぞれPt原子，Ar分子の総数， $F_(i j,z)$ はPtがArから受ける力の $z$ 方向成分である．本研究では上下壁面の両方で圧力を計算し，その平均を取っている．また，測定した圧力により妥当性を判断してArの分子数を決定している．

== 無次元化

本研究で行うナノスケール計算では扱う数値が小さく，丸め誤差による桁落ちが発生し計算精度が下がる可能性がある．そこで本研究では長さ $r "[m]"$，時間 $t "[s]"$，質量 $m "[kg]"$を以下のように無次元化を行った．

$ r^* = r \/ 10^(-10) $ <eq11_1>
$ t^* = t \/ 10^(-15) $ <eq11_2>
$ m^* = m \/ 10^(-26) $ <eq11_3>
#v(5pt)

$*$ がついたものが無次元化された物理量である．
これらを用いて速度 $v upright([m\/s])$，加速度 $a upright([m\/s^2])$，力 $F upright([k g dot m \/s^2])$，エネルギー $E upright([k g dot m^2 \/ s^2])$についても以下のように無次元化を行う．

#v(5pt)
$ v^* = v \/ 10^5 $ <eq11_4>
$ a^* = a \/ 10^20 $ <eq11_5>
$ F^* = F \/ 10^(-6) $ <eq11_6>
$ E^* = E \/ 10^(-16) $ <eq11_7>
#v(5pt)

#pagebreak()

== 機械学習 <cla_ml>

本研究で用いた機械学習モデルGANs（Generative Adversarial Networks）について説明する．GANsとは，一方のネットワーク（生成器G）が本物に近いデータを生成するために目的関数を最大化させ，もう一方のネットワーク（識別器D）はそれを最小にしようと最適化するプロセスを通して，二つのネットワークが互いに競い合いながら学習を進める機械学習モデルである @gan．

=== 損失関数

機械学習や最適化において，モデルが達成すべき目標を定量的に評価するための関数を目的関数（Objective Function）あるいは損失関数（Loss Function）という．最初にGANsを考案したGoodfellowらの文献 @gan によると，損失関数は交差エントロピー誤差（Cross Entropy Loss）という@eq12_1 で表される．

#v(5pt)
$
  min_G max_D V(D,G) = EE_(bold(x)~p_"data" (bold(x)))[log D(bold(x))]
  + EE_(bold(z)~p_bold(z)(bold(z)))[log (1-D(G(bold(z))))]
$ <eq12_1>
#v(5pt)

ここで，$D(bold(x))$ は実データ $bold(x)$ を識別器が正しく本物であると判断する確率，$D(G(bold(z)))$ は生成器が生成する偽物のデータ $G(bold(z))$ を識別器が誤って本物と判断する確率を表しており，$1-D(G(bold(z)))$ はその余事象で，識別器が偽物のデータを正しく偽物と判断することを意味する．また，$EE$ は期待値，$p_"data" (bold(x))$ は実データの確率分布，$p_bold(z)(bold(z))$ はノイズベクトル $bold(z)$ の確率分布を表す．

しかしながら，一般にGANsは安定した訓練が非常に難しいという課題を残しており，モード崩壊や勾配消失といった問題が指摘されている．このような問題への対策として有名な手法にArjovskyらが提案したWGANがある．

=== Wasserstein GAN（WGAN）

WGANはGANsが抱える学習の不安定性を解決するため考えられたGANsモデルである．WGANでは@eq12_2 にしめすEM距離（Earth Mover Distance）を損失関数に導入している @wgan．

#v(5pt)
$
  W(PP_r,PP_g) = inf_(gamma in Pi(PP_r,PP_g)) EE_((x,y)~gamma)[norm(x-y)]
$ <eq12_2>
#v(5pt)

簡潔に述べると，
// ここで，$gamma(x,y)$ は分布 $PP_r$を$PP_g$に変換するために，どれだけの　を$x$から$y$に輸送しなければならないかを表したコストを表しており，$Pi(PP_r,PP_g)$ は $gamma(x,y)$ の同時分布の集合を示す．つまり，
EM距離は2つの分布の最小コストの移動距離を表している @wgan．しかし，EM距離がそもそも1つの線形計画問題の式となっており，GANsの目的関数に使うにしては不適切である．そのため，扱いやすいようにKantorovich-Rubinstein双対性を用いて，@eq12_3 のように変形する @Kantorovich．

#v(5pt)
$
  W(PP_r,PP_g) = sup_(norm(D)_L lt.eq 1) (EE_(x~PP_r)[D(x)] - EE_(x~PP_g)[D(x)])
$ <eq12_3>
#v(5pt)

@eq12_3 はWasserstein距離とよばれ，$D$ は批評器を表している（文献 @wgan によると，WGANにおいて識別器（Discriminator）は批評器（Critic）と表記している）．また，$norm(D)_L lt.eq 1$は1-Lipschitz連続であることを示している．Lipschitz連続性とは，次の@eq12_4 の条件を満たすことである．

#v(5pt)
$
  |f(x)-f(y)| lt.eq K norm(x-y) "  " forall x,y in RR^n
$ <eq12_4>
#v(5pt)

ここで，$K$ はLipschitz定数というある正の定数，$norm(x-y)$ は $x$，$y$ のEuclid距離である．
1-Lipschitzの場合，$K=1$である．

@eq12_3 の変形を用いて，生成器及び批評器の損失関数はそれぞれ，@eq12_5 のように表せる．

$
  L_G &= min_G (- EE_(x~PP_g)[D(x)]) \
  L_D &= max_(norm(D)_L lt.eq 1) (EE_(x~PP_r)[D(x)] - EE_(x~PP_g)[D(x)])
$ <eq12_5>
#v(5pt)

この二式を組み合わせた全体の損失関数は@eq12_6 のようになる．

#v(5pt)
$ min_G max_(norm(D)_L lt.eq 1) EE_(x~PP_r)[D(x)] - EE_(x~PP_g)[D(x)] $ <eq12_6>
#v(5pt)

本研究ではこの損失関数を採用している．

=== Gradient Penalty（GP）

前節で説明したWasserstein距離を正しく計算するためには，Lipschitz連続性を保証しなければならない．本節ではLipschitz連続性を保証する方法について説明する．
文献 @wgan で行っている重みクリッピング（Weight Clipping）は強引な解決策であり，一般的には学習が不安定になるため好まれない．そこで提案されたのが，Gulrajaniら @gp が提案したGradient Penalty（GP）である．
WGAN-GPでは，@eq12_7 を批評器の損失関数に追加する．

#v(5pt)
$
  lambda EE_(bold(hat(x))~PP_bold(hat(x)))[(norm(nabla_bold(hat(x))D(bold(hat(x))))_2 - 1)^2]
$ <eq12_7>

$
  bold(hat(x)) = epsilon bold(x)_r + (1-epsilon) bold(x)_g "   " epsilon ~ U(0,1)
  ," "bold(x)_r in PP_r," " bold(x)_g in PP_g
$
#v(5pt)

ただし，$lambda$ はペナルティ係数といい，文献 @wgan のほか様々な場面で採用されている $lambda=10$ を本研究でも採用としている．$bold(hat(x))$ は実データ分布 $PP_r$ と生成データ分布 $PP_g$ を線形補間したものである．このペナルティ項は，批評器の入力における勾配ノルム$norm(nabla_bold(hat(x))D(bold(hat(x))))_2$ の1からの逸脱量を表している．本研究でも批評器の損失関数にGPを加えている．

= 非平衡分子動力学における#parbreak()#h(-11pt)界面熱抵抗の評価 <chap_3>

== はじめに

平衡分子動力学で計算する界面熱抵抗の値の正確性を確認するため，本研究では@cla_hf で説明した方法で，Ar - Pt壁面系のPhantom層及び固液界面層の両方で熱流束を計算し，@sec_itr_nemd で説明した方法で，非平衡分子動力学法を用いて固液界面熱抵抗を計算した．その際，固液間相互作用強さ $alpha$ をパラメータとして変更して計算を行った．本章では非平衡分子動力学シミュレーションの計算手順と結果及び考察を示す．

== 計算条件
=== 計算系

本研究で用いた計算系を　@md_model に示す．固体原子を $x y$ 平面に対して平行になるように上下に設置し，壁面に囲まれる領域に液体分子を配置している．固体原子にはPt，液体分子にはArを用いており，Pt壁面は (100) 面においてArと接している．計算系の大きさは $3.92 times 3.92 times 8.70 " nm"^3$となっており，x, y方向に周期境界条件を適用している．Pt壁面はPtの格子定数に基づき $z$ 方向に6層配置しており，最外層を固定層，その1つ内側の層をPhantom層としている．また，Ptは上下それぞれに1200個，Ar分子はそれぞれ2000個配置しており，非平衡系においては，上壁面を130 K，下壁面を70 KでLangevin法を用いて制御し，Ar分子は速度スケーリング法を用いて，初めの100000ステップを100 Kに制御している．ただし，時間刻み $italic(Delta t)$ は1.0 fsとしている．また本研究では，固液間相互作用強さ $alpha$ を0.01，0.03，0.05，0.07，0.1，0.2に変更し，結果を比較した．

=== 計算手順 <sec_3_2_2>

計算手順は以下のようになっている．
#v(1em)
+ 最初の0.1 nsのみ速度スケーリングを行い，Ar分子を100 Kに制御する．Langevin法によりPt原子の上壁面を130 K，下壁面を70 Kに制御する．
+ 0.1 ns経過したらAr分子の速度スケーリングを外し，1 nsの緩和計算を行う．この間はデータ取得を行わない．
+ 緩和計算終了後，10 ns間にデータを取得する．
#v(1em)

　温度の取得方法について具体的に説明する．Ptは最外層を除いた各層ごとに平均を取り，Arは計算系の壁面を除いた領域を $z$ 方向に15分割し，その領域に存在するArの平均温度を毎ステップ計算する．10 ns間で得られた温度データについて時間平均を取ったものを，最終的な温度分布としている．界面温度差の計算については，Arの温度分布の回帰直線を延長して，固液界面と交差したところを固液界面におけるArの温度とし，固液界面層のPt壁面の温度と差を取って算出した．
熱流束の取得方法については，@eq8_1，@eq8_2 に示した式に従い，10 nsの間に上下のPhantom層と固液界面層の4箇所で熱輸送量を積算している．積算した熱輸送量を縦軸，時間を横軸としてプロットしたグラフの傾きを求めることで，熱流束を算出する．
圧力の取得方法については，@eq10_1 に示した式に従い，上下壁面の2箇所で計測し，10 ns間の時間平均を取った後，上下壁面の結果の平均を取って算出する．
固液界面熱抵抗については，@eq9_1 に示した式に従い，界面温度差を熱流束で除することにより算出する．その際，熱流束は上下壁面の平均値を用いる．なお各条件における圧力について，@cla_press に基づいて計算した結果を @tbl_press_nemd に示す．

#v(3cm)
#img(
  image("Figures/MD_ortho.png", width: 60%),
  caption: [ MD simulation model.],
) <md_model>

#pagebreak()

== 温度分布の妥当性

固液間相互作用強さ $alpha$ を変更した全ての系において，@temp_0.01 – @temp_0.2 に温度分布の結果を示す．縦軸は温度，横軸は鉛直方向の距離であり，最下層のPtの $z$ 座標を0としている．ただし，Ptの固定層はプロットしていない．また，縦軸と平行な灰色の点線は固液界面の高さを表し，赤色の実線はArの温度分布の回帰直線を表している． @temp_0.01 – @temp_0.2 を見ると，全てのケースにおいて温度が100 K付近となっており，定常状態となっていることが分かる．また，$alpha$ が大きくなるほど温度勾配も大きくなっていることが分かる．これは，$alpha$ が大きくなるほど濡れ性が高くなり，熱輸送量が増加するためだと考えられる．いずれの系においても線形な温度勾配を確認することができ，Fourierの法則とよく一致していることが分かる．

#v(0.5em)
#img(
  image("Figures/nemd/a0.01/tempe_Layer_a0.01_.svg", width: 63%),
  caption: [ Temperature distribution at $alpha = 0.01$.],
) <temp_0.01>

#img(
  image("Figures/nemd/a0.03/tempe_Layer_a0.03_.svg", width: 63%),
  caption: [ Temperature distribution at $alpha = 0.03$.],
) <temp_0.03>

#pagebreak()
#v(-1.75cm)

#img(
  image("Figures/nemd/a0.05/tempe_Layer_a0.05_.svg", width: 63%),
  caption: [ Temperature distribution at $alpha = 0.05$.],
) <temp_0.05>

#img(
  image("Figures/nemd/a0.07/tempe_Layer_a0.07_.svg", width: 63%),
  caption: [ Temperature distribution at $alpha = 0.07$.],
) <temp_0.07>

#img(
  image("Figures/nemd/a0.1/tempe_Layer_a0.1_.svg", width: 63%),
  caption: [ Temperature distribution at $alpha = 0.1$.],
) <temp_0.1>

#pagebreak()
// #v(-1.75cm)

#img(
  image("Figures/nemd/a0.2/tempe_Layer_a0.2_.svg", width: 63%),
  caption: [ Temperature distribution at $alpha = 0.2$.],
) <temp_0.2>
#v(3cm)

== 熱流束の妥当性

固液間相互作用強さ $alpha$ を変更した全ての系における熱輸送量と時間変化のグラフを @img_hf_0.01 – @img_hf_0.2 に示す．縦軸は $z$ 方向を正とした熱流量の積算値，横軸は熱流束を計測した際の経過時間である．また，全ての条件における熱流束及び，同条件におけるPhantom層の熱流束と固液界面層の熱流束の相対誤差を @tbl_hf に示す．各グラフを見ると，$alpha$ が大きくなるほど熱輸送量が大きくなっていることが分かる．これは温度分布での考察と同様に，$alpha$ が大きくなるほどAr - Pt間の相互作用力が大きくなり，それに伴い熱輸送量が大きくなるためと考えられる．また，$alpha$ が小さいとPhantom層と固液界面層での熱流束の誤差が大きくなっていることが分かる．これは $alpha$ が小さくなるほど熱輸送量が減少し，計算誤差による影響が大きくなったことが原因として考えられる．ほとんどのケースにおいて相対誤差が5%以内に収まっており，得られたシミュレーション結果は妥当であると判断できる．





#pagebreak()
#v(-1.75cm)

#img(
  grid(
    columns: 2,
    [#figure(
        image("Figures/nemd/a0.01/heatflux_phantom_a0.01_.svg", width: 85%),
        caption: [(a) Phantom layer],
        supplement: "",
        numbering: none,
      ) <pha_0.01>],
    [#figure(
        image("Figures/nemd/a0.01/heatflux_interface_a0.01_.svg", width: 85%),
        caption: [(b) Interfacial layer],
        supplement: "",
        numbering: none,
      ) <int_0.01>],
  ),
  caption: [ Energy transfer at upper and lower walls at $alpha = 0.01$.],
) <img_hf_0.01>
#v(20pt)
#img(
  grid(
    columns: 2,
    [#figure(
        image("Figures/nemd/a0.03/heatflux_phantom_a0.03_.svg", width: 85%),
        caption: [(a) Phantom layer],
        supplement: "",
        numbering: none,
      )],
    [#figure(
        image("Figures/nemd/a0.03/heatflux_interface_a0.03_.svg", width: 85%),
        caption: [(b) Interfacial layer],
        supplement: "",
        numbering: none,
      )],
  ),
  caption: [ Energy transfer at upper and lower walls at $alpha = 0.03$.],
) <img_hf_0.03>
#v(20pt)
#img(
  grid(
    columns: 2,
    [#figure(
        image("Figures/nemd/a0.05/heatflux_phantom_a0.05_.svg", width: 85%),
        caption: [(a) Phantom layer],
        supplement: "",
        numbering: none,
      )],
    [#figure(
        image("Figures/nemd/a0.05/heatflux_interface_a0.05_.svg", width: 85%),
        caption: [(b) Interfacial layer],
        supplement: "",
        numbering: none,
      )],
  ),
  caption: [ Energy transfer at upper and lower walls at $alpha = 0.05$.],
) <img_hf_0.05>

#pagebreak()
#v(-1.75cm)

#img(
  grid(
    columns: 2,
    [#figure(
        image("Figures/nemd/a0.07/heatflux_phantom_a0.07_.svg", width: 85%),
        caption: [(a) Phantom layer],
        supplement: "",
        numbering: none,
      )],
    [#figure(
        image("Figures/nemd/a0.07/heatflux_interface_a0.07_.svg", width: 85%),
        caption: [(b) Interfacial layer],
        supplement: "",
        numbering: none,
      )],
  ),
  caption: [ Energy transfer at upper and lower walls at $alpha = 0.07$.],
) <img_hf_0.07>
#v(20pt)
#img(
  grid(
    columns: 2,
    [#figure(
        image("Figures/nemd/a0.1/heatflux_phantom_a0.1_.svg", width: 85%),
        caption: [(a) Phantom layer],
        supplement: "",
        numbering: none,
      )],
    [#figure(
        image("Figures/nemd/a0.1/heatflux_interface_a0.1_.svg", width: 85%),
        caption: [(b) Interfacial layer],
        supplement: "",
        numbering: none,
      )],
  ),
  caption: [ Energy transfer at upper and lower walls at $alpha = 0.1$.],
) <img_hf_0.1>
#v(20pt)
#img(
  grid(
    columns: 2,
    [#figure(
        image("Figures/nemd/a0.2/heatflux_phantom_a0.2_.svg", width: 85%),
        caption: [(a) Phantom layer],
        supplement: "",
        numbering: none,
      )],
    [#figure(
        image("Figures/nemd/a0.2/heatflux_interface_a0.2_.svg", width: 85%),
        caption: [(b) Interfacial layer],
        supplement: "",
        numbering: none,
      )],
  ),
  caption: [ Energy transfer at upper and lower walls at $alpha = 0.2$.],
) <img_hf_0.2>

#tbl(
  table(
    stroke: (x, y) => (
      top: if y == 0 or y == 1 { 0.6pt },
      bottom: if y == 0
        or y == 2
        or x == 0 and y == 1
        or y == 4
        or x == 0 and y == 3
        or y == 6
        or x == 0 and y == 5
        or y == 8
        or x == 0 and y == 7
        or y == 10
        or x == 0 and y == 9
        or y == 12
        or x == 0 and y == 11 { 0.6pt },
    ),
    row-gutter: (2.2pt, auto),
    rows: 30pt,
    columns: (2.5cm, 2cm, 3cm, 3cm, 3cm),
    align: horizon,
    table.header[Interaction \ parameter $alpha$][Wall][Phantom layer \ $ (times 10^7) upright(W)"/"upright(m^2)$][Interfacial layer \ $ (times 10^7) upright(W)"/"upright(m^2)$][Relative error \ %],
    table.cell(rowspan: 2, [0.01]),
    [Upper], [$"  "$3.2176], [$"  "$2.9910], [7.04],
    [Lower], [-3.2765], [-3.1959], [2.46],
    table.cell(rowspan: 2, [0.03]),
    [Upper], [$"  "$6.2779], [$"  "$6.0529], [3.58],
    [Lower], [-6.1850], [-6.1018], [1.35],
    table.cell(rowspan: 2, [0.05]),
    [Upper], [$"  "$10.247], [$"  "$10.015], [2.26],
    [Lower], [-10.137], [-10.057], [0.79],
    table.cell(rowspan: 2, [0.07]),
    [Upper], [$"  "$14.478], [$"  "$14.325], [1.06],
    [Lower], [-14.680], [-14.577], [0.70],
    table.cell(rowspan: 2, [0.1]),
    [Upper], [$"  "$21.146], [$"  "$20.891], [1.21],
    [Lower], [-20.990], [-20.910], [0.38],
    table.cell(rowspan: 2, [0.2]),
    [Upper], [$"  "$38.539], [$"  "$38.415], [0.32],
    [Lower], [-38.574], [-38.481], [0.24],
  ),
  caption: [Heat flux in phantom layer and interfacial layer.],
) <tbl_hf>
#v(2cm)

== 界面熱抵抗の妥当性

また，前項で求めた熱流束と界面温度差のデータを用いて，界面熱抵抗を計算した結果を @tbl_icr に示す．@tbl_icr を見ると，固液間相互作用強さ $alpha$ が大きいほど界面熱抵抗が小さくなっていることが確認できる．この結果より， $alpha$ が大きいほど熱量の授受が活発に行われていることが分かる．本章で得られた非平衡分子動力学シミュレーションの結果を基に，次章では平衡分子動力学シミュレーションの妥当性を検証する．

#pagebreak()
#v(2cm)
#tbl(
  table(
    stroke: (x, y) => (
      top: if y == 0 { 0.6pt } else if y == 1 { 0.6pt },
      bottom: if y == 0
        or y == 2
        or x == 0 and y == 1
        or y == 4
        or x == 0 and y == 3
        or y == 6
        or x == 0 and y == 5
        or y == 8
        or x == 0 and y == 7
        or y == 10
        or x == 0 and y == 9
        or y == 12
        or x == 0 and y == 11 { 0.6pt },
    ),
    row-gutter: (2.2pt, auto),
    rows: 30pt,
    columns: (2.5cm, 2cm, 3cm, 3cm, 3cm),
    align: horizon,
    table.header[Interaction \ parameter $alpha$][Wall][Temperature \ difference K][#table.cell(
        colspan: 2,
        [ITR $(times 10^(-7))$ $upright(m^2 dot K)"/"upright(W)$ \ Phantom layer$"     "$ Interfacial layer],
      )],
    table.cell(rowspan: 2, [0.01]),
    [Upper], [29.825], [9.1853], [9.6413],
    [Lower], [28.825], [8.8773], [9.3181],
    table.cell(rowspan: 2, [0.03]),
    [Upper], [29.445], [4.7252], [4.8450],
    [Lower], [27.505], [4.4139], [4.5258],
    table.cell(rowspan: 2, [0.05]),
    [Upper], [27.557], [2.7038], [2.7458],
    [Lower], [27.317], [2.6802], [2.7219],
    table.cell(rowspan: 2, [0.07]),
    [Upper], [26.053], [1.7870], [1.8029],
    [Lower], [25.949], [1.7799], [1.7957],
    table.cell(rowspan: 2, [0.1]),
    [Upper], [24.577], [1.1666], [1.1759],
    [Lower], [23.981], [1.1383], [1.1474],
    table.cell(rowspan: 2, [0.2]),
    [Upper], [19.038], [0.4938], [0.4952],
    [Lower], [18.251], [0.4734], [0.4747],
  ),
  caption: [Temperature difference and ITR.],
) <tbl_icr>

#pagebreak()
#v(2cm)

#tbl(
  table(
    stroke: (x, y) => (
      top: if y == 0 { 0.6pt } else if y == 1 { 0.6pt },
      bottom: if y == 0 or y == 6 { 0.6pt },
    ),
    row-gutter: (2.2pt, auto),
    rows: 30pt,
    columns: (3cm, 5cm),
    align: horizon,
    table.header[Interaction \ parameter $alpha$][Pressure \ $"MPa"$],
    [0.01], [47.392],
    [0.03], [42.717],
    [0.05], [38.203],
    [0.07], [33.390],
    [0.1], [29.852],
    [0.2], [17.144],
  ),
  caption: [ The relationship between pressure and interaction parameter $alpha$.],
) <tbl_press_nemd>

= 平衡分子動力学における#parbreak()#h(-11pt)界面熱抵抗の評価 <chap_4>

== はじめに

本章では@sec_itr_emd で説明した方法で熱流束の自己相関関数を作成し，Green – Kubo式を用いて平衡分子動力学における固液界面熱抵抗を計算する．その際，固液間相互作用強さ $alpha$ を変更して固液界面熱抵抗の値を比較する．

== 計算条件
=== 計算系

この章で用いた計算系について説明する．Pt壁面の温度は上壁面と下壁面の両方を100 Kに設定している．それ以外の条件は@chap_3 で用いた計算系と同じものを用いている．数値積分の時間刻み $italic(Delta t)$ を1.0 fsとし，熱流束の取得は上下壁面両方で15 ns間行う．固液間相互作用強さ $alpha$ を0.01，0.03，0.05，0.07，0.1，0.2に変更し，結果を比較する．

=== 計算手順 <sec_emd_pro>

計算手順は以下のようになっている．

#v(0.5em)
+ 最初の0.1 nsのみ速度スケーリングを行い，Ar分子を100 Kに制御する．Langevin法によりPt原子の上下壁面を100 Kに制御する．
+ 0.1 ns経過したらAr分子の速度スケーリングを外し，3 nsの緩和計算を行う．この間はデータ取得を行わない．
+ 緩和計算終了後，15 nsの間データを取得する．
#v(0.5em)

　熱平衡状態を正確に実現するため，非平衡分子動力学シミュレーションよりも長く緩和計算時間を設けている．熱流束の計算方法については，@eq9_3 で示した方法に従い，上下のAr - Pt壁面において15 nsの間毎ステップ計測するため，熱流束のデータは合計で30000000個収集できる．界面熱抵抗の計算については，@eq9_2 に示した方法に従い，上下壁面それぞれで自己相関関数を計算し，その結果の平均を取って算出する．なお各条件における圧力について，@cla_press に基づいて計算した結果を @tbl_press_emd に示す．

== 温度分布の妥当性

固液間相互作用強さ $alpha$ を変更した全ての系において， @temp_e0.01 – @temp_e0.2 に温度分布の結果を示す．縦軸は温度，横軸は鉛直方向の距離を表しており，最下層のPtの $z$ 座標を0としている．ただし，Ptの固定層はプロットしていない．また，縦軸と平衡な灰色の点線は固液界面の高さを表し，横軸と平衡な赤色の点線は目標温度である100 Kを表している．@temp_e0.01 – @temp_e0.2 を見ると，$alpha$ を変更した全ての系においてArの温度分布が100 Kで安定していることから，熱平衡状態に達していると判断した．

#pagebreak()
#v(-1.75cm)

#img(
  image("Figures/emd/emd_a0.01/tempe_Layer_emd0.01.svg", width: 63%),
  caption: [ Temperature distribution at $alpha = 0.01$.],
) <temp_e0.01>

#img(
  image("Figures/emd/emd_a0.03/tempe_Layer_emd0.03.svg", width: 63%),
  caption: [ Temperature distribution at $alpha = 0.03$.],
) <temp_e0.03>

#img(
  image("Figures/emd/emd_a0.05/tempe_Layer_emd0.05.svg", width: 63%),
  caption: [ Temperature distribution at $alpha = 0.05$.],
) <temp_e0.05>

#pagebreak()
#v(-1.75cm)

#img(
  image("Figures/emd/emd_a0.07/tempe_Layer_emd0.07.svg", width: 63%),
  caption: [ Temperature distribution at $alpha = 0.07$.],
) <temp_e0.07>

#img(
  image("Figures/emd/emd_a0.1/tempe_Layer_emd0.1.svg", width: 63%),
  caption: [ Temperature distribution at $alpha = 0.1$.],
) <temp_e0.1>

#img(
  image("Figures/emd/emd_a0.2/tempe_Layer_emd0.2.svg", width: 63%),
  caption: [ Temperature distribution at $alpha = 0.2$.],
) <temp_e0.2>

#pagebreak()

== 自己相関関数，界面熱抵抗の妥当性

それぞれの系で取得した熱流束データの確率分布のグラフを @distribution に示す．@distribution を見ると，すべての系で平均がおよそ0の左右対称な分布となり，正規分布に近い形状を示した．これにより，いずれの条件においても固液界面での熱の出入りが等しく，見かけ上では熱の移動が起こっていない平衡状態にあると考えられる．また，固液間相互作用強さ $alpha$ が大きいほど分散が大きく，最頻値が低くなっていることが分かる．これは，$alpha$ が大きいほど固液界面熱抵抗が小さく，絶対値の大きな熱流が正負に流れている状態が実現されているためであると考えられる．

次に $alpha$ を変更した全ての系において，自己相関関数及び界面熱抵抗のグラフをそれぞれ\ @acf_0.01 – @acf_0.2 ，@itr_0.01 – @itr_0.2 に示す．また，自己相関関数のグラフを見ると，全ての系において1 psあたりから0に収束していることが分かる．
@acf_0.01 を見ると，他の系に比べて0に収束する時間が長いようにみえる．$alpha$ が相対的に小さい場合には，収束が悪くなる傾向があるため， $alpha$ と収束性は関連がある可能性がある．また @acf_0.2 を見ると，熱流束が0付近でわずかに揺れている．これは $alpha$ が大きいと熱流束のゆらぎ範囲が大きくなり，自己相関関数の収束に必要なアンサンブル数が増えるためであると考えられる．

続いて，$alpha$ 別に界面熱抵抗の値をまとめた結果を @tbl_itr_emd に示す．界面熱抵抗は全ての系において，自己相関関数が収束したと判断できる5 psから10 psまでの@itr_0.01 – @itr_0.2 の値を平均した結果を出力した．また，@chap_3 で求めた非平衡分子動力学の界面熱抵抗と比較した結果を @comp_n_e に示す．縦軸は界面熱抵抗の値であり，横軸は固液間相互強さである．NEMDでは $alpha$ 1つにつき，上下のPhantom層と固液界面層の4つの結果をプロットした．グラフを見ると，本研究では圧力の調整を行っていないため，$alpha$ に依って多少の誤差はあるが，固液間相互作用が大きくなるにつれて界面熱抵抗が小さくなる傾向はNEMDとEMDの両方で確認することができた．この結果より，本研究で得た界面熱抵抗の計算が妥当であると判断した．



#pagebreak()
#v(3cm)
#img(
  image("Figures/distribution_2.svg", width: 80%),
  caption: [ Heat flux distribution with each $alpha$.],
) <distribution>

#pagebreak()
#v(-1.75cm)

#img(
  image("Figures/emd/emd_a0.01/ACF_true.svg", width: 48%),
  caption: [ Autocorrelation function at $alpha = 0.01$.],
) <acf_0.01>

#img(
  image("Figures/emd/emd_a0.03/ACF_true.svg", width: 47%),
  caption: [ Autocorrelation function at $alpha = 0.03$.],
) <acf_0.03>

#img(
  image("Figures/emd/emd_a0.05/ACF_true.svg", width: 46%),
  caption: [ Autocorrelation function at $alpha = 0.05$.],
) <acf_0.05>

#pagebreak()
#v(-1.75cm)

#img(
  image("Figures/emd/emd_a0.07/ACF_true.svg", width: 46%),
  caption: [ Autocorrelation function at $alpha = 0.07$.],
) <acf_0.07>

#img(
  image("Figures/emd/emd_a0.1/ACF_true.svg", width: 46%),
  caption: [ Autocorrelation function at $alpha = 0.1$.],
) <acf_0.1>

#img(
  image("Figures/emd/emd_a0.2/ACF_true.svg", width: 47%),
  caption: [ Autocorrelation function at $alpha = 0.2$.],
) <acf_0.2>

#pagebreak()
#v(-1.75cm)

#img(
  image("Figures/emd/emd_a0.01/ITR_true.svg", width: 44%),
  caption: [ Interfacial thermal resistance at $alpha = 0.01$.],
) <itr_0.01>

#img(
  image("Figures/emd/emd_a0.03/ITR_true.svg", width: 46%),
  caption: [ Interfacial thermal resistance at $alpha = 0.03$.],
) <itr_0.03>

#img(
  image("Figures/emd/emd_a0.05/ITR_true.svg", width: 46%),
  caption: [ Interfacial thermal resistance at $alpha = 0.05$.],
) <itr_0.05>

#pagebreak()
#v(-1.75cm)

#img(
  image("Figures/emd/emd_a0.07/ITR_true.svg", width: 46%),
  caption: [ Interfacial thermal resistance at $alpha = 0.07$.],
) <itr_0.07>

#img(
  image("Figures/emd/emd_a0.1/ITR_true.svg", width: 46%),
  caption: [ Interfacial thermal resistance at $alpha = 0.1$.],
) <itr_0.1>

#img(
  image("Figures/emd/emd_a0.2/ITR_true.svg", width: 44%),
  caption: [ Interfacial thermal resistance at $alpha = 0.2$.],
) <itr_0.2>

#pagebreak()

#tbl(
  table(
    stroke: (x, y) => (
      top: if y == 0 { 0.6pt } else if y == 1 { 0.6pt },
      bottom: if y == 0 or y == 6 { 0.6pt },
    ),
    row-gutter: (2.2pt, auto),
    rows: 30pt,
    columns: (3cm, 5cm),
    align: horizon,
    table.header[Interaction \ parameter $alpha$][ITR $(times 10^(-7))$ $upright(m^2 dot K)"/"upright(W)$],
    [0.01], [10.792],
    [0.03], [5.0074],
    [0.05], [2.9460],
    [0.07], [2.0158],
    [0.1], [1.3330],
    [0.2], [0.6047],
  ),
  caption: [ The relationship between ITR and interaction parameter $alpha$.],
) <tbl_itr_emd>

\ \
#img(
  image("Figures/ITR_comparison_n_e.svg", width: 60%),
  caption: [ Comparison of ITR between NEMD and EMD.],
) <comp_n_e>

#pagebreak()
#v(2cm)

#tbl(
  table(
    stroke: (x, y) => (
      top: if y == 0 { 0.6pt } else if y == 1 { 0.6pt },
      bottom: if y == 0 or y == 6 { 0.6pt },
    ),
    row-gutter: (2.2pt, auto),
    rows: 30pt,
    columns: (3cm, 5cm),
    align: horizon,
    table.header[Interaction \ parameter $alpha$][Pressure \ $"MPa"$],
    [0.01], [47.300],
    [0.03], [42.765],
    [0.05], [39.394],
    [0.07], [34.266],
    [0.1], [29.623],
    [0.2], [17.569],
  ),
  caption: [ The relationship between pressure and interaction parameter $alpha$.],
) <tbl_press_emd>

= GANsによる界面熱抵抗の予測
#v(-30pt)
== はじめに

本章では平衡分子動力学シミュレーションで取得したAr - Pt壁面系の界面熱流束を機械学習で予測する手順ついて説明し，熱流束，自己相関関数，固液界面熱抵抗において，シミュレーション結果と生成データの比較を行う．その際，固液間相互作用強さ $alpha$ を0.01，0.03，0.05，0.07，0.1，0.2に変更したそれぞれの系について予測を行った．

== GANsモデルの構造について

@sec_emd_pro で詳しく述べたが，MDシミュレーションで30000000個の熱流束データを取得する．このうちの約2%のデータ（512000個）を抽出して機械学習モデルに学習させている．本研究では@cla_ml でも説明したように，機械学習モデルとして WGAN-GP を用いている．生成器及び批評器の学習モデルの概略図を@gene_model，@disc_model に示す．

本モデルの生成器は，ランダムノイズを入力として受け取り，元データの分布に類似した新しい時系列データを生成する役割を担う．まず，長さ1000のランダムなノイズベクトルを入力し，1次元畳み込み層（Conv1D）を通じて，時系列データの局所的な特徴を抽出する．畳み込み層を用いた畳み込みニューラルネットワーク（Convolutional Neural Network）は，一般的に2次元の画像などを生成するために用いられるが，本研究のような1次元の時系列データにおける連続的な関係性やパターンを学習することにも有効であり，入力されたランダムノイズから潜在的な特徴を抽出する．次にFlatten層で，畳み込み層の出力を次の全結合層（Dense層）に渡すために平坦化される．
続いて，得られた特徴は2層の全結合層によって処理され，これらの出力をConcatenate 層で結合する．この処理により，元の特徴と新たに抽出された特徴が融合され，ネットワークにより多くの情報を提供する．
その後，得られた特徴は3つの隠れ層（Dense層）を通じて非線形変換される．各隠れ層では活性化関数としてReLU関数を用いた．最後に，出力層では，訓練データと同じ形状である長さ1000の時系列データを再構成する．このようなプロセスを通じて，生成器は元の熱流束の時系列変化を模倣することを目指す．

続いて，批評器ネットワークの構成について説明する．批評器は，生成されたデータの本物らしさの度合いを出力する役割をもつ．まず，データ全体を1つのフィルターで畳み込む処理をするConv1D層と，サイズ1のフィルターを1つずつずらしながら畳み込む処理をするConv1D層の2つで空間的な特徴を抽出し，Flatten層で平坦化した．次に，3つの隠れ層（Dense層）を通じてさらに特徴を抽出し，最終的に出力層で入力データの本物らしさの指標を出力する．全てのDense層には活性化関数としてReLU関数を用いることで，勾配消失を防ぎつつ効率的な学習を進めた．

続いて，学習設定について説明する．本研究では，損失関数として@eq12_6 で示したWasserstein Lossを用いており，その正則化項として@eq12_7 に示したGPを採用している．
最適化手法にはRMSPropを用いており，生成器の1回の勾配の更新につき，批評器の勾配の更新を5回行っている．生成器の学習率を $2.0 times 10^(-4)$ ，批評器の学習率を生成器の1/5の $4.0 times 10^(-5)$ としている．
また，バッチサイズは512，イテレーション数は20000に設定し，効率的な学習を進めた．

#pagebreak()

なお，学習モデルおよびシステムの構築は，Pythonで実行可能なフレームワークであるTensorflowで実施した．以下にこれらのライブラリの環境を示す．
#v(0.3cm)
- Python : 3.11.5
- tensorflow : 2.12.0 (build source: gpu py311h65739b5 0)
- cudnn : 8.2.1
- CUDA v12.4, v11.3
#v(0.3cm)
また，これらのプログラムは以下のハードウェアで実行している．
#v(0.3cm)
- PC : HPC5000-XIL216TS-D8
- CPU : Xeon Gold 6326 (16core, 2.9 GHz and 185 W)
- GPU : GeForce RTX 4090 (24 GB and 450 W)
#v(0.3cm)

以上の環境で行ったMDシミュレーション及びGANsの計算時間について，MDシミュレーションでは熱流束の取得に約109時間58分，GANsでは約26分の時間がかかった．

#pagebreak()

#img(
  image("Figures/generator.png", width: 90%),
  caption: [ The architecture of generator network of the GANs.],
) <gene_model>

#v(0.5cm)

#img(
  image("Figures/discriminator.png", width: 77%),
  caption: [ The architecture of discriminator network of the GANs.],
) <disc_model>

#pagebreak()

== GANsによる予測の評価

@chap_4 に示したMDシミュレーションによる結果とGANsによる予測結果を， @hf_10ps_0.01 – @dist_0.2 に示す．@hf_10ps_0.01，@hf_10ps_0.03，@hf_10ps_0.05，@hf_10ps_0.07，@hf_10ps_0.1，@hf_10ps_0.2 の左図の赤い線はMDシミュレーションで得た熱流束であり，右図の青い線はGANsで生成した熱流束である．
GANsで生成した熱流束において，固液間相互作用強さ $alpha$ を変更したいずれの系においても，ゆらぎの振幅や波長の大まかな特徴は再現できているが，細部をよく見ると細かく振動していることが分かる．これは，モデルに入力したノイズの影響が表れている可能性がある．また@dist_0.01，@dist_0.03，@dist_0.05，@dist_0.07，@dist_0.1，@dist_0.2 のグラフは，縦軸を確率密度，横軸を熱流束データとした確率分布である．結果を見ると，いずれの系においてもMDシミュレーションに近い分布を得ることができているが，$alpha$ が0.1以外の系においては，0付近のピークが僅かにずれている．このように熱流束の分布がそもそも異なっている場合，固液界面熱抵抗の誤差を小さくすることが困難になるため，今後は熱流束の分布を真の分布にさらに近づけた上で， $alpha$ を変更した系でも精度良く予測できるGANsモデルを実現することが課題となる．

次に@chap_4 と同様の方法で，生成した熱流束データから自己相関関数を計算し，固液界面熱抵抗を算出した．MDとGANsの計算結果の比較を @comp_md_gan_0.01 – @comp_md_gan_0.2 に示す．自己相関関数を見ると，いずれの系においても1 psを超えた辺りから0に収束している傾向を確認することができたが，@comp_md_gan_0.01 の自己相関関数は周期性をもった僅かな振動が見られた．これは，$alpha$ が小さい場合に熱流束のゆらぎ範囲が狭く，学習できたパターンの少なさが原因であると考えられる．また，MDの自己相関関数には0に収束する前に数回の大きな振動が確認されたが，GANsの予測結果の振動はその振動の振幅が小さくなっていることが分かる．このことから，各時刻の熱流束について，十分な時間が経過したときの熱流束の相関の低下を再現することはできているが，短時間での熱流束の相関を正確に再現することができていないと考えられる．また，確率分布ではMDシミュレーションに非常に近い分布が得られた系があったにもかかわらず，自己相関関数や固液界面熱抵抗の値に誤差が生じている．これらの原因としては，本研究で用いた学習モデルが熱流束の時系列変化の傾向を正確に学習できなかった可能性が考えられる．

本研究で用いたモデルは最適化を十分に行えていない．そのため，今後の解決策として，学習率や訓練データ数などのハイパーパラメータを変更するほか，熱流束の時系列データについてより細かい特徴抽出を行うため，ネットワークのアーキテクチャの層の数や隠れ層のノード数を変更することなどが挙げられる．

また，先行研究 @gan_heatflux では，生成した熱流束データについて高速Fourier変換をすることで，周波数空間の情報を確認しているため，今後の展望としては，熱流束データのFourier変換で周波数空間における類似度でも評価をし，その時系列的な再現性について調査を行うことも考えられる．

#pagebreak()

#img(
  grid(
    columns: 2,
    [#figure(
        image("Figures/gan/0.01/heatflux_true_10ps.svg", width: 100%),
        supplement: "",
      )],
    [#figure(
        image("Figures/gan/0.01/heatflux_pred_10ps.svg", width: 100%),
        supplement: "",
      )],
  ),
  caption: [
    Time histories of interfacial heat flux via MD simulation (#text(fill: rgb(100%,0%,0%))[red]), and GANs (#text(fill: rgb(0%,0%,100%))[blue]) at $alpha = 0.01$.
  ],
) <hf_10ps_0.01>

#v(1.4cm)

#img(
  image("Figures/gan/0.01/histogram_comparison.svg", width: 70%),
  caption: [ Comparison of heat flux distribution in MD simulation and GANs at $alpha = 0.01$.],
) <dist_0.01>

#pagebreak()

#img(
  grid(
    columns: 2,
    [#figure(
        image("Figures/gan/0.03/heatflux_true_10ps.svg", width: 100%),
        supplement: "",
      )],
    [#figure(
        image("Figures/gan/0.03/heatflux_pred_10ps.svg", width: 100%),
        supplement: "",
      )],
  ),
  caption: [
    Time histories of interfacial heat flux via MD simulation (#text(fill: rgb(100%,0%,0%))[red]), and GANs (#text(fill: rgb(0%,0%,100%))[blue]) at $alpha = 0.03$.
  ],
) <hf_10ps_0.03>

#v(1.4cm)

#img(
  image("Figures/gan/0.03/histogram_comparison.svg", width: 70%),
  caption: [ Comparison of heat flux distribution in MD simulation and GANs at $alpha = 0.03$.],
) <dist_0.03>

#pagebreak()

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
    Time histories of interfacial heat flux via MD simulation (#text(fill: rgb(100%,0%,0%))[red]), and GANs (#text(fill: rgb(0%,0%,100%))[blue]) at $alpha = 0.05$.
  ],
) <hf_10ps_0.05>

#v(1.4cm)

#img(
  image("Figures/gan/0.05/histogram_comparison.svg", width: 70%),
  caption: [ Comparison of heat flux distribution in MD simulation and GANs at $alpha = 0.05$.],
) <dist_0.05>

#pagebreak()

#img(
  grid(
    columns: 2,
    [#figure(
        image("Figures/gan/0.07/heatflux_true_10ps.svg", width: 100%),
        supplement: "",
      )],
    [#figure(
        image("Figures/gan/0.07/heatflux_pred_10ps.svg", width: 100%),
        supplement: "",
      )],
  ),
  caption: [
    Time histories of interfacial heat flux via MD simulation (#text(fill: rgb(100%,0%,0%))[red]), and GANs (#text(fill: rgb(0%,0%,100%))[blue]) at $alpha = 0.07$.
  ],
) <hf_10ps_0.07>

#v(1.4cm)

#img(
  image("Figures/gan/0.07/histogram_comparison.svg", width: 70%),
  caption: [ Comparison of heat flux distribution in MD simulation and GANs at $alpha = 0.07$.],
) <dist_0.07>

#pagebreak()

#img(
  grid(
    columns: 2,
    [#figure(
        image("Figures/gan/0.1/heatflux_true_10ps.svg", width: 100%),
        supplement: "",
      )],
    [#figure(
        image("Figures/gan/0.1/heatflux_pred_10ps.svg", width: 100%),
        supplement: "",
      )],
  ),
  caption: [
    Time histories of interfacial heat flux via MD simulation (#text(fill: rgb(100%,0%,0%))[red]), and GANs (#text(fill: rgb(0%,0%,100%))[blue]) at $alpha = 0.1$.
  ],
) <hf_10ps_0.1>

#v(1.4cm)

#img(
  image("Figures/gan/0.1/histogram_comparison.svg", width: 70%),
  caption: [ Comparison of heat flux distribution in MD simulation and GANs at $alpha = 0.1$.],
) <dist_0.1>

#pagebreak()

#img(
  grid(
    columns: 2,
    [#figure(
        image("Figures/gan/0.2/heatflux_true_10ps.svg", width: 100%),
        supplement: "",
      )],
    [#figure(
        image("Figures/gan/0.2/heatflux_pred_10ps.svg", width: 100%),
        supplement: "",
      )],
  ),
  caption: [
    Time histories of interfacial heat flux via MD simulation (#text(fill: rgb(100%,0%,0%))[red]), and GANs (#text(fill: rgb(0%,0%,100%))[blue]) at $alpha = 0.2$.
  ],
) <hf_10ps_0.2>

#v(1.4cm)

#img(
  image("Figures/gan/0.2/histogram_comparison.svg", width: 70%),
  caption: [ Comparison of heat flux distribution in MD simulation and GANs at $alpha = 0.2$.],
) <dist_0.2>

#pagebreak()
#v(-1.75cm)

#img(
  grid(
    columns: 2,
    [#figure(
        image("Figures/gan/0.01/ACF_pred_and_true.svg", width: 91%),
        supplement: "",
      )],
    [#figure(
        image("Figures/gan/0.01/ITR_pred_and_true.svg", width: 83%),
        supplement: "",
      )],
  ),
  caption: [ Comparison of ACF and ITR in MD simulation and GANs at $alpha = 0.01$.],
) <comp_md_gan_0.01>
#v(20pt)
#img(
  grid(
    columns: 2,
    [#figure(
        image("Figures/gan/0.03/ACF_pred_and_true.svg", width: 89%),
        supplement: "",
      )],
    [#figure(
        image("Figures/gan/0.03/ITR_pred_and_true.svg", width: 86%),
        supplement: "",
      )],
  ),
  caption: [ Comparison of ACF and ITR in MD simulation and GANs at $alpha = 0.03$.],
) <comp_md_gan_0.03>
#v(20pt)
#img(
  grid(
    columns: 2,
    [#figure(
        image("Figures/gan/0.05/ACF_pred_and_true.svg", width: 86%),
        supplement: "",
      )],
    [#figure(
        image("Figures/gan/0.05/ITR_pred_and_true.svg", width: 87%),
        supplement: "",
      )],
  ),
  caption: [ Comparison of ACF and ITR in MD simulation and GANs at $alpha = 0.05$.],
) <comp_md_gan_0.05>

#pagebreak()
#v(-1.75cm)

#img(
  grid(
    columns: 2,
    [#figure(
        image("Figures/gan/0.07/ACF_pred_and_true.svg", width: 86%),
        supplement: "",
      )],
    [#figure(
        image("Figures/gan/0.07/ITR_pred_and_true.svg", width: 87%),
        supplement: "",
      )],
  ),
  caption: [ Comparison of ACF and ITR in MD simulation and GANs at $alpha = 0.07$.],
) <comp_md_gan_0.07>
#v(20pt)
#img(
  grid(
    columns: 2,
    [#figure(
        image("Figures/gan/0.1/ACF_pred_and_true.svg", width: 86%),
        supplement: "",
      )],
    [#figure(
        image("Figures/gan/0.1/ITR_pred_and_true.svg", width: 87%),
        supplement: "",
      )],
  ),
  caption: [ Comparison of ACF and ITR in MD simulation and GANs at $alpha = 0.1$.],
) <comp_md_gan_0.1>
#v(20pt)
#img(
  grid(
    columns: 2,
    [#figure(
        image("Figures/gan/0.2/ACF_pred_and_true.svg", width: 89%),
        supplement: "",
      )],
    [#figure(
        image("Figures/gan/0.2/ITR_pred_and_true.svg", width: 83%),
        supplement: "",
      )],
  ),
  caption: [ Comparison of ACF and ITR in MD simulation and GANs at $alpha = 0.2$.],
) <comp_md_gan_0.2>

#pagebreak()

#tbl(
  table(
    stroke: (x, y) => (
      top: if y == 0 { 0.6pt } else if y == 1 { 0.6pt },
      bottom: 0.6pt,
    ),
    row-gutter: (2.2pt, auto),
    rows: 30pt,
    columns: (3cm, 3cm, 3cm),
    align: horizon,
    table.header[Interaction \ parameter $alpha$][#table.cell(
        colspan: 2,
        [ITR $(times 10^(-7))$ $upright(m^2 dot K)"/"upright(W)$ \ $"  "$MD $"                 "$ GANs],
      )],

    [0.01], [10.792], [7.9521],
    [0.03], [5.0074], [4.3522],
    [0.05], [2.9460], [2.4096],
    [0.07], [2.0158], [1.1287],
    [0.1], [1.3330], [0.8933],
    [0.2], [0.6047], [0.3757],
  ),
  caption: [ Comparison of ITR in MD simulation and GANs.],
) <tbl_itr_md_gan>

\ \
#img(
  image("Figures/ITR_comparison_e_g.svg", width: 60%),
  caption: [ Comparison of ITR in MD simulation and GANs.],
) <comp_e_g>

= 結論

== 結論

本研究では，平衡分子動力学における固液界面の熱流束ゆらぎをGANsを用いて予測し，Green – Kubo式を用いて固液界面熱抵抗を計算，評価をすることで，分子動力学シミュレーションで得られる物理量の予測可能性について検証した．それにあたり，最初に本研究では流体分子の上下を固体壁面で挟んだ壁面系を用いて，ナノスケールにおける固液界面熱抵抗の検証を行った．その際，固体原子にはPt，流体分子にはArを用いたほか，様々な濡れ性を有する壁面系においても予測を可能にするため固液間相互作用強さ $alpha$ を変更して計算を行った．以下に具体的な調査内容について述べる．

#v(1em)
+ 平衡分子動力学シミュレーションで得られる固液界面熱抵抗の妥当性を確認するため，非平衡分子動力学シミュレーションにおいて，固液界面及びPhantom層を介して伝搬される熱流束と，界面に生じる温度差により固液界面熱抵抗を求めて比較を行った．

+ 平衡分子動力学シミュレーションにおいて，熱流束の時系列データから30000000のアンサンブルを用意し，自己相関関数を収束させることで固液界面熱抵抗を計算した．

+ 平衡分子動力学シミュレーションで得られた熱流束データの一部をサンプリングして敵対的生成ネットワーク（GANs）に学習させ，熱流束データを30000000個生成した．生成した熱流束データから30000000の自己相関関数のアンサンブルを作成し，固液界面熱抵抗を求めて平衡分子動力学シミュレーションと比較し，評価を行った．
#v(1em)

以上の調査を踏まえて，本研究で得られた知見を述べる．

#v(1em)

+ 非平衡分子動力学シミュレーションにおいて，分子数を固定し，固液間相互作用強さ $alpha$ を大きくすることで熱輸送量が増加し，固液界面熱抵抗が下がることを確認できた．
+ 平衡分子動力学シミュレーションにおいて， $alpha$ を変更した場合，固液界面熱抵抗の値は非平衡分子動力学シミュレーションと同様の傾向を示した．
+ 本研究で用いたGANsは， $alpha$ を変更したいずれの系においても固液界面熱抵抗の値に定量的な誤差が見られたが， $alpha$ と固液界面熱抵抗の関係について，MDシミュレーションの結果とGANsによる予測の両方に同様の傾向が見られたため，定性的には固液界面熱抵抗の予測が可能である．
+ 計算にかかる時間的コストの観点において，GANsはMDシミュレーションの約250倍の速度で熱流束データの取得が可能である．
+ 固液界面熱抵抗の計算に必要なアンサンブル数の観点において，MDシミュレーションでは30000000個の熱流束データに対し，GANsで用いた訓練データセットの長さはMDシミュレーションの約2%であり，計算量を大幅に削減することができる．

// #pagebreak()

== 今後の展望

本研究では，定性的な固液界面熱抵抗の予測をすることができたが，誤差を小さくするためには，更なるGANsのモデルの改善を行う必要がある．例えば，GANsで予測した熱流束ゆらぎに高周波成分のノイズが見られたため，学習率を下げることや学習率スケジューリングの導入，ドロップアウトの追加，R2正則化 @r1r2 の実施などが考えられる．また，生成された熱流束データは時間的な相関に比較的弱いため，時系列変化についてさらに詳しく学習させる必要がある．例えば，訓練データをさらに増やすことや，ネットワークのアーキテクチャの層の数，隠れ層のノード数などを変更して，効率的な特徴抽出を行うことなどが考えられる．また，得られた熱流束データについてFourier解析を行うことで，周波数分布や時系列的な関係性などについて，新たな知見が得られる可能性がある．

#show bibliography: set text(1em, lang: "en")
#bibliography("bib/reference_sotsuron.bib", title: "参考文献", style: "ieee")

#heading(numbering: none)[謝辞]

#v(3cm)
本研究を行うにあたって，芝原正彦教授には研究内容や研究方針について丁寧にご指導いただき，貴重なご助言を賜りました．心より深く感謝申し上げます．

また，藤原邦夫准教授には，研究環境の整備にご尽力いただくとともに，進路に関する相談にも親身に応じていただきました．心より御礼申し上げます．

さらに，奥田尚代事務員には，研究生活を円滑に進めるための各種手続きに関し，多大なるご支援をいただきました．心より御礼申し上げます．

そして，芝原・藤原研究室の田中翔大さんには，機械学習に関する助言をはじめ，卒業論文の添削や多方面にわたるサポートをしていただきました．心より深く感謝申し上げます．

最後に，日々の研究活動を共にした芝原・藤原研究室の皆様に，改めて深く感謝の意を表します．
