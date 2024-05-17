//
//  API+Building.swift
//  Intelligent
//
//  Created by Kurt on 10/24/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

extension API {
    public class func searchBuildings(_ request: SearchBuildingRequest, success: @escaping (_ buildings: [OtherBuilding]) -> Void, failure: @escaping APIResponseFailureHandler) -> DataRequest {
        return shared.get(endpoint: "/buildings/search", parameters: request.parameters, success: { (json) in
            var buildings: [OtherBuilding] = []
            for bJSON in json["Buildings"].arrayValue {
                if let building = OtherBuilding(json: bJSON, isPersonal: false) {
                    buildings.append(building)
                }
            }
            //let hasMoreData = json["hasMoreData"].boolValue
            success(buildings)
        }, failure: failure)
    }

    public class func getSuggestedBuildings(_ success: @escaping (_ buildings: [OtherBuilding]) -> Void, failure: @escaping APIResponseFailureHandler) {
        shared.get(endpoint: "/buildings/suggested", success: { (json) in
            let result = json["success"].boolValue
            if result {
                var buildings: [OtherBuilding] = []
                for bJSON in json["Buildings"].arrayValue {
                    if let building = OtherBuilding(json: bJSON, isPersonal: false) {
                        buildings.append(building)
                    }
                }
                //let hasMoreData = json["hasMoreData"].boolValue
                success(buildings)
            } else {
                let error = INError(json: json)
                failure(error)
            }
        }, failure: failure)
    }
}

//MARK: Create (personal) Building (community)
extension API {
    public class func createBuilding(_ request: CreateBuildingRequest, success: @escaping APIResponseSuccessVoidHandler, failure: @escaping APIResponseFailureHandler) {
        shared.post(endpoint: "/buildings/create_personal_community", parameters: request.parameters, success: { (json) in
            let result = json["success"].boolValue
            if result {
                updateCurrentSubscriber({ (_) in
                    success()
                }, failure: failure)
            } else {
                let error = INError(json: json)
                failure(error)
            }
        }, failure: failure)
    }
}

//MARK: Get Building (community)
extension API {
    public class func getBuilding(_ buildingId: Int, success: @escaping (Building) -> Void, failure: @escaping APIResponseFailureHandler) {
        shared.get(endpoint: "/buildings/get/\(buildingId)", success: { (json) in
            guard let building = OtherBuilding(json: json["Building"], isPersonal: false) else {
                failure(nil)
                return
            }
            success(building)
        }, failure: failure)
    }
}

//MARK: Edit (personal) Building (community)
extension API {
    public class func editBuilding(_ request: EditBuildingRequest, success: @escaping APIResponseSuccessVoidHandler, failure: @escaping APIResponseFailureHandler) {
        shared.post(endpoint: "/buildings/create_personal_community/\(request.building.id)", parameters: request.parameters, success: { (json) in
            let result = json["success"].boolValue
            if result {
                updateCurrentSubscriber({ (_) in
                    success()
                }, failure: failure)
            } else {
                let error = INError(json: json)
                failure(error)
            }
        }, failure: failure)
    }
}

//MARK: Delete (personal) Building (community)
extension API {
    public class func deleteBuilding(_ request: DeleteBuildingRequest, success: @escaping APIResponseSuccessVoidHandler, failure: @escaping APIResponseFailureHandler) {
        shared.post(endpoint: "/buildings/personalCommunities/deletePersonalCommunity/\(request.building.id)", success: { (json) in
            let result = json["success"].boolValue
            if result {
                updateCurrentSubscriber({ (_) in
                    success()
                }, failure: failure)
            } else {
                let error = INError(json: json)
                failure(error)
            }
        }, failure: failure)
    }
}

//MARK: Subscribe from Community
extension API {
    public class func subscribeToBuilding(_ request: SubscribeBuildingRequest, success: APIResponseSuccessVoidHandler?, failure: APIResponseFailureHandler?) {
        shared.post(endpoint: "/buildings/update-subscription", parameters: request.parameters, success: { (json) in
            let result = json["success"].boolValue
            if result {
                if let subscriber = INSubscriber(json: json["Subscriber"]) {
                    INSubscriberManager.updateCurrentSubscriber(subscriber)
                }
                if request.optIn {
                    let autoRequest = AutoSubscribeOptRequest(buildingId: request.buildingId, optOut: false)
                    autoSubscribe(autoRequest, success: nil, failure: nil)
                }
                success?()
            } else {
                let error = INError(json: json)
                failure?(error)
            }
        }, failure: failure)
    }
}

//MARK: Unsubscribe from Community
extension API {
    public class func unsubscribeFromBuilding(_ request: UnsubscribeBuildingRequest, success: APIResponseSuccessVoidHandler?, failure: APIResponseFailureHandler?) {
        shared.post(endpoint: "/buildings/update-subscription", parameters: request.parameters, success: { (json) in
            let result = json["success"].boolValue
            if result {
                if let subscriber = INSubscriber(json: json["Subscriber"]) {
                    INSubscriberManager.updateCurrentSubscriber(subscriber)
                }
                if let building: INBuilding = INBuilding.object(forPrimaryKey: request.buildingId) {
                    Realm.write({ (realm) in
                        building.isSubscribedByCurrentUser = false
                    })
                }
                success?()
            } else {
                let error = INError(json: json)
                failure?(error)
            }
        }, failure: failure)
    }
}

//MARK: AutoSubscribe Opt for Community
extension API {
    public class func autoSubscribe(_ request: AutoSubscribeOptRequest, success: APIResponseSuccessVoidHandler?, failure: APIResponseFailureHandler?) {
        shared.post(endpoint: "/subscribers/autosubscribeOptOut", parameters: request.parameters, success: { (json) in
            let result = json["success"].boolValue
            if result {
                if let subscriber = INSubscriber.current {
                    Realm.write({ (realm) in
                        var ids = Array(subscriber.autoSubscribeOptOutBuildingIds)
                        if request.optOut {
                            ids.append(request.buildingId)
                        } else {
                            ids = ids.filter({ return $0 != request.buildingId })
                        }
                        let autoSubscribeOptOutBuildingIds = List<Int>()
                        autoSubscribeOptOutBuildingIds.append(objectsIn: ids)
                        subscriber.autoSubscribeOptOutBuildingIds = autoSubscribeOptOutBuildingIds
                    })
                    INSubscriberManager.updateCurrentSubscriber(subscriber)
                }
                success?()
            } else {
                let error = INError(json: json)
                failure?(error)
            }
        }, failure: failure)
    }
}
