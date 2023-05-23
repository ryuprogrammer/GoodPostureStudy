//
//  AddReportViewModel.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/28.
//

import Foundation
import CoreData
import SwiftUI

class AddReportViewModel: ObservableObject {
    @Published var content: String = ""
    @Published var color: String = ""
    @Published var startTime: Date = Date()
    @Published var endTime: Date = Date() + (60*60)
    private var task: Task?

    struct AlertItem: Identifiable {
        var id = UUID()
        var alert: Alert
    }

    // 追加するタスクが有効かチェック
    func checkTask(task: String, startTime: Date, endTime: Date) -> AlertItem? {
        var showingAlert: AlertItem?
        if task == "" { // タスクが空欄
            showingAlert = AlertItem(alert: Alert(title: Text("やることの項目でエラー"), message: Text("やることを入力してください。")))
        } else if startTime > endTime { // 開始時間が終了時間よりも早い
            showingAlert = AlertItem(alert: Alert(title: Text("時間の項目でエラー"), message: Text("開始時間よりも終了時間が早いです。")))
        }
        return showingAlert
    }

    // 編集するタスク内容を渡す
    func store(task: Task) {
        self.task = task
        if let taskCantent = task.task,
           let taskColor = task.color,
           let taskStartTime = task.startTime,
           let taskEndTime = task.endTime {
            content = taskCantent
            color = taskColor
            startTime = taskStartTime
            endTime = taskEndTime
        }
    }

    // 編集したタスク内容を保存
    func editSave() {
        task?.task = content
        task?.color = color
        task?.startTime = startTime
        task?.endTime = endTime
        task?.isDone = true
        TaskDataModel.shared.editSave()
    }
}
