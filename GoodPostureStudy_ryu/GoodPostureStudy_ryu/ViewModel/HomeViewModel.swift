//
//  HomeViewModel.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/23.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    // DateFormatterのインスタンス生成
    let dateFormatter = DateFormatter()
    
    // タスク削除メソッド
    func delete(offsets: IndexSet) {
        TaskDataModel.shared.delete(offsets: offsets)
    }
    
    func colorChangeToColor(colorName: String) -> Color {
        return ColorModel.colorModel.colorChangeToColor(colorName: colorName)
    }
    
    func dateString(date: Date) -> String {
        // カレンダー、ロケール、タイムゾーンの設定（未指定時は端末の設定が採用される）
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "jp_JP")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        
        // 変換フォーマット定義（未定義の場合は自動フォーマットが採用される）
        dateFormatter.dateFormat = "H:mm"
        // データ変換（Date→テキスト）
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
}
