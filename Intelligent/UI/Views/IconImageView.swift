//
//  IconImageView.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/8/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

class IconImageView: UIImageView {
    
    override init(image: UIImage?) {
        super.init(image: image?.withRenderingMode(.alwaysTemplate))
    }
    
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image?.withRenderingMode(.alwaysTemplate), highlightedImage: highlightedImage?.withRenderingMode(.alwaysTemplate))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        image = image?.withRenderingMode(.alwaysTemplate)
    }
    
}
