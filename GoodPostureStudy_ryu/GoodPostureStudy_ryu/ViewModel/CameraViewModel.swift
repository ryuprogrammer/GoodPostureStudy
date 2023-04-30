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
    // AVCaptureSessionのインスタンス
    let session = AVCaptureSession()
    // BodyPoseViewに通知するプロパティ
    @Published var bodyPoints: BodyPoints? = nil
    
    override init() {
        super.init()
        do {
            session.sessionPreset = .photo
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
            let input = try AVCaptureDeviceInput(device: device)
            session.addInput(input)
            let output = AVCaptureVideoDataOutput()
            output.setSampleBufferDelegate(self, queue: .main)
            session.addOutput(output)
            let view = UIView(frame: UIScreen.main.bounds)
            addPreviewLayer(to: view)
            session.commitConfiguration()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // キャプチャセッションから得られたカメラ映像を表示するためのレイヤーを追加するメソッド
    func addPreviewLayer(to view: UIView) {
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.frame = UIScreen.main.bounds
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer) // UIViewにAVCaptureVideoPreviewLayerを追加
    }
    
    // キャプチャを開始
    func start() {
        if session.isRunning == false {
            // 非同期処理をバックグラウンドスレッドで実行
            DispatchQueue.global().async {
                self.session.startRunning()
            }
        }
    }
    
    // AVCaptureVideoDataOutputから取得した動画フレームからてのジェスチャーを検出するメソッド
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let request = VNDetectHumanBodyPoseRequest()
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:])
        
        do {
            try handler.perform([request])
            
            guard let observation = request.results?.first as? VNHumanBodyPoseObservation else { return }
            
            let leftEar = try observation.recognizedPoint(VNHumanBodyPoseObservation.JointName.leftEar)
            let leftEye = try observation.recognizedPoint(VNHumanBodyPoseObservation.JointName.leftEye)
            let rightEar = try observation.recognizedPoint(VNHumanBodyPoseObservation.JointName.rightEar)
            let rightEye = try observation.recognizedPoint(VNHumanBodyPoseObservation.JointName.rightEye)
            let neck = try observation.recognizedPoint(VNHumanBodyPoseObservation.JointName.neck)
            let nose = try observation.recognizedPoint(VNHumanBodyPoseObservation.JointName.nose)
            let leftShoulder = try observation.recognizedPoint(VNHumanBodyPoseObservation.JointName.leftShoulder)
            let rightShoulder = try observation.recognizedPoint(VNHumanBodyPoseObservation.JointName.rightShoulder)
            let leftElbow = try observation.recognizedPoint(VNHumanBodyPoseObservation.JointName.leftElbow)
            let rightElbow = try observation.recognizedPoint(VNHumanBodyPoseObservation.JointName.rightElbow)
            let leftWrist = try observation.recognizedPoint(VNHumanBodyPoseObservation.JointName.leftWrist)
            let rightWrist = try observation.recognizedPoint(VNHumanBodyPoseObservation.JointName.rightWrist)
            let root = try observation.recognizedPoint(VNHumanBodyPoseObservation.JointName.root)
            let leftHip = try observation.recognizedPoint(VNHumanBodyPoseObservation.JointName.leftHip)
            let rightHip = try observation.recognizedPoint(VNHumanBodyPoseObservation.JointName.rightHip)
            let leftKnee = try observation.recognizedPoint(VNHumanBodyPoseObservation.JointName.leftKnee)
            let rightKnee = try observation.recognizedPoint(VNHumanBodyPoseObservation.JointName.rightKnee)
            // ここを埋める
            bodyPoints = BodyPoints(leftEar: Point(point: pointChange(point: leftEar.location), confidance: leftEar.confidence),
                           leftEye: Point(point: pointChange(point: leftEye.location), confidance: leftEye.confidence),
                           rightEar: Point(point: pointChange(point: rightEar.location), confidance: rightEar.confidence),
                           rightEye: Point(point: pointChange(point: rightEye.location), confidance: rightEye.confidence),
                           neck: Point(point: pointChange(point: neck.location), confidance: neck.confidence),
                           nose: Point(point: pointChange(point: nose.location), confidance: nose.confidence),
                           leftShoulder: Point(point: pointChange(point: leftShoulder.location), confidance: leftShoulder.confidence),
                           rightShoulder: Point(point: pointChange(point: rightShoulder.location), confidance: rightShoulder.confidence),
                           leftElbow: Point(point: pointChange(point: leftElbow.location), confidance: leftElbow.confidence),
                           rightElbow: Point(point: pointChange(point: rightElbow.location), confidance: rightElbow.confidence),
                           leftWrist: Point(point: pointChange(point: leftWrist.location), confidance: leftWrist.confidence),
                           rightWrist: Point(point: pointChange(point: rightWrist.location), confidance: rightWrist.confidence),
                           root: Point(point: pointChange(point: root.location), confidance: root.confidence),
                           leftHip: Point(point: pointChange(point: leftHip.location), confidance: leftHip.confidence),
                           rightHip: Point(point: pointChange(point: rightHip.location), confidance: rightHip.confidence),
                           leftKnee: Point(point: pointChange(point: leftKnee.location), confidance: leftKnee.confidence),
                           rightKnee: Point(point: pointChange(point: rightKnee.location), confidance: rightKnee.confidence))
        } catch {
            print("Error detecting body pose: \(error.localizedDescription)")
        }
        
        // 画面上の点とカメラに映る体の点の位置を合わせる
        func pointChange(point: CGPoint) -> CGPoint {
            let normalizedPoint = CGPoint(x: 1 - point.x*1.3, y: 1 - point.y*1.1)
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height
            
            let x = normalizedPoint.x * width * 1.5
            let y = normalizedPoint.y * height
            
            return CGPoint(x: x, y: y)
        }
    }
}
