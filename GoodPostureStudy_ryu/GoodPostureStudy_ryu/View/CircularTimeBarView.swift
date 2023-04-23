//
//  CircularTimeBarView.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/23.
//

import SwiftUI

struct CircularTimeBarView: View {
    // 被管理オブジェクトコンテキスト（ManagedObjectContext）の取得
    @Environment(\.managedObjectContext) private var context
    // データの取得処理
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "startTime", ascending: true)], animation: .spring())
    var tasks: FetchedResults<Task>
    @State var percentage: Int = 0
    @State var isProgress: Bool = false
    // 現在時刻を表示
    @State var dateText = ""
    @State var timeDegrees: Double = 0.0
    @State var remainingTime: String = ""
    @State var isShowTime: Bool = false
    // 西暦（gregorian）カレンダーを生成
    let calendar = Calendar(identifier: .gregorian)
    @State var nowDate = Date()
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
            
            if isShowTime {
                // 現在時刻までmask
                Circle()
                    // 0:1=0:360
                    .trim(from: 0, to: isProgress ? timeDegrees/360 : 0)
                    .stroke(style: StrokeStyle(lineWidth: 50, lineCap: .butt, lineJoin: .round))
                    .foregroundColor(.gray.opacity(0.6))
                    .rotationEffect(Angle(degrees: 90))
            }
            
            ForEach(tasks) { data in
                // 進捗を示す円
                // 0:1 = 0:12
                // 0:1 = 0:60
                Circle()
                    .trim(from: CGFloat(calendar.component(.hour, from: data.startTime!))/24 + CGFloat(calendar.component(.minute, from: data.startTime!))/60,
                          to: min(isProgress ?
                                  CGFloat(calendar.component(.hour, from: data.endTime!))/24 + CGFloat(calendar.component(.minute, from: data.endTime!))/60: CGFloat(calendar.component(.hour, from: data.startTime!))/24 + CGFloat(calendar.component(.minute, from: data.startTime!))/60,
                                  24))
                // 線の端の形状などを指定
                    .stroke(style: StrokeStyle(lineWidth: 40, lineCap: .butt, lineJoin: .round))
                    .fill(LinearGradient(gradient: Gradient(colors: [.pink,.purple]),
                                         startPoint: .top,
                                         endPoint: .bottom))
                    .rotationEffect(Angle(degrees: 90))
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
            
            VStack {
                Text("本日残り")
                    .bold()
                    .font(.title)
                
                Text("\(remainingTime)")
                    .bold()
                    .font(.largeTitle)
            }
        }
        .frame(width: 250, height: 250)
        .onTapGesture {
            withAnimation {
                isShowTime.toggle()
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1)) {
                isProgress = true
//                percentage += Int(progress * 100)
            }
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.nowDate = Date()
                dateText = "\(dateFormatter.string(from: nowDate))"
                // 0:24=0:360
                // 0:60=0:15
                timeDegrees = Double(calendar.component(.hour, from: nowDate))*15+Double(calendar.component(.minute, from: nowDate))/4
                let leftHour = 23 - calendar.component(.hour, from: nowDate)
                let leftMonute = 59 - calendar.component(.minute, from: nowDate)
                remainingTime = "\(leftHour)h \(leftMonute)min"
            }
    }
    }
}

struct CircularTimeBarView_Previews: PreviewProvider {
    static var previews: some View {
        CircularTimeBarView()
    }
}
