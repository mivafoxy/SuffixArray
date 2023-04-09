//
//  WrappedSequence.swift
//  SuffixArray
//
//  Created by Илья Малахов on 13.03.2023.
//

struct WrappedSequence<Wrapped: Sequence, Element>: Sequence {
    typealias IteratorFunction = (inout Wrapped.Iterator) -> Element?
    
    private let wrapped: Wrapped
    private let iterator: IteratorFunction
    
    init(wrapped: Wrapped, iterator: @escaping IteratorFunction) {
        self.wrapped = wrapped
        self.iterator = iterator
    }
    
    func makeIterator() -> some IteratorProtocol {
        var wrappedIterator = wrapped.makeIterator()
        return AnyIterator { self.iterator(&wrappedIterator) }
    }
}
