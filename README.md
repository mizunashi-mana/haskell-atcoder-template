# 個人用 AtCoder テンプレ

AtCoder の新環境用のテンプレです

**まだ現環境では使うことができないです**

## 使い方

1.  テンプレからプロジェクト作る

```bash
git clone https://github.com/mizunashi-mana/haskell-atcoder-template.git "$(date "+atcoder-%Y%m%d")"
cd "$(date "+atcoder-%Y%m%d")"
git remote rm origin
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

基本的には， [MIT ライセンス](https://github.com/mizunashi-mana/haskell-atcoder-template/blob/master/MIT-LICENSE.txt) です．

ただし，以下の条件に該当する場合は，特例により [CC0 ライセンス](https://github.com/mizunashi-mana/haskell-atcoder-template/blob/master/CC0-LICENSE.txt) を選ぶことができます:

* AtCoder その他の競技プログラミング目的で運用されるサイトにプログラムを提出する際，本プログラムの一部または全部を切り出し，複製または改変，統合して使用する場合
* Writeup など競技プログラミング目的で書かれたプログラムについての文献を書く際，本プログラムの一部または全部を切り出し，複製または改変，統合して使用する場合

[MIT ライセンス](https://github.com/mizunashi-mana/haskell-atcoder-template/blob/master/MIT-LICENSE.txt) を選ぶ場合は，以下の一行を追記するだけで著作権表記を行ったと認定されます:

```haskell
-- Released under https://github.com/mizunashi-mana/haskell-atcoder-template/blob/master/MIT-LICENSE.txt 
```

なお，テンプレには既に著作権表記が含まれているので，そのまま使う場合は特別な操作は必要ありません． [CC0 ライセンス](https://github.com/mizunashi-mana/haskell-atcoder-template/blob/master/CC0-LICENSE.txt) を選んだ場合は，特別な表記は必要ありません．

### ライセンス選択の意義

ここでは，著作者のライセンス選択の意図について記載しています．ただし，免責事項として，ライセンスの条文は上記の条文が全てであり，ここで記載された内容がライセンスの条文にいかなる影響も与えないことは明記しておきます．

競技プログラミング目的であなたがこのプロジェクトのコードを一部流用する場合，あなたは自動的に CC0 ライセンスによって流用を行う権利を得ます．これは，あなたが意識してライセンス選択を行わなかったり，このライセンスに関する注意事項をよく読まないで競技プログラミングのサイトに流用したプログラムを提出してしまっても，特に問題は起きず，また著者に対するなんの背徳的な行為も行っていないことを意味します．

もし，あなたが競技プログラミング目的でない，または一時的な提出ではなく恒久的な流用を目的としているならば，MIT ライセンスに従ってください．MIT ライセンスは，著作権の放棄に関する法的な問題と無縁であり，著作者がライセンスに関する責任を負うことを明記するために，著作権表示を利用しています．よって，MIT ライセンスを利用する場合，著作物の著者を尊重しないような許諾表示でも，許諾文及びその文に責任を持つ人物が誰かが，派生物の利用者から分かる形であれば問題ありません．

また，CC0 ライセンス，MIT ライセンス共に，提供する著作物の信頼性については，一切著作者の保証がないことを謳っていることに注意してください．これは，著作者が意図的にそのようなライセンスを選んでおり，あなたがこの著作物を利用したことによって被るいかなる被害に対しても，著作者は一切関与しないことを意味します．

### 外部文献への参照

もし，各ライセンスについての詳細が知りたい場合は，以下の文献を参照してください:

* MIT ライセンスについて: https://writing.kemitchell.com/2016/09/21/MIT-License-Line-by-Line.html
* CC0 ライセンスについて: https://creativecommons.org/publicdomain/zero/1.0/deed.ja
