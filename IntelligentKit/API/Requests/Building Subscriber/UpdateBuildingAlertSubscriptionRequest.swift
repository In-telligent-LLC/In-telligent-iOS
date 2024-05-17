//
//  UpdateBuildingAlertSubscriptionRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct UpdateBuildingAlertSubscriptionRequest: APIRequest {
    let building: INBuilding
    let subscription: Subscription
    
    public init(building: INBuilding, subscription: Subscription) {
        self.building = building
        self.subscription = subscription
    }
    
    var parameters: Parameters {
        return [
            "buildingId": building.id,
            "subscription": subscription.rawValue
        ]
    }
}
