#import "report_format.typ": *
#import "@preview/numbly:0.1.0": numbly
#import "@preview/codelst:2.0.0": sourcecode

// #import "@preview/physica:0.9.2"
#show: master_thesis.with(
  title: "先進情報セキュリティとアルゴリズム",
  number: "1",
  author: "川口 達也",
  id: "2510414",
  university: "JAIST",
)

= 線形型システムの実装

ex1.linの実行結果

```rust
AST:
Ok(
    (
        "\n",
        QVal(
            QValExpr {
                qual: Lin,
                val: Fun(
                    FnExpr {
                        var: "x",
                        ty: TypeExpr {
                            qual: Lin,
                            prim: Bool,
                        },
                        expr: If(
                            IfExpr {
                                cond_expr: Var(
                                    "x",
                                ),
                                then_expr: QVal(
                                    QValExpr {
                                        qual: Lin,
                                        val: Bool(
                                            false,
                                        ),
                                    },
                                ),
                                else_expr: QVal(
                                    QValExpr {
                                        qual: Lin,
                                        val: Bool(
                                            true,
                                        ),
                                    },
                                ),
                            },
                        ),
                    },
                ),
            },
        ),
    ),
)

式:
lin fn x : lin bool {
    if x {
        lin false
    } else {
        lin true
    }
}

の型は
lin (lin bool -> lin bool)
です.
```
#pagebreak()

ex2.linの実行結果

```rust
AST:
Ok(
    (
        "\n",
        Let(
            LetExpr {
                var: "x",
                ty: TypeExpr {
                    qual: Un,
                    prim: Bool,
                },
                expr1: QVal(
                    QValExpr {
                        qual: Un,
                        val: Bool(
                            true,
                        ),
                    },
                ),
                expr2: If(
                    IfExpr {
                        cond_expr: Var(
                            "x",
                        ),
                        then_expr: QVal(
                            QValExpr {
                                qual: Un,
                                val: Bool(
                                    false,
                                ),
                            },
                        ),
                        else_expr: QVal(
                            QValExpr {
                                qual: Un,
                                val: Bool(
                                    true,
                                ),
                            },
                        ),
                    },
                ),
            },
        ),
    ),
)

式:
let x : un bool = un true;
if x {
    un false
} else {
    un true
}

の型は
un bool
です.
```
#pagebreak()

ex3.linの実行結果
```rust
AST:
Ok(
    (
        "\n",
        QVal(
            QValExpr {
                qual: Lin,
                val: Fun(
                    FnExpr {
                        var: "x",
                        ty: TypeExpr {
                            qual: Lin,
                            prim: Bool,
                        },
                        expr: Free(
                            FreeExpr {
                                var: "x",
                                expr: QVal(
                                    QValExpr {
                                        qual: Lin,
                                        val: Bool(
                                            false,
                                        ),
                                    },
                                ),
                            },
                        ),
                    },
                ),
            },
        ),
    ),
)

式:
lin fn x : lin bool {
    free x;
    lin false
}

の型は
lin (lin bool -> lin bool)
です.
```
#pagebreak()

ex4.linの実行結果
```rust
AST:
Ok(
    (
        "\n",
        Split(
            SplitExpr {
                expr: QVal(
                    QValExpr {
                        qual: Lin,
                        val: Pair(
                            QVal(
                                QValExpr {
                                    qual: Lin,
                                    val: Bool(
                                        true,
                                    ),
                                },
                            ),
                            QVal(
                                QValExpr {
                                    qual: Lin,
                                    val: Bool(
                                        false,
                                    ),
                                },
                            ),
                        ),
                    },
                ),
                left: "x",
                right: "y",
                body: Free(
                    FreeExpr {
                        var: "x",
                        expr: Free(
                            FreeExpr {
                                var: "y",
                                expr: QVal(
                                    QValExpr {
                                        qual: Un,
                                        val: Bool(
                                            true,
                                        ),
                                    },
                                ),
                            },
                        ),
                    },
                ),
            },
        ),
    ),
)

式:
split lin <lin true, lin false> as x, y {
    free x;
    free y;
    un true
}

の型は
un bool
です.
```
#pagebreak()

