//
//  ShimmerPlaceholderView.swift
//  ml-app-ios-v2
//
//  Created by Bruno Correa on 08/11/2017.
//  Copyright © 2017 LuizaLabs. All rights reserved.
//

import UIKit
import Shimmer


public class ShimmerPlaceholderView: UIView {
    public enum LinesAlignment {
        case vertical
        case horizontal
    }
    
    fileprivate let interLineSpacing: CGFloat = 10
    fileprivate var shimmeringView = FBShimmeringView()
    fileprivate var linePlaceholderLayers: [CALayer] = []
    fileprivate var imagePlaceholderLayer: CALayer = CALayer()
    fileprivate var needsUpdateLayers: Bool = true
    
    public var margin: CGFloat = 15
    
    var contentView: UIView?
    
    public var linesAlignment: LinesAlignment = .horizontal {
        didSet {
            if oldValue == linesAlignment {
                return
            }
            needsUpdateLayers = true
            
        }
    }
    
    public var imagePlaceholderSize: CGSize = CGSize(width: 35, height: 35) {
        didSet {
            if oldValue == imagePlaceholderSize {
                return
            }
            needsUpdateLayers = true
            
        }
    }
    
    public var placeholderLineHeight: CGFloat = 10 {
        didSet {
            if oldValue == placeholderLineHeight {
                return
            }
            needsUpdateLayers = true
        }
    }
    
    public var numberOfPlaceholderLines: Int = 2 {
        didSet {
            if oldValue == numberOfPlaceholderLines {
                return
            }
            needsUpdateLayers = true
        }
    }
    
    public var smallLinePlaceholdersIndexes: Set<Int> = [1] {
        didSet {
            if oldValue == smallLinePlaceholdersIndexes {
                return
            }
            needsUpdateLayers = true
        }
    }
    
    public var smallLabelRatio: CGFloat = 0.8 {
        didSet {
            if oldValue == smallLabelRatio {
                return
            }
            needsUpdateLayers = true
        }
    }
    
    public var placeholderColor: UIColor = UIColor.lightGray {
        didSet {
            imagePlaceholderLayer.backgroundColor = placeholderColor.cgColor
            linePlaceholderLayers.forEach { $0.backgroundColor = placeholderColor.cgColor }
        }
    }
    
    public var cellHeight: CGFloat {
        let linesTotal = CGFloat(numberOfPlaceholderLines) * placeholderLineHeight
        let spacingTotal = CGFloat(numberOfPlaceholderLines) * interLineSpacing
        let marginTotal = margin * 2
        
        let linesHeightTotal = linesTotal + spacingTotal + marginTotal
        let imageHeightTotal = marginTotal + imagePlaceholderSize.height
        
        switch linesAlignment {
        case .horizontal:
            return (imageHeightTotal > linesHeightTotal) ? imageHeightTotal : linesHeightTotal
            
        case .vertical:
            return imageHeightTotal + linesHeightTotal
            
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    fileprivate func commonInit() {
        addSubview(shimmeringView)
        backgroundColor = .white
    }
    
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if needsUpdateLayers {
            needsUpdateLayers = false
            updateImageLayer()
            updateLineLayers()
        }
        updateShimmeringView()
    }
    
    public override func updateConstraints() {
        super.updateConstraints()
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
        contentView?.layer.addSublayer(imagePlaceholderLayer)
    }
    
    fileprivate func updateLineLayers() {
        for layer in linePlaceholderLayers {
            layer.removeFromSuperlayer()
        }
        linePlaceholderLayers = []
        
        for i in 0..<numberOfPlaceholderLines {
            let widthRatio: CGFloat = smallLinePlaceholdersIndexes.contains(i) ? smallLabelRatio : 1
            
            let originX: CGFloat
            let originY: CGFloat
            let width: CGFloat
            let height: CGFloat
            
            switch linesAlignment {
            case .horizontal:
                originX = imagePlaceholderLayer.frame.maxX + margin
                originY = imagePlaceholderLayer.frame.minY + (CGFloat(i) * placeholderLineHeight) + (CGFloat(i) * interLineSpacing)
                width = (bounds.width - originX - margin) * widthRatio
                height = placeholderLineHeight

            case .vertical:
                originX = margin
                originY = imagePlaceholderLayer.frame.maxX + margin + (CGFloat(i) * placeholderLineHeight) + (CGFloat(i) * interLineSpacing)
                width = (bounds.width - (margin * 2)) * widthRatio
                height = placeholderLineHeight
                
            }
            
            let layer = CALayer()
            layer.frame = CGRect(x: originX, y: originY, width: width, height: placeholderLineHeight)
            layer.backgroundColor = placeholderColor.cgColor
            linePlaceholderLayers.append(layer)
            contentView?.layer.addSublayer(layer)
        }
        
    }
    
    public func prepareForReuse() {
        shimmeringView.removeFromSuperview()
        
        shimmeringView = FBShimmeringView()
        shimmeringView.shimmeringSpeed = ShimmerAnimationMetrics.placeholderLoadingSpeed
        shimmeringView.shimmeringPauseDuration = ShimmerAnimationMetrics.placeholderLoadingPauseDuration
        shimmeringView.shimmeringBeginFadeDuration = ShimmerAnimationMetrics.placeholderLoadingBeginFadeDuration
        
        addSubview(shimmeringView)
    }
    
    fileprivate func updateShimmeringView() {
        shimmeringView.frame = bounds
        shimmeringView.contentView = contentView
        shimmeringView.isShimmering = true
    }
    
    
}
