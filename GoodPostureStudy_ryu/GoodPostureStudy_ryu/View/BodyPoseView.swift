//
//  BodyPoseView.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/24.
//

import SwiftUI
import AVFoundation
import Vision

struct BodyPoseView: View {
    // 勉強するタスク内容
    @Binding var selectedTask: Task?
    // CameraModelのインスタンス生成
    @ObservedObject var camera = CameraModel()
    // BodyPoseViewModelのインスタンス生成
    @ObservedObject var bodyPoseViewModel = BodyPoseViewModel()
    // 背骨の角度
    @State var bodyAngle: CGFloat = 0
    // 足を組んでいるか
    @State var isCrossLegs: Bool = false
    // 伸びをしてるか
    @State var isStretch: Bool = false
    // 伸びをした回数
    @State var stretchCount: Int = 0
    // 姿勢、足組み、伸びのメソッドを以下のtimerの間隔で実行
    @State private var timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    // 勉強時間計測のためのタイマー
    @State private var studyTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    // 画面に表示するテキスト（タイマーの表示など）
    @State var showText: String = ""
    // 秒数
    @State var studyTimeCount: Int = 0
    @State var startTime = Date()
    @State var endTime = Date() + (60*10)
    @State var nowTime: Date?
    @State var progress = 0.5
    // タイムバーの進捗割合
    @State var timeCircleRatio: CGFloat = 0.0
    // 全勉強時間
    @State var allTime: Double = 0.0
    // Viewの背景色のプロパティ（ジャンケンの手が有効の時青、無効の時赤に変化）
    @State private var backgroundColor = Color.red
    // ユーザーのデバイスの画面の大きさ
    let UserScreenWidth: Double = UIScreen.main.bounds.size.width
    let UserScreenHeight: Double = UIScreen.main.bounds.size.height
    // AddReportViewの表示
    @State var isShowAddReportView: Bool = false
    
    var body: some View {
        ZStack {
            CameraView(camera: camera)
                .ignoresSafeArea(.all)
            
            BodyLineView(bodyPoints: camera.bodyPoints)
            
            // 画面の大きさに合わせて画面の縁に色をつける
            RoundedRectangle(cornerRadius: 60)
                .stroke(backgroundColor.opacity(0.5), lineWidth: 50)
                .edgesIgnoringSafeArea(.all)
                .frame(width: UserScreenWidth, height: UserScreenHeight)
            
            // タイマーボタン
            VStack {
                VStack {
                    Text(bodyPoseViewModel.alertText)
                }
                .frame(maxWidth: 200, maxHeight: 100)
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .overlay (
                    RoundedRectangle(cornerRadius: 15)
                        .stroke()
                        .foregroundStyle(
                            .linearGradient(colors: [.white.opacity(0.5), .clear],
                                            startPoint: .top,
                                            endPoint: .bottom)
                        )
                )
                .shadow(color: .black.opacity(0.3), radius: 20, y: 20)
                .padding(50)
                
                // タイムバー表示
                ZStack {
                    // 背景の円
                    Circle()
                    // 円形の線描写するように指定
                        .stroke(lineWidth: 20)
                        .foregroundColor(.mint.opacity(0.15))
                    
                    // 進捗を示す円
                    Circle()
                        .trim(from: 0.0, to: min(timeCircleRatio, 1))
                    // 線の端の形状などを指定
                        .stroke(style: StrokeStyle(lineWidth: 25, lineCap: .round, lineJoin: .round))
                        .fill(LinearGradient(gradient: Gradient(colors: [.blue, .mint]),
                                             startPoint: .top,
                                             endPoint: .bottom))
                        .rotationEffect(Angle(degrees: 270))
                    
                    // 勉強時間を表示
                    Text("\(bodyPoseViewModel.showStudyTime)")
                        .frame(width: 450, height: 100)
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 20)
                }
                .frame(width: 300)
                .padding(50)
                
                Button {
                    isShowAddReportView = true
                } label: {
                    Text("完了")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .frame(width: 330, height: 55)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(10)
                }
            }
            .sheet(isPresented: $isShowAddReportView) {
                // AddReportViewを表示
                AddReportView(addTask: selectedTask!)
            }
        }
        .onReceive(timer) { _ in
            // 正しい姿勢で勉強できている場合のみタイマーを進める
            bodyPoseViewModel.stopTimer(bodyPoints: camera.bodyPoints)
            // 画面の縁の色をタイマーのオンオフによって変化
            backgroundColor = bodyPoseViewModel.isTimer ? .cyan : .red
        }
        .onReceive(studyTimer) { _ in
            if bodyPoseViewModel.isTimer {
                withAnimation {
                    studyTimeCount += 1
                }
            }
            // 残り時間を計算
            bodyPoseViewModel.calculateTimeLeft(startTime: startTime, studyTime: nowTime, studyTimeCount: studyTimeCount)
            
            // 勉強時間、画面に表示するテキストを更新
            bodyPoseViewModel.studyTimeText(studyTimeCount: studyTimeCount, allTime: allTime)
            
            // タイムバーの進捗割合を更新
            timeCircleRatio = CGFloat(bodyPoseViewModel.timeLeft/allTime)
        }
        .onAppear {
            // 開始時間と終了時間を初期化
            startTime = selectedTask?.startTime ?? Date()
            endTime = selectedTask?.endTime ?? Date()
            // 開始時間と終了時間から全勉強時間を算出
            allTime = bodyPoseViewModel.calculateAllTime(startTime: startTime, endTime: endTime)
            // 現在の時刻を開始時間で初期化
            nowTime = startTime
        }
    }
}