ex5.linの実行結果
```rust
AST:
Ok(
    (
        "\n",
        App(
            AppExpr {
                expr1: QVal(
                    QValExpr {
                        qual: Lin,
                        val: Fun(
                            FnExpr {
                                var: "x",
                                ty: TypeExpr {
                                    qual: Lin,
                                    prim: Bool,
                                },
                                expr: If(
                                    IfExpr {
                                        cond_expr: Var(
                                            "x",
                                        ),
                                        then_expr: QVal(
                                            QValExpr {
                                                qual: Un,
                                                val: Pair(
                                                    QVal(
                                                        QValExpr {
                                                            qual: Un,
                                                            val: Bool(
                                                                true,
                                                            ),
                                                        },
                                                    ),
                                                    QVal(
                                                        QValExpr {
                                                            qual: Un,
                                                            val: Bool(
                                                                false,
                                                            ),
                                                        },
                                                    ),
                                                ),
                                            },
                                        ),
                                        else_expr: QVal(
                                            QValExpr {
                                                qual: Un,
                                                val: Pair(
                                                    QVal(
                                                        QValExpr {
                                                            qual: Un,
                                                            val: Bool(
                                                                false,
                                                            ),
                                                        },
                                                    ),
                                                    QVal(
                                                        QValExpr {
                                                            qual: Un,
                                                            val: Bool(
                                                                true,
                                                            ),
                                                        },
                                                    ),
                                                ),
                                            },
                                        ),
                                    },
                                ),
                            },
                        ),
                    },
                ),
                expr2: QVal(
                    QValExpr {
                        qual: Lin,
                        val: Bool(
                            true,
                        ),
                    },
                ),
            },
        ),
    ),
)

式:
(lin fn x : lin bool {
    if x {
        un <un true, un false>
    } else {
        un <un false, un true>
    }
} lin true)

の型は
un (un bool * un bool)
です.
```
#pagebreak()

ex6.linの実行結果
```rust
AST:
Ok(
    (
        "\n",
        QVal(
            QValExpr {
                qual: Un,
                val: Pair(
                    QVal(
                        QValExpr {
                            qual: Un,
                            val: Bool(
                                true,
                            ),
                        },
                    ),
                    QVal(
                        QValExpr {
                            qual: Un,
                            val: Bool(
                                false,
                            ),
                        },
                    ),
                ),
            },
        ),
    ),
)

式:
un <un true, un false>

の型は
un (un bool * un bool)
です.
```
#pagebreak()

ex7.linの実行結果
```rust
AST:
Ok(
    (
        "\n",
        QVal(
            QValExpr {
                qual: Lin,
                val: Fun(
                    FnExpr {
                        var: "x",
                        ty: TypeExpr {
                            qual: Lin,
                            prim: Pair(
                                TypeExpr {
                                    qual: Lin,
                                    prim: Bool,
                                },
                                TypeExpr {
                                    qual: Lin,
                                    prim: Bool,
                                },
                            ),
                        },
                        expr: Split(
                            SplitExpr {
                                expr: Var(
                                    "x",
                                ),
                                left: "a",
                                right: "b",
                                body: If(
                                    IfExpr {
                                        cond_expr: Var(
                                            "a",
                                        ),
                                        then_expr: Var(
                                            "b",
                                        ),
                                        else_expr: Var(
                                            "b",
                                        ),
                                    },
                                ),
                            },
                        ),
                    },
                ),
            },
        ),
    ),
)

式:
lin fn x : lin (lin bool * lin bool) {
    split x as a, b {
        if a {
            b
        } else {
            b
        }
    }
}

の型は
lin (lin (lin bool * lin bool) -> lin bool)
です.
```
#pagebreak()

