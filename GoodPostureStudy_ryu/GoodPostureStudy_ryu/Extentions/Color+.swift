//
//  Color+.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/26.
//

import SwiftUI

extension Color {
    enum TaskColorNames: String {
        case red = ".red"
        case orange = ".orange"
        case green = ".green"
        case cyan = ".cyan"
        case blue = ".blue"
    }

    // initはインスタンス生成時に必ず呼ばれる
    init(taskColorName: TaskColorNames) {
        switch taskColorName {
        case .red: self = .red
        case .orange: self = .orange
        case .green: self = .green
        case .cyan: self = .cyan
        case .blue: self = .blue
        }
    }

    func toCustomColorName() -> TaskColorNames {
        switch self {
        case .red: return .red
        case .orange: return .orange
        case .green: return .green
        case .cyan: return .cyan
        case .blue: return .blue
        default: return .blue
        }
    }
}
