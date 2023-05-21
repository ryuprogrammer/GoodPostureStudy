//
//  HomeView.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/23.
//

import SwiftUI

struct HomeView: View {
    // データの取得処理
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "startTime", ascending: true)], animation: .spring())
    var tasks: FetchedResults<Task>
    // 選択されたタスク
    @State var selectedTask: Task?
    // 被管理オブジェクトコンテキスト（ManagedObjectContext）の取得
    @Environment(\.managedObjectContext) private var context
    // 文字アニメーション用timer
    @State private var textAnimation = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    // 表示するアニメーションテキストの配列Ver
    @State private var showTextArray = []
    // 表示するアニメーションテキストのStringVer
    @State private var showStartText = ""
    // テキストを一つずつ表示
    @State private var textCount = 0
    // タスクがない場合に表示するアニメーションテキスト
    private let startText = Array("1日の始まりです。まずはタスクを追加しましょう!")
    // HomeViewModelのインスタンス生成
    private let homeViewModel = HomeViewModel()
    // ユーザーのデバイスの画面の大きさ
    private let userScreenWidth: Double = UIScreen.main.bounds.size.width
    private let userScreenHeight: Double = UIScreen.main.bounds.size.height

    var body: some View {
        NavigationStack {
            VStack {
                if tasks.isEmpty {
                    emptyTaskListView
                } else {
                    List {
                        CircularTimeBarViewSection
                            // リストの区切り線を消す
                            .listRowSeparator(.hidden)

                        Section {
                            // 今日やること
                            ForEach(tasks) { task in
                                if task.isDone == false {
                                    TaskCardView(selectedTask: $selectedTask, task: task)
                                        // リストの区切り線を消す
                                        .listRowSeparator(.hidden)
                                        .padding(3)
                                }
                            }
                            .onDelete { IndexSet in
                                homeViewModel.delete(offsets: IndexSet)
                            }
                        } header: {
                            Text("今日のタスク")
                                .font(.title2)
                                .padding(5)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("ホーム")
            .fullScreenCover(item: $selectedTask) { _ in
                BodyPoseView(selectedTask: $selectedTask)
            }
        }
        .onReceive(textAnimation) { _ in
            if textCount < startText.count {
                textCount += 1
                showTextArray.append(startText[textCount-1])
                showStartText = "\(showStartText)\(showTextArray[textCount-1])"
            }
        }
    }

    @ViewBuilder
    private var emptyTaskListView: some View {
        Text(showStartText)
    }

    @ViewBuilder
    private var CircularTimeBarViewSection: some View {
        Section {
            // 時間を表示
            CircularTimeBarView()
                .scaleEffect(CGSize(width: 0.8, height: 0.8))
                .frame(maxWidth: .infinity)
        } header: {
            Text("タイムテーブル")
                .font(.title2)
                .padding(5)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
