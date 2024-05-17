//
//  GroupMemberFindViewController.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/20/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit
import MapKit
import IntelligentKit

class GroupMemberFindViewController: INViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    var buildingSubscriber: BuildingSubscriber!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchLastLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchCurrentLocation()
    }

    override func setupView() {
        super.setupView()
        
        titleLabel?.text = NSLocalizedString("Find Member", comment: "")
    }
    
    private func updateBuildingSubscriberLocationPin(_ coordinate: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = buildingSubscriber.name
        annotation.subtitle = buildingSubscriber.status.rawValue
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}

// Fetch Last Location
extension GroupMemberFindViewController {
    
    private func fetchLastLocation() {
        let subscriberId = buildingSubscriber.subscriberId
        let request = LastLocationRequest(subscriberId: subscriberId)
        API.getLastKnownLocation(request, success: { [weak self] (coordinate) in
            self?.updateBuildingSubscriberLocationPin(coordinate)
        }) { [weak self] (error) in
            self?.showError(error)
        }
    }
    
    private func fetchCurrentLocation() {
        let subscriberId = buildingSubscriber.subscriberId
        let request = LastLocationRequest(subscriberId: subscriberId)
        API.getCurrentLocation(request, success: { [weak self] (coordinate) in
            self?.updateBuildingSubscriberLocationPin(coordinate)
        }) { (error) in
            //self?.showError(error)
        }
    }
}
