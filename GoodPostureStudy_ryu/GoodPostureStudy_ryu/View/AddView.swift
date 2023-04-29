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
    // 何も書かれていない時のアラーム
    @State private var isTaskEmpty: Bool = false
    // 開始時間よりも終了時間が早い場合のアラーム
    @State private var isEndtimeEarly: Bool = false
    // アラート
    @State private var showingAlert: AddViewModel.AlertItem?
    // 開始時間の初期値は現在時刻に設定
    @State var startTime: Date = Date()
    // 終了時間の初期値は１時間進めておく
    @State var endTime: Date = Date() + (60 * 60)
    // datepickerを５分刻みにする
    init() {
        UIDatePicker.appearance().minuteInterval = 5
    }
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
    // 被管理オブジェクトコンテキスト（ManagedObjectContext）の取得
    @Environment(\.managedObjectContext) private var context
    // データの取得処理
    @FetchRequest(entity: Task.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "startTime", ascending: true)],
                  animation: .spring())
    var tasks: FetchedResults<Task>
    
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                
                List {
                    if tasks.isEmpty == false {
                        // 時間を表示
                        CircularTimeBarView()
                            .scaleEffect(CGSize(width: 0.7, height: 0.7))
                            .frame(maxWidth: .infinity)
                            .listRowSeparator(.hidden)
                    }
                    
                    Section {
                        TextField("やることを入力", text: $addViewModel.task)
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
                            DatePicker("開始",
                                       selection: $addViewModel.startTime,
                                       displayedComponents: .hourAndMinute)
                            .environment(\.locale, Locale(identifier: "ja_JP"))
                            .frame(width: 120)
                            .onChange(of: addViewModel.startTime) { startTime in
                                addViewModel.endTime = startTime + (60 * 60)
                            }
                            
                            Spacer()
                                .frame(width: 30)
                            
                            DatePicker("終了",
                                       selection: $addViewModel.endTime,
                                       displayedComponents: .hourAndMinute)
                            .environment(\.locale, Locale(identifier: "ja_JP"))
                            .frame(width: 110)
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
                    if let alert = addViewModel.checkTask(task: addViewModel.task, startTime: addViewModel.startTime, endTime: addViewModel.endTime) {
                        showingAlert = alert
                    } else {
                        addViewModel.color = selectedIcon.toCustomColorName().rawValue
                        addViewModel.add(task: addViewModel.task, color: addViewModel.color, startTime: addViewModel.startTime, endTime: addViewModel.endTime)
                        addViewModel.task = ""
                        print(tasks)
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
                .alert(item: $showingAlert) { item in
                    item.alert
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
