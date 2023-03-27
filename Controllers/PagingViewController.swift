//
//  PagingViewController.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 3/27/23.
//

import Foundation
import UIKit
import DropDown
enum DropDownOption: Int {
    case case1
    case case2

    // MARK: Internal

    // Should be these two but minimize doesnt work yet
    // [minimize, revealPrice]
    // [minimize, hidePrice]
    static var allOptions = [case1, case2]
    var optionText: String {
        switch self {
        case .case1: return "String 1"
        case .case2: return "String 2"
        }
    }
    var optionIcon: String {
        switch self {
        case .case1: return "ImageNamed1"
        case .case2: return "ImageNamed2"
        }
    }
}
class PagingViewController: UIViewController {
    @IBOutlet var dropDownContainer: UIView!
    var dropDown = DropDown()
    private lazy var artifactsViewController: PagingPageViewController? = {
        let viewCtl = PagingPageViewController()
        viewCtl.superView = view
        //pass anthing like delegates
        return viewCtl
    }()

    func setUP() {
        let titles =  DropDownOption.allOptions.map(\.optionText)
        let icons = DropDownOption.allOptions.map(\.optionIcon)
        dropDown.direction = .bottom
        if let offsetY = dropDown.anchorView?.plainView.bounds.height {
            dropDown.bottomOffset = CGPoint(x: 0, y: offsetY)
        }
        dropDown.anchorView = dropDownContainer
        dropDown.dataSource = titles
        dropDown.cellNib = UINib(nibName: "DropDownTableViewCell", bundle: nil)
        dropDown.customCellConfiguration = { (index: Index, _: String, cell: DropDownCell) in
//            guard let cell = cell as? DropDownTableViewCell else { return }
//            let imageName = icons[index]
            //cell.optionImageView.image = UIImage(named: imageName)
        }
        dropDown.selectionAction = { [unowned self] (index: Int, _: String) in
            if let option = DropDownOption(rawValue: index) {
               // artifactsViewController?.dropDownSelected(option: option)
            }
        }
        customizeDropDown()
    }
    func customizeDropDown() {
        dropDown.cellHeight = 40
        dropDown.cornerRadius = 5
        dropDown.shadowOpacity = 0.9
        dropDown.shadowRadius = 0
        dropDown.animationduration = 0.25
    }
    
}
