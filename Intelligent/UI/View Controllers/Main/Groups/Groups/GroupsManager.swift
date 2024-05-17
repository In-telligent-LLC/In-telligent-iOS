//
//  GroupsManager.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/13/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
import IntelligentKit

protocol GroupsManagerDelegate: AnyObject {
    func didUpdateGroups()
}

class GroupsManager: NSObject {
    
    enum GroupCollection {
        case suggested(andRemoveBuildingId: Int?), mine, search(onlyIfSearchTextIs: String)
    }
    
    weak var delegate: (INViewController & GroupsManagerDelegate)?
    
    private (set)var currentSearchRequest: DataRequest?
    var filter: GroupFilter? { didSet { configureToken() } }
    var searchText: String? { didSet { configureToken() } }

    private (set)var suggestedBuildings: [OtherBuilding] = []
    
    private var myBuildingResults: Results<INBuilding>?
    private var myBuildingsIds: [Int] = []
    private (set)var myBuildings: [INBuilding] = [] {
        didSet {
            myBuildingsIds = myBuildings.map({ return $0.id })
            filterOtherBuildings()
        }
    }
    
    private var otherBuildings: [OtherBuilding] = []
    private (set)var otherBuildingsFiltered: [OtherBuilding] = []
    
    private var token: NotificationToken?
    override init() {
        super.init()
        
        configureToken()
    }
    
    private func configureToken() {
        token?.invalidate()
        
        myBuildingResults = INSubscriber.current?.myBuildings
            .sorted(byKeyPath: "name")
        if let filter = filter, filter != .none {
            myBuildingResults = myBuildingResults?.filter("_filterCategory = %@", filter.rawValue)
        }
        if let searchText = searchText, !searchText.isEmpty {
            myBuildingResults = myBuildingResults?.filter("name CONTAINS[c] %@", searchText)
        }
        
        token = myBuildingResults?.observe({ [weak self] (change) in
            guard let strongSelf = self,
                let results = strongSelf.myBuildingResults else { return }
            
            strongSelf.didUpdateMyBuildings(Array(results))
        })
    }

    public func update(_ collections: [GroupCollection]) {
        for collection in collections {
            switch collection {
            case .suggested(let buildingId):
                fetchSuggestedBuildings(andRemove: buildingId)
            case .mine:
                fetchMyBuildings()
            case .search(let onlyIfSearchTextIs):
                searchBuildingsIfSearchText(is: onlyIfSearchTextIs)
            }
        }
    }
    
    public func removeSuggested(_ building: Building) {
        guard let building = building as? OtherBuilding else { return }
        
        update([.suggested(andRemoveBuildingId: building.id)])
    }
    
}

//MARK: BuildingsDataSource
extension GroupsManager: BuildingsDataSource {
    private func building(offset: Int, from currentBuilding: Building) -> Building? {
        var building: Building?
        if let otherBuilding = currentBuilding as? OtherBuilding {
            if let index = suggestedBuildings.index(of: otherBuilding) {
                building = suggestedBuildings[safe: index+offset]
            } else if let index = otherBuildings.index(of: otherBuilding) {
                building = otherBuildings[safe: index+offset]
            }
        } else if let inBuilding = currentBuilding as? INBuilding {
            if let index = myBuildings.index(of: inBuilding) {
                building = myBuildings[safe: index+offset]
            }
        }
        return building
    }
    
    func nextBuilding(after building: Building) -> Building? {
        let building: Building? = self.building(offset: 1, from: building)
        return building
    }
    
    func previousBuilding(before building: Building) -> Building? {
        let building: Building? = self.building(offset: -1, from: building)
        return building
    }
}

//MARK: Fetch My Buildings
extension GroupsManager {
    
    private func fetchMyBuildings() {
        delegate?.showLoading(nil)
        API.updateCurrentSubscriber({ [weak self] (subscriber) in
            self?.delegate?.hideLoading()
        }) { [weak self] (error) in
            self?.delegate?.hideLoading()
            self?.delegate?.showError(error)
        }
    }
    
    private func didUpdateMyBuildings(_ buildings: [INBuilding]) {
        self.myBuildings = buildings
        delegate?.didUpdateGroups()
    }
}

//MARK: Filter Buildings
extension GroupsManager {
    
    private func filterOtherBuildings() {
        DispatchQueue.global(qos: .background).async {
            let otherBuildingsFiltered: [OtherBuilding] = self.otherBuildings.filter({ return !self.myBuildingsIds.contains($0.id) })
            DispatchQueue.main.async(execute: {
                self.otherBuildingsFiltered = otherBuildingsFiltered
                self.delegate?.didUpdateGroups()
            })
        }
    }
}

//MARK: Fetch Suggested Buildings
extension GroupsManager {
    
    private func fetchSuggestedBuildings(andRemove buildingId: Int?) {
        // dont do anything with show/hideLoading(), as suggested are initially hidden anyway.
        API.getSuggestedBuildings({ [weak self] (buildings) in
            self?.didFetchSuggestedBuildings(buildings, remove: buildingId)
        }) { [weak self] (error) in
            self?.delegate?.showError(error)
        }
    }
    
    private func didFetchSuggestedBuildings(_ buildings: [OtherBuilding], remove buildingId: Int?) {
        var suggestedBuildings = self.suggestedBuildings
        suggestedBuildings.append(contentsOf: buildings)
        
        suggestedBuildings = suggestedBuildings.filter({ return !myBuildingsIds.contains($0.id) })
        if let buildingId = buildingId {
            suggestedBuildings = suggestedBuildings.filter({ return $0.id != buildingId })
        }
        
        self.suggestedBuildings = suggestedBuildings
        delegate?.didUpdateGroups()
    }
}

//MARK: Search Buildings
extension GroupsManager {
    
    private func searchBuildingsIfSearchText(is text: String?) {
        guard searchText == text else { return }
        
        searchBuildings()
    }
    
    private func searchBuildings() {
        guard let query = searchText, !query.isEmpty else { return }
        
        if let currentSearchRequest = currentSearchRequest {
            currentSearchRequest.cancel()
            self.currentSearchRequest = nil
        }

        delegate?.showLoading(nil)
        let request = SearchBuildingRequest(query: query)
        currentSearchRequest = API.searchBuildings(request, success: { [weak self] (buildings) in
            self?.currentSearchRequest = nil
            self?.delegate?.hideLoading()
            self?.didSearchBuildings(query, buildings: buildings)
        }) { [weak self] (error) in
            if let error = error,
                (error as NSError).code == -999 { // "cancelled"
                return
            }

            self?.currentSearchRequest = nil
            self?.delegate?.hideLoading()
            self?.delegate?.showError(error)
        }
    }
    
    private func didSearchBuildings(_ query: String, buildings: [OtherBuilding]) {
        self.otherBuildings = buildings
        filterOtherBuildings()
        
        if query != searchText {
            searchBuildings()
        }
    }
}
