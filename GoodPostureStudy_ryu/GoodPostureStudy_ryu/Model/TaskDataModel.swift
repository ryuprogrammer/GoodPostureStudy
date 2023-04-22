//
//  TaskDataModel.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/22.
//

import Foundation
import CoreData
import SwiftUI

class TaskDataModel {
    // シングルトン化
    static let shared = TaskDataModel()
    
    // CoreDataを扱うためのPresistanceControllerクラスのインスタンス生成
    private var controller: PersistenceController = {
        // シングルトンを返却
        return PersistenceController.shared
    }()
    
    // 管理対象のオブジェクトの変更・追跡のためのオブジェクト
    private var viewContext: NSManagedObjectContext {
        return controller.container.viewContext
    }
    
    private var task: Task?
    
    // CoreDataからデータ取得
    func fetchAll() -> [Task] {
        let request = NSFetchRequest<Task>(entityName: "Task")
        
        do {
            return try viewContext.fetch(request)
        } catch {
            fatalError("CoreDataからデータ取得失敗")
        }
    }
    
    // データを追加するメソッド
    func save(task: Task) {
        let newTask = Task(context: viewContext)
        newTask.task = task.task
        newTask.color = task.color
        newTask.startTime = task.startTime
        newTask.endTime = task.endTime
        newTask.isDone = task.isDone
        
        do {
            try viewContext.save()
        } catch {
            fatalError("データ保存失敗")
        }
    }
    
    // データを削除するメソッド
    func delete(offsets: IndexSet) {
        let tasks = fetchAll()
        for index in offsets {
            viewContext.delete(tasks[index])
        }
        
        do {
            try viewContext.save()
        } catch {
            fatalError("データ削除失敗")
        }
    }
    
    // 編集内容を保存するメソッド
    func editSave() {
        do {
            try viewContext.save()
        } catch {
            fatalError("CoreDataからデータ取得失敗")
        }
    }
}
