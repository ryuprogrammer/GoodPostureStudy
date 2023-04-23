//
//  ColorModel.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/23.
//

import Foundation
import SwiftUI

struct ColorModel {
    static let colorModel = ColorModel()
    enum colorNames: String {
        case red = ".red"
        case yellow = ".yerrow"
        case green = ".green"
        case cyan = ".cyan"
        case blue = ".blue"
    }
    
    func colorChangeToColor(colorName: String) -> Color {
        switch colorName {
        case colorNames.red.rawValue: return .red
        case colorNames.yellow.rawValue: return .yellow
        case colorNames.green.rawValue: return .green
        case colorNames.cyan.rawValue: return .cyan
        case colorNames.blue.rawValue: return .blue
        default: return .blue
        }
    }
    
    func colorChangeToString(color: Color) -> String {
        switch color {
        case .red: return colorNames.red.rawValue
        case .yellow: return colorNames.yellow.rawValue
        case .green: return colorNames.green.rawValue
        case .cyan: return colorNames.cyan.rawValue
        case .blue: return colorNames.blue.rawValue
        default:
            return colorNames.blue.rawValue
        }
    }
}
