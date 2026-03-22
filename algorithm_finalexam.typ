#import "report_format.typ": *
#import "@preview/numbly:0.1.0": numbly
#import "@preview/codelst:2.0.0": sourcecode

// #import "@preview/physica:0.9.2"
#show: master_thesis.with(
  title: "アルゴリズムとデータ構造",
  subtitle: "期末テスト問題",
  author: "川口 達也",
  id: "2510414",
  university: "JAIST",
  bibliography-file: "",
)

= 課題から出題

= Question 2 (20pt)

You are given an unsorted array of $n$ distinct integers , along with $m$ queries. \
Each query is an integer that you have to search in the array, reporting "found" or "not found". \
Queries have to be processed in the order they are given.

\

(a) (10pt) Assuming that $m = floor(sqrt(n))$, would you answer each query via a linear search of the unsorted array, 
or would you rather preliminarily sort the array to speed up your searches? Briefly justify your answer.

\

(b) (10pt) What if $m = floor(sqrt(log n))$ instead? Briefly justify your answer.

#pagebreak()

= Question 3 (20pt)

(a) (10pt) You are given a directed graph $G(V, E)$ represented as an adjacency list and two vertices $s, t in V$. \
Describe an efficient algorithm that checks if is there is a directed path from $s$ to $t$ in $G$. \
Prove the correctness and analyze the running time of your algorithm.

\

(b) (10pt) You are given a directed graph $G(V, E)$ represented as an adjacency list and two sets of vertices $A, B subset V$ \
such that $A inter B = emptyset$. Describe an algorithm with a running time of $O(|V| + |E|)$ that checks if there exists a vertex $a in A$, \
and a vertex $b in B$ such that there is a directed path from $a$ to $b$ in $G$. \
Prove the correctness and analyze the running time of your algorithm.

#pagebreak()

= Question 4 (20pt)

A _contiguous subsequence_ of a sequence $S$ is a subsequence made up of consecutive elements of $S$. \
For instance, if $S$ is $(5, 15, -30, 10, -5, 40, 10)$, then $(15, -30, 10)$ is a contiguous subsequence but (5, 15, 40) is not. \
Give a linear-time algorithm for the following problem:

\

*Input: * a sequence of (positive and negative) integers, $a_1, a_2, ..., a_n$ \
*Output: * the maximum sum of a contiguous subsequence (a subsequence of length zero has sum zero).

\

For the preceding example, the answer would be $10 - 5 +40 + 10 = 55$. \
Prove the correctness of your algorithm and analyze its running time, showing that it is $O(n)$. \
(Hint: use dynamic programming. For each $1 <= j <= n$, consider contiguous subsequences ending exactly at position $j$.)