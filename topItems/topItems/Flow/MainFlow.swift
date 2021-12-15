//
//  MainFlow.swift
//  topItems
//
//  Created by user on 2021/12/12.
//

import UIKit

final class MainFlow: Flow {
    
    override func firstVC() -> UIViewController {
        let firstVC = MainViewController()
        firstVC.delegate = self
        return firstVC
    }
}

extension MainFlow: MainViewControllerDelegate {
    func didTapFavoriteButton(_ vc: MainViewController) {
        let nextVC = FavoriteTableViewController()
        nextVC.delegate = self
        push(nextVC)
    }
    
    func didTapItemRow(_ vc: MainViewController, item: Item) {
        if let url = item.encodedUrl {
            let nextVC = WebViewController(url: url)
            push(nextVC)
        }
    }
}

extension MainFlow: FavoriteTableViewControllerDelegate {
    func didTapItemRow(_ vc: FavoriteTableViewController, item: Item) {
        if let url = item.encodedUrl {
            let nextVC = WebViewController(url: url)
            push(nextVC)
        }
    }
}
