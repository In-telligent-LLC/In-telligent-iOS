//
//  BuildingSubscriptionsManager.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/20/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import RealmSwift
import IntelligentKit

protocol BuildingSubscriptionsManagerDelegate: class {
    func didUpdateBuildingSubscriptions()
}

class BuildingSubscriptionsManager: NSObject {
    
    weak var delegate: (INViewController & BuildingSubscriptionsManagerDelegate)?
    
    private var buildingResults: Results<INBuilding>?
    private (set)var severeWeatherBuilding: INBuilding?
    private (set)var buildings: [INBuilding] = []

    private var token: NotificationToken?
    override init() {
        super.init()
        
        configureToken()
    }
    
    private func configureToken() {
        token?.invalidate()
        
        buildingResults = INSubscriber.current?.myBuildings
            .filter("isManagedByCurrentUser = %@", false)
            .filter("isPersonal = %@", false)
            .sorted(byKeyPath: "name")
        
        token = buildingResults?.observe({ [weak self] (change) in
            guard let strongSelf = self,
                let results = strongSelf.buildingResults else { return }
            
            strongSelf.didUpdateBuildings(Array(results))
        })
    }
    
}

//MARK: Update Buildings
extension BuildingSubscriptionsManager {
    
    private func didUpdateBuildings(_ buildings: [INBuilding]) {
        // severe weather is 967
        self.severeWeatherBuilding = buildings.first(where: { return $0.id == 967 })
        self.buildings = buildings.filter({ return !$0.isPersonal && $0.id != 967 })
        
        delegate?.didUpdateBuildingSubscriptions()
    }
}
