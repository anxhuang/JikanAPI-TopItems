//
//  Extension.swift
//  topItems
//
//  Created by user on 2021/12/12.
//

import UIKit

extension Flow {
    static let loading = LoadingCover()
}

extension URL {
    mutating func append(path: Any?) {
        guard let text = path else { return }
        appendPathComponent("/" + String(describing: text))
    }
}

extension UIViewController {
    func showAlert(title: String?, message: String?, action: Alert.Action = .okay, block: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: action.text, style: .default, handler: block))
        present(alert, animated: true, completion: nil)
    }
}

extension UIView {
    
    convenience init(id: AccessId) {
        self.init()
        set(id: id)
    }
    
    func set(id: AccessId) {
        accessibilityIdentifier = id.rawValue
    }
    
    func find<T: UIView>(_ ofType: T.Type, id: AccessId) -> T {
        findViews(ofType).first { $0.accessibilityIdentifier == id.rawValue }!
    }
}
