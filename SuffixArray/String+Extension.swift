//
//  String+Extension.swift
//  SuffixArray
//
//  Created by Илья Малахов on 13.03.2023.
//

import Foundation

extension String {
    func suffixArray() -> [SuffixModel] {
        let startTime = DispatchTime.now().uptimeNanoseconds
        let indexes = SuffixArrayService.suffixArray(self).sorted(by: >)
        return indexes.compactMap { index in
            let position = self.index(self.startIndex, offsetBy: index)
            let resultString = String(self[position..<self.endIndex])
            let endTime = DispatchTime.now().uptimeNanoseconds
            return SuffixModel(suffix: resultString, searchTime: (endTime - startTime))
        }
    }
}
