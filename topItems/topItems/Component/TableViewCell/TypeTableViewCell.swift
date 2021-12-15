//
//  TypeTableViewCell.swift
//  topItems
//
//  Created by user on 2021/12/14.
//

import UIKit

final class TypeTableViewCell<T: LocalText>: UITableViewCell {
    
    private let typeName = UILabel(id: .typeName)
    override var isSelected: Bool {
        didSet {
            typeName.font = isSelected ? .h2(.bold) : .h3(.regular)
            accessoryType = isSelected ? .checkmark : .none
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        typeName.textColor = .white
        contentView.addSubview(typeName)
        typeName.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload(type: T, selected: T) {
        typeName.text = type.text
        isSelected = type == selected
    }
}
