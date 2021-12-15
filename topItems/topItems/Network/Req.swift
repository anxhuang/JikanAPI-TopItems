//
//  Req.swift
//  topItems
//
//  Created by user on 2021/12/12.
//

import Foundation

enum Api {
    case top
}

protocol Req {
    var url: URL { get }
}

extension Req {
    fileprivate func makeUrl(_ api: Api) -> URL {
        var url = URL(string: "https://api.jikan.moe/v3")!
        url.append(path: api)
        return url
    }
}

struct TopReq: Req {
    var prime: PrimeType
    var page: Int
    var sub: SubType
    var url: URL {
        var url = makeUrl(.top)
        url.append(path: prime)
        url.append(path: page)
        url.append(path: sub)
        return url
    }
}
