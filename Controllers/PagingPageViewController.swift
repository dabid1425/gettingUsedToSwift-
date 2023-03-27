//
//  PagingPageViewController.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 3/27/23.
//

import Foundation
import UIKit
enum CaseIterablesExample: Int, CaseIterable {
    case case1, case2, case3
}
class PagingPageViewController: UIPageViewController {
    var currentPage: Int = 0
    var superView: UIView?
    private lazy var _viewControllers: [UIViewController] = CaseIterablesExample.allCases.map { segment in
       
        let storyboard = UIStoryboard(name: "storyBoard", bundle: nil)
        switch segment {
            case .case1:
              //get storyboard and set up
            break
            case .case2:
            //get storyboard and set up
             break
            case .case3:
                break
            }
        return UIViewController()
    }
}
extension PagingPageViewController {
    private func setupView() {
        guard let first = _viewControllers[safeIndex: currentPage] else {
            return
        }
        setViewControllers([first], direction: .forward, animated: false)
    }
}
extension PagingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        _viewControllers.before(viewController)
    }
    func pageViewController(
        _: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        _viewControllers.after(viewController)
    }
}
