//
//  NaviView.swift
//  GoodPostureStudy_ryu
//
//  Created by トム・クルーズ on 2023/04/29.
//

import SwiftUI

struct NaviView: View {
    // アラートの内容
    @Binding var alertText: String
    // 勉強がスタートしているか
    @Binding var isStart: Bool
    // NaviViewModelのインスタンス生成
    @StateObject var naviViewModel = NaviViewModel()
    // メッセージのページ
    @State private var messagePage: Int = 0

    var body: some View {
        ZStack {
            VStack {
                // カード
                Rectangle()
                    .foregroundColor(.white.opacity(0.5))
                    .frame(maxWidth: naviViewModel.isStartStudy ? 200 : 300)
                    .frame(maxHeight: naviViewModel.isStartStudy ? 100 : 500)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke()
                            .foregroundStyle(
                                .linearGradient(colors: [.white.opacity(0.5), .clear],
                                                startPoint: .top,
                                                endPoint: .bottom)
                            )
                    )
                    .shadow(color: .black.opacity(0.3), radius: 20, y: 20)
                    .padding(50)

                Spacer()
                    .frame(height: naviViewModel.isStartStudy ? 600 : 0)
            }

            if naviViewModel.isStartStudy {
                VStack {
                    // アラートメッセージ
                    Text(alertText)

                    Spacer()
                        .frame(height: naviViewModel.isStartStudy ? 600 : 0)
                }
            } else {
                VStack {
                    Text("〜説明〜")
                        .padding()
                    Text(naviViewModel.naviData.naviText)
                        .font(.title)
                        .padding(20)
                    Spacer()
                    Image(systemName: naviViewModel.naviData.naviImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)

                    Spacer()
                    Text("タップして次へ")
                        .padding(20)
                }
                .frame(width: 280, height: 500)
            }
        }
        .onTapGesture {
            withAnimation {
                // 次のページに映る
                messagePage += 1
                // メッセージ内容を更新
                naviViewModel.changeNaviText(messagePage: messagePage)
                // 勉強がスタートしているかをBindingで値渡し
                isStart = naviViewModel.isStartStudy
            }
        }
    }
}
