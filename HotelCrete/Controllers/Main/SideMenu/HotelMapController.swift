//
//  HotelMapController.swift
//  HotelCrete
//
//  Created by John Nik on 01/03/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SVProgressHUD

class HotelMapController: UIViewController {
    
    var currentLocation = CLLocationCoordinate2D(latitude: 35.2, longitude: 24.9)
    
    var selectedCategory: String?
    var guideCreteInfos: [Crete.GuideCreteInfo] = []
    
    var myMarker: GMSMarker = {
        let marker = GMSMarker()
        marker.title = "Me"
        return marker
    }()
    
    lazy var googleMapView: GMSMapView = {
        
        var map = GMSMapView()
        
        let camera = GMSCameraPosition.camera(withLatitude: 35.2, longitude: 24.9, zoom: 70.0)
        
        map = GMSMapView.map(withFrame: CGRect.zero , camera: camera)
        map.settings.consumesGesturesInView = false
        map.delegate = self
        return map
        
    }()
    
    lazy var menuBar: MapMenuBar = {
        let bar = MapMenuBar()
        bar.mapController = self
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupViews()
        
        fetchHotelMenuBarList()
//        createUserMarker()
    }
    
}

extension HotelMapController {
    
    func createUserMarker() {
        if let usersLocation = LocationManager.sharedInstance.userLocation {
            currentLocation = usersLocation.coordinate
        }
        myMarker.position = currentLocation
        myMarker.map = googleMapView
        googleMapView.animate(toLocation: myMarker.position)
    }
}

extension HotelMapController {
    
    func fetchHotelMenuBarList() {
        guard ReachabilityManager.shared.internetIsUp else {
            
            self.showPMAlertOkay(title: "Internet Error", message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        APIService.sharedInstance.handleGetMapMenuList { (result: HotelMap.ResultGuideCrete) in
            switch result {
            case .failure(_):
                self.showErrorMessage(title: "Server Error", message: AlertMessages.somethingWentWrong.rawValue)
            case .success(let response):
                if let menuItems = response.result {
                    
                    var items: [HotelMap.MenuItem] = []
                    
                    for menuItem in menuItems {
                        
                        let item = menuItem.GuideCrete
                        items.append(item)
                    }
                    
                    self.menuBar.menuItems = items
                    
                }
            }
        }
        
        APIService.sharedInstance.handleGetGuideCrete { (result: Crete.ResultGuideCrete) in
            
            switch result {
            case .failure(_):
                self.showErrorMessage(title: "Server Error", message: AlertMessages.somethingWentWrong.rawValue)
            case .success(let response):
                if let guideCreteInfos = response.result {
                    self.guideCreteInfos = guideCreteInfos
                }
            }
            
        }
    }
    
}

extension HotelMapController {
    
    func didSelectMapMenuItem( _ menuItem: HotelMap.MenuItem) {
        
        if selectedCategory == menuItem.title {
            return
        }
        
        MapDataProvider.sharedInstance.fetchPindataWith(menuItem: menuItem) { (hotelPlaces: [HotelMap.HotelPlace]) in
            DispatchQueue.main.async {
                self.googleMapView.clear()
            }
            
//            self.myMarker.map = self.googleMapView
            self.selectedCategory = menuItem.title
            
            for hotelPlace in hotelPlaces {
                
                DispatchQueue.main.async {
                    let hotelMarker = HotelMarker(place: hotelPlace)
                    hotelMarker.map = self.googleMapView
                }
            }
           
            if hotelPlaces.count > 0 {
                DispatchQueue.main.async {
                    self.googleMapView.animate(toLocation: hotelPlaces[0].coordinate)
                }
                
            }
        }
        
    }
    
}

extension HotelMapController {
    
    func showErrorMessage(title: String, message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showPMAlertOkay(title: title, message: message)
        }
    }
}

extension HotelMapController {
    