ex8.linの実行結果
```rust
AST:
Ok(
    (
        "\n",
        Let(
            LetExpr {
                var: "x",
                ty: TypeExpr {
                    qual: Lin,
                    prim: Bool,
                },
                expr1: QVal(
                    QValExpr {
                        qual: Lin,
                        val: Bool(
                            true,
                        ),
                    },
                ),
                expr2: Let(
                    LetExpr {
                        var: "y",
                        ty: TypeExpr {
                            qual: Lin,
                            prim: Bool,
                        },
                        expr1: QVal(
                            QValExpr {
                                qual: Lin,
                                val: Bool(
                                    false,
                                ),
                            },
                        ),
                        expr2: QVal(
                            QValExpr {
                                qual: Lin,
                                val: Pair(
                                    Var(
                                        "x",
                                    ),
                                    Var(
                                        "y",
                                    ),
                                ),
                            },
                        ),
                    },
                ),
            },
        ),
    ),
)

式:
let x : lin bool = lin true;
let y : lin bool = lin false;
lin <x, y>

の型は
lin (lin bool * lin bool)
です.
```
#pagebreak()

err1.linの実行結果
```rust
AST:
Ok(
    (
        "\n",
        QVal(
            QValExpr {
                qual: Un,
                val: Pair(
                    QVal(
                        QValExpr {
                            qual: Lin,
                            val: Bool(
                                true,
                            ),
                        },
                    ),
                    QVal(
                        QValExpr {
                            qual: Lin,
                            val: Bool(
                                false,
                            ),
                        },
                    ),
                ),
            },
        ),
    ),
)

式:
un <lin true, lin false>

型付けエラー: un型のペア内でlin型を利用している
Error: Typing
```
#pagebreak()

err2.linの実行結果
```rust
AST:
Ok(
    (
        "\n",
        QVal(
            QValExpr {
                qual: Lin,
                val: Fun(
                    FnExpr {
                        var: "x",
                        ty: TypeExpr {
                            qual: Lin,
                            prim: Bool,
                        },
                        expr: Free(
                            FreeExpr {
                                var: "x",
                                expr: Var(
                                    "x",
                                ),
                            },
                        ),
                    },
                ),
            },
        ),
    ),
)

式:
lin fn x : lin bool {
    free x;
    x
}

型付けエラー: "x"という変数は定義されていないか, 利用済みか, キャプチャできない
Error: Typing
```
#pagebreak()

err3.linの実行結果
```rust
AST:
Ok(
    (
        "\n",
        QVal(
            QValExpr {
                qual: Lin,
                val: Fun(
                    FnExpr {
                        var: "x",
                        ty: TypeExpr {
                            qual: Lin,
                            prim: Bool,
                        },
                        expr: Free(
                            FreeExpr {
                                var: "x",
                                expr: Free(
                                    FreeExpr {
                                        var: "x",
                                        expr: QVal(
                                            QValExpr {
                                                qual: Lin,
                                                val: Bool(
                                                    true,
                                                ),
                                            },
                                        ),
                                    },
                                ),
                            },
                        ),
                    },
                ),
            },
        ),
    ),
)

式:
lin fn x : lin bool {
    free x;
    free x;
    lin true
}

型付けエラー: freeで指定された変数はすでに利用済み
Error: Typing
```
#pagebreak()

err4.linの実行結果
```rust
AST:
Ok(
    (
        "\n",
        Split(
            SplitExpr {
                expr: QVal(
                    QValExpr {
                        qual: Lin,
                        val: Pair(
                            QVal(
                                QValExpr {
                                    qual: Lin,
                                    val: Bool(
                                        true,
                                    ),
                                },
                            ),
                            QVal(
                                QValExpr {
                                    qual: Lin,
                                    val: Bool(
                                        false,
                                    ),
                                },
                            ),
                        ),
                    },
                ),
                left: "x",
                right: "y",
                body: Var(
                    "x",
                ),
            },
        ),
    ),
)

式:
split lin <lin true, lin false> as x, y {
    x
}

型付けエラー: split内でlin型の変数 "y" が消費されていない
Error: Typing
```
#pagebreak()

