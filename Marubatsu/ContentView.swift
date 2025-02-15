//
//  ContentView.swift
//  Marubatsu
//
//  Created by 米澤菜摘子 on 2025/02/15.
//

import SwiftUI

// Quizの構造体
struct Quiz: Identifiable, Codable {
    var id = UUID() //それぞれの設問を区別するID
    var question: String //問題文
    var answer: Bool //回答
}

struct ContentView: View {
    
    // 問題
    let quizeExamples: [Quiz] = [
        Quiz(question: "iPhoneアプリを開発する統合環境はZcodeである", answer: false),
        Quiz(question: "Xcode画面の右側にはユーティリティーズがある", answer: true),
        Quiz(question: "Textは文字列を表示する際に利用する", answer: true)
    ]
    @State var currentQuestionNum: Int = 0 //今、何問目の数字
    @State var showingAlert = false //アラートの表示・非表示を管理
    @State var alertTitle = "" // "正解"か"不正解"の文字を入れる用の変数
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text(showQuestion()) //問題文を表示
                    .padding() //余白の余裕
                    .frame(width: geometry.size.width * 0.85,alignment: .leading) //横幅を250、左寄せにする
                    .font(.system(size:  25)) //フォントサイズを25に
                    .fontDesign(.rounded) //フォントを丸みのあるものに
                    .background(.yellow) //背景を黄色に
                
                Spacer() //問題文とボタンの間を最大限広げるための余白を配置
                
                //◯✗ボタンを横並びに表示するのでHStackを使う
                HStack {
                    //◯ボタン
                    Button {
                        checkAnswer(yourAnswer: true) // ボタンが押されたときの動作
                    } label: {
                        Text("◯") //　ボタンの見た目
                    }
                    .frame(width: geometry.size.width * 0.4,
                           height: geometry.size.width * 0.4)//幅・高さ：親ビューの幅の0.4倍
                    .font(.system(size: 100, weight: .bold))//フォントサイズ：100、太字
                    .foregroundStyle( .white)//文字の色を白
                    .background( .red)//背景を赤
                    
                    //✗ボタン
                    Button {
                        checkAnswer(yourAnswer: false) // ボタンが押されたときの動作
                    } label: {
                        Text("✗") //　ボタンの見た目
                    }
                    .frame(width: geometry.size.width * 0.4,
                           height:  geometry.size.width * 0.4)//幅・高さ：親ビューの幅の0.4倍
                    .font(.system(size: 100, weight: .bold))//フォントサイズ：100、太字
                    .foregroundStyle( .white)//文字の色を白
                    .background( .blue)//背景を青
                    
                }
            }
            .padding()
            //ズレを直すために親ビューのサイズをVStackに適用
            .frame(width: geometry.size.width, height: geometry.size.height)
            
            //回答時のアラート
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK", role: .cancel) {/*　今回は処理なし　*/}
            }
        }
    }
    // 問題を表示するための関数
    func showQuestion() -> String {
        let question = quizeExamples[currentQuestionNum].question
        return question
    }
    
    // 回答をチェックするためのカンス
    //　正解なら次の問題を表示します
    func checkAnswer(yourAnswer: Bool) {
        let quiz = quizeExamples[currentQuestionNum]
        let ans = quiz.answer
        if yourAnswer == ans { //正解のとき
            alertTitle = "正解！"
            // 現在の問題番号が問題数を超えないように場合分け
            if currentQuestionNum + 1 < quizeExamples.count {
                currentQuestionNum += 1 //次の問題に進む
            }else{
                // 超えるときは０に戻す
                currentQuestionNum = 0
            }
        }else { // 不正解のとき
            alertTitle = "不正解..."
        }
        showingAlert = true //アラートを表示
    }
    
}

#Preview {
    ContentView()
}
