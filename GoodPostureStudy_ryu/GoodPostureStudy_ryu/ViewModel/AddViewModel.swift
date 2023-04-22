//
//  AddViewModel.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/23.
//

import Foundation

class AddViewModel: ObservableObject {
    @Published var task: Task?
    
    func add(task: Task) {
        TaskDataModel.shared.save(task: task)
    }
}
