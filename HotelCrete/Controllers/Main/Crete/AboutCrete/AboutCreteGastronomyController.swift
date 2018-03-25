//
//  AboutCreteGastronomyController.swift
//  HotelCrete
//
//  Created by John Nik on 24/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class AboutCreteGastronomyController: CreteMenuController {
    
    var gastronomies: [Crete.Gastronomy] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(AboutCreteGastronomyCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func fetchData() {}
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gastronomies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AboutCreteGastronomyCell
        
        cell.gastronomy = gastronomies[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let gastronomy = gastronomies[indexPath.item]
        
        let gastronomyDescriptionController = AboutCreteGastronomyDescriptionController()
        gastronomyDescriptionController.gastronomy = gastronomy
        
        navigationController?.pushViewController(gastronomyDescriptionController, animated: true)
    }
}
