//
//  SudokuBox.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 6/3/22.
//

import Foundation
import RealmSwift
class SudokuBox: Object {
    @objc dynamic var possibleValues: String = ""
    @objc dynamic var boxValue: Int = 0
    @objc dynamic var isHidden: Bool = false
    @objc dynamic var isSolved: Bool = false
    var parentCategory = LinkingObjects(fromType: SudokuRow.self, property: "currentRow")
}

