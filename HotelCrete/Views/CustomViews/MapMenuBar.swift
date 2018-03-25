//
//  MapMenuBar.swift
//  HotelCrete
//
//  Created by John Nik on 01/03/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class MapMenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var mapController: HotelMapController?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = StyleGuideManager.mainLightBlueBackgroundColor
        cv.dataSource = self
        cv.delegate = self
        return cv
        
    }()
    
    let cellId = "cellId"
    var menuItems: [HotelMap.MenuItem]? {
        
        didSet {
            guard let _ = menuItems else {
                return
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(MapMenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        
        addConnstraintsWith(Format: "H:|[v0]|", views: collectionView)
        addConnstraintsWith(Format: "V:|[v0]|", views: collectionView)
    }
    var horizontalBArLeftAnchorConstraint: NSLayoutConstraint?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let menuItmes = self.menuItems {
            mapController?.didSelectMapMenuItem(menuItmes[indexPath.item])
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let menuItmes = self.menuItems {
            return menuItmes.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MapMenuCell
        
        if let menuItmes = self.menuItems {
            cell.titleLabel.text = getLocalizedTitle(from: menuItmes[indexPath.item])
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let menuItems = self.menuItems {
            let menuItem = menuItems[indexPath.item]
            
            let estimatedWidth = GlobalFunction.estimateFrameForText(text: menuItem.title, width: frame.width, font: CGFloat(16)).width
            
            return CGSize(width: estimatedWidth + 75, height: frame.height)
        }
        
        
        return CGSize(width: frame.width / 3, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MapMenuBar {
    func getLocalizedTitle(from detail: HotelMap.MenuItem) -> String? {
        var title: String?
        
        if currentLanguage() == DisplayName.england.rawValue {
            title = detail.title
        } else if currentLanguage() == DisplayName.france.rawValue {
            title = detail.title_french
        } else if currentLanguage() == DisplayName.germany.rawValue {
            title = detail.title_german
        } else if currentLanguage() == DisplayName.italy.rawValue {
            title = detail.title_italian
        } else {
            title = detail.title_russian
        }
        
        return title
    }
}

class MapMenuCell: BaseCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        return view
    }()
    
    let iconImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: AssetName.redMapMarker.rawValue)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 7, paddingLeft: 3.5, paddingBottom: 7, paddingRight: 3.5, width: 0, height: 0)
        
        addSubview(iconImageView)
        iconImageView.anchor(top: nil, left: containerView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: iconImageView.rightAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    
}