    func didTapMarker(_ marker: HotelMarker) {
        
        if selectedCategory == HotelMap.MenuTitle.cities.rawValue {
            
            self.handleTappedCitiesMarker(marker)
        } else if selectedCategory == HotelMap.MenuTitle.townsVillages.rawValue {
            
            handleTappedTownsMarker(marker)
            
        } else if selectedCategory == HotelMap.MenuTitle.beaches.rawValue {
            self.handleTappedBeachesMarker(marker, index: 2)
        } else if selectedCategory == HotelMap.MenuTitle.landscapes.rawValue {
            self.handleTappedBeachesMarker(marker, index: 3)
        } else if selectedCategory == HotelMap.MenuTitle.archaelogoical.rawValue {
            self.handleTappedArchaelogicalMarker(marker, index: 4)
        } else if selectedCategory == HotelMap.MenuTitle.museums.rawValue {
            self.handleTappedArchaelogicalMarker(marker, index: 5)
        }  else if selectedCategory == HotelMap.MenuTitle.monuments.rawValue {
            self.handleTappedArchaelogicalMarker(marker, index: 6)
        }   else if selectedCategory == HotelMap.MenuTitle.monasteries.rawValue {
            self.handleTappedArchaelogicalMarker(marker, index: 7)
        }
    }
    
