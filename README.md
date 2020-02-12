# 個人用 AtCoder テンプレ

AtCoder の新環境用のテンプレです

**まだ現環境では使うことができないです**

## 使い方

1.  テンプレからプロジェクト作る

    ```bash
    git clone https://github.com/mizunashi-mana/haskell-atcoder-template.git
    cp -r haskell-atcoder-template "$(date "+atcoder-%Y%m%d")"
    cd "$(date "+atcoder-%Y%m%d")"
    git init .
    ```

2.  問題用の `main` 作る

    ```bash
    cp problem/{Template,P01}.hs
    ```

    ```bash
    $ cat >> atcoder-template.cabal

    executable p01
      import:
        problem,
      main-is:
        problem/P01.hs
    ```

    ```bash
    editor problem/P01.hs
    ```

3.  (お好みで) デバッグする

    ```bash
    $ cabal repl exe:p01
    >>> solve 10
    10
    >>> :i solve
    solve :: Int -> Int     -- Defined at problem/P01.hs:14:1
    >>> :r
    >>> solve 10
    10
    ```

4.  (お好みで) テスト書く

    ```bash
    $ editor atcoder-template.cabal
       x-doctest-components:
    -    exe:template
    +    exe:p01
    ```

    ```bash
    cabal test
    ```

5.  ビルドして実行確認する

    ```bash
    $ cabal build exe:p01 && cabal exec p01
    10
    10
    ```

6.  提出用のコードコピる

    ```bash
    ./script/extract problem/P01.hs | pbcopy
    ```

7.  Submit する (適当にペーストしてくれ)
8.  (WA くらって，3 に戻るの無限ループ)

    万が一 AC したら，2 に戻って次の問題へ

## ライセンス

MIT ライセンスです． [LICENSE](LICENSE) を見てくれ．
