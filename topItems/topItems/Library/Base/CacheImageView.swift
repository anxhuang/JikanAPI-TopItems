//
//  CacheImageView.swift
//  topItems
//
//  Created by user on 2021/12/15.
//

import UIKit

open class CacheImageView: UIImageView {
    
    private var source: String = ""
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        return indicator
    }()
    
    open func load(img url: String) {
        source = url
        fetch(img: url) { [weak self] img, source in
            guard let self = self, self.source == source else { return }
            self.stopLoading()
            self.image = img
        }
    }
    
    private func startLoading() {
        indicator.startAnimating()
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 0.5
    }
    
    private func stopLoading() {
        indicator.stopAnimating()
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
    }
    
    private func fetch(img url: String, completion: @escaping (UIImage, String) -> Void) {
        let request = URLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        let cache = session.configuration.urlCache
        if let data = cache?.cachedResponse(for: request)?.data,
           let img = UIImage(data: data) {
            completion(img, url)
        } else {
            startLoading()
            session.dataTask(with: request) { data, response, error in
                guard let response = response,
                      let data = data,
                      let img = UIImage(data: data) else { return }
                cache?.storeCachedResponse(.init(response: response, data: data), for: request)
                DispatchQueue.main.async {
                    completion(img, url)
                }
            }.resume()
        }
    }
}
