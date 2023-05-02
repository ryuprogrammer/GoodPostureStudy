//
//  TaskCardView.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/05/03.
//

import SwiftUI

struct TaskCardView: View {
    @Binding var selectedTask: Task?
    // タスク
    @State var task: Task
    
    var body: some View {
        HStack {
            Image(systemName: "highlighter")
                .resizable()
                .scaledToFit()
                .padding(8)
                .foregroundColor(.white)
                .frame(width: 45, height: 45)
                .background(Color(taskColorName: Color.TaskColorNames(rawValue: task.color!)!).opacity(0.5))
                .cornerRadius(8)
                .shadow(color: Color(taskColorName: Color.TaskColorNames(rawValue: task.color!)!), radius: 5, x: 3, y: 3)
                .shadow(color: .white.opacity(0.5), radius: 5, x: -3, y: -3)
            
            VStack {
                Text(task.task!)
                    .font(.system(size: 20))
                    .bold()
                
                Text("\(task.startTime!.formattedTimeString())〜\(task.endTime!.formattedTimeString())")
                    .font(.system(size: 15))
            }
            .frame(width: 200)
            
            Button {
                if task.isDone == false {
                    selectedTask = task
                }
            } label: {
                Text(task.isDone ? "完了しました！" : "スタート")
                    .font(.system(size: 15))
                    .frame(width: 120, height: 40)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(13)
            }
            .disabled(task.isDone)
        }
    }
}
