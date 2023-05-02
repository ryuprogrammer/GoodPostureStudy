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
    private let UserScreenWidth: Double = UIScreen.main.bounds.size.width
    private let UserScreenHeight: Double = UIScreen.main.bounds.size.height
    
    var body: some View {
        NavigationView {
            VStack {
                if tasks.isEmpty {
                    Text(showStartText)
                } else {
                    List {
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
                        // リストの区切り線を消す
                        .listRowSeparator(.hidden)

                        
                        Section {
                            // 今日やること
                            ForEach(tasks) { data in
                                if data.isDone == false {
                                    HStack {
                                        Image(systemName: "highlighter")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(8)
                                            .foregroundColor(.white)
                                            .frame(width: 50, height: 50)
                                            .background(Color(taskColorName: Color.TaskColorNames(rawValue: data.color!) ?? .blue).opacity(0.5))
                                            .cornerRadius(8)
                                            .shadow(color: Color(taskColorName: Color.TaskColorNames(rawValue: data.color!) ?? .blue), radius: 5, x: 3, y: 3)
                                            .shadow(color: .white.opacity(0.5), radius: 5, x: -3, y: -3)
                                        
                                        VStack {
                                            Text(data.task!)
                                                .font(.system(size: 20))
                                                .bold()
                                            
                                            Text("\(data.startTime!.formattedTimeString())〜\(data.endTime!.formattedTimeString())")
                                                .font(.system(size: 15))
                                        }
                                        .frame(width: 200)
                                        
                                        Button {
                                            selectedTask = data
                                        } label: {
                                            Text("スタート")
                                                .font(.title3)
                                                .frame(width: 120, height: 40)
                                                .foregroundColor(.white)
                                                .background(Color.blue)
                                                .cornerRadius(13)
                                        }
                                    }
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
