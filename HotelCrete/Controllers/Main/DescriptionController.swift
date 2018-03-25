//
//  DescriptionController.swift
//  HotelCrete
//
//  Created by John Nik on 18/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreLocation

class DescriptionController: UICollectionViewController {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    func didTappedMapSegment(index: Int, marker: HotelMarker) {
        if index == 0 {
            self.handleShowMarker(marker)
        } else {
            
            self.handleNavigationTo(marker: marker)
        }
    }
    
    func handleShowMarker(_ marker: HotelMarker) {
        let generalMapController = GeneralMapControler()
        generalMapController.marker = marker
        navigationController?.pushViewController(generalMapController, animated: true)
    }
    
    func handleNavigationTo(marker: HotelMarker) {
        var currentLocation = CLLocationCoordinate2DMake(35.331690, 24.030762)
        if let usersLocation = LocationManager.sharedInstance.userLocation {
            currentLocation = usersLocation.coordinate
        }
        
        let fromPoint = CMMapPoint(coordinate: currentLocation)
        let toPoint = CMMapPoint(coordinate: marker.position)
        
        self.showMultiActionSheetWith(nil, message: "", galleryActionTitle: "Google Map", cameraActionTitle: "Apple Map", otherActionTitle: "Waze", galleryAction: { (action) in
            CMMapLauncher.launch(.googleMaps, forDirectionsFrom: fromPoint, to: toPoint)
        }, cameraAction: { (action) in
            CMMapLauncher.launch(.appleMaps, forDirectionsFrom: fromPoint, to: toPoint)
        }, otherAction: { (action) in
            if CMMapLauncher.launch(.waze, forDirectionsFrom: fromPoint, to: toPoint) {
                
            } else {
                self.showErrorMessage(title: "Error", message: "Can't find the app on your phone.")
            }
        }, completion: nil)
    }
    
    func showErrorMessage(title: String, message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showPMAlertOkay(title: title, message: message)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DescriptionCell
        
       
        
        return cell
    }
}

extension DescriptionController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: GAP100 * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension DescriptionController {
    
    @objc fileprivate func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
}

extension DescriptionController {
    
    fileprivate func setupViews() {
        
        setupCollectionView()
        setupNavBar()
    }
    
    private func setupNavBar() {
        
        let image = UIImage(named: AssetName.back.rawValue)
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleDismiss))
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupCollectionView() {
        collectionView?.backgroundColor = .white
        
        collectionView?.register(DescriptionCell.self, forCellWithReuseIdentifier: cellId)
    }
}
