//
//  SudokuBoard.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 6/3/22.
//

import Foundation
import RealmSwift

class SudokuRow: Object {
    @objc dynamic var rowNumber: Int = 0
    let currentRow = List<SudokuBox>()
}
