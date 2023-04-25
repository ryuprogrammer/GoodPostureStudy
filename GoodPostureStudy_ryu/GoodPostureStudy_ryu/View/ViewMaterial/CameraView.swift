//
//  CameraView.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/25.
//

import SwiftUI

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
