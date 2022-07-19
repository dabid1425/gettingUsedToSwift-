/**
 * The $1 Unistroke Recognizer
 *
 *    Jacob O. Wobbrock, Ph.D.
 *     The Information School
 *    University of Washington
 *    Seattle, WA 98195-2840
 *    wobbrock@uw.edu
 *
 *    Andrew D. Wilson, Ph.D.
 *    Microsoft Research
 *    One Microsoft Way
 *    Redmond, WA 98052
 *    awilson@microsoft.com
 *
 *    Yang Li, Ph.D.
 *    Department of Computer Science and Engineering
 *     University of Washington
 *    Seattle, WA 98195-2840
 *     yangli@cs.washington.edu
 *
 * The academic publication for the $1 recognizer, and what should be
 * used to cite it, is:
 *
 *  Wobbrock, J.O., Wilson, A.D. and Li, Y. (2007). Gestures without
 *       libraries, toolkits or training: A $1 recognizer for user interface
 *       prototypes. Proceedings of the ACM Symposium on User Interface
 *       Software and Technology (UIST '07). Newport, Rhode Island (October
 *       7-10, 2007). New York: ACM Press, pp. 159-168.
 *
 * The Protractor enhancement was separately published by Yang Li and programmed
 * here by Jacob O. Wobbrock:
 *
 *  Li, Y. (2010). Protractor: A fast and accurate gesture
 *      recognizer. Proceedings of the ACM Conference on Human
 *      Factors in Computing Systems (CHI '10). Atlanta, Georgia
 *      (April 10-15, 2010). New York: ACM Press, pp. 2169-2172.
 *
 * This software is distributed under the "New BSD License" agreement:
 *
 * Copyright (C) 2007-2012, Jacob O. Wobbrock, Andrew D. Wilson and Yang Li.
 * All rights reserved. Last updated July 14, 2018.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *    * Redistributions of source code must retain the above copyright
 *      notice, this list of conditions and the following disclaimer.
 *    * Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in the
 *      documentation and/or other materials provided with the distribution.
 *    * Neither the names of the University of Washington nor Microsoft,
 *      nor the names of its contributors may be used to endorse or promote
 *      products derived from this software without specific prior written
 *      permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 * IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Jacob O. Wobbrock OR Andrew D. Wilson
 * OR Yang Li BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
 * OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 **/

 /**
 * (Swift version) is provided by Oleksandr Glagoliev 12.04.19
 * fewlinesofcode.com
 */

import Foundation
import CoreGraphics


/// Result structure
struct UnistrokeResult {
    let name: String
    let score: Float
    let time: TimeInterval?
}

/// CGFloat convenience
extension CGFloat {
    var sqr: CGFloat { return self * self }
    
    
    /// Deg to radian conversion
    ///
    /// - Parameter deg: degrees
    /// - Returns: radians
    static func degToRad(deg: CGFloat) -> CGFloat {
        return deg * .pi / 180.0
    }
}

/// CGPoint convenience
extension CGPoint {
    
    /// Measures distance between two points
    ///
    /// - Parameter point: coordinates of given point
    /// - Returns: distance to given point
    func distance(to point: CGPoint) -> CGFloat {
        let xDist = x - point.x
        let yDist = y - point.y
        return CGFloat(xDist.sqr + yDist.sqr).squareRoot()
    }
}


// MARK: - Convenience methods on array of CGPoints
extension Array where Element == CGPoint {
    
    var pathLength: CGFloat {
        guard count > 1 else { return 0 }
        
        var length = CGFloat.zero
        for i in 1..<count {
            length += self[i - 1].distance(to: self[i])
        }
        return length
    }
    
