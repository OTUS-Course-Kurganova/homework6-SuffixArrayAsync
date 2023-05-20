//
//  TextFieldViewModel.swift
//  hwSuffixArrayAsync
//
//  Created by Alexandra Kurganova on 20.05.2023.
//

import Foundation

protocol TextFieldElementViewModelProtocol {
    var suffixCountSorted: String { get set }
    var makeReversed: Bool { get set }
    func countSuffixesFrom(text: String)
}

final class TextFieldElementViewModel: ObservableObject {
    @Published var suffixCountSorted = ""
    private var sortMode: SortMode = .alphabetically
    private var sortType: SortType = .asc
    private var suffixes = [SuffixInfo]()
    
    enum SortMode {
        case alphabetically
        case top10
    }
    
    enum SortType {
        case asc
        case desc
    }

    struct SuffixInfo {
        let word: String
        let count: Int
    }

    func countSuffixesFrom(text: String) {
        let words = text
            .split(separator: " ")
            .map { String($0) }
        
        let suffixCount = words
            .flatMap { SuffixSequence(word: $0) }
            .filter { $0.count >= 3 }
            .reduce([String: Int](), { suffixCount, suffix in
                var suffixCount = suffixCount
                suffixCount[suffix] = (suffixCount[suffix] ?? 0) + 1
                return suffixCount
            })
        
        suffixes = suffixCount
            .map { SuffixInfo(word: $0.key, count: $0.value) }
        
        switch sortMode {
            case .alphabetically:
                fillSortedAlphabetically()
            case .top10:
                fillTop10ThreeLettered()
        }
    }
    
    func setAlphabeticalSort(type: SortType) {
        sortMode = .alphabetically
        sortType = type
        
        fillSortedAlphabetically()
    }
    
    func setTop10Sort() {
        sortMode = .top10
        sortType = .desc
        
        fillTop10ThreeLettered()
    }
    
    private func fillSortedAlphabetically() {
        let sortedAlphabeticallySuffixes: [SuffixInfo]
        switch sortType {
            case .asc:
                sortedAlphabeticallySuffixes = suffixes.sorted(by: asc)
            case .desc:
                sortedAlphabeticallySuffixes = suffixes.sorted(by: desc)
        }
        combineSuffixSorted(suffixes: sortedAlphabeticallySuffixes)
    }
    
    private func asc(info1: SuffixInfo, info2: SuffixInfo) -> Bool { info1.word < info2.word }
    private func desc(info1: SuffixInfo, info2: SuffixInfo) -> Bool { info1.word > info2.word }
    
    private func fillTop10ThreeLettered() {
        let top10ThreeLetteredSuffixes = Array(suffixes
            .filter { $0.word.count == 3 }
            .sorted { info1, info2 in info1.count > info2.count }
            .prefix(10))
        combineSuffixSorted(suffixes: top10ThreeLetteredSuffixes)
    }

    private func combineSuffixSorted(suffixes: [SuffixInfo]) {
        suffixCountSorted = suffixes.reduce("", { res, info in
            info.count > 1 ? res + "\(info.word) – \(info.count)\n" : res + "\(info.word)\n"
        })
    }
}
