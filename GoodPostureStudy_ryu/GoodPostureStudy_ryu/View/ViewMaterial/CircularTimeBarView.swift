//
//  CircularTimeBarView.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/23.
//

import SwiftUI

struct CircularTimeBarView: View {
    // CircularTimeBarViewModelのインスタンス生成
    let circularTimeBarViewModel = CircularTimeBarViewModel()
    // 被管理オブジェクトコンテキスト（ManagedObjectContext）の取得
    @Environment(\.managedObjectContext) private var context
    // データの取得処理
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "startTime", ascending: true)], animation: .spring())
    var tasks: FetchedResults<Task>
    @State var percentage: Int = 0
    @State var isProgress: Bool = false
    // 現在時刻を表示
    @State var timeDegrees: Double = 0.0
    @State var remainingTime: String = ""
    @State var nowTime: String = ""
    @State var isShowRemainingTime: Bool = false
    // 西暦（gregorian）カレンダーを生成
    let calendar = Calendar(identifier: .gregorian)
    private let dateFormatter = DateFormatter()
    init() {
        dateFormatter.dateFormat = "YYYY/MM/dd(E) \nHH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ja_jp")
    }
    var body: some View {
        ZStack {
            // 背景の円
            Circle()
            // 円形の線描写するように指定
                .stroke(lineWidth: 50)
                .foregroundColor(.gray.opacity(0.15))
            
            // 現在時刻までmask
            Circle()
                // 0:1=0:360
                .trim(from: 0, to: isProgress ? timeDegrees/360 : 0)
                .stroke(style: StrokeStyle(lineWidth: 50, lineCap: .butt, lineJoin: .round))
                .foregroundColor(.gray.opacity(isShowRemainingTime ? 0.6 : 0))
                .rotationEffect(Angle(degrees: 90))
            
            ForEach(tasks) { data in
                // 今日のタスクのみ表示
                if circularTimeBarViewModel.isEqualToDate(startTime: data.startTime!) {
                    let color: Color = Color(taskColorName: Color.TaskColorNames(rawValue: data.color!) ?? .blue)
                    // 進捗を示す円
                    Circle()
                        .trim(from: CGFloat(calendar.component(.hour, from: data.startTime!))/24 + CGFloat(calendar.component(.minute, from: data.startTime!))/60,
                              to: min(isProgress ?
                                      CGFloat(calendar.component(.hour, from: data.endTime!))/24 + CGFloat(calendar.component(.minute, from: data.endTime!))/60: CGFloat(calendar.component(.hour, from: data.startTime!))/24 + CGFloat(calendar.component(.minute, from: data.startTime!))/60,
                                      24))
                    // 線の端の形状などを指定
                        .stroke(style: StrokeStyle(lineWidth: 40, lineCap: .butt, lineJoin: .round))
                        .fill(LinearGradient(gradient: Gradient(colors: [color, color.opacity(0.5)]),
                                             startPoint: .top,
                                             endPoint: .bottom))
                        .rotationEffect(Angle(degrees: 90))
                }
            }
            
            ForEach(0..<24) { time in
                // 円の区切り線
                Rectangle()
                    .frame(width: 2, height: 300)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .rotationEffect(Angle(degrees: Double(time*15)))
                
                // 時計の数字
                ZStack {
                    Text("\(time)")
                        .position(x: 140, y:-13)
                        .rotationEffect(Angle(degrees: Double(time*15)+174.5))
                }
            }
            
            // 時間または残り時間を表示
            Text(isShowRemainingTime ? remainingTime : nowTime)
                .bold()
                .font(.largeTitle)
        }
        .frame(width: 250, height: 250)
        .onTapGesture {
            withAnimation {
                isShowRemainingTime.toggle()
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1)) {
                isProgress = true
            }
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                nowTime = Date().formattedTimeString()
                remainingTime = Date().getRemainingTimeToday()
                // 0:24=0:360
                // 0:60=0:15
                timeDegrees = Double(calendar.component(.hour, from: Date()))*15+Double(calendar.component(.minute, from: Date()))/4
            }
    }
    }
}

struct CircularTimeBarView_Previews: PreviewProvider {
    static var previews: some View {
        CircularTimeBarView()
    }
}
