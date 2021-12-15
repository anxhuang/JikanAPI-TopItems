//
//  WebViewController.swift
//  topItems
//
//  Created by user on 2021/12/13.
//

import WebKit

class WebViewController: UIViewController {
    
    convenience init(url: URL) {
        self.init()
        webView.load(URLRequest(url: url))
        webView.navigationDelegate = self
    }
    
    private let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Navigation.item.text
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.centerX.bottom.equalToSuperview()
        }
        
        Flow.loading.start()
    }
}

extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        Flow.loading.stop()
    }
}
