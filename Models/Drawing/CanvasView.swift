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
            context.setLineCap(.round)
            context.strokePath()
        }
    }
    
    func newUserLine() {
        lines.append(TouchPointsAndColor(color: UIColor(), points: [CGPoint]()))
    }
    
    func userMovingLine(pointToBeAdded: CGPoint) {
        if (usingEraser){
            checkifNeedToRemove(pointToBeAdded: pointToBeAdded)
        } else {
            guard var lastPoint = lines.popLast() else {return}
            lastPoint.points.append(pointToBeAdded)
            lastPoint.color = strokeColor
            lastPoint.width = pencilStrokeWidth
            lastPoint.eraser = false
            lastPoint.opacity =  usingEraser ? 0.0 : pencilStrokeOpacity
            lines.append(lastPoint)
        }
        setNeedsDisplay()
    }
    
    func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        return CGFloat(sqrt((from.x - to.x)*(from.x - to.x) + (from.y - to.y)*(from.y - to.y)))
    }
    
    func isInCircle(withCenter center: CGPoint, point: CGPoint, radius: CGFloat) -> Bool {
        return distance(from: center, to: point) <= radius
    }
    
    func getPoints(withCenter center:CGPoint, radius: CGFloat) -> [CGPoint] {
        let minX = Int(center.x - radius)
        let minY = Int(center.y - radius)
        let maxX = Int(center.x + radius)
        let maxY = Int(center.y + radius)
        
        var result = [CGPoint]()
        for x in minX...maxX {
            for y in minY...maxY {
                let point = CGPoint(x: x, y: y)
                if isInCircle(withCenter: center, point: point, radius: radius) {
                    result.append(point)
                }
            }
        }
        
        return result
    }
    
    
    func checkifNeedToRemove(pointToBeAdded: CGPoint){
        for checkIfNonEraseLine in 0..<lines.count{
            if (!lines[checkIfNonEraseLine].eraser){
                let pointsNearBy = getPoints(withCenter: pointToBeAdded, radius: pencilStrokeWidth * 20)
                for pointNearBy in pointsNearBy{
                    if (lines[checkIfNonEraseLine].points.contains(pointNearBy)){
                        guard var lastPoint = lines.popLast() else {return}
                        lastPoint.points.append(pointToBeAdded)
                        lastPoint.color = .white
                        lastPoint.width = pencilStrokeWidth
                        lastPoint.opacity = pencilStrokeOpacity
                        lines.append(lastPoint)
                    }
                }
            }
        }
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
