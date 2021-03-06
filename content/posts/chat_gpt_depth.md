---
title: "ChatGPTにステレオ画像からDepth推定するコードを書いてもらう"
date: 2023-03-19T11:46:03Z
tags: [Python, CV, AI]
---


## 背景

どうやらChatGPTが凄いという話をよく聞くので、自分でも凄さを体験してみた。


## やったこと

無料版のChatGPT (GPT3.5) を利用して、OpenCVを使ったステレオ画像からのDepth推定を行ってもらった。データセットは、`UTIAS long-term localization and mapping dataset` の `C00005`を利用させて頂く。

いきなりダイレクトに聞いてみた。

![step1](/20230319/step1.png)

凄い！！ 一発でそれっぽいコードが生成された。

でも、これはそのまま実行できない。なぜなら、ステレオカメラの内部・外部パラメータのキャリブレーションファイル `calibration_file.yaml` が存在しておらず、テキスト形式で与えられた内部パラメータと外部パラメータ(基線長)しかないから。

そこで、その点を指摘しつつ、テキスト形式のままパラメータを与えてみた。

![step2](/20230319/step2.png)

パラメータの意味を理解して、コードを修正してくれた。これでDepth画像は正しく作れるようになった。

ただ、Depth画像が不可視だったので、その点を指摘した。 (自分の指示が間違っていますね。16bit pngが人間の目で見えないだけで、オーバフローは起こしていませんでした。)

![step3](/20230319/step3.png)

![step4](/20230319/step4.png)

上記のコードで最終的に算出されたDepth画像がこちら。

- カラー画像
  - ![rgb](/20230319/000000.png)
- Depth画像 (を可視化したもの)
  - ![depth_color](/20230319/depth_color.png)

正しく求まっていそう。ライブラリを使ってサンプルコードくらいのものを書いてもらうという作業なら、十分依頼できそうだ。ChatGPT4は更に高性能らしいし、自分が洗練したプロンプトを入力できれば、もっと複雑なこともできるのだろう。




## あとがき

月並みだが、ChatGPT以前と以後ではプログラミングという作業の形態がガラッと変わるだろう、と感じた。

数年もしないうちに、①人間がやりたいことを考える → ②人間がプロンプトを音声で発話してChatGPTがコード化 → ③結果を人間が確認。必要があれば再度変更点を伝える というスタイルが当たり前になっていくのでは？という気がしている。

したがって、下記のような仕事は真っ先にChatGPTで代替されるだろう、という危機感を感じた。
- ペアプロのドライバー役
  - 実際、ChatGPTにコードを書いてもらっているときの感覚はナビゲーターそのものだった。
- リファクタリング
- テストの生成

一方で、"何を実現したいか" という部分が人間依存のものである以上、"指示出し" と "結果確認" は、やっぱり人間が行うしかないのだろうなと感じる。

そして、人間への指示出しと同様に、その作業は誰にでも行えるものではないのだろう。
プロンプトエンジニアは職業として成立するのか？ 特定の学習済モデルだけに人生をかけて大丈夫なのか？ なんて思っていたが、実はプログラマーよりも本質的な仕事なのかも知れない。
