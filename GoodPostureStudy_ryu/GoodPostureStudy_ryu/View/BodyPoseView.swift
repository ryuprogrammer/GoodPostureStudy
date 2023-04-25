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
    // CameraModelのインスタンス生成
    @ObservedObject var camera = CameraModel()
    // Postureのインスタンス生成
    @State var posture = Posture()
    // 背骨の角度
    @State var bodyAngle: CGFloat = 0
    // 足を組んでいるか
    @State var isCrossLegs: Bool = false
    // 伸びをしてるか
    @State var isStretch: Bool = false
    // タイマーをストップするか
    @State var isTimer: Bool = true
    // 姿勢、足組み、伸びのメソッドを以下のtimerの間隔で実行
    @State private var timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    // 勉強時間計測のためのタイマー
    @State private var studyTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    // 画面に表示するテキスト（タイマーの表示など）
    @State var showText: String = ""
    // Calender()のインスタンス生成（グレゴリオ暦を採用）
    let calender = Calendar(identifier: .gregorian)
    // 時間表示の書式を設定
    let formatter = DateComponentsFormatter()
    // 秒数
    @State var studyTimeCount: Int = 0
    @State var startTime = Date()
    @State var endTime = Date() + (60*10)
    @State var studyTime: Date?
    @State var progress = 0.5
    // 経過時間
    @State var timeLeft: Double = 0.0
    // 全勉強時間
    @State var allTime: Double = 0.0
    
    var body: some View {
        ZStack {
            CameraView(camera: camera)
                .ignoresSafeArea(.all)
            
            BodyLineView(bodyPoints: camera.bodyPoints)
            
            // タイムバー表示
            ZStack {
                // 背景の円
                Circle()
                // 円形の線描写するように指定
                    .stroke(lineWidth: 20)
                    .foregroundColor(.mint.opacity(0.15))
                
                // 進捗を示す円
                Circle()
                    .trim(from: 0.0, to: min(CGFloat(timeLeft/allTime), 1))
                // 線の端の形状などを指定
                    .stroke(style: StrokeStyle(lineWidth: 25, lineCap: .round, lineJoin: .round))
                    .fill(LinearGradient(gradient: Gradient(colors: [.blue, .mint]),
                                         startPoint: .top,
                                         endPoint: .bottom))
                    .rotationEffect(Angle(degrees: 270))
                
                Text("\(showText)")
                    .frame(width: 450, height: 100)
                    .font(.system(size: 100))
            }
            .frame(width: 400)
            
            // タイマーボタン
            VStack {
                Spacer()
                    .frame(height: 400)
                
                Button {
                    isTimer.toggle()
                } label: {
                    Text("タイマー")
                        .frame(width: 200, height: 80)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(20)
            }
            }
        }
        .onReceive(timer) { _ in
            if let points: BodyPoints = camera.bodyPoints {
                bodyAngle = posture.postureAngle(bodyPoints: points)
                isCrossLegs = posture.crossLegs(bodyPoints: points)
                isStretch = posture.stretch(bodyPoints: points)
                if isStretch {
                    isTimer = false
                } else {
                    isTimer = true
                }
            }
        }
        .onReceive(studyTimer) { _ in
            if isTimer {
                withAnimation {
                    studyTimeCount += 1
                }
            }
            if let time = studyTime,
               let second = calender.dateComponents([.second],
                                                    from: startTime,
                                                    to: time + TimeInterval(studyTimeCount)).second {
                timeLeft = Double(second)
            }
            
            // 開始時間から終了時間までの秒数
            let timeLeftSecond = Int(allTime)*60
            
            // 設定した
            if studyTimeCount < timeLeftSecond {
                // 勉強時間を表示
                showText = formatter.string(from: timeLeft) ?? ""
            } else if studyTimeCount > timeLeftSecond {
                // 勉強時間終了
                showText = "finish"
            }
        }
        .onAppear {
            formatter.unitsStyle = .positional
            formatter.allowedUnits = [.hour, .minute, .second]
            if let time = calender.dateComponents([.second], from: startTime, to: endTime).second {
                allTime = Double(time)
            }
            studyTime = startTime
        }
    }
}
