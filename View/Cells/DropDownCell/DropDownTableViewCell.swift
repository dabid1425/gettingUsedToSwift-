//
//  DropDownTableViewCell.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 3/27/23.
//
import DropDown
import UIKit
class DropDownTableViewCell: DropDownCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
       //reset if need be
    }
}
