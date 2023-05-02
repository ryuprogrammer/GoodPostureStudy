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
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        // 過去5日間の勉強時間データ
                        BarMarkView()
                    } header: {
                        Text("過去7日間の勉強データ")
                            .font(.title2)
                            .padding(5)
                    }
                    // リストの区切り線を消す
                    .listRowSeparator(.hidden)
                    
                    Section {
                        // 完了したタスク
                        ForEach(tasks) { data in
                            // 完了したタスクのみ表示
                            if data.isDone == true {
                                HStack {
                                    // アイコンを表示
                                    Image(systemName: "highlighter")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(8)
                                        .foregroundColor(.white)
                                        .frame(width: 40, height: 40)
                                        .background(Color(taskColorName: Color.TaskColorNames(rawValue: data.color!) ?? .blue).opacity(0.5))
                                        .cornerRadius(8)
                                        .shadow(color: Color(taskColorName: Color.TaskColorNames(rawValue: data.color!) ?? .blue), radius: 5, x: 3, y: 3)
                                        .shadow(color: .white.opacity(0.5), radius: 5, x: -3, y: -3)
                                    VStack {
                                        // タスクを表示
                                        Text(data.task!)
                                            .font(.system(size: 20))
                                            .bold()
                                        // タスクの時間を表示
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
                                // リストの区切り線を消す
                                .listRowSeparator(.hidden)
                                .padding(3)
                            }
                        }
                        .onDelete { IndexSet in
                            // タスクを削除
                            reportViewModel.delete(offsets: IndexSet)
                        }
                    } header: {
                        Text("完了したタスク")
                            .font(.title2)
                            .padding(5)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("レポート")
        }
    }
}

//struct ReportView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReportView()
//    }
//}
