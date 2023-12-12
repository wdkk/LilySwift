LilySwift ライブラリ
=================

update : 2023.12.12

渡辺電気株式会社でSwiftに関するコードを整理しているiOS/macOS向けライブラリです。
よく使う基本モジュール, UIKitのユーティリティ, Metalのユーティリティなどを含みます。
主にグラフィックプログラミング、ビジュアルエフェクト、2D画像処理のコーディングを目的として開発・整理しています。


## モジュール群の概要( Overview of Modules )

* **LilyCore**  
  - 汎用的な処理モジュール群(C言語からの移植)です。型の定義、画像オブジェクト、基礎的なロジックなどを含みます。

* **Lily** 
  - メインとなるSwiftモジュール群です。LilyCoreモジュールのラッパーオブジェクト、Metalのモジュール、ユーティリティなどを含みます。
  
* **Lily_View** 
  - iOS, macOSのビューに関するモジュール群です。AppKit,UIKitを用いるレイヤです。

* **Lily_Metal**
  - Metalを用いるヘルパーユーティリティ群です。オブジェクトや各種拡張を含みます。

* **Lily_Stage**
  - Metalを用いたグラフィックス処理のモジュール群です。パイプラインをまとめています。

* **Lily_UI**
  - Lily_ViewのSwiftUI向けモジュールです。

## 検証している環境 ( Environment )

* XCode 15.0
* iOS 17.1
* macOS 14.1 (with macCatalyst)

## 利用手順( Usage )

Lilyのビルドを通すまでの手順を説明します。

#### a. インストール( Install )

1. XCodeを用意してください。

2. XCodeを起動し、新規のiOS Appプロジェクトを作成します。

#### b. Swift Packageの追加( Add Swift Package )

1. [File] > [Add Packages] を選択します。

2. Package選択画面の右上の[検索フィールド]で以下を入力します.
  - https://github.com/wdkk/LilySwift.git

3. [LilySwift]が表示されるのでこれを選択します

4. Dependency Ruleを設定します。
  - [Brunch]を選択
  - 現在は"dev-5.0"で開発中のブランチとなります

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
