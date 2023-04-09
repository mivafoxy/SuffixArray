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
            // 2. Внутри приложения поле ввода для текста
            TextField("Search", text: $inputText)
                .padding()
                .background(Color.gray.opacity(0.2))
                .onChange(of: inputText) { viewModel.countSuffixMatchesIn(text: $0) }
            
            Picker("", selection: $selected) {
                ForEach(PickerSelector.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }
            
            // 7. Отображать Segmented Control(Picker в SwiftUI) переключения между
            switch selected {
                // 7.1. листом всех суффиксов, повторяющиеся помечать кол-вом, остортировать по алфавиту, сделать переключение сортировки ASC/DESC
            case .asc_desc:
                // 3. Показывать в приложении(пункт 3.1) статистику совпадения суффиксов более 3х символов.
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
                // 7.2. Топом 10 самых популярных 3х буквенных суффиксов, отсортированных по кол-ву нахождений
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
