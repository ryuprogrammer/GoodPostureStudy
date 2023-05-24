# 姿勢管理アプリ『ポスタ』
<img width="600" src="https://github.com/CodeCandySchool/GoodPostureStudy_ryu/assets/120238831/703bb223-1f0b-4433-84bf-757cb961ccb3">

## 1. 概要・コンセプト
<img width="600" src="https://github.com/CodeCandySchool/GoodPostureStudy_ryu/assets/120238831/96f56a45-2cc0-4ebb-a94b-8e884ad554e7">

## 2. アプリの機能３つ
<img width="600" src="https://github.com/CodeCandySchool/GoodPostureStudy_ryu/assets/120238831/440cc39f-82bd-44a0-8b6c-bd75f3dcd9e9">
<img width="600" src="https://github.com/CodeCandySchool/GoodPostureStudy_ryu/assets/120238831/126a9cc9-af43-4eeb-9cb5-e31910bde801">
<img width="600" src="https://github.com/CodeCandySchool/GoodPostureStudy_ryu/assets/120238831/dfe65b1f-3b06-4f03-a6ab-05aa12d5085a">

## 3. アプリの動作
### タスクの追加方法
タスク内容、アイコンの色、時間を入力するだけで簡単に追加できます。

<img width="200" src="https://github.com/CodeCandySchool/GoodPostureStudy_ryu/assets/120238831/acf5eae5-7eff-4bf1-8a35-0790fec248b4">

### 姿勢の検知
姿勢を検知して、正しい姿勢の時だけタイマーが進みます。

<img width="200" src="https://github.com/CodeCandySchool/GoodPostureStudy_ryu/assets/120238831/d77f7e81-32e9-4330-aac3-b644c45b4655">


##  4. ダウンロードリンク
[![App_Store_Badge_JP](https://user-images.githubusercontent.com/68992872/204145956-f5cc0fa8-d4c9-4f2c-b1d4-3c3b1d2e2aba.png)](https://apps.apple.com/jp/app/%E3%83%9D%E3%82%B9%E3%82%BF/id6448646839)

## 5. 今後追加する機能
今後はStudyPlus（勉強版Twitter）に完了したタスクを登録する機能を実装します！

ここから以降は、主にエンジニアチームに向けてのアピールです。

## 6. アプリの設計について
<img width="600" src="https://github.com/CodeCandySchool/GoodPostureStudy_ryu/assets/120238831/897116c8-d0bf-48ca-8548-560eeac9e49c">
<img width="600" src="https://github.com/CodeCandySchool/GoodPostureStudy_ryu/assets/120238831/95b434ac-2d3d-4220-bfaf-7408596ed437">
<img width="600" src="https://github.com/CodeCandySchool/GoodPostureStudy_ryu/assets/120238831/4f2ebd07-1acc-4e67-b4af-e90203d0fc34">
<img width="600" src="https://github.com/CodeCandySchool/GoodPostureStudy_ryu/assets/120238831/2e30f7e3-0c01-4df4-afbf-29eaff5053ca">


- フローチャート
こちらで[フローチャートについて学習をして](https://cacoo.com/ja/blog/keep-it-simple-how-to-avoid-overcomplicating-your-flowcharts/)、フローチャートを記述してみてください。
Miroでも、Keynoteでも、フリーボードでも作成しやすいツールで構わないです。

## 7. MVVMの構成図
参考情報の他の受講生のポートフォリオを参考にして、MVVMの構成図を作成してください。

## 8. 工夫したコード／設計
プロジェクトで工夫した設計や、コードを具体的に示してください。
該当コードを示して、どんな工夫をしたのか分かりやすく記載してください。
### ポイント１ タスクをタイムチャートで表示
タスクの開始時間と終了時間を可視化するためにタイムチャートを作成しました。
↓タイムチャート
<img width="200" src="https://github.com/CodeCandySchool/GoodPostureStudy_ryu/assets/120238831/c693b9d4-d165-4f24-8c86-bb3d8ed56e55">

https://github.com/CodeCandySchool/GoodPostureStudy_ryu/blob/031942d3ee0d5546858dbe470d83b084358d590a/GoodPostureStudy_ryu/GoodPostureStudy_ryu/View/ViewMaterial/CircularTimeBarView.swift#L27-L100

### ポイント２ 過去7日分のデータをChartで表示
CoreDataからタスクデータを取得して、完了済みのタスクの合計時間を過去7日分Chartで表示しました。
↓Chart
<img width="200" src="https://github.com/CodeCandySchool/GoodPostureStudy_ryu/assets/120238831/0d5ad873-1657-425a-9148-a3754e0ed612">

https://github.com/CodeCandySchool/GoodPostureStudy_ryu/blob/031942d3ee0d5546858dbe470d83b084358d590a/GoodPostureStudy_ryu/GoodPostureStudy_ryu/ViewModel/BarMarkViewModel.swift#L10-L127

## 9 その他リンク
[ホームページ](https://y70ns.hp.peraichi.com/posta)
[作成者Twitter](https://twitter.com/engineerforios?s=11&t=E3_w-CiFaS5cBpi-By2fYg)

