# 姿勢管理アプリ『ポスタ』
<img width="600" src="https://github.com/ryuprogrammer/GoodPostureStudy/assets/120238831/3afb8603-3f80-4071-8fac-e6324719600d">

## 1. 概要・コンセプト
<img width="600" src="https://github.com/ryuprogrammer/GoodPostureStudy/assets/120238831/af465015-c5e7-4353-a525-8a94c61a5dd6">

## 2. アプリの機能３つ
<img width="600" src="https://github.com/ryuprogrammer/GoodPostureStudy/assets/120238831/03be2a1c-9d27-495f-a7e4-1046e4f47e87">
<img width="600" src="https://github.com/ryuprogrammer/GoodPostureStudy/assets/120238831/254ef1ae-907a-4cce-b5c6-2d9219e6ea3e">
<img width="600" src="https://github.com/ryuprogrammer/GoodPostureStudy/assets/120238831/2ee0a50e-b723-473b-b0f3-aaa052e42284">

## 3. アプリの動作
### タスクの追加方法
タスク内容、アイコンの色、時間を入力するだけで簡単に追加できます。

<img width="200" src="https://github.com/ryuprogrammer/GoodPostureStudy/assets/120238831/9ba70427-f6b3-43ad-9a2f-733bb0675b1c">

### 姿勢の検知
姿勢を検知して、正しい姿勢の時だけタイマーが進みます。

<img width="200" src="https://github.com/ryuprogrammer/GoodPostureStudy/assets/120238831/6e962bd2-961b-4a5c-b5e9-3e3c2fc8b2fc">

##  4. ダウンロードリンク
[![App_Store_Badge_JP](https://user-images.githubusercontent.com/68992872/204145956-f5cc0fa8-d4c9-4f2c-b1d4-3c3b1d2e2aba.png)](https://apps.apple.com/jp/app/%E3%83%9D%E3%82%B9%E3%82%BF/id6448646839)

## 5. 今後追加する機能
今後はStudyPlus（勉強版Twitter）に完了したタスクを登録する機能を実装します！
レポート機能を充実させます！

## 6. MVVMの構成図  
・View   
<img width="600" src="https://github.com/ryuprogrammer/GoodPostureStudy/assets/120238831/e775d227-ba7e-4f22-8b16-ccc006e46749">  
・ViewModel  
<img width="600" src="https://github.com/ryuprogrammer/GoodPostureStudy/assets/120238831/25031846-a2d9-4752-af3f-f0e24b323406">  
・Model  
<img width="600" src="https://github.com/ryuprogrammer/GoodPostureStudy/assets/120238831/db262571-66c4-4d95-a49d-9731985fd715">  
・Extension  
<img width="600" src="https://github.com/ryuprogrammer/GoodPostureStudy/assets/120238831/a897c75e-00d8-45bd-9045-41b00b025149">  

## 8. 工夫したコード／設計
プロジェクトで工夫した設計や、コードを具体的に示してください。
該当コードを示して、どんな工夫をしたのか分かりやすく記載してください。
### ポイント１ タスクをタイムチャートで表示
タスクの開始時間と終了時間を可視化するためにタイムチャートを作成しました。  
<img width="250" src="https://github.com/ryuprogrammer/GoodPostureStudy/assets/120238831/ef8e19c5-98bd-4ecc-a54d-6463131f2a27">  
タイムチャート  
https://github.com/ryuprogrammer/GoodPostureStudy/blob/031942d3ee0d5546858dbe470d83b084358d590a/GoodPostureStudy_ryu/GoodPostureStudy_ryu/View/ViewMaterial/CircularTimeBarView.swift#L27-L100

### ポイント２ 過去7日分のデータをChartで表示
CoreDataからタスクデータを取得して、完了済みのタスクの合計時間を過去7日分Chartで表示しました。  
<img width="250" src="https://github.com/ryuprogrammer/GoodPostureStudy/assets/120238831/1c8f7ac7-2642-4f4e-a478-00d4a16aa825">  
過去7日分のレポート  

https://github.com/ryuprogrammer/GoodPostureStudy/blob/031942d3ee0d5546858dbe470d83b084358d590a/GoodPostureStudy_ryu/GoodPostureStudy_ryu/ViewModel/BarMarkViewModel.swift#L10-L127

## 9 その他リンク
[ホームページ](https://y70ns.hp.peraichi.com/posta)  
[作成者Twitter](https://twitter.com/engineerforios?s=11&t=E3_w-CiFaS5cBpi-By2fYg)

