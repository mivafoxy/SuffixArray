//
//  ContentView.swift
//  SuffixArray
//
//  Created by Илья Малахов on 13.03.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var inputText = ""
    @ObservedObject private var viewModel = SuffixViewModel()
    
    var body: some View {
        VStack {
            // 2. Внутри приложения поле ввода для текста
            TextField("Search", text: $inputText)
                .padding()
                .background(Color.gray.opacity(0.2))
                .onChange(of: inputText) { text in
                    Task {
                        await viewModel.countSuffixMatchesIn(text: text)
                    }
                }
            
            List {
                ForEach(viewModel.suffixModels, id: \.self) { model in
                    Text("Суффикс \(model.suffix) - \(model.searchTime) нс")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
