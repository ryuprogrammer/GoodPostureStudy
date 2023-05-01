//
//  Date+.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/05/01.
//

import Foundation

extension Date {
    // Dateから年月日を取得
    func formattedDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.locale = Locale(identifier: "jp_JP")
        let changedDate = dateFormatter.string(from: self)
        return changedDate
    }
}
