//
//  PrimeType.swift
//  topItems
//
//  Created by user on 2021/12/13.
//

import Foundation

enum PrimeType: LocalText, CaseIterable {
    var prefix: String { "PrimeType" }
    case anime
    case manga
    
    var subTypes: [SubType] {
        switch self {
        case .anime:
            return [
                .bypopularity,
                .favorite,
                .airing,
                .upcoming,
                .tv,
                .movie,
                .ova,
                .special,
            ]
        case .manga:
            return [
                .bypopularity,
                .favorite,
                .manga,
                .novels,
                .oneshots,
                .doujin,
                .manhwa,
                .manhua,
            ]
        }
    }
}
