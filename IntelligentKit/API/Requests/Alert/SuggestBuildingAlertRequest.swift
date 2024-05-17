//
//  SuggestBuildingAlertRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct SuggestBuildingAlertRequest: APIRequest {
    let title: String
    let message: String
    let building: INBuilding
    let attachments: [CustomImage]
    
    public init(title: String, message: String, building: INBuilding, attachments: [CustomImage]) {
        self.title = title
        self.message = message
        self.building = building
        self.attachments = attachments
    }
    
    var parameters: Parameters {
        var parameters: Parameters = [
            "title": title,
            "description": message,
            "building_id": "\(building.id)"
        ]
        if attachments.count > 0 {
            var attachments: [[String: Any]] = []
            for attachment in self.attachments {
                attachments.append([
                    "data": attachment.imageData?.base64EncodedString() ?? "",
                    "name": attachment.imageName ?? ""
                ])
            }
            parameters["attachment"] = attachments
        }
        return parameters
    }
}
