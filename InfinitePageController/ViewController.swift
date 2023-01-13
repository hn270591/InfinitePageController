//
//  ViewController.swift
//  InfinitePageController
//
//  Created by Nguyen Dac Trung on 13/01/2023.
//

import UIKit

class ContentVC: UIViewController {
    var index: Int = 0
    
    private let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.text = "\(index)"
        
        view.backgroundColor = UIColor(hue: CGFloat(index) / 10, saturation: 1, brightness: 1, alpha: 1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.frame = view.bounds
    }
}

class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<3 {
            let content = ContentVC()
            content.index = i + 1
            viewControllers.append(content)
        }
        
        // Add page view controller as a child view
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([viewControllers.first!], direction: .forward, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            guard let current = self.pageViewController.viewControllers?.first else { return }
            if let index = self.viewControllers.firstIndex(of: current) {
                var next: Int
                if index < self.viewControllers.count - 1 {
                    next = index + 1
                } else {
                    next = 0
                }
                self.pageViewController.setViewControllers([self.viewControllers[next]], direction: .forward, animated: true)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageViewController.view.frame = view.bounds
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index < viewControllers.count else { return nil }

        if index == 0 {
            return viewControllers.last
        }
        
        return viewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index < viewControllers.count else { return nil }
        
        if index == viewControllers.count - 1 {
            return viewControllers.first
        }
        
        return viewControllers[index + 1]
    }
    
    // MARK: - UIPageViewControllerDelegate
    
    // Number of indicator for page control
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        viewControllers.count
    }
    
    // Current number of page control
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let current = pageViewController.viewControllers?.first else { return 0 }
        return viewControllers.firstIndex(of: current) ?? 0
    }
}


