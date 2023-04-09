//
//  WrappedSequence.swift
//  SuffixArray
//
//  Created by Илья Малахов on 13.03.2023.
//

extension String {
    func suffixArray() -> [Int] {
        SuffixArrayService.suffixArray(self).sorted(by: >)
    }
}

struct SuffixSequence: Sequence {
    
    let word: String
    
    func makeIterator() -> SuffixIterator {
        SuffixIterator(word: word, suffixArray: word.suffixArray())
    }
    
    func suffixes() -> [Suffix] {
        self.map { $0 }
    }
    
}

// 5. Как показано в уроке создать SuffixIterator
struct SuffixIterator: IteratorProtocol {
    
    let word: String
    let suffixArray: [Int]
    var startIndex: Int = 0
    
    mutating func next() -> (suffix: String, index: Int)? {
        guard startIndex < suffixArray.count else { return nil }
        let startIndex = word.index(word.startIndex, offsetBy: suffixArray[startIndex])
        self.startIndex += 1
        let substring = word[startIndex..<word.endIndex]
        
        return Suffix(
            suffix: String(substring),
            index: suffixArray[self.startIndex - 1]
        )
    }
    
}

typealias Suffix = (suffix: String, index: Int)
