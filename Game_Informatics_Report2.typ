#import "report_format.typ": *
#import "@preview/numbly:0.1.0": numbly
#import "@preview/codelst:2.0.0": sourcecode

// #import "@preview/physica:0.9.2"
#show: master_thesis.with(
  title: "Game Informatics",
  subtitle: "Report 2",
  author: "Tatsuya Kawaguchi",
  id: "2510414",
  university: "JAIST",
  bibliography-file: "bib\Game_Informatics_Report1.bib",
)

英語が苦手なのでchatGPTに訳してもらいました。

= Empirical Validity of the GR Range

Many popular sports and games that have attracted people for a long time were analyzed using the Game Refinement measure, and it was empirically observed that their GR values tend to concentrate around 0.07–0.08.
These results are based on statistical analyses of existing, widely accepted games and sports, as presented in the lecture materials, suggesting that this range corresponds to games perceived as well-balanced and refined by humans.

= Theoretical Limits of GR from Human Constraints

The GR value is approximately defined as $G R = sqrt(B)/D$, where $B$is the branching factor and $D$ is the game length.
Although GR can theoretically increase by making $B$ extremely large or $D$ extremely small, such games are unlikely to be perceived as enjoyable by humans.
An excessively large branching factor increases cognitive load, while an extremely short game length undermines fairness and meaningful decision-making.
Therefore, human cognitive and temporal constraints implicitly impose practical upper bounds on $B$ and lower bounds on $D$, causing GR values to naturally concentrate within a limited range such as 0.07–0.08.