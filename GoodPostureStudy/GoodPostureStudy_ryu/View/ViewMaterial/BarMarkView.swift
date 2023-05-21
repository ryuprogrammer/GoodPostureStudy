//
//  BarMarkView.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/05/01.
//

import SwiftUI
import Charts

struct BarMarkView: View {
    // BarMarkViewModelのインスタンス生成
    @StateObject var barMarkViewModel = BarMarkViewModel()
    // データの取得処理
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "startTime", ascending: true)], animation: .spring())

    var tasks: FetchedResults<Task>
    var body: some View {
        // Chartを表示
        Chart(barMarkViewModel.reportData) { data in
            BarMark(x: .value("日付", data.day), y: .value("数値", data.timeCount))
        }
        .frame(height: 200)
        .padding()
        .chartYAxisLabel("時間")
        .onAppear {
            barMarkViewModel.fetchReport(tasks: tasks)
        }
    }
}

struct BarMarkView_Previews: PreviewProvider {
    static var previews: some View {
        BarMarkView()
    }
}
