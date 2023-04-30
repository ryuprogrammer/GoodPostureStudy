//
//  AddViewModel.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/23.
//

import CoreData
import SwiftUI

class AddViewModel: ObservableObject {
    @Published var task: String = ""
    @Published var color: String = ""
    @Published var startTime: Date = Date()
    @Published var endTime: Date = Date() + (60*60)
    
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
    
    func add(task: String, color: String, startTime: Date, endTime: Date) {
        TaskDataModel.shared.add(task: task, color: color, startTime: startTime, endTime: endTime)
    }
}
