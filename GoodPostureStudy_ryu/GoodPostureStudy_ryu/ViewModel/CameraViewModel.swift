//
//  CameraViewModel.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/30.
//

import Foundation
import UIKit
import AVFoundation
import Vision

class CameraViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    // CameraModelインスタンス
    let cameraModel = CameraModel()
    // BodyPoseViewに通知するプロパティ
    @Published var bodyPoints: BodyPoints? = nil
    
    // キャプチャを開始
    func start() {
        if cameraModel.session.isRunning == false {
            // 非同期処理をバックグラウンドスレッドで実行
            DispatchQueue.global().async {
                self.cameraModel.session.startRunning()
            }
        }
    }
}
