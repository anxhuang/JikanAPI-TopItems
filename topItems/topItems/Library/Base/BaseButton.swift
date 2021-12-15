//
//  BaseButton.swift
//  
//
//  Created by user on 2021/7/11.
//

import UIKit

open class BaseButton: UIButton {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        isExclusiveTouch = true
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.isUserInteractionEnabled = true
        }
    }
}
