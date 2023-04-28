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
    
    // 編集するタスク内容を渡す
    func store(task: Task) {
        self.task = task
        content = task.task ?? ""
        color = task.color ?? ""
        startTime = task.startTime ?? Date()
        endTime = task.endTime ?? Date() + (60*60)
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
