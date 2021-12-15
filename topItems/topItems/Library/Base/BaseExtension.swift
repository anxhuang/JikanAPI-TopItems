//
//  BaseExtension.swift
//  
//
//  Created by user on 2021/7/8.
//

import UIKit

public extension UIApplication {
    var appWindow: UIWindow? {
        (delegate as? AppDelegate)?.window
    }
}

public extension UIView {
    
    func findViews<T: UIView>(_ ofType: T.Type) -> [T] {
        return recursiveSubviews.compactMap { $0 as? T }
    }

    var recursiveSubviews: [UIView] {
        return subviews + subviews.flatMap { $0.recursiveSubviews }
    }
}

public extension UITableView {
    
    func register<T: UITableViewCell>(_ cellClass: T.Type) {
        return register(cellClass, forCellReuseIdentifier: T.reuseId)
    }
    
    func dequeue<T: UITableViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.reuseId, for: indexPath) as! T
    }
}

public extension UITableViewCell {
    
    static var reuseId: String { .init(describing: self) }
}
