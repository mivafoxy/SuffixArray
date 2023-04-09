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
            TextField("Search", text: $inputText)
                .padding()
                .background(Color.gray.opacity(0.2))
                .onChange(of: inputText) { viewModel.countSuffixMatchesIn(text: $0) }
            List {
                ForEach(viewModel.suffixToMatches.sorted(by: >), id: \.key) { key, value in
                    Text("\(key) - \(value)")
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
