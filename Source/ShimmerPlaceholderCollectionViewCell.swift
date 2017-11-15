//
//  ShimmerCollectionViewCell.swift
//  ml-app-ios-v2
//
//  Created by Bruno Correa on 08/11/2017.
//  Copyright © 2017 LuizaLabs. All rights reserved.
//

import UIKit


public class ShimmerPlaceholderCollectionViewCell: UICollectionViewCell {
    public let placeholderView = ShimmerPlaceholderView()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
