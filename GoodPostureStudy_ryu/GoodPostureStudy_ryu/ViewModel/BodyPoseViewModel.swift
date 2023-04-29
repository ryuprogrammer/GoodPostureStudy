//
//  BodyPoseViewModel.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/25.
//

import Foundation
import UIKit

class BodyPoseViewModel: ObservableObject {
    // 勉強のタイマーのオンオフ
    @Published var isTimer: Bool = true
    // タイマーを止めた理由
    @Published var alertText: String = ""
    // 画面に表示する勉強時間
    @Published var showStudyTime: String = ""
    // タイムバーの進捗割合
    @Published var timeCircleRatio: CGFloat = 0.0
    // BodyPointsが全て検知できているか
    var isDetectAllBodyPoints: Bool = false
    // 残り時間
    var timeLeft: Double = 0.0
    // PostureModelのインスタンス生成
    let postureModel = PostureModel()
    // Calender()のインスタンス生成（グレゴリオ暦を採用）
    let calender = Calendar(identifier: .gregorian)
    // 時間表示の書式を設定
    let formatter = DateComponentsFormatter()
    init() {
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
    }

    // MARK: - メソッド
    // 開始時間と終了時間から勉強時間（allTime）を算出
    func calculateAllTime(startTime: Date, endTime: Date) -> Double {
        var allTime: Double = 0.0
        if let time = calender.dateComponents([.second], from: startTime, to: endTime).second {
            allTime = Double(time)
        }
        return allTime
    }
    
    // 残り時間（timeLeft）を計算
    func calculateTimeLeft(startTime: Date, studyTime: Date?, studyTimeCount: Int) {
        if let time = studyTime,
           let second = calender.dateComponents([.second],
                                                from: startTime,
                                                to: time + TimeInterval(studyTimeCount)).second {
            timeLeft = Double(second)
        }
    }
    
    // 勉強時間、画面に表示するテキストを更新
    func studyTimeText(studyTimeCount: Int, allTime: Double) {
        // 開始時間から終了時間までの秒数
        let allTimeSecond = Int(allTime) * 60
        
        if studyTimeCount < allTimeSecond {
            if let timeText = formatter.string(from: timeLeft) {
                // 勉強時間を表示
                showStudyTime = timeText
            }
        } else if studyTimeCount > allTimeSecond {
            // 勉強終了
            showStudyTime = "finish"
        }
    }
    
    // BodyPointsが全て認識されているかチェック
    func detectAllBodyPoints(bodyPoints: BodyPoints?) {
        isDetectAllBodyPoints = true
        // bodyPointsをアンラップ
        if let points = bodyPoints {
            // pointの信頼度が全て０でないことを確認→全てのpointが認識されている
            for point in points.points {
                if point.confidance > 0 {
                    isDetectAllBodyPoints = true
                } else {
                    isDetectAllBodyPoints = false
                }
            }
        }
    }
    
    // 体のポーズによってタイマーを止める
    func stopTimer(bodyPoints: BodyPoints?) {
        // 足組み
        var isCrossLegs: Bool = false
        // 伸び
        var isStretch: Bool = false
        
        if let points = bodyPoints {
            isCrossLegs = postureModel.crossLegs(bodyPoints: points)
            isStretch = postureModel.stretch(bodyPoints: points)

            if isDetectAllBodyPoints {
                if isCrossLegs && isStretch {
                    isTimer = false
                    alertText = "伸びをして足を組んでいるためタイマーを止めています。"
                } else if isCrossLegs {
                    isTimer = false
                    alertText = "足を組んでいるためタイマーを止めています。"
                } else if isStretch {
                    isTimer = false
                    alertText = "伸びをしているのでタイマーを止めています。"
                } else {
                    isTimer = true
                    alertText = "正しい姿勢です！"
                }
            } else {
                // 体が認識されていない場合
                isTimer = false
                alertText = "体全体を映してください。"
            }
        }
    }
}
