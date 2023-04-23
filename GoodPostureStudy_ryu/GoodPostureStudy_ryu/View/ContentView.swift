//
//  ContentView.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    // 西暦（gregorian）カレンダーを生成
    let calendar = Calendar(identifier: .gregorian)
    // 現在日時を取得
    @State var nowDate = Date()
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    VStack {
                        Image(systemName: "list.triangle")
                        Text("ホーム")
                    }
                }
            
            AddView()
                .tabItem {
                    VStack {
                        Image(systemName: "highlighter")
                        Text("タスク追加")
                    }
                }
            
            ReportView()
                .tabItem {
                    VStack {
                        // 今日の日付のアイコンを表示
                        Image(systemName: "\(Int(calendar.component(.day, from: nowDate))).square.fill")
                        Text("レポート")
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
