//
//  CameraModel.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/25.
//

import Foundation
import Vision

struct Point: Identifiable {
    let id: UUID = UUID()
    let point: CGPoint
    let confidance: VNConfidence
}

struct BodyPoints {
    // まとめ
    var points: [Point] {
        return [
            leftEar, leftEye, rightEar, rightEye, neck, nose,
            leftShoulder, rightShoulder, leftElbow, rightElbow, rightWrist, leftWrist,
            root,
            leftHip, rightHip, leftKnee, rightKnee
        ]
    }
    // 頭
    var leftEar: Point
    var leftEye: Point
    var rightEar: Point
    var rightEye: Point
    var neck: Point
    var nose: Point
    // 腕
    var leftShoulder: Point
    var rightShoulder: Point
    var leftElbow: Point
    var rightElbow: Point
    var leftWrist: Point
    var rightWrist: Point
    // ウエスト
    var root: Point
    // 脚
    var leftHip: Point
    var rightHip: Point
    var leftKnee: Point
    var rightKnee: Point
}
