#import "./preprint_format.typ": *

#show: preprint.with(
  presentation: [口頭発表の原稿],
  title: "RPGのラスボス撃破時におけるクライマックス演出の最適化に関する研究",
  author: "川口 達也",
  university: [],
  faculty: [],
  department: [],
  major: [],
  field: [],
  laboratory: [],
  date: ("2025", "7", "5"),
  bibliography-file: "bib/jaist_essay.bib",
)

= 初めに
それでは、RPGのラスボス撃破時におけるクライマックス演出の最適化に関する研究と題しまして、口頭発表の方を始めさせていただきます。

// まるまるカットも検討
// = 専攻を変えた理由
// まず初めに、学部での研究内容と、専攻を変えようと思った理由について簡単に説明します。
// 学部では分子シミュレーションに機械学習を応用する研究に取り組みました。
// しかし、限られた期間では理論を理解するのに精一杯で、機械学習のモデル設計まで深く踏み込むことができなかったことが心残りでした。
// そのため、大学院では最低でも機械学習を使った研究に取り組みたいと考えていました。
// そうして研究室を探す中で、ゲームAIを扱う興味深い研究室を見つけたので、もともとゲームにも関心があったことから、JAISTの情報科学分野を志望いたしました。
// ここまで

= 研究背景
次に、JAISTで取り組みたい研究について説明いたします。本研究の目的は、RPGのラスボス戦において、機械学習を用いて演出を最適化し、すべてのプレイヤーにとって感動的な体験となるクライマックスを実現することです。

続いて研究背景です。
プレイヤーを没入させるゲームジャンルの一つにロールプレイングゲームが挙げられます。（以下ではRPGと呼びます）
RPGにはストーリーや冒険、戦闘など様々な要素があり、プレイヤーはキャラクターに自己を投影し、まるで自分がその世界を生きているかのような没入感を得ることができます。

心理学者のダニエル・カーネマンによれば、人間は過去の体験を振り返るとき、「ピークの瞬間」と「終わり方」の印象によって、その体験全体の評価を決める傾向があるとされています。
これはゲームにおいても顕著であり、RPGにおいては特にラスボス戦における体験がそのゲーム全体の印象に大きく影響します。
本研究では、ラスボス戦の感動体験の要素として、没入感と音楽演出に着目しました。

まず没入感についてです。
没入感を高めるためには、プレイヤーの技量とゲームの難易度のバランスが重要です。
難易度がプレイヤーにとって、簡単すぎず難しすぎないちょうどいいバランスになっていると、プレイヤーはフロー状態と呼ばれる状態に入り、プレイヤーに強い没入感を体験させることができます。
ですが、プレイヤーには初心者から熟練者まで幅広い層が存在し、あらかじめ固定された難易度では、すべてのプレイヤーを満足させることは難しいです。
この課題に対するアプローチとして、プレイヤーの状態に応じてゲームの難易度をリアルタイムで調整する、動的難易度調整という手法が提案されています。（以下ではDDAと呼びます）

続いて音楽演出についてです。
ラスボス戦における音楽は、プレイヤーの感情に直接働きかける重要な要素です。
近年では、ゲームの状況に応じて音楽を変化させるインタラクティブミュージックという技術が注目されています。
この技術自体は昔から研究されており、
// （例えばスーパーマリオブラザーズにおけるテンポアップや、ゼルダの伝説シリーズのバトルシーン移行時のシームレスな曲調の変化などが挙げられます。）
近年ではFF15のボス戦において、メインパートとエンドパートの間にプレエンドパートを設け、そのパートではループ間隔を短くすることで、いつでもエンドパートに遷移できる工夫がされています。こうした工夫によって、ボス戦のBGMがそのまま自然に勝利BGMへと移る演出が可能になります。

このようにインタラクティブミュージックという分野では、ゲームの状況に応じて音楽を変化させる取り組みが進められてきました。しかしその一方で、音楽に合わせてゲームの状況を変化させるという逆のアプローチはまだあまり行われていません。そこで本研究では、BGMのクライマックスに合わせてちょうどラスボスが倒されるように、ラスボスの行動を制御するAIを構築します。
以上のように、本研究では没入感と音楽演出の二つの要素に着目し、すべてのプレイヤーにとって手ごたえがあり、感動的なクライマックスを演出するラスボス戦の実現を目指します。
// （4分）（タイトル含め8枚）
// （3分）

= 研究手法

