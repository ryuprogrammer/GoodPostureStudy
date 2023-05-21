//
//  GoodPostureStudy_ryuApp.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/22.
//

import SwiftUI

@main
struct GoodPostureStudy_ryuApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            StartUpView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
