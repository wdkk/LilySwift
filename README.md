LilySwift ライブラリ
=================

update : 2022.02.13

渡辺電気株式会社でSwiftに関するコードを整理しているiOS/macOS向けライブラリです。
よく使う基本モジュール, UIKitのユーティリティ, Metalのユーティリティなどを含みます。
主にグラフィックプログラミング、ビジュアルエフェクト、2D画像処理のコーディングを目的として開発・整理しています。


## モジュール群の概要( Overview of Modules )

* **LilyCoreSwift**  - 汎用的な処理モジュール群(C言語からの移植部分)です。型の定義、画像オブジェクト、基礎的なロジックなどを含みます。

* **Lily** -  メインとなるSwiftモジュール群です。LilyCoreモジュールのラッパークラス、Metalのモジュール、ユーティリティなどを含みます。
  
* **LilyUI** - iOS, macOSのUIに関するモジュール群です。



## 開発環境 ( Environment )

* macOS Monterey
* XCode13.2.1



## 利用手順( Usage )

以下では、Lilyを用いてビルドを通すまでの手順を説明します。

### Case-A. Swift Packageを使う場合

#### A-a. インストール( Install )

1. XCodeを用意してください。

2. XCodeを起動し、新規のiOS Appプロジェクトを作成します。

#### A-b. Swift Packageの追加( Add Swift Package )

1. [File] > [Add Packages] を選択します。

2. Packageリストの左下の[+]ボタンを押して、コレクションを追加します。
  - https://github.com/wdkk/LilySwift.git

3. 追加された[WDKK-LilySwift] > [LilySwift]を選択します。

4. Dependency Ruleを設定します。
  - [Up to Next Major Version]を選択
  - バージョンの値を4.0.0 ~ 5.0.0を設定

5. Addボタンを押します。


----

### Case-B. xcframeworkを使う場合

#### B-a. インストール( Install )

1. XCodeを用意してください。
  
2. プロジェクトをダウンロードもしくはクローンしてください。


#### B-b. LilySwift.xcframeworkの作成と実行テスト

1. 取得したプロジェクトのXCワークスペースを開いてください。
  
   位置: [LilySwift] > [project] > [apple] > LilySwift.xcworkspace
    
2. XCode上で"LilySwift.xc-framework"スキーマを選択し、Runを実行します（ビルド）。
  
3. プロジェクトのルートフォルダに[_lib] > [LilySwift.xcframework]が生成されているか確認してください。
  
4. XCode上で"iOSApp"スキーマ、出力先に"任意のSimulator"を選択し、Runを実行します。
  
5. 起動したシミュレータで中心に青い四角が表示されれば成功です。


#### B-c. iOSAppでLilyを利用する

1. LilyiOSAppプロジェクト > [codes] > MyViewController.swiftを開いてください。
  
2. MyViewController.swiftが上記手順5の青い四角を表示するための、LilyBoardモジュールセットの記述です。
  
3. LilyiOSAppプロジェクト > [samples] に開発で用いている試行錯誤のコードが含まれています。ご参考ください。
  
4. 実際の利用シーンについては今後サンプルコードやリファレンスを用意してまいります。しばらくお待ちください。



## ライブラリの成り立ち( Library structure )

2004年ごろ、Windows向けの画像処理ライブラリの必要性からLilyの開発を開始しました。
LilySwiftはiOS/macOS向けにSwiftで動作するようにしたLilyライブラリです。



## ライセンス(License)

LilySwiftライブラリは MIT License ( https://github.com/wdkk/LilySwift/blob/master/LICENSE )のもと、公開しています。



## 開発元(Developer)

- 渡辺電気株式会社(Watanabe-Denki Inc.)
　　
  - https://wdkk.co.jp/

- 渡邉賢悟(Kengo Watanabe)

  - https://kengolab.net/



Copyright(c) 2004- Watanabe-Denki.Inc.
