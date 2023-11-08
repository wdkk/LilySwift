LilySwift ライブラリ
=================

update : 2023.11.06

渡辺電気株式会社でSwiftに関するコードを整理しているiOS/macOS向けライブラリです。
よく使う基本モジュール, UIKitのユーティリティ, Metalのユーティリティなどを含みます。
主にグラフィックプログラミング、ビジュアルエフェクト、2D画像処理のコーディングを目的として開発・整理しています。


## モジュール群の概要( Overview of Modules )

* **LilyCore**  
- 汎用的な処理モジュール群(C言語からの移植)です。型の定義、画像オブジェクト、基礎的なロジックなどを含みます。

* **Lily** 
- メインとなるSwiftモジュール群です。LilyCoreモジュールのラッパーオブジェクト、Metalのモジュール、ユーティリティなどを含みます。
  
* **Lily.View** 
- iOS, macOSのビューに関するモジュール群です。AppKit,UIKitを用いるレイヤです。

* **Lily.Metal**
- Metalを用いるヘルパーユーティリティ群です。オブジェクトや各種拡張を含みます。

* **Lily.Stage**
- Metalを用いたグラフィックス処理のモジュール群です。パイプラインをまとめています。

* **Lily.UI**
- Lily.ViewのSwiftUI向けモジュールです。

## 開発環境 ( Environment )

* XCode 15.0
* iOS 15.0
* macOS 13.0

## 利用手順( Usage )

Lilyのビルドを通すまでの手順を説明します。

### Case-A. Swift Packageを使う

#### A-a. インストール( Install )

1. XCodeを用意してください。

2. XCodeを起動し、新規のiOS Appプロジェクトを作成します。

#### A-b. Swift Packageの追加( Add Swift Package )

1. [File] > [Add Packages] を選択します。

2. Package選択画面の右上の[検索フィールド]で以下を入力します.
  - https://github.com/wdkk/LilySwift.git

3. [LilySwift]が表示されるのでこれを選択します

4. Dependency Ruleを設定します。
  - [Up to Next Major Version]を選択
  - バージョンの値を4.0.0 ~ 5.0.0を設定

5. Addボタンを押します。


## ライブラリの成り立ち( Library structure )

2004年ごろ、Windows向けの画像処理ライブラリの必要性からLilyの開発を開始しました。
LilySwiftはiOS/macOS向けにLilyをSwiftに移植したライブラリです。



## ライセンス(License)

LilySwiftライブラリは MIT License ( https://github.com/wdkk/LilySwift/blob/master/LICENSE )のもと、公開しています。



## 開発元(Developer)

- 渡辺電気株式会社(Watanabe-Denki, Inc.)
　　
  - https://wdkk.co.jp/

- 渡邉賢悟(Kengo Watanabe)

  - https://kengolab.net/



Copyright(c) 2004- Watanabe-Denki, Inc.
