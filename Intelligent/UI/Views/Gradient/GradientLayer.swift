//
//  GradientLayer.swift
//  Intelligent
//
//  Created by Kurt on 10/13/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

enum GradientType: String {
    
    struct Points {
        let start: CGPoint
        let end: CGPoint
    }
    
    case leftRight = "leftRight"
    case rightLeft = "rightLeft"
    case topBottom = "topBottom"
    case bottomTop = "bottomTop"
    case topLeftBottomRight = "topLeftBottomRight"
    case bottomRightTopLeft = "bottomRightTopLeft"
    case topRightBottomLeft = "topRightBottomLeft"
    case bottomLeftTopRight = "bottomLeftTopRight"
    
    var points: Points {
        switch self {
        case .leftRight:
            return Points(start: CGPoint(x: 0, y: 0.5), end: CGPoint(x: 1, y: 0.5))
        case .rightLeft:
            return Points(start: CGPoint(x: 1, y: 0.5), end: CGPoint(x: 0, y: 0.5))
        case .topBottom:
            return Points(start: CGPoint(x: 0.5, y: 0), end: CGPoint(x: 0.5, y: 1))
        case .bottomTop:
            return Points(start: CGPoint(x: 0.5, y: 1), end: CGPoint(x: 0.5, y: 0))
        case .topLeftBottomRight:
            return Points(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 1, y: 1))
        case .bottomRightTopLeft:
            return Points(start: CGPoint(x: 1, y: 1), end: CGPoint(x: 0, y: 0))
        case .topRightBottomLeft:
            return Points(start: CGPoint(x: 1, y: 0), end: CGPoint(x: 0, y: 1))
        case .bottomLeftTopRight:
            return Points(start: CGPoint(x: 0, y: 1), end: CGPoint(x: 1, y: 0))
        }
    }
}

class GradientLayer: CAGradientLayer {
    var gradient: GradientType? {
        didSet {
            startPoint = gradient?.points.start ?? CGPoint.zero
            endPoint = gradient?.points.end ?? CGPoint.zero
        }
    }
}

protocol GradientViewProvider {
    associatedtype GradientViewType
}

extension GradientViewProvider where Self: UIView {
    var gradientLayer: GradientViewType {
        return layer as! GradientViewType
    }
}

extension UIView: GradientViewProvider {
    typealias GradientViewType = GradientLayer
}