    var boundingBox: CGRect {
        var minX = CGFloat.infinity
        var maxX = -CGFloat.infinity
        var minY = CGFloat.infinity
        var maxY = -CGFloat.infinity
        
        for point in self {
            minX = Swift.min(minX, point.x)
            minY = Swift.min(minY, point.y)
            maxX = Swift.max(maxX, point.x)
            maxY = Swift.max(maxY, point.y)
        }
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
    
    var centroid: CGPoint {
        var x = CGFloat.zero
        var y = CGFloat.zero
        forEach {
            x += $0.x
            y += $0.y
        }
        x /= CGFloat(self.count)
        y /= CGFloat(self.count)
        return CGPoint(x: x, y: y)
    }
    
    var indicativeAngle: CGFloat {
        let c = centroid
        return atan2(c.y - self[0].y, c.x - self[0].x)
    }
    
    var vectorized: [CGFloat] {
        var sum = CGFloat.zero
        var vector = [CGFloat]()
        for p in self {
            vector.append(p.x)
            vector.append(p.y)
            sum += p.x.sqr + p.y.sqr
        }
        let magnitude = sum.squareRoot()
        return vector.map { $0 / magnitude }
    }
    
    func distance(to path: [CGPoint]) -> CGFloat {
        guard self.count == path.count else {
            fatalError("Paths lengths should be equal")
        }
        
        var distance = CGFloat.zero
        for i in 0..<count {
            distance += self[i].distance(to: path[i])
        }
        return distance / CGFloat(count)
    }
    
    func rotate(by radians: CGFloat) -> [CGPoint] {
        let sin = CoreGraphics.sin(radians)
        let cos = CoreGraphics.cos(radians)
        let c = self.centroid
        var rotatedPoints = [CGPoint]()
        forEach {
            let qx = ($0.x - c.x) * cos - ($0.y - c.y) * sin + c.x
            let qy = ($0.x - c.x) * sin + ($0.y - c.y) * cos + c.y
            rotatedPoints.append(CGPoint(x: qx, y: qy))
        }
        return rotatedPoints
    }
    
    func scale(to size: CGFloat) -> [CGPoint] {
        let b = boundingBox
        var scaledPoints = [CGPoint]()
        for point in self {
            let qx = point.x * (size / b.width)
            let qy = point.y * (size / b.height)
            scaledPoints.append(CGPoint(x: qx, y: qy))
        }
        return scaledPoints
    }
    
    func translate(to point: CGPoint) -> [CGPoint] {
        let c = centroid
        var translatedPoints = [CGPoint]()
        for p in self {
            let qx = p.x + point.x - c.x
            let qy = p.y + point.y - c.y
            translatedPoints.append(CGPoint(x: qx, y: qy))
        }
        return translatedPoints
    }
}

func distanceAtAngle(points: [CGPoint], template: UnistrokeTemplate, angle: CGFloat) -> CGFloat {
    let rotatedPoints = points.rotate(by: angle)
    return rotatedPoints.distance(to: template.points)
}

func distanceAtBestAngle(points: [CGPoint], template: UnistrokeTemplate, fromAngle: CGFloat, toAngle: CGFloat, anglePrecision: CGFloat) -> CGFloat {
    
    let phi: CGFloat = 0.5 * (-1.0 + sqrt(5.0)) // Golden Ratio
    
    var a = fromAngle
    var b = toAngle
    var x1 = phi * a + (1 - phi) * b
    var f1 = distanceAtAngle(points: points, template: template, angle: x1)
    var x2 = (1.0 - phi) * a + phi * b
    var f2 = distanceAtAngle(points: points, template: template, angle: x2)
    while abs(b - a) > anglePrecision {
        if (f1 < f2) {
            b = x2
            x2 = x1
            f2 = f1
            x1 = phi * a + (1.0 - phi) * b
            f1 = distanceAtAngle(points: points, template: template, angle: x1)
        } else {
            a = x1
            x1 = x2
            f1 = f2
            x2 = (1.0 - phi) * a + phi * b
            f2 = distanceAtAngle(points: points, template: template, angle: x2)
        }
    }
    return min(f1, f2)
}

func resample(pts: [CGPoint], n: Int) -> [CGPoint] {
    var points = pts
    let increment = points.pathLength / CGFloat(n - 1)
    var D = CGFloat.zero
    var resampledPoints = [pts[0]]
    
    var i = 1
    while i < points.count {
        let d = points[i-1].distance(to: points[i])
        if D + d >= increment {
            let qx = points[i-1].x + ((increment - D) / d) * (points[i].x - points[i-1].x)
            let qy = points[i-1].y + ((increment - D) / d) * (points[i].y - points[i-1].y)
            let q = CGPoint(x: qx, y: qy)
            resampledPoints.append(q)
            points.insert(q, at: i) // insert 'q' at position i in points s.t. 'q' will be the next i
            D = 0.0
        } else {
            D += d
        }
        i += 1
    }
    
    if resampledPoints.count == n - 1 {
        resampledPoints.append(resampledPoints.last!)
    }
    
    return resampledPoints
}


func optimalCosineDistance(v1: [CGFloat], v2: [CGFloat]) -> CGFloat {
    guard v1.count == v2.count else { fatalError("Vector size mismatch!") }
    var a = CGFloat.zero
    var b = CGFloat.zero
    for i in stride(from: 0, to: v1.count, by: 2) {
        a += v1[i] * v2[i] + v1[i+1] * v2[i+1]
        b += v1[i] * v2[i+1] - v1[i+1] * v2[i]
    }
    let angle = atan(b / a);
    return acos(a * cos(angle) + b * sin(angle))
}


class UnistrokeRecognizer {
    /// Unistroke constants
    static let numPoints: Int = 64
    static let squareSize: CGFloat = 250
    static let origin: CGPoint = .zero
    static let angleRange = CGFloat.degToRad(deg: 45.0)
    static let anglePrecision = CGFloat.degToRad(deg: 2.0)
    static let diagonal = sqrt(squareSize.sqr + squareSize.sqr)
    static let halfDiagonal = 0.5 * diagonal
    
