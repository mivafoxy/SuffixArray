//
//  SuffixViewModel.swift
//  SuffixArray
//
//  Created by Илья Малахов on 09.04.2023.
//

import Foundation
import SwiftUI

struct SuffixModel: Hashable {
    let suffix: String
    let searchTime: UInt64
}

final class SuffixViewModel: ObservableObject {
    private let jobQueue = JobQueue(concurrency: 5)
    @Published var suffixModels = [SuffixModel]()
    
    @MainActor
    func countSuffixMatchesIn(text: String) async {        
        let words = text.components(separatedBy: " ")
        
        suffixModels = try! await withThrowingTaskGroup(of: [SuffixModel].self, returning: [SuffixModel].self) { taskGroup in
            for word in words {
                taskGroup.addTask {
                    let result = try! await self.jobQueue.enqueue(operation: { word.lowercased().suffixArray() })
                    return result
                }
            }
            
            var result = [SuffixModel]()
            for try await task in taskGroup {
                result.append(contentsOf: task)
            }
            return result
        }
    }
}
