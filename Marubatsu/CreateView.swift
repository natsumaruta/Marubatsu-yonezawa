//
//  CreateView.swift
//  Marubatsu
//
//  Created by 米澤菜摘子 on 2025/02/15.
//

import SwiftUI

struct CreateView: View {

    @Binding var quizzesArray: [Quiz] // 回答画面で読み込んだ問題を受け取る
    @State private var questionText = "" //　テキストフィールドの文字を受け取る
    @State private var selectedAnswer = "◯" // ピッカーで選ばれた解答を受け取る
    let answers = ["◯","✗"] //ピッカーの選択肢
    
    var body: some View {
        VStack {
            Text("問題文と回答を入力して、追加ボタンを押してください")
                .foregroundStyle(.gray)
                .padding()
            
            // 問題文を入力するテキストフィールド
            TextField(text: $questionText) {
                Text("問題文を入力してください")
            }
            .padding()
            .textFieldStyle(.roundedBorder)
            
            // 解答を選択するピッカー
            Picker("解答", selection: $selectedAnswer) {
                ForEach(answers, id: \.self) { answer in
                    Text(answer)
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 300)
            .padding()
            //追加ボタン
            Button {
                // 追加ボタンが押されたときの処理
                addQuiz(question: questionText, answer: selectedAnswer)
            } label: {
                Text("追加")
            }
            .padding()
            
            // 削除ボタン
            Button {
                quizzesArray.removeAll() //配列を空に
                UserDefaults.standard.removeObject(forKey: "quiz")//保存されているものを削除
            } label: {
                Text("全削除")
            }
            .foregroundStyle(.red)
            .padding()
        }
    }
    // 問題追加・保存の関数
    func addQuiz(question: String, answer: String){
        // 問題文が入力されているかチェック
        if question.isEmpty {
            print("問題文が入力されていません")
            return
        }
        
        // 保存するためのtrue,falseを入れておく変数
        var savingAnswer = true
        
        // ◯か✗かでtrue，falseを切り替える
        switch answer {
        case "◯":
            savingAnswer = true
        case "✗":
            savingAnswer = false
        default:
            print("適切な答えが入っていません")
            break
        }
        
        let newQuiz = Quiz(question: question, answer: savingAnswer)
        
        var array: [Quiz] = quizzesArray //一時的に変数に入れておく
        array.append(newQuiz) //作った問題を配列に追加
        let storekey = "quiz" //UserDefaultsに保存するためのキー
        
        // エンコードできたら保存して配列も更新
        if let encodedQuizzes = try? JSONEncoder().encode(array) {
            UserDefaults.standard.setValue(encodedQuizzes, forKey: storekey)
            questionText = "" //テキストフィールドも空白に戻しておく
            quizzesArray = array //[既存の問題　＋　新問題]となった配列に更新
        }
    }
}

//#Preview {
//    CreateView()
//}
