//
//  ReportView.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/23.
//

import SwiftUI

struct ReportView: View {
    // ReportViewModelのインスタンス生成
    private let reportViewModel = ReportViewModel()
    // 被管理オブジェクトコンテキスト（ManagedObjectContext）の取得
    @Environment(\.managedObjectContext) private var context
    // データの取得処理
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "startTime", ascending: true)], animation: .spring())
    var tasks: FetchedResults<Task>
    @State var selectedTask: Task?

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    BarMarkSectionView
                        // リストの区切り線を消す
                        .listRowSeparator(.hidden)

                    Section {
                        // 完了したタスク
                        ForEach(tasks) { task in
                            // 完了したタスクのみ表示
                            if task.isDone == true {
                                TaskCardView(selectedTask: $selectedTask, task: task)
                                    // リストの区切り線を消す
                                    .listRowSeparator(.hidden)
                                    .padding(.horizontal, 30)
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

    @ViewBuilder
    private var BarMarkSectionView: some View {
        Section {
            // 過去5日間の勉強時間データ
            BarMarkView()
        } header: {
            Text("過去7日間の勉強データ")
                .font(.title2)
                .padding(5)
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
