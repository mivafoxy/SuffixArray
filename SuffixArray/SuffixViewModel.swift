//
//  SuffixViewModel.swift
//  SuffixArray
//
//  Created by Илья Малахов on 09.04.2023.
//

import Foundation
import SwiftUI

final class SuffixViewModel: ObservableObject {
    @Published var suffixToMatches = [String : Int]()
    
    func countSuffixMatchesIn(text: String) {
        suffixToMatches.removeAll()
        let words = text.components(separatedBy: " ")
        
        var suffixes = [String]()
        for word in words {
            let suffixArray = SuffixArrayService.suffixArray(word)
            let suffs = suffixArray.compactMap {
                let index = word.index(word.startIndex, offsetBy: $0)
                let resultString = String(word[index..<word.endIndex])
                return resultString.count >= 3 ? resultString : nil
            }
            suffixes.append(contentsOf: suffs)
        }
        
        for suffix in suffixes {
            if let count = suffixToMatches[suffix] {
                suffixToMatches[suffix] = count + 1
            } else {
                suffixToMatches[suffix] = 1
            }
        }
    }
}
