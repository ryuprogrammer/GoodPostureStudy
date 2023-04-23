//
//  CircularTimeBarViewModel.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/23.
//

import Foundation
import SwiftUI

class CircularTimeBarViewModel: ObservableObject {
    func colorChangeToColor(colorName: String) -> Color {
        return ColorModel.colorModel.colorChangeToColor(colorName: colorName)
    }
}