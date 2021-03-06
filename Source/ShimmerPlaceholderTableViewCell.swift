//
//  ShimmerPlaceholderTableViewCell.swift
//  ml-app-ios-v2
//
//  Created by Gabriela Nogueira on 04/05/17.
//  Copyright © 2017 LuizaLabs. All rights reserved.
//

import UIKit
import Shimmer


open class ShimmerPlaceholderTableViewCell: UITableViewCell {
    public let placeholderView = ShimmerPlaceholderView()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        placeholderView.frame = self.bounds
    }
    
    fileprivate func commonInit() {
        placeholderView.contentView = self.contentView
        addSubview(placeholderView)

        backgroundColor = .white
        
    }
    
    override open func prepareForReuse() {
        placeholderView.prepareForReuse()
    }
}
