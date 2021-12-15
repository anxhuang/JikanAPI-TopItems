//
//  MainViewController.swift
//  topItems
//
//  Created by user on 2021/12/12.
//

import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func didTapFavoriteButton(_ vc: MainViewController)
    func didTapItemRow(_ vc: MainViewController, item: Item)
}

final class MainViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var cellDatas = [Item]()
    private var pageCount = 50
    private var pageToLoad = 1
    private var primeType = PrimeType.anime
    private var subType = SubType.bypopularity
    private var prevIndexPath = IndexPath(row: 0, section: 0)
    
    weak var delegate: MainViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Navigation.topItems.text
        navigationItem.setRightBarButton(.init(image: .heart_list, style: .plain, target: self, action: #selector(tapFavoriteButton)), animated: false)
        
        tableView.register(TypeTableViewCell<PrimeType>.self)
        tableView.register(TypeTableViewCell<SubType>.self)
        tableView.register(ItemTableViewCell.self)
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.isMultipleTouchEnabled = false
        tableView.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.centerX.bottom.equalToSuperview()
        }
        
        getTopItems()
    }
    
    private func makeHeaderView(title: Table) -> UIView {
        let headerView = UIView()
        let label = UILabel()
        label.textColor = .primeGray
        label.font = .h1(.bold)
        label.text = title.text
        headerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.centerY.bottom.equalToSuperview()
            make.leading.equalTo(8)
            make.height.equalTo(48)
        }
        return headerView
    }
    
    private func makeFooterView(title: Table) -> UIView {
        let label = UILabel()
        label.textColor = .primeGray
        label.font = .h3(.bold)
        label.text = title.text
        label.textAlignment = .center
        label.frame.size.height = 48
        return label
    }
    
    private func updateCells(items: [Item]) {
        pageToLoad += 1
        pageCount = items.count
        cellDatas.append(contentsOf: items)
        tableView.reloadData()
    }
    
    private func getTopItems(reset: Bool = false) {
        
        if reset {
            pageToLoad = 1
            cellDatas.removeAll()
        }
        
        let req = TopReq(
            prime: primeType,
            page: pageToLoad,
            sub: subType
        )
        
        var handler = Handler()
        handler.isHidden = pageToLoad > 1
        
        handler.success = { [weak self] rsp in
            guard let items = rsp.top else { return }
            self?.updateCells(items: items)
        }
        
        handler.status[404] = { [weak self] _ in
            guard let self = self else { return }
            self.tableView.tableFooterView = self.makeFooterView(title: .endOfList)
            self.tableView.reloadData()
        }
        
        handler.failure = { [weak self] rsp in
            self?.showAlert(title: rsp.type, message: rsp.message, action: .okay)
        }
        
        handler.error = { [weak self] error in
            self?.showAlert(title: error.domain, message: error.localizedDescription, action: .retry) { _ in
                self?.getTopItems()
            }
        }
     
        Connect.shared.get(req: req, handler: handler)
    }
}

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return PrimeType.allCases.count
        case 1:
            return primeType.subTypes.count
        case 2:
            return cellDatas.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeue(TypeTableViewCell<PrimeType>.self, for: indexPath)
            cell.reload(type: PrimeType.allCases[indexPath.row], selected: primeType)
            return cell
        case 1:
            let cell = tableView.dequeue(TypeTableViewCell<SubType>.self, for: indexPath)
            cell.reload(type: primeType.subTypes[indexPath.row], selected: subType)
            return cell
        case 2:
            let cell = tableView.dequeue(ItemTableViewCell.self, for: indexPath)
            cell.reload(item: cellDatas[indexPath.row])
            return cell
        default:
            return .init()
        }
    }
    
    @objc private func tapFavoriteButton() {
        delegate?.didTapFavoriteButton(self)
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return makeHeaderView(title: .primeType)
        case 1:
            return makeHeaderView(title: .subType)
        case 2:
            return makeHeaderView(title: .items)
        default:
            return .init()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0, 1:
            return 48
        case 2:
            return 120
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            primeType = PrimeType.allCases[indexPath.row]
            subType = .bypopularity
            getTopItems(reset: true)
        case 1:
            subType = primeType.subTypes[indexPath.row]
            getTopItems(reset: true)
        case 2:
            delegate?.didTapItemRow(self, item: cellDatas[indexPath.row])
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.section == 2,
              indexPath.row > cellDatas.count - pageCount / 2,
              indexPath.row > prevIndexPath.row else {
            return
        }
        prevIndexPath.row = cellDatas.count - 1
        getTopItems()
    }
}
