//
//  ScrollableWithCollectionViews.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 3/27/23.
//

import Foundation
import UIKit
class ScrollableWithCollectionViews: UIViewController {
    
    @IBOutlet var topCollectionView: UICollectionView!
    @IBOutlet var bottomCollectionViewHeightContraint: NSLayoutConstraint!
    @IBOutlet var topCollectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var bottomCollectionView: UICollectionView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topCollectionViewHeightConstraint.constant =
        topCollectionView.collectionViewLayout.collectionViewContentSize.height
        bottomCollectionViewHeightContraint.constant =
        bottomCollectionView.collectionViewLayout.collectionViewContentSize.height
      
    }
}
