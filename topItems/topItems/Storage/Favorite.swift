//
//  Favorite.swift
//  topItems
//
//  Created by user on 2021/12/14.
//

import Foundation

protocol FavoriteDelegate: AnyObject {
    func didRemoved(item: Item, at index: Int)
}

final class Favorite {
    
    static let shared = Favorite()

    private init() {
        items = Info.shared.load([Item].self, for: .favorite) ?? []
    }
    
    private(set) var items = [Item]() {
        didSet {
            Info.shared.save(obj: items, for: .favorite)
        }
    }
    
    weak var delegate: FavoriteDelegate?
    
    func append(item: Item) {
        items.append(item)
    }
    
    func remove(item: Item) {
        if let index = items.firstIndex(of: item) {
            items.removeAll { $0 == item }
            delegate?.didRemoved(item: item, at: index)
        }
    }
}
