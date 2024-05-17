//
//  UIFont.swift
//  Intelligent
//
//  Created by Kurt on 10/17/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

extension UIFont {
    
    private func withTraits(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits)) ?? fontDescriptor
        return UIFont(descriptor: descriptor, size: pointSize)
    }
    
    class func boldItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size).withTraits(.traitBold, .traitItalic)
    }
    
}
