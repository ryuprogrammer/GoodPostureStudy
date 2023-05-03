//
//  NaviViewModel.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/29.
//

import Foundation

class NaviViewModel: ObservableObject {
    // ナビ用テキスト
    @Published var naviData: Navi = Navi(naviText: "", naviImage: "")
    @Published var isStartStudy = false

    // インスタンスが生成された時に初期化される
    init() {
        naviData = Navi(naviText: "頭から膝まで映るようにスマホを置きましょう。\n\n認識されているときは画面の縁が緑に光ります。", naviImage: "camera")
    }
    // ページ
    private enum page: Int {
        case first = 1
        case second = 2
        case third = 3
        case last = 4
    }

    struct Navi {
        let naviText: String
        let naviImage: String
    }

    func changeNaviText(messagePage: Int) {
        if messagePage <= page.last.rawValue {
            switch messagePage {
            case page.first.rawValue: naviData = Navi(naviText: "「正しい姿勢」とは何でしょうか。\n\nそれは、人間が一番集中できる姿勢のことです。", naviImage: "figure.mind.and.body")
            case page.second.rawValue: naviData = Navi(naviText: "足を組んでいると勉強に集中できません。\n\n足を組んでいるとタイマーがストップします。", naviImage: "figure.highintensity.intervaltraining")
            case page.third.rawValue: naviData = Navi(naviText: "伸びをしている時も同じく\n\nタイマーがストップします。", naviImage: "figure.cooldown")
            case page.last.rawValue: naviData = Navi(naviText: "それでは\n「正しい姿勢」で勉強をしましょう！", naviImage: "figure.dance")
            default: naviData = Navi(naviText: "test", naviImage: "figure.cooldown")
            }
        } else {
            isStartStudy = true
        }
    }
}
