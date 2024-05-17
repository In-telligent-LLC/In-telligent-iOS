//
//  UIColor.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/5/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

extension UIColor {
    
    var rgb: (red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)? {
        var fRed: CGFloat = 0
        var fGreen: CGFloat = 0
        var fBlue: CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            return (red:fRed, green:fGreen, blue:fBlue, alpha:fAlpha)
        } else {
            return nil
        }
    }
    
    convenience init(hex: String) {
        var r: CGFloat = 1
        var g: CGFloat = 1
        var b: CGFloat = 1
        let a: CGFloat = 1
        let start: String.Index
        if hex.hasPrefix("#") {
            start = hex.index(hex.startIndex, offsetBy: 1)
        } else {
            start = hex.startIndex
        }
        let hexColor = String(hex[start...])
        if hexColor.count == 6 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt32 = 0
            if scanner.scanHexInt32(&hexNumber) {
                r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                b = CGFloat(hexNumber & 0x000000ff) / 255
            }
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
}
