//
//  CircularTimeBarViewModel.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/05/02.
//

import Foundation

struct CircularTimeBarViewModel {
    // タスクのstartTimeが今日か判定
    func isEqualToDate(startTime: Date) -> Bool {
        let nowDate = Date()
        let nowDateString = nowDate.formattedDateString()
        let startTimeString = startTime.formattedDateString()
        
        if nowDateString == startTimeString {
            return true
        } else {
            return false
        }
    }
}
