//
//  ContentView.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/22.
//

import SwiftUI
import CoreData

struct StartUpView: View {
    // タブをコードで動的に切り替える
    @State var tabSelection: Int = 0
    
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
                        Image(systemName: "\(Date().formattedDayString()).square.fill")
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
