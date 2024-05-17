//
//  GradientView.swift
//  Intelligent
//
//  Created by Kurt on 10/13/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

class GradientView: UIView {

    @IBInspectable
    var startColor: UIColor = UIColor.white { didSet { setupGradient() } }
    
    @IBInspectable
    var endColor: UIColor = UIColor.white.withAlphaComponent(0.01) { didSet { setupGradient() } }
    
    @IBInspectable
    var startPercentage: Float = 0.3 { didSet { setupGradient() } }
    
    @IBInspectable
    var endPercentage: Float = 1 { didSet { setupGradient() } }
    
    @IBInspectable
    var gradientTypeString: String? { didSet { setupGradient() } }
    
    @IBInspectable
    var gradientLayerCornerRadius: CGFloat {
        get { return gradientLayer.cornerRadius }
        set { gradientLayer.cornerRadius = newValue }
    }
    
    var gradientType: GradientType {
        get {
            if let gradientTypeString = gradientTypeString,
                let type = GradientType(rawValue: gradientTypeString) {
                return type
            } else {
                return .bottomTop
            }
        }
        set {
            gradientTypeString = newValue.rawValue
        }
    }
    
    var colors: [UIColor] {
        return [
            startColor,
            endColor
        ]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    internal func commonInit() {
        setupGradient()
    }
    
    private func setupGradient() {
        gradientLayer.gradient = gradientType
        gradientLayer.locations = [NSNumber(value: startPercentage), NSNumber(value: endPercentage)]
        gradientLayer.colors = colors.map({ return $0.cgColor })
    }
    
    override public class var layerClass: Swift.AnyClass {
        get {
            return GradientLayer.self
        }
    }
    
}

