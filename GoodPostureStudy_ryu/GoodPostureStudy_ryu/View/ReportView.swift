//
//  ReportView.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/23.
//

import SwiftUI

struct ReportView: View {
    // ReportViewModelのインスタンス生成
    let reportViewModel = ReportViewModel()
    // 被管理オブジェクトコンテキスト（ManagedObjectContext）の取得
    @Environment(\.managedObjectContext) private var context
    // データの取得処理
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "startTime", ascending: true)], animation: .spring())
    var tasks: FetchedResults<Task>
    @State var selectedTask: Task?
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        // 完了したタスク
                        ForEach(tasks) { data in
                            if data.isDone == true {
                                HStack {
                                    Image(systemName: "figure.run")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(8)
                                        .foregroundColor(.white)
                                        .frame(width: 50, height: 50)
                                        .background(Color(data.color!).opacity(0.5))
                                        .cornerRadius(8)
                                        .shadow(color: Color(data.color!), radius: 5, x: 3, y: 3)
                                        .shadow(color: .white.opacity(0.5), radius: 5, x: -3, y: -3)
                                    
                                    VStack {
                                        Text(data.task!)
                                            .font(.system(size: 20))
                                            .bold()
                                        
                                        Text("\(reportViewModel.dateString(date: data.startTime!))〜\(reportViewModel.dateString(date: data.endTime!))")
                                            .font(.system(size: 15))
                                    }
                                    .frame(width: 200)
                                    
                                    Text("完了しました")
                                        .font(.system(size: 16))
                                        .bold()
                                        .frame(width: 120, height: 40)
                                        .foregroundColor(.white)
                                        .background(Color.gray.opacity(0.5))
                                        .cornerRadius(13)
                                }
                            }
                        }
                    } header: {
                        Text("\(tasks.count)個のタスクを完了しました！")
                            .font(.title2)
                            .padding(5)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("レポート")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
