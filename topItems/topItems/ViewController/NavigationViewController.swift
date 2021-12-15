//
//  NavigationViewController.swift
//  topItems
//
//  Created by user on 2021/12/12.
//

import UIKit

final class NavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tintColor: UIColor = .white
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: tintColor]
        
        navigationBar.isTranslucent = false
        navigationBar.tintColor = tintColor
        navigationBar.titleTextAttributes = attributes
        navigationBar.barTintColor = .primeBlue

        if #available(iOS 13.0, *) {
            let barAppearance =  UINavigationBarAppearance()
            barAppearance.configureWithOpaqueBackground()
            barAppearance.titleTextAttributes = attributes
            barAppearance.backgroundColor = .primeBlue
            navigationBar.standardAppearance = barAppearance
            navigationBar.scrollEdgeAppearance = barAppearance
        }
        
        view.backgroundColor = .black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
