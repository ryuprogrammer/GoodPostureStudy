//
//  Task+CoreDataProperties.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/22.
//
//

import Foundation
import CoreData

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var task: String?
    @NSManaged public var color: String?
    @NSManaged public var startTime: Date?
    @NSManaged public var endTime: Date?
    @NSManaged public var isDone: Bool

}

extension Task : Identifiable {

}
