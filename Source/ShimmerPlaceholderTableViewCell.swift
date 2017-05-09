//
//  ShimmerPlaceholderTableViewCell.swift
//  ml-app-ios-v2
//
//  Created by Gabriela Nogueira on 04/05/17.
//  Copyright © 2017 LuizaLabs. All rights reserved.
//

import UIKit
import Shimmer

struct AnimationMetrics {
    static let placeholderLoadingPauseDuration: TimeInterval = 0.125
    static let placeholderLoadingSpeed: CGFloat = 300
    static let placeholderLoadingBeginFadeDuration: TimeInterval = 0.0
}

open class ShimmerPlaceholderTableViewCell: UITableViewCell {
    
    fileprivate let interLineSpacing: CGFloat = 10
    fileprivate var shimmeringView = FBShimmeringView()
    fileprivate var linePlaceholderLayers: [CALayer] = []
    fileprivate var imagePlaceholderLayer: CALayer = CALayer()
    fileprivate var needsUpdateLayers: Bool = true
    
    open var margin: CGFloat = 15
    
    open var imagePlaceholderSize: CGSize = CGSize(width: 35, height: 35) {
        didSet {
            if oldValue == imagePlaceholderSize {
                return
            }
            needsUpdateLayers = true
            
        }
    }
    
    open var placeholderLineHeight: CGFloat = 10 {
        didSet {
            if oldValue == placeholderLineHeight {
                return
            }
            needsUpdateLayers = true
        }
    }
    
    open var numberOfPlaceholderLines: Int = 2 {
        didSet {
            if oldValue == numberOfPlaceholderLines {
                return
            }
            needsUpdateLayers = true
        }
    }
    
    open var smallLinePlaceholdersIndexes: Set<Int> = [1] {
        didSet {
            if oldValue == smallLinePlaceholdersIndexes {
                return
            }
            needsUpdateLayers = true
        }
    }
    
    open var smallLabelRatio: CGFloat = 0.8 {
        didSet {
            if oldValue == smallLabelRatio {
                return
            }
            needsUpdateLayers = true
        }
    }
    
    open var placeholderColor: UIColor = UIColor.lightGrayColor {
        didSet {
            imagePlaceholderLayer.backgroundColor = placeholderColor.cgColor
            linePlaceholderLayers.forEach { $0.backgroundColor = placeholderColor.cgColor }
        }
    }
    
    open var cellHeight: CGFloat {
        let linesTotal = CGFloat(numberOfPlaceholderLines) * placeholderLineHeight
        let spacingTotal = CGFloat(numberOfPlaceholderLines) * interLineSpacing
        let marginTotal = margin * 2
        
        let linesHeightTotal = linesTotal + spacingTotal + marginTotal
        let imageHeightTotal = marginTotal + imagePlaceholderSize.height
        
        return (imageHeightTotal > linesHeightTotal) ? imageHeightTotal : linesHeightTotal
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        addSubview(shimmeringView)
        backgroundColor = .white
        selectionStyle = .none
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if needsUpdateLayers {
            needsUpdateLayers = false
            updateImageLayer()
            updateLineLayers()
        }
        updateShimmeringView()
    }
    
    fileprivate func updateImageLayer() {
        let imageLeftMargin = (imagePlaceholderSize == .zero) ? 0 : margin
        imagePlaceholderLayer.removeFromSuperlayer()
        imagePlaceholderLayer = CALayer()
        let origin = CGPoint(x: imageLeftMargin, y: margin)
        imagePlaceholderLayer.frame = CGRect(origin: origin, size: imagePlaceholderSize)
        imagePlaceholderLayer.backgroundColor = placeholderColor.cgColor
        contentView.layer.addSublayer(imagePlaceholderLayer)
    }
    
    fileprivate func updateLineLayers() {
        for layer in linePlaceholderLayers {
            layer.removeFromSuperlayer()
        }
        linePlaceholderLayers = []
        
        for i in 0..<numberOfPlaceholderLines {
            let originX = imagePlaceholderLayer.frame.maxX + margin
            let originY = imagePlaceholderLayer.frame.minY + (CGFloat(i) * placeholderLineHeight) + (CGFloat(i) * interLineSpacing)
            let widthRatio: CGFloat = smallLinePlaceholdersIndexes.contains(i) ? smallLabelRatio : 1
            let width = (bounds.width - originX - margin) * widthRatio
            let layer = CALayer()
            layer.frame = CGRect(x: originX, y: originY, width: width, height: placeholderLineHeight)
            layer.backgroundColor = placeholderColor.cgColor
            linePlaceholderLayers.append(layer)
            contentView.layer.addSublayer(layer)
        }
        
    }
    
    override open func prepareForReuse() {
        shimmeringView.removeFromSuperview()
        
        shimmeringView = FBShimmeringView()
        shimmeringView.shimmeringSpeed = AnimationMetrics.placeholderLoadingSpeed
        shimmeringView.shimmeringPauseDuration = AnimationMetrics.placeholderLoadingPauseDuration
        shimmeringView.shimmeringBeginFadeDuration = AnimationMetrics.placeholderLoadingBeginFadeDuration
        
        addSubview(shimmeringView)
    }
    
    fileprivate func updateShimmeringView() {
        shimmeringView.frame = bounds
        shimmeringView.contentView = contentView
        shimmeringView.isShimmering = true
    }
    
}
