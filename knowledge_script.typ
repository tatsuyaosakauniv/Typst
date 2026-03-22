#import "report_format.typ": *
#import "@preview/numbly:0.1.0": numbly
#import "@preview/codelst:2.0.0": sourcecode

// #import "@preview/physica:0.9.2"
#show: master_thesis.with(
  title: "Methodology for Knowledge Media",
  subtitle: "Speech Script",
  author: "Tatsuya Kawaguchi",
  id: "2510414",
  university: "JAIST",
  bibliography-file: "",
)

= Introduction

Good morning everyone. I'm Tatsuya Kawaguchi. My student ID is 2510414.

Today, I would like to talk about communication in online environments by introducing two research papers.

Both papers were selected from the “Games, Entertainment, & Culture” session, and they approach online communication from different perspectives.

= Paper 1: Communication Patterns Predict Team Skill in Multiplayer Online Games
== Introduction

First, I will summarize the first paper.

This study focuses on team communication in multiplayer online games, using _World of Tanks_ as a case study.

In this game, players form long-term teams called clans.
Each clan has defined roles, participates in battles together, and receives a skill rating based on performance.

The main research question of this paper is:
Can a team’s communication patterns predict how skilled that team is?

== Methodology

To answer this question, the authors analyzed large-scale chat log data from over one thousand and six hundreds clans.
They extracted various communication features, including:

- The number of messages,
- The timing of communication,
- and the structure of communication networks, such as who talks to whom.

Using these features, they applied Lasso regression, which is a machine learning method, to predict clan skill ratings.

== Results

The key finding of study is that strong teams do not simply communicate more.

Instead, the quality and structure of communication matter more than quantity.

Specifically, the authors found that:
- Communication before battles is strongly associated with higher performance.
- Teams perform better when many different members actively participate in communication.
- And overly centralized communication, dominated by a few leaders, is associated with lower performance.

This study shows that effective teamwork depends on inclusive and well-structured communication, rather than message volume alone.

#pagebreak()

= Paper 2: ThingMoji: User-Captured Cut-Outs for In-Stream Visual Communication
== Introduction

Next, I will introduce the second paper.

Unlike the first paper, it focuses on introducing a new communication method and discussing its potential and challenges.

The authors propose a system called ThingMoji.

ThingMoji is a new communication tool that can be used as an alternative to emojis
in online communication.

== Method

ThingMoji is designed to turn real-world objects into communication tools.

Users can cut out objects from their environment or from on-screen content,
and use them as visual expressions during live communication.

Instead of using predefined emojis, users create their own expressions,
which makes communication more personal and context-aware,
especially in fast-paced online settings such as live streaming.

== Problems

The paper also discusses future challenges, such as:
- The effort required to create ThingMojis,
- Long-term usability,
- And how ThingMoji should coexist with other communication tools.

Overall, this paper positions ThingMoji not as a finalized solution, but as an exploration of how online communication can be expanded and enriched through design.

#pagebreak()

= Why I Chose These Two Papers

Now, I would like to explain why I chose these two papers.

I belong to a game AI research laboratory, where we study games using techniques such as reinforcement learning.

In particular, I am interested in how communication within games influences player behavior, team performance, and overall player experience.

The first paper directly analyzes communication in an online game and applies machine learning to understand its relationship with team skill.

The second paper focuses on designing new forms of communication in online environments closely related to games, such as live streaming and interactive chat.

Although their approaches are different, I personally found both papers interesting and thought-provoking, especially from the perspective of game AI and interactive systems.

= Relationship Between the Two Papers

Next, I will discuss the relationship between these two studies.

In the first paper, communication is treated as data to be analyzed.
The goal is to help AI systems understand how communication patterns relate to team performance.

In contrast, the second paper treats communication as something to be actively designed and extended, enabling richer and more expressive interaction for users.

In other words, the two papers approach online communication from opposite but complementary perspectives:

First treats communication as something to be understood and analyzed,
while second treats communication as something to be designed and supported.

Together, they show that online communication can be both a subject of analysis and a target of design.

= Conclusion

To conclude, these two papers provide valuable insights into good communication in online environments.

They show that online communication plays a crucial role not only in team performance, but also in user experience and social connection.

I believe that future game AI research can benefit from integrating these two perspectives,
by not only analyzing player communication, but also supporting and shaping it to improve interaction and experience.

Thank you very much for your attention.

#pagebreak()

= Q&A
== Both

A.（二つの論文の主な違い）

The first paper analyzes communication using data and machine learning.
It tries to understand how communication patterns relate to team performance.
The second paper focuses on designing a new tool to support richer communication.

A.（なぜこのセッションを選んだか）

Both papers study communication in online and interactive environments.
These environments are closely related to games and entertainment.
This fits well with my background in game AI research.

A.（強化学習の応用）

Reinforcement learning could observe how players communicate during games.
Based on this, AI systems could adjust support or game behavior.
This may encourage better teamwork and smoother cooperation.

A.（個人的な学び）

I learned that communication can be studied in different ways.
It can be analyzed using data, and it can also be improved through design.
Combining both approaches seems very important for future game AI.

A.（自分の研究との関係）

My research focuses on game AI and player experience.
I am especially interested in how AI can influence communication and emotions.
These two papers gave me useful ideas from both analysis and design perspectives.

A.（この発表の一番大きなメッセージ）

