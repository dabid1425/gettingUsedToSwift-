//
//  DrawingTableViewCell.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 7/25/22.
//

import UIKit

class DrawingTableViewCell: UITableViewCell {

    @IBOutlet weak var layerView: CanvasView!
    @IBOutlet weak var layerName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
