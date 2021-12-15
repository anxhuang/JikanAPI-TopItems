//
//  LoadingCover.swift
//  topItems
//
//  Created by user on 2021/12/12.
//

import UIKit

final class LoadingCover: BaseCover {
    
    private let indicator = UIActivityIndicatorView(style: .whiteLarge)

    override init() {
        super.init()
        indicator.center = cover.center
        cover.addSubview(indicator)
        cover.backgroundColor = .init(white: 0, alpha: 0.25)
    }
    
    func start() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.topWindow?.addSubview(self.cover)
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.cover.alpha = 1
                self?.indicator.startAnimating()
            }
        }
    }
    
    func stop() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                self?.indicator.stopAnimating()
                self?.cover.alpha = 0
            }) { [weak self] _ in
                self?.cover.removeFromSuperview()
            }
        }
    }
}

