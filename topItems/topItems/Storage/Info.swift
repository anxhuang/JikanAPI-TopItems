//
//  Favorite.swift
//  topItems
//
//  Created by user on 2021/12/14.
//

import Foundation

final class Info {
    
    enum InfoKeys: String {
        case favorite
    }
    
    static var shared = Info()
    private init() {}
    
    func save<T: Encodable>(obj: T, for key: InfoKeys) {
        if let encoded = try? JSONEncoder().encode(obj) {
            UserDefaults.standard.set(encoded, forKey: key.rawValue)
        }
    }
    
    func load<T: Decodable>(_ objType: T.Type, for key: InfoKeys) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key.rawValue),
              let obj = try? JSONDecoder().decode(objType, from: data) else {
            return nil
        }
        return obj
    }
    
    func remove(key: InfoKeys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
