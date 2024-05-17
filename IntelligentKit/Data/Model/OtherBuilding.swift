//
//  OtherBuilding.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/20/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol Building {
    var id: Int { get }
    var name: String? { get }
    var info: String? { get }
    var imageURL: String? { get }
    var websiteURL: String? { get }
    var password: String? { get }
    var image: UIImage? { get }
    var action: Action? { get }
    var createdAt: Date? { get }
    var isPersonal: Bool { get }
    var isVirtual: Bool { get }
    var availableContactActions: [ContactAction] { get }
    var isManagedByCurrentUser: Bool { get }
}

public struct OtherBuilding: Building, Hashable {
    
    public var hashValue: Int {
        return id
    }
    
    public let id: Int
    public let name: String?
    public let info: String?
    public let websiteURL: String?
    public let imageURL: String?
    public let password: String?
    
    public let isPersonal: Bool
    public let isManagedByCurrentUser: Bool

    public let isVirtual: Bool
    public let isVoipEnabled: Bool
    public let isTextEnabled: Bool

    public let createdAt: Date?
    
    init?(json: JSON, isPersonal: Bool) {
        guard let id = json["id"].int else { return nil }
        
        self.id = id
        self.name = json["name"].string
        if let imageURL = json["BuildingCategory"]["BuildingCategoryImages"].array?.first?["image"].string {
            if imageURL.starts(with: "http") {
                self.imageURL = imageURL
            } else {
                self.imageURL = "https://app.in-telligent.com/img/categories/\(imageURL)"
            }
        } else {
            self.imageURL = json["imageUrl"].string 
        }
        self.info = json["description"].string
        self.websiteURL = json["website"].string
        self.password = json["password"].string
        
        self.isManagedByCurrentUser = false
        self.isPersonal = isPersonal

        isVirtual = json["BuildingAddress"]["isVirtual"].boolValue
        isVoipEnabled = json["isVoipEnabled"].intValue > 0
        isTextEnabled = json["isTextEnabled"].intValue == 1

        self.createdAt = DateFormatter.isoDateFormatter.date(from: json["created"].stringValue)
    }

}

extension OtherBuilding {
    public var image: UIImage? {
        return HeroImage.buildingImage(id)
    }
    public var action: Action? {
        return .connect
    }
    public var availableContactActions: [ContactAction] {
        return []
    }
}
