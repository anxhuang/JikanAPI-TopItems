//
//  Theme.swift
//  topItems
//
//  Created by user on 2021/12/12.
//

import UIKit

extension UIColor {
    
    static let primeBlue = UIColor(red: 0, green: 0.2, blue: 0.4, alpha: 1)
    static let primeOrange = UIColor(red: 0.9, green: 0.6, blue: 0, alpha: 1)
    static let primeGray = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    static let secondGray = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
}

extension UIFont {

    enum Style: String {
        case regular = "HelveticaNeue"
        case medium = "HelveticaNeue-Medium"
        case bold = "HelveticaNeue-Bold"
        case italic = "HelveticaNeue-BoldItalic"
        case mono

        func ofSize(_ size: CGFloat) -> UIFont {
            return self == .mono ? .monospacedDigitSystemFont(ofSize: size, weight: .regular) : UIFont(name: rawValue, size: size)!
        }
    }

    static func h1(_ style: Style) -> UIFont { style.ofSize(26) }
    static func h2(_ style: Style) -> UIFont { style.ofSize(22) }
    static func h3(_ style: Style) -> UIFont { style.ofSize(18) }
    static func h4(_ style: Style) -> UIFont { style.ofSize(16) }
    static func h5(_ style: Style) -> UIFont { style.ofSize(14) }
    static func h6(_ style: Style) -> UIFont { style.ofSize(12) }
}

extension UIImage {
    static let heart_filled = UIImage(named: "heart_filled")
    static let heart_list = UIImage(named: "heart_list")
    static let heart_outline = UIImage(named: "heart_outline")
}
