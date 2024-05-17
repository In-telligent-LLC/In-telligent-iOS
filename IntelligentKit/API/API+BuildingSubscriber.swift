//
//  API+BuildingSubscriber.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/2/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import RealmSwift

extension API {
    
    public class func getBuildingSubscriberInvites(_ building: Building, success: @escaping (_ buildingSubscribers: [BuildingSubscriber]) -> Void, failure: @escaping APIResponseFailureHandler) {
        shared.get(endpoint: "/buildings/personalCommunities/\(building.id)/invites", success: { (json) in
            let result = json["success"].boolValue
            if result {
                let buildingSubscribers = BuildingSubscriber.initMany(json: json["invites"])
                success(buildingSubscribers)
            } else {
                let error = INError(json: json)
                failure(error)
            }
        }, failure: failure)
    }
    
    public class func getBuildingSubscribers(_ building: Building, success: @escaping (_ buildingSubscribers: [BuildingSubscriber]) -> Void, failure: @escaping APIResponseFailureHandler) {
        shared.get(endpoint: "/buildings/\(building.id)/subscribers", success: { (json) in
            let result = json["success"].boolValue
            if result {
                let buildingSubscribers = BuildingSubscriber.initMany(json: json)
                success(buildingSubscribers)
            } else {
                let error = INError(json: json)
                failure(error)
            }
        }, failure: failure)
    }
}

extension API {
    public class func updateBuildingAlertSubscription(_ request: UpdateBuildingAlertSubscriptionRequest, success: @escaping APIResponseSuccessVoidHandler, failure: @escaping APIResponseFailureHandler) {
        shared.post(endpoint: "/subscribers/syncAlertSubscription", parameters: request.parameters, success: { (json) in
            let result = json["success"].boolValue
            if result {
                Realm.write({ (realm) in
                    request.building.subscriber?.alertsSubscription = request.subscription
                })
                success()
            } else {
                let error = INError(json: json)
                failure(error)
            }
        }, failure: failure)
    }
}

//MARK: Invite Subscriber
extension API {
    public class func inviteSubscriber(_ request: InviteSubscriberRequest, success: @escaping APIResponseSuccessVoidHandler, failure: @escaping APIResponseFailureHandler) {
        shared.post(endpoint: "/buildings/personalCommunities/\(request.building.id)/invite", parameters: request.parameters, success: { (json) in
            let result = json["success"].boolValue
            if result {
                success()
            } else {
                let error = INError(json: json)
                failure(error)
            }
        }, failure: failure)
    }
}

//MARK: Edit Building Subscriber
extension API {
    public class func editBuildingSubscriber(_ request: EditBuildingSubscriberRequest, success: @escaping APIResponseSuccessVoidHandler, failure: @escaping APIResponseFailureHandler) {
        shared.post(endpoint: "/buildings/personalCommunities/editInvite/\(request.inviteId)", parameters: request.parameters, success: { (json) in
            let result = json["success"].boolValue
            if result {
                success()
            } else {
                let error = INError(json: json)
                failure(error)
            }
        }, failure: failure)
    }
}

//MARK: Delete Building Subscriber
extension API {
    public class func deleteBuildingSubscriber(_ subscriberId: Int, success: @escaping APIResponseSuccessVoidHandler, failure: @escaping APIResponseFailureHandler) {
        shared.post(endpoint: "/buildings/personalCommunities/deleteInvite/\(subscriberId)", success: { (json) in
            let result = json["success"].boolValue
            if result {
                success()
            } else {
                let error = INError(json: json)
                failure(error)
            }
        }, failure: failure)
    }
}
