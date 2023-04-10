//
//  String+Extension.swift
//  SuffixArray
//
//  Created by Илья Малахов on 13.03.2023.
//

extension String {
    func suffixArray() -> [String] {
        let indexes = SuffixArrayService.suffixArray(self).sorted(by: >)
        return indexes.compactMap { index in
            let position = self.index(self.startIndex, offsetBy: index)
            return String(self[position..<self.endIndex])
        }
    }
}
