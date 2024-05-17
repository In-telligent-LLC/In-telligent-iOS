//
//  INButton.swift
//  Intelligent
//
//  Created by Kurt on 10/11/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

class INButton: UIButton {
    
    var title: String? {
        get { return title(for: .normal) }
        set { setTitle(newValue, for: .normal) }
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
        imageView?.contentMode = .scaleAspectFit
    }

}