err5.linの実行結果
```rust
AST:
Ok(
    (
        "\n",
        QVal(
            QValExpr {
                qual: Lin,
                val: Fun(
                    FnExpr {
                        var: "x",
                        ty: TypeExpr {
                            qual: Lin,
                            prim: Pair(
                                TypeExpr {
                                    qual: Lin,
                                    prim: Bool,
                                },
                                TypeExpr {
                                    qual: Lin,
                                    prim: Bool,
                                },
                            ),
                        },
                        expr: Split(
                            SplitExpr {
                                expr: Var(
                                    "x",
                                ),
                                left: "a",
                                right: "b",
                                body: If(
                                    IfExpr {
                                        cond_expr: Var(
                                            "a",
                                        ),
                                        then_expr: Var(
                                            "b",
                                        ),
                                        else_expr: QVal(
                                            QValExpr {
                                                qual: Lin,
                                                val: Bool(
                                                    true,
                                                ),
                                            },
                                        ),
                                    },
                                ),
                            },
                        ),
                    },
                ),
            },
        ),
    ),
)

式:
lin fn x : lin (lin bool * lin bool) {
    split x as a, b {
        if a {
            b
        } else {
            lin true
        }
    }
}

型付けエラー: ifのthenとelseの式の型が異なる
Error: Typing
```
#pagebreak()
err6.linの実行結果
```rust
AST:
Ok(
    (
        "\n",
        QVal(
            QValExpr {
                qual: Un,
                val: Fun(
                    FnExpr {
                        var: "x",
                        ty: TypeExpr {
                            qual: Lin,
                            prim: Bool,
                        },
                        expr: QVal(
                            QValExpr {
                                qual: Un,
                                val: Fun(
                                    FnExpr {
                                        var: "y",
                                        ty: TypeExpr {
                                            qual: Un,
                                            prim: Bool,
                                        },
                                        expr: QVal(
                                            QValExpr {
                                                qual: Lin,
                                                val: Fun(
                                                    FnExpr {
                                                        var: "z",
                                                        ty: TypeExpr {
                                                            qual: Un,
                                                            prim: Bool,
                                                        },
                                                        expr: QVal(
                                                            QValExpr {
                                                                qual: Lin,
                                                                val: Pair(
                                                                    Var(
                                                                        "x",
                                                                    ),
                                                                    Var(
                                                                        "y",
                                                                    ),
                                                                ),
                                                            },
                                                        ),
                                                    },
                                                ),
                                            },
                                        ),
                                    },
                                ),
                            },
                        ),
                    },
                ),
            },
        ),
    ),
)

式:
un fn x : lin bool {
    un fn y : un bool {
        lin fn z : un bool {
            lin <x, y>
        }
    }
}

型付けエラー: "x"という変数は定義されていないか, 利用済みか, キャプチャできない
Error: Typing
```
#pagebreak()
err7.linの実行結果
```rust
AST:
Ok(
    (
        "\n",
        Let(
            LetExpr {
                var: "x",
                ty: TypeExpr {
                    qual: Lin,
                    prim: Bool,
                },
                expr1: QVal(
                    QValExpr {
                        qual: Lin,
                        val: Bool(
                            true,
                        ),
                    },
                ),
                expr2: QVal(
                    QValExpr {
                        qual: Un,
                        val: Bool(
                            false,
                        ),
                    },
                ),
            },
        ),
    ),
)

式:
let x : lin bool = lin true;
un false

型付けエラー: let内でlin型の変数 "x" を消費していない
Error: Typing
```
#pagebreak()

parse_err.linの実行結果
```rust
AST:
Err(
    Error(
        VerboseError {
            errors: [
                (
                    "x {\n        lin false\n    } else {\n        lin true\n    }\n}\n",
                    Char(
                        '}',
                    ),
                ),
            ],
        },
    ),
)

パースエラー:
0: at line 2:
    iff x {
        ^
expected '}', found x


Error: Parse
```
#pagebreak()

