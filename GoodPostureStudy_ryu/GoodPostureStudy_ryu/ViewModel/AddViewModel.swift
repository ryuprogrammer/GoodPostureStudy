//
//  AddViewModel.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/23.
//

import Foundation
import CoreData

class AddViewModel: ObservableObject {
    @Published var task: Task?
    @Published var task2: String = ""
    @Published var color: String = ""
    @Published var startTime: Date = Date()
    @Published var endTime: Date = Date() + (60*60)
    
    func add(task: Task) {
        TaskDataModel.shared.save(task: task)
    }
    
    func add2(task: String, color: String, startTime: Date, endTime: Date, isDone: Bool) {
        TaskDataModel.shared.add(task: task, color: color, startTime: startTime, endTime: endTime, isDone: isDone)
    }
}
