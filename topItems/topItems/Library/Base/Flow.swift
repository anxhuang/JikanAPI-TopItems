//
//  Flow.swift
//  
//
//  Created by user on 2021/7/7.
//

import UIKit

open class Flow {
    
    private static var navc: UINavigationController {
        if let navc = UIApplication.shared.appWindow?.rootViewController as? UINavigationController {
            return navc
        } else {
            fatalError("⚠️ UINavigationController not found! Make sure keyWindow is exist and call launch(_:flow:)")
        }
    }
    private static var root: Flow!
    private static var subs = [Flow]()
        
    private static func setRoot(_ flow: Flow, first: UIViewController? = nil) -> UIViewController {
        let firstVC = first ?? flow.firstVC()
        flow.rootVC = firstVC
        root = flow
        return firstVC
    }
    
    private static func topViewController(_ anyVC: UIViewController? = nil) -> UIViewController {

        guard let rootViewController = anyVC ?? UIApplication.shared.appWindow?.rootViewController else {
            fatalError("⚠️ RootViewController not found!")
        }

        switch rootViewController {
        case let navigationController as UINavigationController:
            return topViewController(navigationController.viewControllers.last)

        case let tabBarController as UITabBarController:
            return topViewController(tabBarController.selectedViewController)

        default:
            guard let presented = rootViewController.presentedViewController else {
                return rootViewController
            }
            return topViewController(presented)
        }
    }
    
    public static var topVC: UIViewController { topViewController() }
    
    public static func launch<T: UINavigationController>(_ navcType: T.Type, flow: Flow) {
        UIApplication.shared.appWindow?.rootViewController = T(rootViewController: setRoot(flow))
    }
    
    // MARK: Instance Part
    public weak var rootVC: UIViewController?
    
    public init() {}
    
    open func firstVC() -> UIViewController {
        fatalError("Override this")
    }

    public func push(_ vc: UIViewController) {
        Self.navc.pushViewController(vc, animated: true)
    }
    
    public func pop() {
        Self.navc.popViewController(animated: true)
    }
}