    fileprivate func handleTappedTownsMarker(_ marker: HotelMarker) {
        guard ReachabilityManager.shared.internetIsUp else {
            
            self.showPMAlertOkay(title: "Internet Error", message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        guard let region = marker.place.region else { return }
        let guideVillage = Crete.Region(region: region)
        let request = Crete.RequestGuideVillage(GuideVillage: guideVillage)
        
        APIService.sharedInstance.handleGetGuideCreteVillages(request) { (result: Crete.ResultGuideVillage) in
            
            switch result {
            case .failure(_):
                self.showErrorMessage(title: "Server Error", message: AlertMessages.somethingWentWrong.rawValue)
            case .success(let response):
                if let guideCreteListDetails = response.result {
                    var guideCreteLists: [Crete.GuideListDetail] = []
                    SVProgressHUD.show()
                    for detail in guideCreteListDetails {
                        if let guideVillage = detail.GuideVillage {
                            guideCreteLists.append(guideVillage)
                        }
                    }
                    
                    for guideCreteList in guideCreteLists {
                        
                        let id = String(marker.place.id)
                        
                        if id == guideCreteList.id {
                            
                            SVProgressHUD.dismiss()
                            
                            DispatchQueue.main.async {
                                let directionControlleller = GuideCreteSightSeeingDetailDirectionController(collectionViewLayout: UICollectionViewFlowLayout())
                                directionControlleller.guideCreteListDetails = [guideCreteList]
                                directionControlleller.navigationItem.title = self.getLocalizedString(from: guideCreteList)
                                self.navigationController?.pushViewController(directionControlleller, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func handleTappedArchaelogicalMarker(_ marker: HotelMarker, index: Int) {
        if guideCreteInfos.count > 0 {
            
            let guideCreteInfo = guideCreteInfos[index]
            if let guideCreteDatas = guideCreteInfo.GuideData, guideCreteDatas.count > 0 {
                for guideCreteData in guideCreteDatas {
                    let id = String(marker.place.id)
                    if id == guideCreteData.id {
                        
                        let directionController = GuideCreteDataGeneralDirectionController(collectionViewLayout: UICollectionViewFlowLayout())
                        directionController.navigationItem.title = self.getLocalizedString(from: guideCreteData)
                        directionController.guideCreteDatas = [guideCreteData]
                        
                        navigationController?.pushViewController(directionController, animated: true)
                    }
                }
            }
        }
    }
    
    fileprivate func handleTappedBeachesMarker(_ marker: HotelMarker, index: Int) {
        if guideCreteInfos.count > 0 {
            
            let guideCreteInfo = guideCreteInfos[index]
            if let guideCreteDatas = guideCreteInfo.GuideData, guideCreteDatas.count > 0 {
                for guideCreteData in guideCreteDatas {
                    if let beaches = guideCreteData.GuideBeache {
                        for beach in beaches {
                            let id = String(marker.place.id)
                            if id == beach.id {
                                
                                let directionController = GuideCreteDataAreaDirectionController(collectionViewLayout: UICollectionViewFlowLayout())
                                directionController.navigationItem.title = self.getLocalizedString(from: beach)
                                directionController.guideCreteDatas = [beach]
                                
                                navigationController?.pushViewController(directionController, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func handleTappedCitiesMarker(_ marker: HotelMarker) {
        if guideCreteInfos.count > 0 {
            let guideCreteInfo = guideCreteInfos[0]
            if let guideCreteLists = guideCreteInfo.GuideList, guideCreteLists.count > 0 {
                
                var markedCreteLists: [Crete.GuideList] = []
                
                for guideList in guideCreteLists {
                    
                    let id = String(marker.place.id)
                    
                    if id == guideList.id {
                        markedCreteLists.append(guideList)
                    }
                }
                
                if markedCreteLists.count > 0 {
                    let sightSeeingController = GuideCreteSightSeeingController(collectionViewLayout: UICollectionViewFlowLayout())
                    sightSeeingController.guideCreteLists = markedCreteLists
                    sightSeeingController.navigationItem.title = self.getLocalizedString(from: markedCreteLists[0])
                    
                    navigationController?.pushViewController(sightSeeingController, animated: true)
                }
            }
        }
    }
}

extension HotelMapController {
    
    func getLocalizedString(from detail: Crete.GuideListDetail) -> String? {
        var string: String?
        
        if currentLanguage() == DisplayName.england.rawValue {
            string = detail.title
        } else if currentLanguage() == DisplayName.france.rawValue {
            string = detail.title_french
        } else if currentLanguage() == DisplayName.germany.rawValue {
            string = detail.title_german
        } else if currentLanguage() == DisplayName.italy.rawValue {
            string = detail.title_italian
        } else {
            string = detail.title_russian
        }
        
        return string
    }
    
    func getLocalizedString(from detail: Crete.GuideData) -> String? {
        var string: String?
        
        if currentLanguage() == DisplayName.england.rawValue {
            string = detail.title
        } else if currentLanguage() == DisplayName.france.rawValue {
            string = detail.title_french
        } else if currentLanguage() == DisplayName.germany.rawValue {
            string = detail.title_german
        } else if currentLanguage() == DisplayName.italy.rawValue {
            string = detail.title_italian
        } else {
            string = detail.title_russian
        }
        
        return string
    }
    
    func getLocalizedString(from detail: Crete.GuideDataDetail) -> String? {
        var string: String?
        
        if currentLanguage() == DisplayName.england.rawValue {
            string = detail.title
        } else if currentLanguage() == DisplayName.france.rawValue {
            string = detail.title_french
        } else if currentLanguage() == DisplayName.germany.rawValue {
            string = detail.title_german
        } else if currentLanguage() == DisplayName.italy.rawValue {
            string = detail.title_italian
        } else {
            string = detail.title_russian
        }
        
        return string
    }
    
    func getLocalizedString(from detail: Crete.GuideList) -> String? {
        var string: String?
        
        if currentLanguage() == DisplayName.england.rawValue {
            string = detail.title
        } else if currentLanguage() == DisplayName.france.rawValue {
            string = detail.title_french
        } else if currentLanguage() == DisplayName.germany.rawValue {
            string = detail.title_german
        } else if currentLanguage() == DisplayName.italy.rawValue {
            string = detail.title_italian
        } else {
            string = detail.title_russian
        }
        
        return string
    }
    
}

extension HotelMapController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("tapped marker")
        
        if marker.isKind(of: HotelMarker.self), let selectedMarker = marker as? HotelMarker {
            
            didTapMarker(selectedMarker)
            
        }
        
        
        return false
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
    }
}

extension HotelMapController {
    
    fileprivate func setupViews() {
        
        navigationItem.title = "Map".localized()
        
        setGoogleMap()
        setupMenuBar()
        
    }
    
    private func setupMenuBar() {
        
        let containerView = UIView()
        containerView.backgroundColor = StyleGuideManager.mainLightBlueBackgroundColor
        
        view.addSubview(containerView)
        containerView.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 45)
        
        let fingerImageView = UIImageView()
        fingerImageView.image = UIImage(named: AssetName.finger.rawValue)?.withRenderingMode(.alwaysTemplate)
        fingerImageView.tintColor = .white
        fingerImageView.contentMode = .scaleAspectFit
        
        containerView.addSubview(fingerImageView)
        fingerImageView.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 7, paddingRight: 0, width: 40, height: 0)
        
        view.addSubview(menuBar)
        menuBar.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: fingerImageView.leftAnchor, paddingTop: 0, paddingLeft: 3.5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    private func setGoogleMap() {
        self.view = googleMapView
        
        googleMapView.isMyLocationEnabled = true
        googleMapView.settings.myLocationButton = true
        
        if let usersLocation = LocationManager.sharedInstance.userLocation {
            currentLocation = usersLocation.coordinate
        }
        
        googleMapView.animate(toLocation: currentLocation)
        googleMapView.animate(toZoom: 7.7)
        googleMapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 45, right: 0)
    }
    
}