The main message is that communication is very important in online environments.
It affects both team performance and user experience.
Good communication can be analyzed and also improved through design.

A.（コミュニケーションを研究する重要性）

Communication strongly influences how people work and play together online.
Even small differences in communication can change outcomes.
Understanding communication helps us build better systems and experiences.

A.（二つの論文を一緒に紹介する意味）

The two papers look at communication from different sides.
One analyzes existing communication, and the other creates new ways to communicate.
Together, they give a more complete picture of online communication.

A.（ゲームをしない人との関係性）

Yes, because the ideas apply to many online environments.
Teamwork and communication are important in work, learning, and social platforms.
Games are just a clear and rich example of these interactions.

== First

A.（戦闘前コミュニケーションの重要性）

Communication before battles helps teams share plans and roles.
It allows players to prepare and understand each other better.
This often leads to better coordination during gameplay.

A.（過度に中央集権的なコミュニケーション）

It means that only a few players talk most of the time.
Other team members may speak less or not at all.
This can reduce teamwork and limit useful information sharing.

A.（World of Tanks が研究対象として適している理由）

The game has long-term teams called clans.
These teams communicate regularly and have clear performance measures.
This makes it easier to study the relationship between communication and skill.

A.（メッセージ数だけでは強さが分からない理由）

More messages do not always mean better communication.
Too much talking can be confusing or unnecessary.
Timing and structure of communication are more important.

A.（現実世界のチームへの適用可能性）

Yes, to some extent.
Many real-world teams also need balanced and inclusive communication.
However, game environments are simpler than real workplaces.

A.（第一論文の限界）

The study mainly uses text chat data.
It does not fully capture voice chat or player actions.
So, communication is only partially observed.

== Second

A.（AI研究かどうか）

The second paper is not directly about AI.
It mainly focuses on interaction and communication design.
However, its ideas are still useful for thinking about AI-supported communication.

A.（ThingMojiの利点）

ThingMoji is created by users using real-world objects.
This makes the expressions more personal and meaningful.
It allows people to communicate in a more creative way.

A.（ThingMojiの課題）

Creating ThingMojis takes time and effort.
Some users may not want to create them often.
Keeping long-term user interest is also a challenge.

A.（ゲームAI研究への応用）

ThingMoji ideas could inspire new communication support in games.
AI could suggest expressive tools based on game situations.
This may help players share emotions and intentions more easily.

A. （課題に対してどう対処する？）

I would use reinforcement learning to support communication adaptively,
by learning when and what kind of expressions should be suggested based on context.

A.（既存の絵文字が不十分な理由）

Standard emojis are fixed and shared by everyone.
They cannot always express personal or situational meaning.
ThingMoji allows users to express context more clearly.

A.（ThingMoji が特に役立つ場面）

It is useful in live communication, such as streaming or group chat.
It helps explain situations quickly and visually.
It can also create humor and shared experiences.

A.（初めて使う人にとっての難しさ）

Yes, it may feel difficult at first.
Creating ThingMojis takes some effort and learning.
This is one of the challenges discussed in the paper.

A.（ThingMoji が広く使われない可能性）

Users may prefer faster and simpler tools.
They may not want to spend time creating new expressions.
Ease of use is very important for adoption.

== Reflection

A.（二つの研究を組み合わせた場合の可能性）

We could analyze communication and then design tools based on the results.
For example, systems could support weak communication patterns.
This connects analysis with practical design.

A.（将来のゲームAIにおけるコミュニケーションの役割）

Communication will become an important part of player experience.
AI may help players communicate more smoothly and fairly.
This could improve both enjoyment and teamwork.

A. （一番覚えておいてほしいこと）

Communication is not just a side feature of online systems.
It strongly shapes performance and experience.
Studying and designing communication is a valuable research direction.

== Tough

A.（相関と因果の区別はできているのか）

The first paper mainly shows correlation, not clear causation.
Good communication may lead to strong teams, but strong teams may also communicate better.
The paper is careful about this limitation.

A.（機械学習を使う必要は本当にあったのか）

Simple statistics could explain some patterns.
However, machine learning helps handle many features at once.
It allows a more flexible analysis of communication patterns.

A.（Lasso回帰の選択は妥当だったのか）

Lasso is useful for feature selection.
It helps reduce overfitting and keeps the model simple.
For large-scale chat data, this is a reasonable choice.

A.（データにバイアスはなかったのか）

Yes, there may be bias in the data.
Only active players and text chat users are fully observed.
The results may not represent all players.

A.（ThingMojiは一時的な面白さで終わらないか）

That is a real risk.
Novelty may attract users at first, but interest can fade.
The paper also discusses long-term usability as a challenge.

A.（コミュニケーションを増やすことが逆効果になる可能性）

More communication is not always better.
Too much information can distract players.
This is why quality and timing are important.

A.（AIが感情やコミュニケーションを操作することへの倫理的問題）

Influencing communication can raise ethical concerns.
Players should know and control how AI supports them.
Transparency and user choice are important.

A.（実際のゲーム開発で使えるほど現実的なのか）

Real game development has many constraints.
Systems must be simple and low-cost to implement.
These ideas may need simplification for real products.

A.（実際のゲームへの導入の難しさ）

Game developers must consider cost and complexity.
New systems should not slow down gameplay.
Ease of integration is very important.