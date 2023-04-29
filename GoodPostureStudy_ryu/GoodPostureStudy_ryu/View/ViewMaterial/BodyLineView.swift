//
//  BodyLineView.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/25.
//

import SwiftUI

struct BodyLineView: View {
    var bodyPoints: BodyPoints?
    var body: some View {
        ZStack {
            Path { path in
                if let bodyPoints = bodyPoints {
                    // MARK: - 右半身
                    // 右手首から右肘
                    if bodyPoints.rightWrist.confidance > 0 && bodyPoints.rightElbow.confidance > 0 {
                        path.move(to: bodyPoints.rightWrist.point)
                        path.addLine(to: bodyPoints.rightElbow.point)
                    }
                    // 右肘から右肩
                    if bodyPoints.rightElbow.confidance > 0 && bodyPoints.rightShoulder.confidance > 0 {
                        path.move(to: bodyPoints.rightElbow.point)
                        path.addLine(to: bodyPoints.rightShoulder.point)
                    }
                    // 右肩から右腰
                    if bodyPoints.rightShoulder.confidance > 0 && bodyPoints.rightHip.confidance > 0 {
                        path.move(to: bodyPoints.rightShoulder.point)
                        path.addLine(to: bodyPoints.rightHip.point)
                    }
                    // 右腰から右膝
                    if bodyPoints.rightHip.confidance > 0 && bodyPoints.rightKnee.confidance > 0 {
                        path.move(to: bodyPoints.rightHip.point)
                        path.addLine(to: bodyPoints.rightKnee.point)
                    }
                    // MARK: - 左半身
                    // 左手首から左肘
                    if bodyPoints.leftWrist.confidance > 0 && bodyPoints.leftElbow.confidance > 0 {
                        path.move(to: bodyPoints.leftWrist.point)
                        path.addLine(to: bodyPoints.leftElbow.point)
                    }
                    // 左肘から左肩
                    if bodyPoints.leftElbow.confidance > 0 && bodyPoints.leftShoulder.confidance > 0 {
                        path.move(to: bodyPoints.leftElbow.point)
                        path.addLine(to: bodyPoints.leftShoulder.point)
                    }
                    // 左肩から左腰
                    if bodyPoints.leftShoulder.confidance > 0 && bodyPoints.leftHip.confidance > 0 {
                        path.move(to: bodyPoints.leftShoulder.point)
                        path.addLine(to: bodyPoints.leftHip.point)
                    }
                    // 左腰から左膝
                    if bodyPoints.leftHip.confidance > 0 && bodyPoints.leftKnee.confidance > 0 {
                        path.move(to: bodyPoints.leftHip.point)
                        path.addLine(to: bodyPoints.leftKnee.point)
                    }
                    // MARK: - その他
                    // 右肩から首
                    if bodyPoints.rightShoulder.confidance > 0 && bodyPoints.neck.confidance > 0 {
                        path.move(to: bodyPoints.rightShoulder.point)
                        path.addLine(to: bodyPoints.neck.point)
                    }
                    // 左肩から首
                    if bodyPoints.leftShoulder.confidance > 0 && bodyPoints.neck.confidance > 0 {
                        path.move(to: bodyPoints.leftShoulder.point)
                        path.addLine(to: bodyPoints.neck.point)
                    }
                    // 右腰から左腰
                    if bodyPoints.rightHip.confidance > 0 && bodyPoints.leftHip.confidance > 0 {
                        path.move(to: bodyPoints.rightHip.point)
                        path.addLine(to: bodyPoints.leftHip.point)
                    }
                    // 首から鼻
                    if bodyPoints.neck.confidance > 0 && bodyPoints.nose.confidance > 0 {
                        path.move(to: bodyPoints.neck.point)
                        path.addLine(to: bodyPoints.nose.point)
                    }
                }
            }
            .strokedPath(.init(lineWidth: 10, lineCap: .round, lineJoin: .round))
            .fill(LinearGradient(gradient: Gradient(colors: [.blue, .pink, .purple]), startPoint: .top, endPoint: .bottom))
            
            ForEach(bodyPoints?.points ?? []) { point in
                if point.confidance > 0 {
                    Circle()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                        .position(point.point)
                }
            }
        }
    }
}
