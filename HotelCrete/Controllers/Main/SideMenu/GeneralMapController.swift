//
//  GeneralMapController.swift
//  HotelCrete
//
//  Created by John Nik on 02/03/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class GeneralMapControler: UIViewController {
    
    var marker: HotelMarker? {
        
        didSet {
            guard let marker = marker else { return }
            
            marker.map = self.googleMapView
            
            googleMapView.animate(toLocation: marker.position)
        }
    }
    
    lazy var googleMapView: GMSMapView = {
        
        var map = GMSMapView()
        
        let camera = GMSCameraPosition.camera(withLatitude: 35.2, longitude: 24.9, zoom: 70.0)
        
        map = GMSMapView.map(withFrame: CGRect.zero , camera: camera)
        map.settings.consumesGesturesInView = false
        return map
        
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGoogleMap()
    }
    
    private func setGoogleMap() {
        
        self.view = googleMapView
        
        googleMapView.isMyLocationEnabled = true
        googleMapView.settings.myLocationButton = true
        googleMapView.animate(toZoom: 7.7)
    }
}