続いて研究手法について説明いたします．
本研究では、ドラクエやFFなどに代表される、一般的なターン制のコマンド型RPGを対象とします。
ゲームはunityで簡単なものを制作します。
また、機械学習の手法としては、強化学習を用います。
// カット
// 強化学習とは、エージェントが環境の中で行動し、その結果得られる報酬をもとに、「どのように行動すれば最適かを学習する機械学習の一種です．
// たとえば囲碁を例にすると、環境とはゲームのルールと盤面、エージェントとは強くしたい対戦プレイヤーに相当します。
// 対戦プレイヤーAIは、状態と呼ばれる、現在の盤面の碁石の配置を見ながら、行動と呼ばれる、次にどこに石を置くかを選びます。
// そして、対局を通じて得られる勝敗などの報酬をもとに、AIがプレイヤーのように経験を積みながら、より良い行動の選び方を自ら学んでいくのが、強化学習の特徴です。
機械学習の方はpythonで処理を行います。
本研究では、強化学習アルゴリズムとしてDeep Q-Networkを使います。（以下ではDQNと呼びます）
DQNは強化学習にニューラルネットワークの技術を応用した手法です。

続いてゲームの設定について説明します。
一般的なコマンドRPGを参考にし、状態はこのように～種類、行動はこのように～種類定義します。
状態と行動は、プレイヤーとラスボスに共通しています。

// 7分に含めるか要検討
注意点として、HPは最大HPに対する現在のHPの割合を用います。
また、回復のコマンドは入れますが、最大HPを毎回変更するといったことはしません。
あくまでラスボスの行動によってHPを調整します。
また、状態にはBGMのループ時間を1となるように時間を正規化し、現在の時刻を0～1の数値として状態に含めることで、今がループのどのあたりかエージェントが把握できるようにします。
これらの状態や行動については暫定的にこのようにしていますが、研究を進めていく中で模索していこうと思っています。
（行動する順番について）
// ここまで

BGMはループの一番最後に最も盛り上がると仮定します．
灰色の縦の点線がループが終了するタイミングです．
報酬関数はこのBGMを元にこのように設定します．
ループの終盤の近くでラスボスを倒すほど，点数が高くなりますが，少しでも超えると点数を大幅に下げます．
これは，多少早い場合は自然に勝利BGMに繋げられますが，遅い場合は繋げられないからです．

// また、討伐までの学習を安定化させるために、中間報酬も用意します。
// 簡単なスクリプトAIから、経過時間とラスボスのHP残量のグラフをあらかじめ作成します。
// だいたいこのような右下がりのグラフになると思います。
// この理想のHP残量と実際のHP残量を比較し、その差分を減点することで討伐まで順調にラスボスのHPが減らせているかを判断します。
// ただし、BGMの終わりに倒されることが優先なので、この中間報酬は点数を低めにしておきます。

続いて、さらにプレイヤーを熱くさせる要素として、攻撃の命中や回避、クリティカルと呼ばれたりする倍以上の攻撃などの運要素を取り入れ、これらを意図的に確率操作することをします。
また，ゲーム中盤の報酬として，プレイヤーを熱くさせる展開があった時に加点を行います．これらは一例ですが，後に説明する方法によって加点方法を追加したりブラッシュアップを行います．

続いて、結果の評価方法について説明します。
// 学習後のエージェントについて、討伐時間のヒストグラムを作成し、ループ終了タイミングとの一致度を定量的に評価します。
実際に人にプレイしてもらい，GEQと呼ばれるゲームの評価によく用いられる分析手法に基づいてアンケートを実施します．
質問項目では，プレイ中に抱いた感情をこれらの7つの感情から複数選択してもらい，それを感じた場面を答えてもらうことで，特定のイベントがどの感情に効果的だったかフィードバックすることで，先ほどの熱くなる展開，イベントの更新を行います．

最後に課題及び今後の展望について考察します。
本研究は、ゲームAIが演出と連携し、プレイヤー体験を最適化する新しい可能性を提示する研究です。
課題としては、なかなかちょうどいいタイミングでプレイヤーがコマンドを選択してくれない場合、戦闘が終結せずグダってしまうことや、〜などが考えられます。
今後の展望としては、複数キャラクターによるパーティバトルや、アクションゲームなどのリアルタイム性の高いジャンルへの応用なども期待できます。
以上で発表を終わります。
ご清聴ありがとうございました。
// （3分半）（7枚）
