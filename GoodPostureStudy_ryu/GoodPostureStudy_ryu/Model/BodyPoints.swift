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
    let leftEar: Point
    let leftEye: Point
    let rightEar: Point
    let rightEye: Point
    let neck: Point
    let nose: Point
    // 腕
    let leftShoulder: Point
    let rightShoulder: Point
    let leftElbow: Point
    let rightElbow: Point
    let leftWrist: Point
    let rightWrist: Point
    // ウエスト
    let root: Point
    // 脚
    let leftHip: Point
    let rightHip: Point
    let leftKnee: Point
    let rightKnee: Point
}
