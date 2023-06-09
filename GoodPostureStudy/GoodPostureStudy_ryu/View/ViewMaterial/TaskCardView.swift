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
    // タスクの色
    @State var taskColor: Color = .blue
    // タスク内容
    @State var taskContent: String = ""
    // 開始時間
    @State var startTime: Date = Date()
    // 終了時間
    @State var endTime: Date = Date()

    var body: some View {
        HStack(spacing: 30) {
            Image(systemName: "highlighter")
                .resizable()
                .scaledToFit()
                .padding(8)
                .foregroundColor(.white)
                .frame(width: 45, height: 45)
                .background(taskColor.opacity(0.5))
                .cornerRadius(8)
                .shadow(color: taskColor, radius: 5, x: 3, y: 3)
                .shadow(color: .white.opacity(0.5), radius: 5, x: -3, y: -3)
                .padding(.leading, 25)

            VStack {
                Text(taskContent)
                    .font(.system(size: 18))
                    .bold()

                Text("\(startTime.formattedTimeString())〜\(endTime.formattedTimeString())")
                    .font(.system(size: 15))
            }
            .frame(width: 130)

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
            .padding(.trailing, 25)
            .disabled(task.isDone)
        }
        .onAppear {
            // Taskのデータをアンラップ
            guard let color = task.color,
                  let colorName = Color.TaskColorNames(rawValue: color),
                  let content = task.task,
                  let start = task.startTime,
                  let end = task.endTime else {
                return
            }

            taskColor = Color(taskColorName: colorName)
            taskContent = content
            startTime = start
            endTime = end
        }
    }
}
