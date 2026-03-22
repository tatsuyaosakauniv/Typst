#import "report_format.typ": *
#import "@preview/numbly:0.1.0": numbly
#import "@preview/codelst:2.0.0": sourcecode

// #import "@preview/physica:0.9.2"
#show: master_thesis.with(
  title: "Machine Learning",
  subtitle: "Homework 1",
  author: "Tatsuya Kawaguchi",
  id: "2510414",
  university: "JAIST",
  bibliography-file: "",
)

#text(weight: "bold", size: 16pt)[Exercize]

= Classify 100 manga characters into 10 groups based on their similarity.

A. Unsupervised lerning.

There are no labels in this problem.
So, this task falls under unsupervised learning, specifically clustering.

\

= Observe 10 apple pictures and 10 banana pictures, and then answer which fruit it is given a new photo.

A. Supervised learning.

In this problem, the labels "apple" and "banana" are provided.
Therefore, this is a supervised learning problem, specifically image classification.

\

= Learn a rule how many coins can be put in a plastic bottle so as not to sink in water.

A. Supervised learning.

Here, the task is to predict how many coins can be added to the bottle without making it sink.
This is a supervised learning problem, specifically regression.

#pagebreak()

#text(weight: "bold", size: 16pt)[Exercize for Version Space]

(1)  Describe version space for ID 1 in the table.

#h(1.2em)
For P1(ID1):

$
  "P1" = {"shape"(U, "triangle"), "color"(U, "white"), "size"(U, "large")}
$
#h(1.2em)
Using the bit-string representation (constant = 1, variable = 0):

#h(1.2em)
P1 bit stream = \<1, 1, 1>

\
(2) Represent bit streams for ID 2-5 respectively.
$
  "P2" &= {"Square", "Blue", "Large"} &= <1, 1, 1>\
  "P3" &= {"Circle", "Yellow", "Middle"} &= <1, 1, 1>\
  "P4" &= {"Any", "White", "Large"} &= <0, 1, 1>\
  "P5" &= {"Triangle", "White", "Any"} &= <1, 1, 0>
$
(3) Show the results of the concept learning for ID 1-5 in table using version space.

When applying the version space procedure:

$
  "P1" &= "positive"\
  "P2" &= "positive"\
  "P3" &= "negative"\
  "P4" &= "positive"\
  "P5" &= "negative"\
$

The negative instance P3 removes all possible hypotheses.
Therefore, the version space becomes empty.