parse_err2.linの実行結果
```rust
AST:
Err(
    Error(
        VerboseError {
            errors: [
                (
                    "ln bool {\n    x\n}",
                    Nom(
                        Tag,
                    ),
                ),
                (
                    "ln bool {\n    x\n}",
                    Nom(
                        Alt,
                    ),
                ),
            ],
        },
    ),
)

パースエラー:
0: at line 1, in Tag:
lin fn x : ln bool {
           ^

1: at line 1, in Alt:
lin fn x : ln bool {
           ^


Error: Parse
```
#pagebreak()

= アフィン型を追加せよ

typing.rs内で変更した部分について解説します.

TypeEnvにaffを追加します.
```rust
pub struct TypeEnv {
    env_lin: TypeEnvStack, // lin用
    env_aff: TypeEnvStack, // aff用   ← 追加
    env_un: TypeEnvStack,  // un用
}
```

TypeEnv::newにenv_affを追加します.
```rust
pub fn new() -> TypeEnv {
    TypeEnv {
        env_lin: TypeEnvStack::new(),
        env_aff: TypeEnvStack::new(), // 追加
        env_un: TypeEnvStack::new(),
    }
}
```

insertのところにaffを追加します.
```rust
fn insert(&mut self, key: String, value: parser::TypeExpr) {
    if value.qual == parser::Qual::Lin {
        self.env_lin.insert(key, value);
    } else if value.qual == parser::Qual::Aff {        // ← 追加
        self.env_aff.insert(key, value);
    } else {
        self.env_un.insert(key, value);
    }
}
```

get_mutにaffを追加します.これで, 変数参照時に3つのうち一番深いスコープを取れます.
```rust
fn get_mut(&mut self, key: &str) -> Option<&mut Option<parser::TypeExpr>> {
    let lin  = self.env_lin.get_mut(key);
    let aff  = self.env_aff.get_mut(key);  // ← 追加
    let un   = self.env_un.get_mut(key);
```

候補にaffを追加して, depthで最大を選ぶようにします.
```rust
if let Some((d, t)) = aff {
    candidates.push((d as isize, t)); // ← 追加
}
```

parse_qualにaffを追加します.
```rust
let (i, val) = alt((tag("lin"), tag("aff"), tag("un")))(i)?;
match val {
    "lin" => Ok((i, Qual::Lin)),
    "aff" => Ok((i, Qual::Aff)),  // ← 追加
    _     => Ok((i, Qual::Un)),
}
```
#pagebreak()

aff_ex1.linはxを全く使わない例です.

```rust
aff fn x : aff bool {
    aff true
}
```
結果は以下の通りです.
```rust
AST:
Ok(
    (
        "\n",
        QVal(
            QValExpr {
                qual: Aff,
                val: Fun(
                    FnExpr {
                        var: "x",
                        ty: TypeExpr {
                            qual: Aff,
                            prim: Bool,
                        },
                        expr: QVal(
                            QValExpr {
                                qual: Aff,
                                val: Bool(
                                    true,
                                ),
                            },
                        ),
                    },
                ),
            },
        ),
    ),
)

式:
aff fn x : aff bool {
    aff true
}

の型は
aff (aff bool -> aff bool)
です.
```
#pagebreak()

aff_ex2.linはxを1回まで使う例です.
```rust
aff fn x : aff bool {
    if x {
        aff false
    } else {
        aff true
    }
}
```
結果は以下の通りです.
```rust
AST:
Ok(
    (
        "\n",
        QVal(
            QValExpr {
                qual: Aff,
                val: Fun(
                    FnExpr {
                        var: "x",
                        ty: TypeExpr {
                            qual: Aff,
                            prim: Bool,
                        },
                        expr: If(
                            IfExpr {
                                cond_expr: Var(
                                    "x",
                                ),
                                then_expr: QVal(
                                    QValExpr {
                                        qual: Aff,
                                        val: Bool(
                                            false,
                                        ),
                                    },
                                ),
                                else_expr: QVal(
                                    QValExpr {
                                        qual: Aff,
                                        val: Bool(
                                            true,
                                        ),
                                    },
                                ),
                            },
                        ),
                    },
                ),
            },
        ),
    ),
)

式:
aff fn x : aff bool {
    if x {
        aff false
    } else {
        aff true
    }
}

の型は
aff (aff bool -> aff bool)
です.
```
#pagebreak()

