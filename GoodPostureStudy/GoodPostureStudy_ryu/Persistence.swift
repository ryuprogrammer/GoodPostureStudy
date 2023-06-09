//
//  Persistence.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/22.
//

import CoreData

struct PersistenceController {
    // シングルトン化
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let calender = Calendar(identifier: .gregorian)
        for _ in 0 ..< 10 {
            let newTask = Task(context: viewContext)
            newTask.startTime = calender.date(from: DateComponents(year: 2020, month: 4, day: 10, hour: 10, minute: 0, second: 0))!
            newTask.endTime = calender.date(from: DateComponents(year: 2020, month: 4, day: 10, hour: 14, minute: 0, second: 0))!
            newTask.color = "blue"
            newTask.task = "日曜日もプログラミング"
            newTask.isDone = false
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "GoodPostureStudy_ryu")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
