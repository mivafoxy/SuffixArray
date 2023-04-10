//
//  SuffixViewModel.swift
//  SuffixArray
//
//  Created by Илья Малахов on 09.04.2023.
//

import Foundation
import SwiftUI

final class SuffixViewModel: ObservableObject {
    @Published var suffixToCount = [String : Int]()
    
    func countSuffixMatchesIn(text: String) {
        // 4. Перед показом View разложить все полученные слова в тексте на SuffixSequence
        // 6. Обернуть в SuffixSequence каждое слово из полученное из шаринга
        
        let words = text.components(separatedBy: " ")
        
        
        
        let suffixes = text.components(separatedBy: " ").flatMap { SuffixSequence(word: $0.lowercased()).suffixes().filter { $0.suffix.count >= 3 } }
        suffixToCount = {
            var result = [String : Int]()
            for suffix in suffixes {
                if let count = result[suffix.suffix] {
                    result[suffix.suffix] = count + 1
                } else {
                    result[suffix.suffix] = 1
                }
            }
            return result
        }()
    }
    
    func sortedDict(by: PickerSortSelecor) -> [Dictionary<String, Int>.Element] {
        switch by {
        case .asc:
            return suffixToCount.sorted(by: <)
        case .desc:
            return suffixToCount.sorted(by: >)
        }
    }
    
    func getTopOfSuffixes() -> [Dictionary<String, Int>.Element] {
        Array(suffixToCount.sorted { leftValue, rightValue in
            return leftValue.value > rightValue.value
        }
        .prefix(10))
    }
}
