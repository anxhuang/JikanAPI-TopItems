//
//  ItemTableViewCell.swift
//  topItems
//
//  Created by user on 2021/12/12.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    enum Title: LocalText {
        var prefix: String { "Item.Title" }
        case start
        case end
    }
    
    private let imgContent = CacheImageView()
    private let rankContent = UILabel(id: .rankContent)
    private let titleContent = UILabel(id: .titleContent)
    private let typeContent = UILabel(id: .typeContent)
    private let startContent = UILabel(id: .startContent)
    private let endContent = UILabel(id: .endContent)
    private let favoriteButton = BaseButton(id: .favoriteButton)

    private var item: Item?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        imgContent.contentMode = .scaleAspectFill
        imgContent.clipsToBounds = true
        contentView.addSubview(imgContent)
        imgContent.snp.makeConstraints { make in
            make.top.equalTo(4)
            make.leading.equalTo(8)
            make.centerY.equalToSuperview()
            make.width.equalTo(imgContent.snp.height).multipliedBy(0.65)
        }

        rankContent.textColor = .black
        rankContent.textAlignment = .center
        rankContent.font = .h5(.italic)
        rankContent.adjustsFontSizeToFitWidth = true
        rankContent.backgroundColor = .primeOrange
        rankContent.layer.shadowOffset = .init(width: 2, height: 2)
        rankContent.layer.shadowRadius = 4
        rankContent.layer.shadowOpacity = 0.8
        contentView.addSubview(rankContent)
        rankContent.snp.makeConstraints { make in
            make.top.equalTo(imgContent).offset(4)
            make.leading.equalToSuperview()
            make.trailing.equalTo(imgContent).offset(-16)
        }
        
        titleContent.textColor = .white
        titleContent.font = .h3(.bold)
        titleContent.numberOfLines = 2
        contentView.addSubview(titleContent)
        titleContent.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(imgContent.snp.trailing).offset(8)
            make.trailing.equalTo(-8)
        }
        
        let typeContainer = UIView()
        typeContainer.backgroundColor = .primeBlue
        typeContainer.layer.cornerRadius = 4
        contentView.addSubview(typeContainer)
        typeContainer.snp.makeConstraints { make in
            make.top.equalTo(titleContent.snp.bottom).offset(4)
            make.leading.equalTo(titleContent)
        }
        
        
        typeContent.textColor = .secondGray
        typeContent.font = .h4(.medium)
        typeContainer.addSubview(typeContent)
        typeContent.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.equalTo(2)
            make.leading.equalTo(6)
        }
        
        let startTitle = UILabel()
        startTitle.text = Title.start.text
        startTitle.textColor = .primeGray
        startTitle.font = .h5(.regular)
        contentView.addSubview(startTitle)
        startTitle.snp.makeConstraints { make in
            make.top.equalTo(typeContainer.snp.bottom).offset(4)
            make.leading.equalTo(titleContent)
        }
        
        startContent.textColor = .secondGray
        startContent.font = .h5(.medium)
        contentView.addSubview(startContent)
        startContent.snp.makeConstraints { make in
            make.centerY.equalTo(startTitle)
            make.leading.equalTo(startTitle.snp.trailing).offset(8)
        }

        let endTitle = UILabel()
        endTitle.text = Title.end.text
        endTitle.textColor = .primeGray
        endTitle.font = .h5(.regular)
        contentView.addSubview(endTitle)
        endTitle.snp.makeConstraints { make in
            make.top.equalTo(startTitle.snp.bottom)
            make.leading.equalTo(titleContent)
        }

        endContent.textColor = .secondGray
        endContent.font = .h5(.medium)
        contentView.addSubview(endContent)
        endContent.snp.makeConstraints { make in
            make.centerY.equalTo(endTitle)
            make.leading.equalTo(endTitle.snp.trailing).offset(8)
        }
        
        favoriteButton.setImage(.heart_outline, for: .normal)
        favoriteButton.setImage(.heart_filled, for: .selected)
        favoriteButton.addTarget(self, action: #selector(tapFavoriteButton), for: .touchUpInside)
        contentView.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-8)
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapFavoriteButton() {
        guard let item = item else { return }
        favoriteButton.isSelected.toggle()
        if favoriteButton.isSelected {
            Favorite.shared.append(item: item)
        } else {
            Favorite.shared.remove(item: item)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgContent.image = nil
        rankContent.text = ""
    }

    func reload(item: Item, rankMode: Bool = true) {
        self.item = item
        
        if let url = item.image_url {
            imgContent.load(img: url)
        }
        if let number = item.rank {
            rankContent.text = String(number)
        }
        rankContent.isHidden = !rankMode
        titleContent.text = item.title
        typeContent.text = item.type
        startContent.text = item.start_date
        endContent.text = item.end_date ?? "--"
        favoriteButton.isSelected = Favorite.shared.items.contains(item)
    }
}
