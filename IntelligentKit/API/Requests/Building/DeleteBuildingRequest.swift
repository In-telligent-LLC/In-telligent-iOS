//
//  DeleteBuildingRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct DeleteBuildingRequest: APIRequest {
    let building: Building
    
    public init(building: Building) {
        self.building = building
    }
    
    var parameters: Parameters {
        return [:]
    }
}
