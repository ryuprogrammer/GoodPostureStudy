//
//  MaskView.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/25.
//

import SwiftUI

struct MaskView: View {
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var showText: String = ""
    let calender = Calendar(identifier: .gregorian)
    let formatter = DateComponentsFormatter()
    init() {
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
    }
    @State var data = Data()
    @State var count: Int = 0
    @State var startTime = Date()
    @State var endTime = Date() + (60*10)
    @State var studyTime: Date?
    @State var progress = 0.5
    // 経過時間
    @State var timeLeft: Double = 0.0
    // 全勉強時間
    @State var allTime: Double = 0.0
    // タイマー停止
    @State var isStart: Bool = true
    var body: some View {
        ZStack {
            Color.white
                .opacity(0.2)
                .ignoresSafeArea()
            
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
            
            VStack {
                Spacer()
                    .frame(height: 500)
                
                Button {
                    isStart = false
                } label: {
                    Text("止める")
                }

                Button {
                    isStart = true
                } label: {
                    Text("再開")
                }
            }
        }
        .onReceive(timer) { timer in
            if isStart {
                withAnimation {
                    count += 1
                }
            }
            if let time = studyTime,
               let second = calender.dateComponents([.second],
                                                    from: startTime,
                                                    to: time + TimeInterval(count) - 4).second {
                timeLeft = Double(second)
            }
            
            let timeLeftSecond = Int(allTime)*60
            
            switch count {
            case 1: showText = "3"
            case 2: showText = "2"
            case 3: showText = "1"
            case 4: showText = "スタート"
            case 5..<timeLeftSecond: showText = formatter.string(from: timeLeft) ?? ""
            default: break
            }
        }
        .onAppear {
            if let time = calender.dateComponents([.second], from: startTime, to: endTime).second {
                allTime = Double(time)
            }
            studyTime = startTime
        }
    }
}

struct MaskView_Previews: PreviewProvider {
    static var previews: some View {
        MaskView()
    }
}
