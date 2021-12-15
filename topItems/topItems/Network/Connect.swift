//
//  Connect.swift
//  topItems
//
//  Created by user on 2021/12/12.
//

import UIKit

final class Connect {
    
    static let shared = Connect()
    private init() {}

    func get(req: Req, handler: Handler) {
        handler.before()
        let request = URLRequest(url: req.url, timeoutInterval: handler.timeout)
        URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                if let error = error {
                    throw error
                } else if let data = data {
                    let rsp = try JSONDecoder().decode(Rsp.self, from: data)
                    DispatchQueue.main.async {
                        switch rsp.status {
                        case 200, .none:
                            handler.success?(rsp)
                        default:
                            if let code = rsp.status,
                               let block = handler.status[code] {
                                block?(rsp)
                            } else {
                                handler.failure?(rsp)
                            }
                        }
                    }
                }
            } catch let error as NSError {
                DispatchQueue.main.async {
                    handler.error?(error)
                }
            }
            handler.after()
        }.resume()
    }
}
