//
//  ContentView.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/22.
//

import SwiftUI
import CoreData

struct StartUpView: View {
    // TabViewModelのインスタンス生成
    @StateObject var tabViewModel = TabViewModel()
    // タブをコードで動的に切り替える
    @State var tabSelection: Int = 0
    @Environment(\.managedObjectContext) private var viewContext
    // 西暦（gregorian）カレンダーを生成
    let calendar = Calendar(identifier: .gregorian)
    // 現在日時を取得
    @State var nowDate = Date()
    var body: some View {
        TabView(selection: $tabSelection) {
            HomeView()
                .tabItem {
                    VStack {
                        Image(systemName: "list.triangle")
                        Text("ホーム")
                    }
                }
                .tag(0)
            
            AddView(tabSelection: $tabSelection)
                .tabItem {
                    VStack {
                        Image(systemName: "highlighter")
                        Text("タスク追加")
                    }
                }
                .tag(1)
            
            ReportView()
                .tabItem {
                    VStack {
                        // 今日の日付のアイコンを表示
                        Image(systemName: "\(Int(calendar.component(.day, from: nowDate))).square.fill")
                        Text("レポート")
                    }
                }
                .tag(2)
        }
    }
}

struct StartUpView_Previews: PreviewProvider {
    static var previews: some View {
        StartUpView()
    }
}
