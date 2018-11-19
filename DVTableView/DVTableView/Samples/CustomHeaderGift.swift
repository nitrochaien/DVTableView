//
//  CustomHeaderGift.swift
//  AlamofireSample
//
//  Created by Nam Vu on 11/18/18.
//  Copyright © 2018 Nam Vu. All rights reserved.
//

import UIKit

class CustomHeaderGift: UITableViewHeaderFooterView {
    let titleLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        
        // Title label
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 0
        titleLabel.text = "abcd\nalalakj\n"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        let topTitleLabel = titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor)
        let leftTitleLabel = titleLabel.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor, constant: 15)
        let rightTitleLabel = titleLabel.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor, constant: -45)
        let bottomTitleLabel = titleLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([topTitleLabel, leftTitleLabel, rightTitleLabel, bottomTitleLabel])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

