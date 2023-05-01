//
//  BarMarkViewModel.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/05/01.
//

import Foundation
import SwiftUI

class BarMarkViewModel: ObservableObject {
    // Calender()のインスタンス生成（グレゴリオ暦を採用）
    let calender = Calendar(identifier: .gregorian)
    // Chart用構造体
    struct Report: Identifiable {
        let id = UUID()
        // 日付
        let day: String
        // 1日の合計勉強時間
        let timeCount: Double
    }
    // Chart用Data
    @Published var reportData: [Report] = []
    
    // startTimeとendTimeから時差を求める
    // 開始時間と終了時間から勉強時間（allTime）を算出
    func calculateAllTime(startTime: Date, endTime: Date) -> Double {
        var allTime: Double = 0.0
        if let time = calender.dateComponents([.second], from: startTime, to: endTime).second {
            allTime = Double(time)/(60*60)
        }
        return allTime
    }
    
    // taskから今日+過去6日分の勉強データをreportDataに格納
    func fetchReport(tasks: FetchedResults<Task>) {
        // データの初期化
        reportData = []
        // 勉強の合計時間
        var todayStudyTime: Double = 0
        var yesterdayStudyTime: Double = 0
        var twoDaysAgoStudyTime: Double = 0
        var threeDaysAgoStudyTime: Double = 0
        var fourDaysAgoStudyTime: Double = 0
        var fiveDaysAgoStudyTime: Double = 0
        var sixDaysAgoStudyTime: Double = 0
        // 過去6日+今日の年月日を取得
        let days = sixDaysAgoDates()
        // チャートのx軸（日付）
        let today: String = String(days.first(where: { $1 == 0 })!.key.suffix(5))
        let yesterday: String = String(days.first(where: { $1 == 1 })!.key.suffix(5))
        let twoDaysAgo: String = String(days.first(where: { $1 == 2 })!.key.suffix(5))
        let threeDaysAgo: String = String(days.first(where: { $1 == 3 })!.key.suffix(5))
        let fourDaysAgo: String = String(days.first(where: { $1 == 4 })!.key.suffix(5))
        let fiveDaysAgo: String = String(days.first(where: { $1 == 5 })!.key.suffix(5))
        let sixDaysAgo: String = String(days.first(where: { $1 == 6 })!.key.suffix(5))
        
        for task in tasks {
            guard let startTime = task.startTime else { return }
            guard let endTime = task.endTime else { return }
            // １つのタスクの合計時間を計算
            let studyTime = calculateAllTime(startTime: startTime, endTime: endTime)
            // startTimeをString型の年月日に変換
            let stringDay = startTime.formattedDateString()
            // startTimeの今日を基準とした経過日数
            guard let dayElapsed = daySinceToday(stringDay: stringDay) else { return }
            // タスクが完了しているか
            if task.isDone {
                // タスクの経過日数でデータを分ける
                switch dayElapsed {
                case 0: todayStudyTime += studyTime
                case 1: yesterdayStudyTime += studyTime
                case 2: twoDaysAgoStudyTime += studyTime
                case 3: threeDaysAgoStudyTime += studyTime
                case 4: fourDaysAgoStudyTime += studyTime
                case 5: fiveDaysAgoStudyTime += studyTime
                case 6: sixDaysAgoStudyTime += studyTime
                default: break
                }
            }
        }
        // 過去6日+今日のチャートデータ
        let todaysReport = Report(day: today, timeCount: todayStudyTime)
        let yesterdaysReport = Report(day: yesterday, timeCount: yesterdayStudyTime)
        let twoDaysAgoReport = Report(day: twoDaysAgo, timeCount: twoDaysAgoStudyTime)
        let threeDaysAgoReport = Report(day: threeDaysAgo, timeCount: threeDaysAgoStudyTime)
        let fourDaysAgoReport = Report(day: fourDaysAgo, timeCount: fourDaysAgoStudyTime)
        let fiveDaysAgoReport = Report(day: fiveDaysAgo, timeCount: fiveDaysAgoStudyTime)
        let sixDaysAgoReport = Report(day: sixDaysAgo, timeCount: sixDaysAgoStudyTime)
        // チャートデータを追加
        reportData.append(contentsOf: [sixDaysAgoReport,
                                       fiveDaysAgoReport,
                                       fourDaysAgoReport,
                                       threeDaysAgoReport,
                                       twoDaysAgoReport,
                                       yesterdaysReport,
                                       todaysReport])
    }
    
    // 今日から5日前までの年月日を取得
    func sixDaysAgoDates() -> [String: Int] {
        let day: Double = 60*60*24
        let days: [String: Int] = [
            Date().formattedDateString(): 0, // 今日
            (Date() - day).formattedDateString(): 1, // 昨日
            (Date() - 2*day).formattedDateString(): 2, // 2日前
            (Date() - 3*day).formattedDateString(): 3, // 3日前
            (Date() - 4*day).formattedDateString(): 4, // 4日前
            (Date() - 5*day).formattedDateString(): 5, // 5日前
            (Date() - 6*day).formattedDateString(): 6 // 6日前
        ]
        return days
    }
    
    // 年月日から経過日数を計算
    func daySinceToday(stringDay: String) -> Int? {
        let days = sixDaysAgoDates()
        // 経過日数
        var dayElapsed: Int?
        for day in days {
            if day.key == stringDay {
                dayElapsed = day.value
            }
        }
        return dayElapsed
    }
}
