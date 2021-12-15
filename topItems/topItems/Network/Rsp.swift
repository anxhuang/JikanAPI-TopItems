//
//  Rsp.swift
//  topItems
//
//  Created by user on 2021/12/12.
//

import Foundation

struct Rsp: Codable {
    // Status Failed
    var status: Int?
    var type: String?
    var message: String?
    var error: String?
    
    // Top Success
    var request_hash: String?
    var request_cached: Bool?
    var request_cache_expiry: Int?
    var top: [Item]?
}

struct Item: Codable, Equatable {
    var mal_id: Int
    var rank: Int?
    var title: String?
    var url: String?
    var image_url: String?
    var type: String?
    var episodes: Int?
    var start_date: String?
    var end_date: String?
    var members: Int?
    var score: Double?
    
    var encodedUrl: URL? {
        guard let path = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        return URL(string: path)
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        lhs.mal_id == rhs.mal_id
    }
}
