//
//  ContentView.swift
//  SuffixArray
//
//  Created by Илья Малахов on 13.03.2023.
//

import SwiftUI

enum PickerSortSelecor: String, Equatable, CaseIterable {
    case asc = "asc"
    case desc = "desc"
}

enum PickerSelector: String, Equatable, CaseIterable {
    case asc_desc = "asc/desc"
    case top_10 = "Top 10"
}

struct ContentView: View {
    
    @State private var inputText = ""
    @State private var selectedSort = PickerSortSelecor.asc
    @State private var selected = PickerSelector.asc_desc
    @ObservedObject private var viewModel = SuffixViewModel()
    
    var body: some View {
        VStack {
            TextField("Search", text: $inputText)
                .padding()
                .background(Color.gray.opacity(0.2))
                .onChange(of: inputText) { viewModel.countSuffixMatchesIn(text: $0) }
            
            Picker("", selection: $selected) {
                ForEach(PickerSelector.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }
            
            switch selected {
            case .asc_desc:
                Picker("", selection: $selectedSort) {
                    ForEach(PickerSortSelecor.allCases, id: \.self) { value in
                        Text(value.rawValue).tag(value)
                    }
                }
                .pickerStyle(.segmented)
                List {
                    ForEach(viewModel.sortedDict(by: selectedSort), id: \.key) { key, value in
                        Text(value > 1 ? "\(key) - \(value)" : "\(key)")
                    }
                }
            case .top_10:
                List {
                    ForEach(viewModel.getTopOfSuffixes(), id: \.key) { key, value in
                        Text(value > 1 ? "\(key) - \(value)" : "\(key)")
                    }
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
