//
//  LocalText.swift
//  
//
//  Created by user on 2021/7/8.
//

import Foundation

public protocol LocalText: Hashable {
    var prefix: String { get }
    var text: String { get }
}

public extension LocalText {
    var text: String {
        NSLocalizedString(prefix + "." + String(describing: self), comment: "")
    }
}
