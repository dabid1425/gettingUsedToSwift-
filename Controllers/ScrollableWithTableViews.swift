//
//  ScrollableWithTableViews.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 3/27/23.
//

import Foundation
import UIKit
class ScrollableWithTableViews: UIViewController {
    
    @IBOutlet var rightTableView: UITableView!
    @IBOutlet var leftTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    //this will autoresize table view based on scroll view 
    func registerCells() {
        //TableCell.register
        leftTableView.rowHeight = UITableView.automaticDimension
        leftTableView.estimatedRowHeight = 60
        leftTableView.separatorStyle = .none
        rightTableView.rowHeight = UITableView.automaticDimension
        rightTableView.estimatedRowHeight = 60
        rightTableView.separatorStyle = .none
    }
}
