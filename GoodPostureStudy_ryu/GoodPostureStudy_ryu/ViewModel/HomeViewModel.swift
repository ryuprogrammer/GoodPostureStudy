//
//  HomeViewModel.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/23.
//

import Foundation

class HomeViewModel: ObservableObject {
    // DateFormatterのインスタンス生成
    let dateFormatter = DateFormatter()
    
    // タスク削除メソッド
    func delete(offsets: IndexSet) {
        TaskDataModel.shared.delete(offsets: offsets)
    }
}
