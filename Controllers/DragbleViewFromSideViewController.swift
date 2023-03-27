//
//  DragbleViewFromSideViewController.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 3/27/23.
//

import Foundation
import UIKit
class DragbleViewFromSideViewController: UIViewController {
    @IBOutlet var dimmedView: UIView!
    @IBOutlet var leftSideView: UIView!
    @IBOutlet var dragView: UIView!
    @IBOutlet var dragableInsideContraint: NSLayoutConstraint!
    @IBOutlet var dragableOutSideContraint: NSLayoutConstraint!
    var sideViewDragCenter: CGPoint = .zero
    var sideViewCenter: CGPoint = .zero
    var sideViewDragInitCenter: CGPoint = .zero
    var sideViewInitCenter: CGPoint = .zero
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add drag gesture
        let dragPan = UIPanGestureRecognizer(target: self, action: #selector(dragableDragView(pan:)))
        dragPan.minimumNumberOfTouches = 1
        dragPan.delegate = self
        dragView.addGestureRecognizer(dragPan)
        sideViewDragInitCenter = dragView.center
        sideViewInitCenter = leftSideView.center
    }
    
}
extension DragbleViewFromSideViewController: UIGestureRecognizerDelegate {
    // MARK: UIGestureRecognizerDelegate
    @objc func gestureRecognizer(
        _: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer
    ) -> Bool {
        true
    }
    @objc func dragableDragView(pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            sideViewDragCenter = dragView.center
            sideViewCenter = leftSideView.center
            self.dimmedView.alpha = 0.5
        case .changed:
            let translation = pan.translation(in: view)
            dragView.center = CGPoint(x: sideViewDragCenter.x + translation.x, y: sideViewDragCenter.y)
            leftSideView.center = CGPoint(x: sideViewCenter.x + translation.x, y: sideViewCenter.y)
            self.dimmedView.alpha = 0.5
        case .ended:
            let velocity = pan.velocity(in: view)
            let show = velocity.x > 0
            if show {
                
            }
            
        default:
            break
        }
    }
}
