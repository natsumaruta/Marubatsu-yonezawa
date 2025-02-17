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
    
    @AppStorage("quiz") var quizzesData = Data() // UserDefaultsから問題を読み込む（Data型）
    @State var quizzesArray: [Quiz] = [] // 問題を入れておく配列
    
    @State var currentQuestionNum: Int = 0 //今、何問目の数字
    @State var showingAlert = false //アラートの表示・非表示を管理
    @State var alertTitle = "" // "正解"か"不正解"の文字を入れる用の変数
    
    //　起動時にquizzesDateに読み込んだ値（Data型）を[Quiz]型にデコードしてquizzesArrayに入れる
    init(){
        if let decodedQuizzes = try? JSONDecoder().decode([Quiz].self, from: quizzesData){
            _quizzesArray = State(initialValue: decodedQuizzes)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
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
            .navigationTitle("マルバツクイズ")//ナビゲーションバーにタイトル設定
            //回答時のアラート
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK", role: .cancel) {/*　今回は処理なし　*/}
            }
            //問題作成画面へ遷移するためのボタンを設置
            .toolbar{
                //配置する場所を画面最上部のバーの右端に設定
                ToolbarItem( placement: .topBarTrailing) {
                    NavigationLink {
                        CreateView(quizzesArray: $quizzesArray) //遷移先の画面
                            .navigationTitle("問題を作ろう")
                    } label: {
                        // 画面に遷移するためのボタンの見た目
                        Image(systemName: "plus")
                            .font(.title)
                    }
                }
            }
        }
        }
    }
    
    
    // 問題を表示するための関数
    func showQuestion() -> String {
        var question = "問題を作成してください"
        //問題が書かれているかどうかのチェック
        if !quizzesArray.isEmpty{
            let quiz = quizzesArray[currentQuestionNum]
            question = quiz.question
        }
        return question
    }
    
    // 回答をチェックするためのカンス
    //　正解なら次の問題を表示します
    func checkAnswer(yourAnswer: Bool) {
        if quizzesArray.isEmpty {return} //問題がないときは解答チェックしない
        let quiz = quizzesArray[currentQuestionNum]
        let ans = quiz.answer
        if yourAnswer == ans { //正解のとき
            alertTitle = "正解！"
            // 現在の問題番号が問題数を超えないように場合分け
            if currentQuestionNum + 1 < quizzesArray.count {
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
