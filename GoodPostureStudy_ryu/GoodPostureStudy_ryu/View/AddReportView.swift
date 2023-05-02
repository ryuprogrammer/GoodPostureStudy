//
//  AddReportView.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/28.
//

import SwiftUI

struct AddReportView: View {
    // データの取得処理
    @FetchRequest(entity: Task.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "startTime", ascending: true)],
                  animation: .spring())
    var tasks: FetchedResults<Task>
    // AddReportViewModelのインスタンス生成
    @StateObject var addReportViewModel = AddReportViewModel()
    // BodyPoseViewで進行しているタスク
    @State var addTask: Task
    // アラートの内容
    @State private var showingAlert: AddReportViewModel.AlertItem?
    // 被管理オブジェクトコンテキスト（ManagedObjectContext）の取得
    @Environment(\.managedObjectContext) private var context
    // 画面を閉じる
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                
                List {
                    Section {
                        TextField("完了したタスクを入力", text: $addReportViewModel.content)
                    } header: {
                        Text("完了したタスク")
                    }

                    Section {
                        HStack {
                            DatePicker("開始",
                                       selection: $addReportViewModel.startTime,
                                       displayedComponents: .hourAndMinute)
                            .environment(\.locale, Locale(identifier: "ja_JP"))
                            .frame(width: 120)
                            
                            Spacer()
                                .frame(width: 30)
                            
                            DatePicker("終了",
                                       selection: $addReportViewModel.endTime,
                                       displayedComponents: .hourAndMinute)
                            .environment(\.locale, Locale(identifier: "ja_JP"))
                            .frame(width: 110)
                        }
                        .frame(maxWidth: .infinity)
                    } header: {
                        Text("時間")
                    }
                    .padding(.bottom)
                    .listRowSeparator(.hidden)
                }
                
                HStack {
                    Button {
                        // BodyPoseViewに戻る
                        dismiss()
                    } label: {
                        Text("勉強に戻る")
                            .foregroundColor(Color.white)
                            .padding(15)
                            .frame(width: 150, height: 55)
                            .background(Color.blue)
                            .cornerRadius(15)
                    }
                    .padding(.bottom)
                    
                    Button {
                        // 追加するタスクが有効かチェック
                        if let alert = addReportViewModel.checkTask(task: addReportViewModel.content, startTime: addReportViewModel.startTime, endTime: addReportViewModel.endTime) {
                            // アラート表示
                            showingAlert = alert
                        } else {
                            // 完了したタスクを保存
                            addReportViewModel.editSave()
                            // 画面を閉じる
                            dismiss()
                        }
                    } label: {
                        Text("タスク完了")
                            .foregroundColor(Color.white)
                            .padding(15)
                            .frame(width: 150, height: 55)
                            .background(Color.blue)
                            .cornerRadius(15)
                    }
                    .padding(.bottom)
                    .alert(item: $showingAlert) { item in
                        item.alert
                    }
                }
            }
            .navigationTitle("完了したタスクを修正")
            .navigationBarTitleDisplayMode(.inline)
        }
        // ユーザーが手動で閉じないように処理
        .interactiveDismissDisabled()
        .onAppear {
            // BodyPoseViewから渡されたタスク内容
            addReportViewModel.store(task: addTask)
        }
    }
}

//struct AddReportView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddReportView(, addTask: Task)
//    }
//}
