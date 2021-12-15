//
//  FavoriteTableViewController.swift
//  topItems
//
//  Created by user on 2021/12/14.
//

import UIKit

protocol FavoriteTableViewControllerDelegate: AnyObject {
    func didTapItemRow(_ vc: FavoriteTableViewController, item: Item)
}

class FavoriteTableViewController: UITableViewController {
    
    weak var delegate: FavoriteTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = Navigation.favorites.text
        
        tableView.register(ItemTableViewCell.self)
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.isMultipleTouchEnabled = false
        tableView.rowHeight = 120
        tableView.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        
        Favorite.shared.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Favorite.shared.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ItemTableViewCell.self, for: indexPath)
        cell.reload(item: Favorite.shared.items[indexPath.row], rankMode: false)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didTapItemRow(self, item: Favorite.shared.items[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FavoriteTableViewController: FavoriteDelegate {

    func didRemoved(item: Item, at index: Int) {
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
}