    private(set) var templates = [UnistrokeTemplate]()
    
    /// Adds new template to the collection
    ///
    /// - Parameters:
    ///   - name: template id
    ///   - points: vector of points
    func addTemplate(name: String, points: [CGPoint]) {
        templates.append(UnistrokeTemplate(name: name, pts: points))
    }
    
    
    /// Adds new template to recognizers library
    ///
    /// - Parameter template: template
    func addTemplate(_ template: UnistrokeTemplate) {
        templates.append(template)
    }
    
    /// Removes all templates from recognizers library
    func deleteTemplates() {
        templates.removeAll()
    }
    
    
    /// Recieves vector of CGPoints (usually defined by users drawing)
    /// performs normalization and compares it to known templates
    ///
    /// - Parameters:
    ///   - points: input CGPoint vector
    ///   - isUsingProtractor: if `true` - uses Protractor algorithm
    /// - Returns: result containing recognized class, confidence and elapsed time
    func recognize(points: [CGPoint], isUsingProtractor: Bool = false) -> UnistrokeResult {
        let startTime = Date()
        var pts = resample(pts: points, n: UnistrokeRecognizer.numPoints)
        let radians = pts.indicativeAngle
        pts = pts
            .rotate(by: -radians)
            .scale(to: UnistrokeRecognizer.squareSize)
            .translate(to: UnistrokeRecognizer.origin)
        let vector = pts.vectorized
        var b = CGFloat.infinity
        var u = -1
        var i = Int.zero
        for tpl in templates {
            var d: CGFloat
            if isUsingProtractor {
                d = optimalCosineDistance(v1: tpl.points.vectorized, v2: vector)
            } else {
                d = distanceAtBestAngle(points: pts, template: tpl, fromAngle: -UnistrokeRecognizer.angleRange, toAngle: UnistrokeRecognizer.angleRange, anglePrecision: UnistrokeRecognizer.anglePrecision)
            }
            
            if (d < b) {
                b = d // best (least) distance
                u = i // unistroke index
            }
            i += 1
        }
        let dt = Date().timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
        return (u == -1)
            ? UnistrokeResult(name: "No match", score: 0, time: dt)
            : UnistrokeResult(name: templates[u].name, score: isUsingProtractor ? Float(1.0 / b) : Float(1.0 - b / UnistrokeRecognizer.halfDiagonal), time: dt)
    }
}


/// Struct describing uinistroke template
struct UnistrokeTemplate {
    let name: String
    let points: [CGPoint]
    
    /// Initializer
    ///
    /// - Parameters:
    ///   - name: template id (name is used for simplicity sake)
    ///   - pts: vector of points (predefined or pretrained)
    init(name: String, pts: [CGPoint]) {
        self.name = name
        let points = resample(pts: pts, n: UnistrokeRecognizer.numPoints)
        let radians = points.indicativeAngle
        self.points = points
            .rotate(by: -radians)
            .scale(to: UnistrokeRecognizer.squareSize)
            .translate(to: UnistrokeRecognizer.origin)
    }
}
