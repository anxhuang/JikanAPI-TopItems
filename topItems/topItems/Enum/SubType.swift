//
//  SubType.swift
//  topItems
//
//  Created by user on 2021/12/13.
//

import Foundation

enum SubType: LocalText {
    var prefix: String { "SubType" }
    // Anime
    case airing
    case upcoming
    case tv
    case movie
    case ova
    case special
    // Mange
    case manga
    case novels
    case oneshots
    case doujin
    case manhwa
    case manhua
    // Both
    case bypopularity
    case favorite
}
