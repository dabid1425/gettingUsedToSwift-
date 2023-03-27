//
//  Array+Utils.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 3/27/23.
//

import Foundation
extension Array {
    subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}
extension BidirectionalCollection where Iterator.Element: Equatable {
    typealias Element = Self.Iterator.Element

    func after(_ item: Element, loop: Bool = false) -> Element? {
        if let itemIndex = firstIndex(of: item) {
            let lastItem: Bool = (index(after: itemIndex) == endIndex)
            if loop, lastItem {
                return first
            } else if lastItem {
                return nil
            } else {
                return self[index(after: itemIndex)]
            }
        }
        return nil
    }

    func before(_ item: Element, loop: Bool = false) -> Element? {
        if let itemIndex = firstIndex(of: item) {
            let firstItem: Bool = (itemIndex == startIndex)
            if loop, firstItem {
                return last
            } else if firstItem {
                return nil
            } else {
                return self[index(before: itemIndex)]
            }
        }
        return nil
    }
}
