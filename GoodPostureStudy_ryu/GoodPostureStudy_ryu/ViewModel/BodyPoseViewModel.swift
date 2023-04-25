//
//  BodyPoseViewModel.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/25.
//

import Foundation

struct Posture {
    // 体の角度
    func postureAngle(bodyPoints: BodyPoints) -> CGFloat {
        // （首、腰、両膝の中間点）の座標
        let neck = bodyPoints.neck
        let root = bodyPoints.root
        let rightKnee = bodyPoints.rightKnee
        let leftKnee = bodyPoints.leftKnee
        let kneesCenter = CGPoint(x: (Double(rightKnee.point.x) + Double(leftKnee.point.x))/2, y: Double(rightKnee.point.y) + Double(leftKnee.point.y)/2)
        
        //角度の中心位置
        let x0 = root.point.x
        let y0 = root.point.y
        //方向指定1
        let x1 = neck.point.x
        let y1 = neck.point.y
        //方向指定2
        let x2 = kneesCenter.x
        let y2 = kneesCenter.y

        //角度計算開始
        let vec1 = [x1-x0, y1-y0]
        let vec2 = [x2-x0, y2-y0]
        let absvec1 = sqrt(pow(vec1[0], 2) + pow(vec1[1], 2))
        let absvec2 = sqrt(pow(vec2[0], 2) + pow(vec2[1], 2))
        let inner = vec1[0] * vec2[0] + vec1[1] * vec2[1]
        let cos_theta = inner / (absvec1 * absvec2)
        let theta = acos(cos_theta) * 180 / .pi
        
        return theta
    }
    
    // 足組みの判定
    func crossLegs(bodyPoints: BodyPoints) -> Bool {
        let rootY = bodyPoints.root.point.y
        let rightKneeY = bodyPoints.rightKnee.point.y
        let leftKneeY = bodyPoints.leftKnee.point.y
        let kneesCenterY = (rightKneeY + leftKneeY)/2
        var isCrossLegs: Bool = false
        
        if rootY >= kneesCenterY {
            isCrossLegs = true
        } else {
            isCrossLegs = false
        }
        
        return isCrossLegs
    }
    
    // 伸びの判定
    func stretch(bodyPoints: BodyPoints) -> Bool {
        let rightWrist = bodyPoints.rightWrist.point.y
        let rightKnee = bodyPoints.rightKnee.point.y
        let rightShoulder = bodyPoints.rightShoulder.point.y
        let leftWrist = bodyPoints.leftWrist.point.y
        let leftKnee = bodyPoints.leftKnee.point.y
        let leftShoulder = bodyPoints.leftShoulder.point.y
        
        var isStretch = false
        
        if rightWrist > rightKnee &&
            rightKnee > rightShoulder &&
            leftWrist > leftKnee &&
            leftKnee > leftShoulder {
            isStretch = true
        }
        return isStretch
    }
}

