//
//  HomeView.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/23.
//

import SwiftUI

struct HomeView: View {
    // HomeViewModelのインスタンス生成
    let homeViewModel = HomeViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    // 被管理オブジェクトコンテキスト（ManagedObjectContext）の取得
    @Environment(\.managedObjectContext) private var context
    // データの取得処理
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "startTime", ascending: true)], animation: .spring())
    var tasks: FetchedResults<Task>

    var body: some View {
        NavigationView {
            VStack {
                Divider()
                
                // 時間を表示
                CircularTimeBarView()
                    .frame(height: 350)
                    .fixedSize()
                
                List {
                    Section {
                        // 今日やること
                        ForEach(tasks) { data in
                            if data.isDone == false {
                                Button {
    //                                selectedTask = data
                                } label: {
                                    HStack {
                                        Image(systemName: "highlighter")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(8)
                                            .foregroundColor(.white)
                                            .frame(width: 50, height: 50)
                                            .background(homeViewModel.colorChangeToColor(colorName: data.color!).opacity(0.5))
                                            .cornerRadius(8)
                                            .shadow(color: homeViewModel.colorChangeToColor(colorName: data.color!), radius: 5, x: 3, y: 3)
                                            .shadow(color: .white.opacity(0.5), radius: 5, x: -3, y: -3)
                                        
                                        VStack {
                                            Text(data.task!)
                                                .font(.system(size: 20))
                                                .bold()
                                            
                                            Text("\(homeViewModel.dateString(date: data.startTime!))〜\(homeViewModel.dateString(date: data.endTime!))")
                                                .font(.system(size: 15))
                                        }
                                        .frame(width: 200)
                                        
                                        Text("スタート")
                                            .font(.title3)
                                            .frame(width: 120, height: 40)
                                            .foregroundColor(.white)
                                            .background(Color.blue)
                                            .cornerRadius(13)
                                    }
                                }
                            }
                        }
                        .onDelete { IndexSet in
                            homeViewModel.delete(offsets: IndexSet)
                        }
                    } header: {
                        Text("今日は\(tasks.count)個のタスクがあります")
                            .font(.title2)
                            .padding(5)
                    }
                    
                    Section {
                        // 完了したタスク
                        ForEach(tasks) { data in
                            if data.isDone {
                                HStack {
                                    Image(systemName: "figure.run")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(8)
                                        .foregroundColor(.white)
                                        .frame(width: 50, height: 50)
                                        .background(Color(data.color!).opacity(0.5))
                                        .cornerRadius(8)
                                        .shadow(color: Color(data.color!), radius: 5, x: 3, y: 3)
                                        .shadow(color: .white.opacity(0.5), radius: 5, x: -3, y: -3)
                                    
                                    VStack {
                                        Text(data.task!)
                                            .font(.system(size: 20))
                                            .bold()
                                        
                                        Text("\(homeViewModel.dateString(date: data.startTime!))〜\(homeViewModel.dateString(date: data.endTime!))")
                                            .font(.system(size: 15))
                                    }
                                    .frame(width: 200)
                                    
                                    Text("完了しました")
                                        .font(.system(size: 16))
                                        .bold()
                                        .frame(width: 120, height: 40)
                                        .foregroundColor(.white)
                                        .background(Color.gray.opacity(0.5))
                                        .cornerRadius(13)
                                }
                            }
                        }
                    } header: {
                        Text("\(tasks.count)個のタスクを完了しました！")
                            .font(.title2)
                            .padding(5)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("ホーム")
            .navigationBarTitleDisplayMode(.inline)
//            .fullScreenCover(item: $selectedTask) { _ in
//                BodyPoseView()
//            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}