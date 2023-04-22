//
//  AddView.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/23.
//

import SwiftUI

struct AddView: View {
    // AddViewModelのインスタンス
    @StateObject var addViewModel = AddViewModel()
    // 何も書かれていない時のアラームの表示有無
    @State private var isShowAlert: Bool = false
    // 開始時間の初期値は現在時刻に設定
    @State var startTime: Date = Date()
    // 終了時間の初期値は１時間進めておく
    @State var endTime: Date = Date() + (60 * 60)
    // 西暦（gregorian）カレンダーを生成
    let calendar = Calendar(identifier: .gregorian)
    // テキスト
    @State var task: String = ""
    // アイコン
    let iconColor: [Color] = [.red, .orange, .green, .cyan, .blue]
    // 選択されたアイコン（初期値は青）
    @State var selectedIcon: Color = .blue
    // CoreDataに追加するプロパティ
    @State var taskData: Task?
    
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                
                List {
//                    // 時間を表示
//                    CircularTimeBarView()
//                        .scaleEffect(CGSize(width: 0.7, height: 0.7))
//                        .frame(maxWidth: .infinity)
//                        .listRowSeparator(.hidden)
                    
                    Section {
                        TextField("やることを入力", text: $task)
                            .font(.system(size: 20))
                            .frame(width: 360, height: 20)
                            .frame(maxWidth: .infinity)
                    } header: {
                        Text("やること")
                    }
                    .listRowSeparator(.hidden)
                    
                    Section {
                        HStack {
                            ForEach(iconColor, id: \.self) { color in
                                Image(systemName: "highlighter")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(12)
                                    .foregroundColor(.white)
                                    .frame(width: selectedIcon == color ? 55 : 45)
                                    .background(color.opacity(0.5))
                                    .cornerRadius(8)
                                    .shadow(color: color, radius: 5, x: 3, y: 3)
                                    .shadow(color: .white.opacity(0.5), radius: 5, x: -3, y: -3)
                                    .padding(10)
                                    .onTapGesture {
                                        withAnimation {
                                            selectedIcon = color
                                        }
                                    }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    } header: {
                        Text("アイコン")
                    }
                    .listRowSeparator(.hidden)
                    
                    Section {
                        HStack {
                            DatePicker("",
                                       selection: $startTime,
                                       displayedComponents: .hourAndMinute)
                            .environment(\.locale, Locale(identifier: "ja_JP"))
                            .frame(width: 80)
                            
                            Text("〜")
                            
                            DatePicker("",
                                       selection: $endTime,
                                       displayedComponents: .hourAndMinute)
                            .environment(\.locale, Locale(identifier: "ja_JP"))
                            .frame(width: 80)
                        }
                        .frame(maxWidth: .infinity)
                    } header: {
                        Text("時間")
                    }
                    .padding(.bottom)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                
                Button {
                    if task == "" {
                        isShowAlert = true
                    } else {
                        addViewModel.task?.task = task
                        addViewModel.task?.color = "red"
                        addViewModel.task?.startTime = startTime
                        addViewModel.task?.endTime = endTime
                        if let task = addViewModel.task {
                            addViewModel.add(task: task)
                        }
                    }
                } label: {
                    Text("タスクを追加")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .padding(15)
                        .frame(width: 205, height: 55)
                        .background(selectedIcon)
                        .cornerRadius(15)
                }
                .padding(.bottom)
                .alert(isPresented: $isShowAlert) {
                    Alert(title: Text("エラー"), message: Text("やることを入力してください。"))
                }
            }
            .navigationTitle("タスク追加")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
