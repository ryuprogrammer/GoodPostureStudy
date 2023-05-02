//
//  ReportViewModel.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/28.
//

import Foundation

class ReportViewModel {
    // タスク削除メソッド
    func delete(offsets: IndexSet) {
        TaskDataModel.shared.delete(offsets: offsets)
    }
}
