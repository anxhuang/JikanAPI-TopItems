//
//  AppDelegate.swift
//  topItems
//
//  Created by user on 2021/12/12.
//

import UIKit
import SnapKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window!.backgroundColor = .white
        window!.makeKeyAndVisible()
        Flow.launch(NavigationViewController.self, flow: MainFlow())
        return true
    }
}

