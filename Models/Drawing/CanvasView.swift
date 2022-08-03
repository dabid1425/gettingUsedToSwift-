//
//  CanvasView.swift
//  DrawingApp
//
//  Created by Ranosys on 19/09/19.
//  Copyright © 2019 Ranosys. All rights reserved.
//

import UIKit

struct TouchPointsAndColor {
    var color: UIColor?
    var width: CGFloat?
    var opacity: CGFloat?
    var points: [CGPoint]
    var blendMode: CGBlendMode = CGBlendMode.normal
    var eraser:Bool = false
    
    init(color: UIColor, points: [CGPoint]) {
        self.color = color
        self.points = points
        
    }
}

class CanvasView: UIView {
    var lines = [TouchPointsAndColor]()
    var pencilStrokeWidth: CGFloat = 1.0
    var strokeColor: UIColor = .black
    var pencilStrokeOpacity: CGFloat = 1.0
    var usingEraser:Bool = false
    var touchSensitivity:CGFloat =  0.0
    let forceSensitivity: CGFloat = 4.0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        lines.forEach { (line) in
            for (i, p) in (line.points.enumerated()) {
                if i == 0 {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
                context.setStrokeColor(line.color?.withAlphaComponent(line.opacity ?? 1.0).cgColor ?? UIColor.black.cgColor)
                context.setLineWidth(line.width ?? 1.0)
            }
            context.setBlendMode(line.blendMode)
            context.setLineCap(.round)
            context.strokePath()
        }
    }
    
    func newUserLine() {
        lines.append(TouchPointsAndColor(color: UIColor(), points: [CGPoint]()))
    }
    
    func userMovingLine(pointToBeAdded: CGPoint) {
        guard var lastPoint = lines.popLast() else {return}
        lastPoint.points.append(pointToBeAdded)
        lastPoint.color = strokeColor
        lastPoint.width = touchSensitivity > 0 ? pencilStrokeWidth * touchSensitivity : pencilStrokeWidth
        lastPoint.eraser = usingEraser
        lastPoint.opacity =  pencilStrokeOpacity
        lastPoint.blendMode = usingEraser ? CGBlendMode.clear : CGBlendMode.normal
        lines.append(lastPoint)
        setNeedsDisplay()
    }
    
    //maybe used to help determine pressure
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        touchSensitivity = touch.force * forceSensitivity
        
    }
    
    
    func clearCanvasView() {
        lines.removeAll()
        setNeedsDisplay()
    }
    
    func undoDraw() {
        if lines.count > 0 {
            lines.removeLast()
            setNeedsDisplay()
        }
    }
    
    func setUsingEraser(){
        self.usingEraser = !usingEraser
    }
    func determineShape(){
        if let points = lines.last?.points as? [CGPoint]{
            
        }
    }
}
