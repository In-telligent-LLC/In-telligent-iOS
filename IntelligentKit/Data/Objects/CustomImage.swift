//
//  CustomImage.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/2/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

public struct CustomImage {
    public let imageName: String?
    public let imageData: Data?
    
    public init(imageName: String?, imageData: Data?) {
        self.imageName = imageName
        self.imageData = imageData
    }
}
