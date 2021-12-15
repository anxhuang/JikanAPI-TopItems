//
//  Alert.swift
//  topItems
//
//  Created by user on 2021/12/12.
//

import Foundation

enum Alert {
    enum Action: LocalText {
        var prefix: String { "Alert.Action" }
        case okay
        case retry
    }
}
