//
//  SuffixIterator.swift
//  hwSuffixArrayAsync
//
//  Created by Alexandra Kurganova on 20.05.2023.
//

import Foundation

final class SuffixIterator: IteratorProtocol {
    private let word: String
    private var it: IndexingIterator<[String.Index]>

    init(word: String, suffixes: [String.Index]) {
        self.word = word
        self.it = suffixes.makeIterator()
    }

    func next() -> String? {
        guard let next = it.next() else { return nil }
        return String(word.suffix(from: next))
    }
}
