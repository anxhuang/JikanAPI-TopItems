//
//  BaseCover.swift
//
//
//  Created by user on 2021/8/21.
//

import UIKit

open class BaseCover {

    private static let isObserving: Bool = {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { _ in
            isKeyboardAppearing = true
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { _ in
            isKeyboardAppearing = false
        }
        return true
    }()

    private static var isKeyboardAppearing = false

    public var cover = UIView(frame: UIScreen.main.bounds)
    public var appWindow: UIWindow? { UIApplication.shared.appWindow }
    public var topWindow: UIWindow? {
        return Self.isKeyboardAppearing ? UIApplication.shared.windows.last : appWindow
    }

    public init() {
        guard Self.isObserving else { return }
    }
}