aff_err1.linは, xの値を2回使ったらエラーになるようにしています.

```rust
aff fn x : aff bool {
    if x {
        x
    } else {
        aff false
    }
}
```

結果は以下の通りです.
```rust
AST:
Ok(
    (
        "\n",
        QVal(
            QValExpr {
                qual: Aff,
                val: Fun(
                    FnExpr {
                        var: "x",
                        ty: TypeExpr {
                            qual: Aff,
                            prim: Bool,
                        },
                        expr: If(
                            IfExpr {
                                cond_expr: Var(
                                    "x",
                                ),
                                then_expr: Var(
                                    "x",
                                ),
                                else_expr: QVal(
                                    QValExpr {
                                        qual: Aff,
                                        val: Bool(
                                            false,
                                        ),
                                    },
                                ),
                            },
                        ),
                    },
                ),
            },
        ),
    ),
)

式:
aff fn x : aff bool {
    if x {
        x
    } else {
        aff false
    }
}

の型は
aff (aff bool -> aff bool)
です.
```
#pagebreak()

aff_free1.linでは, xを解放します.
```rust
aff fn x : aff bool {
    free x;
    aff true
}
```
結果は以下の通りです.
```rust
AST:
Ok(
    (
        "\n",
        QVal(
            QValExpr {
                qual: Aff,
                val: Fun(
                    FnExpr {
                        var: "x",
                        ty: TypeExpr {
                            qual: Aff,
                            prim: Bool,
                        },
                        expr: Free(
                            FreeExpr {
                                var: "x",
                                expr: QVal(
                                    QValExpr {
                                        qual: Aff,
                                        val: Bool(
                                            true,
                                        ),
                                    },
                                ),
                            },
                        ),
                    },
                ),
            },
        ),
    ),
)

式:
aff fn x : aff bool {
    free x;
    aff true
}

型付けエラー: freeで指定された変数がlin型ではない
Error: Typing
```
#pagebreak()

aff_err2.linは, 解放したあとに使うことでエラーになります.
```rust
aff fn x : aff bool {
    free x;
    x
}
```
結果は以下の通りです.
```rust
AST:
Ok(
    (
        "\n",
        QVal(
            QValExpr {
                qual: Aff,
                val: Fun(
                    FnExpr {
                        var: "x",
                        ty: TypeExpr {
                            qual: Aff,
                            prim: Bool,
                        },
                        expr: Free(
                            FreeExpr {
                                var: "x",
                                expr: Var(
                                    "x",
                                ),
                            },
                        ),
                    },
                ),
            },
        ),
    ),
)

式:
aff fn x : aff bool {
    free x;
    x
}

型付けエラー: freeで指定された変数がlin型ではない
Error: Typing
```
#pagebreak()

aff_pair_ok.linはpairの中でaffを1回ずつ消費する例です.
```rust
aff fn p : aff (aff bool * aff bool) {
    split p as a, b {
        if a {
            b
        } else {
            aff false
        }
    }
}
```
結果は以下の通りです.
```rust
AST:
Ok(
    (
        "\n",
        QVal(
            QValExpr {
                qual: Aff,
                val: Fun(
                    FnExpr {
                        var: "p",
                        ty: TypeExpr {
                            qual: Aff,
                            prim: Pair(
                                TypeExpr {
                                    qual: Aff,
                                    prim: Bool,
                                },
                                TypeExpr {
                                    qual: Aff,
                                    prim: Bool,
                                },
                            ),
                        },
                        expr: Split(
                            SplitExpr {
                                expr: Var(
                                    "p",
                                ),
                                left: "a",
                                right: "b",
                                body: If(
                                    IfExpr {
                                        cond_expr: Var(
                                            "a",
                                        ),
                                        then_expr: Var(
                                            "b",
                                        ),
                                        else_expr: QVal(
                                            QValExpr {
                                                qual: Aff,
                                                val: Bool(
                                                    false,
                                                ),
                                            },
                                        ),
                                    },
                                ),
                            },
                        ),
                    },
                ),
            },
        ),
    ),
)

式:
aff fn p : aff (aff bool * aff bool) {
    split p as a, b {
        if a {
            b
        } else {
            aff false
        }
    }
}

の型は
aff (aff (aff bool * aff bool) -> aff bool)
です.
```
#pagebreak()

