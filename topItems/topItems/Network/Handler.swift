//
//  Handler.swift
//  topItems
//
//  Created by user on 2021/12/12.
//

import UIKit

struct Handler {
    var isHidden: Bool = false
    var timeout: TimeInterval = 10
    var success: ((_ rsp: Rsp) -> Void)?
    var failure: ((_ rsp: Rsp) -> Void)?
    var status: [Int: ((_ rsp: Rsp) -> Void)?] = [:]
    var error: ((_ error: NSError) -> Void)?
    
    func before() {
        isHidden ? nil : Flow.loading.start()
    }
    
    func after() {
        isHidden ? nil : Flow.loading.stop()
    }
}
