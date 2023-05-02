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
    
    // Dateから時間のみ取得
    func formattedTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        dateFormatter.locale = Locale(identifier: "jp_JP")
        let changedTime = dateFormatter.string(from: self)
        return changedTime
    }
    
    // 今日の残り時間を取得
    func getRemainingTimeToday() -> String {
        let calendar = Calendar(identifier: .gregorian)
        let leftHour = 23 - calendar.component(.hour, from: self)
        let leftMinute = 59 - calendar.component(.minute, from: self)
        return "\(leftHour)h \(leftMinute)m"
    }
}