aff_pair_err.linはsplitの後にbを使わない例です.
```rust
aff fn p : aff (aff bool * aff bool) {
    split p as a, b {
        a
    }
}
```
結果は以下の通りです.
```rust
AST:
Ok(
    (
        "\n",
        QVal(
            QValExpr {
                qual: Aff,
                val: Fun(
                    FnExpr {
                        var: "p",
                        ty: TypeExpr {
                            qual: Aff,
                            prim: Pair(
                                TypeExpr {
                                    qual: Aff,
                                    prim: Bool,
                                },
                                TypeExpr {
                                    qual: Aff,
                                    prim: Bool,
                                },
                            ),
                        },
                        expr: Split(
                            SplitExpr {
                                expr: Var(
                                    "p",
                                ),
                                left: "a",
                                right: "b",
                                body: Var(
                                    "a",
                                ),
                            },
                        ),
                    },
                ),
            },
        ),
    ),
)

式:
aff fn p : aff (aff bool * aff bool) {
    split p as a, b {
        a
    }
}

の型は
aff (aff (aff bool * aff bool) -> aff bool)
です.
```
#pagebreak()

aff_un_fn_capture.linはun関数が外のaffをキャプチャする例です.
```rust
aff fn x : aff bool {
    un fn y : un bool {
        x
    }
}
```
結果は以下の通りです.
```rust
AST:
Ok(
    (
        "\n",
        QVal(
            QValExpr {
                qual: Aff,
                val: Fun(
                    FnExpr {
                        var: "x",
                        ty: TypeExpr {
                            qual: Aff,
                            prim: Bool,
                        },
                        expr: QVal(
                            QValExpr {
                                qual: Un,
                                val: Fun(
                                    FnExpr {
                                        var: "y",
                                        ty: TypeExpr {
                                            qual: Un,
                                            prim: Bool,
                                        },
                                        expr: Var(
                                            "x",
                                        ),
                                    },
                                ),
                            },
                        ),
                    },
                ),
            },
        ),
    ),
)

式:
aff fn x : aff bool {
    un fn y : un bool {
        x
    }
}

の型は
aff (aff bool -> un (un bool -> aff bool))
です.
```
#pagebreak()

aff_un_fn_capture_err.linは, un関数内のfnで2回キャプチャしてエラーになる例です.
```rust
aff fn x : aff bool {
    un fn y : un bool {
        if x {
            x
        } else {
            un true
        }
    }
}
```
結果は以下の通りです.
```rust
AST:
Ok(
    (
        "\n",
        QVal(
            QValExpr {
                qual: Aff,
                val: Fun(
                    FnExpr {
                        var: "x",
                        ty: TypeExpr {
                            qual: Aff,
                            prim: Bool,
                        },
                        expr: QVal(
                            QValExpr {
                                qual: Un,
                                val: Fun(
                                    FnExpr {
                                        var: "y",
                                        ty: TypeExpr {
                                            qual: Un,
                                            prim: Bool,
                                        },
                                        expr: If(
                                            IfExpr {
                                                cond_expr: Var(
                                                    "x",
                                                ),
                                                then_expr: Var(
                                                    "x",
                                                ),
                                                else_expr: QVal(
                                                    QValExpr {
                                                        qual: Un,
                                                        val: Bool(
                                                            true,
                                                        ),
                                                    },
                                                ),
                                            },
                                        ),
                                    },
                                ),
                            },
                        ),
                    },
                ),
            },
        ),
    ),
)

式:
aff fn x : aff bool {
    un fn y : un bool {
        if x {
            x
        } else {
            un true
        }
    }
}

型付けエラー: ifのthenとelseの式の型が異なる
Error: Typing
```