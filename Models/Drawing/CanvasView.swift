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
    var points: [CGPoint]?
    
    init(color: UIColor, points: [CGPoint]?) {
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
    private var loadedTemplates: UnistrokeRecognizer!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        lines.forEach { (line) in
            for (i, p) in (line.points?.enumerated())! {
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
        guard var lastPoint = lines.popLast() else {return}
        lastPoint.points?.append(pointToBeAdded)
        lastPoint.color = strokeColor
        lastPoint.width = pencilStrokeWidth
        lastPoint.opacity = pencilStrokeOpacity
        lines.append(lastPoint)
        setNeedsDisplay()
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
            if (loadedTemplates == nil){
                loadTemplatesDirectory()
            }
            print(loadedTemplates.recognize(points: points, isUsingProtractor: true))
        }
        
    }
    private func loadTemplatesDirectory() {
            do {
                // Load template files
                loadedTemplates = UnistrokeRecognizer()
                var templatesFolder = Bundle.main.resourcePath!
                templatesFolder.append("/Templates")
                let list = try FileManager.default.contentsOfDirectory(atPath: templatesFolder)
                for file in list {
                    let templateData = NSData(contentsOfFile: templatesFolder.appendingFormat("/%@", file))
                    let templateDict = try JSONSerialization.jsonObject(with: templateData! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    let templateName = templateDict["name"]! as! String
                    let templateRawPoints: [AnyObject] = templateDict["points"]! as! [AnyObject]
                    var templatePoints: [CGPoint] = []
                    for rawPoint in templateRawPoints {
                        let x = (rawPoint as! [AnyObject]).first! as! Double
                        let y = (rawPoint as! [AnyObject]).last! as! Double
                        templatePoints.append(CGPoint(x: x, y: y))
                    }
                    
                    let templateObj = UnistrokeTemplate(name: templateName, pts: templatePoints)
                    loadedTemplates.addTemplate(templateObj)
                }
                // setup scroll view size
            } catch (let error as NSError) {
                print("Something went wrong while loading templates: \(error.localizedDescription)")
            }
        }
}
