//
//  API+WeatherAlert.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/14/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import Alamofire

//MARK: Weather Alert
extension API {
    public class func sendWeatherAlert(_ buildingId: Int, success: APIResponseSuccessVoidHandler?, failure: APIResponseFailureHandler?) {
        shared.post(endpoint: "/weather/send/\(buildingId)", success: { (json) in
            success?()
        }, failure: failure)
    }
}
