//
//  BeaconWatcher.swift
//  Intelligent
//
//  Created by Zachary Zeno on 7/5/17.
//  Copyright © 2017 Vimbly. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

public class IntelligentBeacon {
    
    enum BeaconType: String {
        case inside = "inside"
        case outside = "outside"
        case location = "location"
    }
    
    let majorUUID: UInt16
    let minorUUID: UInt16
    let beaconGroup: Int
    let type: BeaconType
    
    init(json: JSON) {
        self.majorUUID = json["majorUUID"].uInt16Value
        self.minorUUID = json["minorUUID"].uInt16Value
        self.type = BeaconType(rawValue: json["type"].stringValue)!
        self.beaconGroup = json["beaconGroup"].intValue
    }
    
    func isCLBeacon(beacon: CLBeacon) -> Bool {
        if((beacon.major as! UInt16) != self.majorUUID) {
            return false
        }
        
        if((beacon.minor as! UInt16) != self.minorUUID) {
            return false
        }
        
        return true
    }
}

public class BeaconRanging: CustomStringConvertible {
    let beacon: IntelligentBeacon
    let proximity: CLProximity
    
    init(beacon: IntelligentBeacon, proximity: CLProximity) {
        self.beacon = beacon
        self.proximity = proximity
    }
    
    public var description: String {
        get {
            return "\(beacon.minorUUID): \(proximity.rawValue)"
        }
    }
}


class BeaconHistory: CustomStringConvertible {
    var history: [[BeaconRanging]] = []
    
    var description: String {
        get {
            var output = ""
            for hist in history {
                for beacon in hist {
                    output += beacon.description + "\n"
                }
                
                if !hist.isEmpty {
                    output += "\n"
                }
            }
            
            return output
        }
    }
    
    func processHistory(buildingId: Int) -> [(IntelligentBeacon.BeaconType, Int)] {
        var aggregateHistory: [(IntelligentBeacon.BeaconType, Int)] = []
        var lastAggregateOpt: (IntelligentBeacon.BeaconType, Int)? = nil
        
        for hist in history {
            guard let nearestBeacon = hist.first else {
                continue
            }
            
            if let lastAggregate = lastAggregateOpt, lastAggregate.0 == nearestBeacon.beacon.type {
                lastAggregateOpt!.1 += 1
            }
            else {
                if let lastAggregate = lastAggregateOpt {
                    aggregateHistory.append(lastAggregate)
                }
                lastAggregateOpt = (nearestBeacon.beacon.type, 1)
            }
        }
        if let lastAggregate = lastAggregateOpt {
            aggregateHistory.append(lastAggregate)
        }
        
        for hist in aggregateHistory {
            Logging.info("\(hist.0): \(hist.1)")
        }
        
        return aggregateHistory
    }
}

private var _beacons: [Int: [IntelligentBeacon]]?

class BeaconWatcher: NSObject, CLLocationManagerDelegate {
    
    class func beacons(_ callback: @escaping ([Int: [IntelligentBeacon]]) -> ()) {
        if let beacons = _beacons {
            callback(beacons)
        }
        else {
            API.getAllBeacons({ (beaconsByBuilding) in
                _beacons = beaconsByBuilding
            }) { (error) in
                Logging.info(error)
            }
        }

    }
    
    static let beaconUUID = UUID(uuidString: "937DDCBE-1E3A-45C4-B8DE-06E9F6BB40B3")!
    
    let locationManager = CLLocationManager()
    
    static let shared: BeaconWatcher = BeaconWatcher()
    
    override init() {
        
        super.init()
        
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.delegate = self
    }
    
    var beaconRegions: [Int: CLBeaconRegion] = [:]
    var trackingRegions: Set<Int> = []
    var beaconHistory: [Int: BeaconHistory] = [:]
    
    func startTrackingBeacons(buildingId: Int) {
        
        if trackingRegions.contains(buildingId) {
            return
        }
        trackingRegions.insert(buildingId)
        beaconHistory[buildingId] = BeaconHistory()
        
        if beaconRegions[buildingId] == nil {
            beaconRegions[buildingId] = CLBeaconRegion(proximityUUID: BeaconWatcher.beaconUUID, major: UInt16(buildingId), identifier: "\(buildingId)")
        }
        
        let region = beaconRegions[buildingId]!
        
        locationManager.startRangingBeacons(in: region)
        
    }
    
    func stopTrackingBeacons(buildingId: Int) {
        
        if beaconRegions[buildingId] == nil {
            beaconRegions[buildingId] = CLBeaconRegion(proximityUUID: BeaconWatcher.beaconUUID, major: UInt16(buildingId), identifier: "\(buildingId)")
        }
        
        let region = beaconRegions[buildingId]!
        
        locationManager.stopRangingBeacons(in: region)
        
        trackingRegions.remove(buildingId)
        
        if let beaconHistory = beaconHistory[region.major as! Int] {
            
            Logging.info("Stopped tracking beacons for \(buildingId)")
//            Logging.info(beaconHistory)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        Logging.info("Got beacon ranging for region \(region)")
        
        guard let intelligentBeacons = _beacons?[region.major as! Int] else {
            Logging.info("Missing beacons")
            return
        }
        
        var historyRecord: [BeaconRanging] = []
        for beacon in beacons {
            Logging.info(beacon)
            if beacon.proximity == .unknown {
                continue
            }
            
            guard let intelligentBeacon = intelligentBeacons.first(where: { return $0.isCLBeacon(beacon: beacon) }) else {
                Logging.info("Missing beacon")
                return
            }
            
            historyRecord.append(BeaconRanging(beacon: intelligentBeacon, proximity: beacon.proximity))
        }
        
        guard let beaconHistory = beaconHistory[region.major as! Int] else {
            Logging.info("Missing beacon history")
            return
        }
        
        beaconHistory.history.append(historyRecord)
        
        let buildingId = region.major as! Int
        
        let aggregateHistory = beaconHistory.processHistory(buildingId: buildingId)
        
        if let start = aggregateHistory.first, let end = aggregateHistory.last, start.1 >= 3, end.1 >= 3, start.0 != end.0 {
            
            guard let subscriber = INSubscriber.current else { return }
            
            let isSubscribed = subscriber.isSubscribed(to: buildingId)
            let isAutoSubscribed = subscriber.isAutoSubscribed(to: buildingId)
            
            if end.0 == .inside && !isSubscribed {
                Logging.info("Subscribing to \(buildingId)")
                let request = SubscribeBuildingRequest(buildingId: buildingId, automatic: true, inviteId: nil, optIn: false)
                API.subscribeToBuilding(request, success: nil, failure: nil)
            } else if end.0 == .outside && isSubscribed && isAutoSubscribed {
                Logging.info("Unsubscribing from \(buildingId)")
                let request = UnsubscribeBuildingRequest(buildingId: buildingId, automatic: true)
                API.unsubscribeFromBuilding(request, success: nil, failure: nil)
            }
            
            beaconHistory.history = [historyRecord]
        }
    }
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        
        Logging.info("Error ranging beacons")
        Logging.info(error)
        
    }
}
