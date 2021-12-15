//
//  topItemsTests.swift
//  topItemsTests
//
//  Created by user on 2021/12/12.
//

import XCTest
@testable import topItems

class topItemsTests: XCTestCase {
    
    private var flow: MainFlow!
    private var mainVC: MainViewController!
    private var item: Item!

    override func setUpWithError() throws {
        Favorite.shared.delegate = nil
        flow = MainFlow()
        Flow.launch(NavigationViewController.self, flow: flow)
        RunLoop.current.run(until: Date())
        mainVC = Flow.topVC as? MainViewController
        
        item = Item(
            mal_id: .random(in: .min ... .max),
            rank: .random(in: .min ... .max),
            title: UUID().uuidString,
            url: "https://myanimelist.net/anime/11111/Another",
            image_url: "https://cdn.myanimelist.net/images/anime/4/75509.jpg?s=bedc6b5df639a126aa125bb4d2ef5424",
            type: UUID().uuidString,
            start_date: UUID().uuidString,
            end_date: UUID().uuidString
        )
    }

    override func tearDownWithError() throws {
        Info.shared.remove(key: .favorite)
        URLSession.shared.configuration.urlCache?.removeAllCachedResponses()
    }
    
    func testTypeTableViewCell() throws {
        // Unselected
        let primeCell = TypeTableViewCell<PrimeType>(style: .default, reuseIdentifier: TypeTableViewCell<PrimeType>.reuseId)
        primeCell.reload(type: .anime, selected: .manga)
        
        XCTAssertEqual(primeCell.contentView.find(UILabel.self, id: .typeName).text, PrimeType.anime.text)
        XCTAssertEqual(primeCell.isSelected, false)
        
        // Selected
        let subCell = TypeTableViewCell<SubType>(style: .default, reuseIdentifier: TypeTableViewCell<SubType>.reuseId)
        subCell.reload(type: .special, selected: .special)
        
        XCTAssertEqual(subCell.contentView.find(UILabel.self, id: .typeName).text, SubType.special.text)
        XCTAssertEqual(subCell.isSelected, true)
    }
    
    func testItemTableViewCell() throws {
        let cell = ItemTableViewCell(style: .default, reuseIdentifier: ItemTableViewCell.reuseId)
        cell.reload(item: item)
        
        XCTAssertEqual(cell.contentView.find(UILabel.self, id: .rankContent).text, String(item.rank!))
        XCTAssertEqual(cell.contentView.find(UILabel.self, id: .titleContent).text, item.title)
        XCTAssertEqual(cell.contentView.find(UILabel.self, id: .typeContent).text, item.type)
        XCTAssertEqual(cell.contentView.find(UILabel.self, id: .startContent).text, item.start_date)
        XCTAssertEqual(cell.contentView.find(UILabel.self, id: .endContent).text, item.end_date)
        
        let favButton = cell.contentView.find(UIButton.self, id: .favoriteButton)
        XCTAssertEqual(favButton.isSelected, false)
        favButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(favButton.isSelected, true)
        XCTAssertEqual(Favorite.shared.items.contains(item), true)
        favButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(favButton.isSelected, false)
        XCTAssertEqual(Favorite.shared.items.contains(item), false)
    }
    
    func testMainViewController() throws {
        XCTAssertTrue(mainVC.delegate === flow)
        
        flow.didTapItemRow(mainVC, item: item)
        RunLoop.current.run(until: Date())
        guard Flow.topVC is WebViewController else {
            XCTFail()
            return
        }
    }

    func testFavoriteTableViewController() throws {
        Favorite.shared.append(item: item)
        
        let barButton = mainVC.navigationItem.rightBarButtonItem!
        mainVC.perform(barButton.action)
        RunLoop.current.run(until: Date())
        guard let favVC = Flow.topVC as? FavoriteTableViewController else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(favVC.delegate === flow)
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        favVC.tableView(favVC.tableView, didSelectRowAt: indexPath)
        RunLoop.current.run(until: Date().addingTimeInterval(1))
        guard Flow.topVC is WebViewController else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(Favorite.shared.delegate === favVC)
        let cell = favVC.tableView.cellForRow(at: indexPath)!
        let favButton = cell.contentView.find(UIButton.self, id: .favoriteButton)
        favButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(Favorite.shared.items.contains(item), false)
    }
    
    func testConnectSuccess() throws {
        
        for prime in PrimeType.allCases {
            for sub in prime.subTypes {
                            
                let req = TopReq(
                    prime: prime,
                    page: 1,
                    sub: sub
                )
                
                let expect = expectation(description: req.url.absoluteString)
                
                var handler = Handler()
                handler.isHidden = true
                handler.success = { rsp in
                    guard rsp.top != nil else { return }
                    expect.fulfill()
                }
                handler.error = { error in
                    XCTFail(error.localizedDescription)
                }
                
                Connect.shared.get(req: req, handler: handler)

                wait(for: [expect], timeout: 15)
            }
        }
    }
    
    func testConnectStatus() throws {
        
        let req = TopReq(
            prime: .anime,
            page: 99,
            sub: .upcoming
        )
        
        let expect = expectation(description: req.url.absoluteString)
        
        var handler = Handler()
        handler.status[404] = { [weak self] rsp in
            guard rsp.status == 404 else { return }
            self?.mainVC.showAlert(title: rsp.type, message: rsp.message, action: .okay, block: nil)
            expect.fulfill()
        }
        
        Connect.shared.get(req: req, handler: handler)
        
        wait(for: [expect], timeout: handler.timeout + 1)
        
        RunLoop.current.run(until: Date())
        guard Flow.topVC is UIAlertController else {
            XCTFail()
            return
        }
    }
    
    func testConnectFailed() throws {
        
        let req = TopReq(
            prime: .anime,
            page: 99,
            sub: .upcoming
        )
        
        let expect = expectation(description: req.url.absoluteString)
        
        var handler = Handler()
        handler.failure = { [weak self] rsp in
            self?.mainVC.showAlert(title: rsp.type, message: rsp.message, action: .okay, block: nil)
            expect.fulfill()
        }
        
        Connect.shared.get(req: req, handler: handler)
        
        wait(for: [expect], timeout: handler.timeout + 1)
        
        RunLoop.current.run(until: Date())
        guard Flow.topVC is UIAlertController else {
            XCTFail()
            return
        }
    }
    
    func testConnectError() throws {
        
        let req = TopReq(
            prime: .anime,
            page: 99,
            sub: .upcoming
        )
        
        let expect = expectation(description: req.url.absoluteString)
        
        var handler = Handler()
        handler.timeout = 0.01
        handler.error = { [weak self] error in
            self?.mainVC.showAlert(title: error.domain, message: error.localizedDescription, action: .retry, block: nil)
            expect.fulfill()
        }
        
        Connect.shared.get(req: req, handler: handler)
        
        wait(for: [expect], timeout: 1)
        
        RunLoop.current.run(until: Date())
        guard Flow.topVC is UIAlertController else {
            XCTFail()
            return
        }
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
