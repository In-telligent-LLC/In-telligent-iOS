//
//  DeleteBuildingSubscriberRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct DeleteBuildingSubscriberRequest: APIRequest {
    let name: String
    let info: String
    let customImage: CustomImage?
    
    public init(name: String, info: String, customImage: CustomImage) {
        self.name = name
        self.info = info
        self.customImage = customImage
    }
    
    var parameters: Parameters {
        var parameters: Parameters = [
            "name": name,
            "description": info
        ]
        if let customImage = customImage {
            parameters["attachment"] = customImage.imageName ?? ""
            parameters["attachmentData"] = customImage.imageData?.base64EncodedString() ?? ""
        }
        return parameters
    }
}
