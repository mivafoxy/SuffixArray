//
//  SuffixViewModel.swift
//  SuffixArray
//
//  Created by Илья Малахов on 09.04.2023.
//

import Foundation
import SwiftUI

final class SuffixViewModel: ObservableObject {
    private let jobQueue = JobQueue(concurrency: 5)
    @Published var suffixToCount = [String : Int]()
    
    @MainActor
    func countSuffixMatchesIn(text: String) async {        
        let words = text.components(separatedBy: " ")
        
        let allResults = try! await withThrowingTaskGroup(of: [String].self, returning: [String].self) { taskGroup in
            for word in words {
                taskGroup.addTask {
                    let startTime = DispatchTime.now().uptimeNanoseconds
                    let result = try! await self.jobQueue.enqueue(operation: { word.lowercased().suffixArray() })
                    let endTime = DispatchTime.now().uptimeNanoseconds
                    print(endTime - startTime)
                    return result
                }
            }
            
            var result = [String]()
            for try await task in taskGroup {
                result.append(contentsOf: task)
            }
            return result
        }
        
        suffixToCount = {
            var result = [String : Int]()
            for suffix in allResults {
                if let count = result[suffix] {
                    result[suffix] = count + 1
                } else {
                    result[suffix] = 1
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
