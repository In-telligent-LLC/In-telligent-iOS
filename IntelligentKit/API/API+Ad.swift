//
//  API+Ad.swift
//  IntelligentKit
//
//  Created by Kurt on 4/24/19.
//  Copyright © 2019 Kurt Jensen. All rights reserved.
//

import Foundation
import Alamofire

//MARK: Ads
extension API {
    
    public class func getAd(_ success: @escaping (_ ad: Ad) -> Void, failure: APIResponseFailureHandler?) {
        shared.get(endpoint: "/subscribers/ad", success: { (json) in
            let bannerAdJSON = json["data"]["bannerAd"]
            let imageName = bannerAdJSON["image"].stringValue
            let imageURL = "https://app.in-telligent.com/img/banner_ads/\(imageName)"
            let ad = Ad(
                id: bannerAdJSON["id"].intValue,
                imageURL: imageURL,
                url: bannerAdJSON["url"].stringValue
            )
            success(ad)
        }, failure: failure)
    }
    
    public class func sendAdClick(_ adId: Int, success: APIResponseSuccessVoidHandler?, failure: APIResponseFailureHandler?) {
        shared.post(endpoint: "/subscribers/clickAd/\(adId)", success: { (json) in
            success?()
        }, failure: failure)
    }
}
