//
//  CreateView.swift
//  Marubatsu
//
//  Created by 米澤菜摘子 on 2025/02/15.
//

import SwiftUI

struct CreateView: View {
    @AppStorage("quiz") var quizzesData = Data() // UserDefaultsから問題を読み込む（Data型）
    @Binding var quizzesArray: [Quiz]// 回答画面で読み込んだ問題を受け取る
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
        List{
            ForEach(quizzesArray){ Quiz in
                HStack{
                    Text("問題：\(Quiz.question)")
                        .frame(alignment: .leading)
                    Spacer()
                    switch Quiz.answer {
                    case true:
                        Text("解答：◯")
                    case false:
                        Text("解答：✗")
                    }
                }
            }
            // リストの並び替え時の処理を設定
            .onMove{ from, to in
                replaceRow(from, to)
            }
            // リストの削除
            .onDelete(perform: rowRemove)

        }
        // ナビゲーションバーに編集ボタンを追加
        .toolbar(content: {
            EditButton()
        })
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
    // 並び替え処理と　並び替え後の保存
    func replaceRow(_ from: IndexSet, _ to: Int){
        quizzesArray.move(fromOffsets: from, toOffset: to)
        if let encodedQuizzes = try? JSONEncoder().encode(quizzesArray){
            quizzesData = encodedQuizzes //　エンコードできたらAppStrageに渡す
        }
    }
    // 行を削除する処理　と　削除後の保存
    func rowRemove(offsets:IndexSet){
        var array = quizzesArray //quizzesArrayを一時的に別の変数「array」へ
        array.remove(atOffsets: offsets) // 一時的な配列「array」からタスクを削除
        if let encodedQuizzes = try? JSONEncoder().encode(array){
            UserDefaults.standard.setValue(encodedQuizzes, forKey: "quiz") // UserDefaultsに保存
            quizzesArray = array //　エンコードできたらAppStrageに渡す
        }
    }
}

//#Preview {
//    CreateView()
//}
