//
//  WrappedSequence.swift
//  SuffixArray
//
//  Created by Илья Малахов on 13.03.2023.
//

struct SuffixSequence: Sequence {
    
    let word: String
    
    func makeIterator() -> SuffixIterator {
        SuffixIterator(word: word)
    }
    
    func suffixArray() -> [Int] {
        SuffixArrayService.suffixArray(self.word)
    }
    
    func suffixes() -> [Suffix] {
        self.map { $0 }
    }
    
}

// 5. Как показано в уроке создать SuffixIterator
struct SuffixIterator: IteratorProtocol {
    
    let word: String
    var startIndex: Int = 0
    
    mutating func next() -> (suffix: String, index: Int)? {
        guard startIndex < word.count else { return nil }
        startIndex += 1
        let substring = word.suffix(startIndex)
        
        return Suffix(
            suffix: String(substring),
            index: word.count - startIndex
        )
    }
    
}

typealias Suffix = (suffix: String, index: Int)
