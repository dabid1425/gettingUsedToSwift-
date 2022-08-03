//
//  DrawingTableViewCell.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 7/25/22.
//

import UIKit

extension UIView {
    func fill(with view: UIView) {
        addSubview(view)
        NSLayoutConstraint.activate([
            leftAnchor.constraint(equalTo: view.leftAnchor),
            rightAnchor.constraint(equalTo: view.rightAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

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
    
    func configure(layer: CanvasView, originalWidth: CGFloat, originalHeight: CGFloat) {
        let width = self.layerView.frame.size.width
        let height = self.layerView.frame.size.height
        for line in layer.lines{
            var newLine = TouchPointsAndColor(color: UIColor(), points: [CGPoint]())
            for i in 0..<line.points.count{
                let scaledPoint = CGPoint(x: line.points[i].x * (width / originalWidth) , y: line.points[i].y * (height / originalWidth))
                newLine.points.append(scaledPoint)
                newLine.eraser = line.eraser
                newLine.color = line.color
                newLine.width = line.width
                newLine.opacity = line.opacity
            }
            layerView.lines.append(newLine)
        }
        layerView.setNeedsDisplay()
    }
    
}
