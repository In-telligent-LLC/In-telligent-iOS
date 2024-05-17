//
//  BuildingSubscribersManager.swift
//  Intelligent
//
//  Created by Kurt Jensen on 2/13/19.
//  Copyright © 2019 Kurt Jensen. All rights reserved.
//

import UIKit
import IntelligentKit

protocol BuildingSubscribersManagerDelegate: class {
    func didUpdateGroupMembers()
}

class BuildingSubscribersManager: NSObject {
    
    weak var delegate: (INViewController & BuildingSubscribersManagerDelegate)?
    
    var searchText: String? { didSet { filterGroupMembers() } }
    
    private var buildingSubscribers: [BuildingSubscriber] = []
    var filteredBuildingSubscribers: [BuildingSubscriber] = []
    
    let building: Building
    
    init(_ building: Building) {
        self.building = building
        super.init()
    }
    
    public func update() {
        fetchBuildingSubscribers()
    }
}

//MARK: Fetch Building Subscribers
extension BuildingSubscribersManager {
    
    private func fetchBuildingSubscribers() {
        delegate?.showLoading(nil)
        API.getBuildingSubscriberInvites(building, success: { [weak self] (subscribers) in
            self?.delegate?.hideLoading()
            self?.didFetchSubscribers(subscribers)
            }, failure: { [weak self] (error) in
                self?.delegate?.hideLoading()
                self?.delegate?.showError(error)
        })
    }
    
    private func didFetchSubscribers(_ subscribers: [BuildingSubscriber]) {
        let acceptedSubscribers = subscribers.filter({ return $0.status == BuildingSubscriberStatus.accepted })
        self.buildingSubscribers = acceptedSubscribers
        self.filterGroupMembers()
    }
    
    private func filterGroupMembers() {
        if let searchText = searchText, searchText.count > 0 {
            filteredBuildingSubscribers = buildingSubscribers.filter({ return $0.email?.contains(searchText) == true })
        } else {
            filteredBuildingSubscribers = buildingSubscribers
        }
        delegate?.didUpdateGroupMembers()
    }
}
