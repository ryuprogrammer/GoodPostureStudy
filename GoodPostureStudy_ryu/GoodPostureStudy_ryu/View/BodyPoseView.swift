//
//  BodyPoseView.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/24.
//

import SwiftUI
import AVFoundation
import Vision

struct BodyPoseView: View {
    // CameraModelのインスタンス生成
    @ObservedObject var camera = CameraModel()
    // Postureのインスタンス生成
    @State var posture = Posture()
    // 背骨の角度
    @State var bodyAngle: CGFloat = 0
    // 足を組んでいるか
    @State var isCrossLegs: Bool = false
    
    @State private var timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack {
            CameraView(camera: camera)
                .ignoresSafeArea(.all)
            
            BodyLineView(bodyPoints: camera.bodyPoints)
            
            MaskView()
            
//            VStack {
//                Text("体の角度")
//                    .bold()
//                    .font(.system(size: 60))
//                    .foregroundColor(Color.white)
//                Text("\(bodyAngle)°")
//                    .bold()
//                    .font(.system(size: 50))
//                    .foregroundColor(Color.white)
//
//                Text("足を組んで\(isCrossLegs ? "る":"ない")")
//                    .bold()
//                    .font(.system(size: 50))
//                    .foregroundColor(Color.white)
//            }
        }
        .onReceive(timer) { _ in
            if let points: BodyPoints = camera.bodyPoints {
                bodyAngle = posture.postureAngle(bodyPoints: points)
                isCrossLegs = posture.crossLegs(bodyPoints: points)
            }
        }
    }
}

struct Posture {
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
}

// カメラのプレビューレイヤーを設定
struct CameraView: UIViewRepresentable {
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let previewView = UIView(frame: UIScreen.main.bounds)
        camera.addPreviewLayer(to: previewView)
        context.coordinator.camera = camera // CoordinatorにCameraModelを渡す
        return previewView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // ここでは何もしない。
    }
    
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(camera: camera)
        return coordinator
    }
    
    class Coordinator: NSObject {
        @ObservedObject var camera: CameraModel // CameraModelを監視可能にするために@ObservedObjectを追加
        
        init(camera: CameraModel) {
            self.camera = camera
        }
    }
}

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
                    // 右膝から右足首
                    if bodyPoints.rightKnee.confidance > 0 && bodyPoints.rightAnkle.confidance > 0 {
                        path.move(to: bodyPoints.rightKnee.point)
                        path.addLine(to: bodyPoints.rightAnkle.point)
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
                    // 左膝から左足首
                    if bodyPoints.leftKnee.confidance > 0 && bodyPoints.leftAnkle.confidance > 0 {
                        path.move(to: bodyPoints.leftKnee.point)
                        path.addLine(to: bodyPoints.leftAnkle.point)
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

// 体の線を引く
struct BodyLine: Shape {
    var bodyPoints: BodyPoints?
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
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
            // 右膝から右足首
            if bodyPoints.rightKnee.confidance > 0 && bodyPoints.rightAnkle.confidance > 0 {
                path.move(to: bodyPoints.rightKnee.point)
                path.addLine(to: bodyPoints.rightAnkle.point)
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
            // 左膝から左足首
            if bodyPoints.leftKnee.confidance > 0 && bodyPoints.leftAnkle.confidance > 0 {
                path.move(to: bodyPoints.leftKnee.point)
                path.addLine(to: bodyPoints.leftAnkle.point)
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
        path = path.strokedPath(.init(lineWidth: 10, lineCap: .round, lineJoin: .round))
        
        return path
    }
}

class CameraModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    let session = AVCaptureSession()
    // BodyPoseViewに通知するプロパティ
    @Published var bodyPoints: BodyPoints? = nil
    
    override init() {
        super.init()
        do {
            session.sessionPreset = .photo
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            let input = try AVCaptureDeviceInput(device: device!)
            session.addInput(input)
            let output = AVCaptureVideoDataOutput()
            output.setSampleBufferDelegate(self, queue: .main)
            session.addOutput(output)
            let view = UIView(frame: UIScreen.main.bounds)
            addPreviewLayer(to: view)
            session.commitConfiguration()
            session.startRunning()
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
            let leftAnkle = try observation.recognizedPoint(VNHumanBodyPoseObservation.JointName.leftAnkle)
            let rightAnkle = try observation.recognizedPoint(VNHumanBodyPoseObservation.JointName.rightAnkle)
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
                           rightKnee: Point(point: pointChange(point: rightKnee.location), confidance: rightKnee.confidence),
                           leftAnkle: Point(point: pointChange(point: leftAnkle.location), confidance: leftAnkle.confidence),
                           rightAnkle: Point(point: pointChange(point: rightAnkle.location), confidance: rightAnkle.confidence))
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
            
            print("point:\(point)")
            print("normalizedPoint:\(normalizedPoint)")
            print("pointChange:\(CGPoint(x: normalizedPoint.x, y: normalizedPoint.y))")
            
            return CGPoint(x: x, y: y)
        }
    }
}

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
            leftHip, rightHip, leftKnee, rightKnee, leftAnkle, rightAnkle
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
    var leftAnkle: Point
    var rightAnkle: Point
}
