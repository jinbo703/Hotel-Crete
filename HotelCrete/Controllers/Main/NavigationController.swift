//
//  NavigationController.swift
//  HotelCrete
//
//  Created by John Nik on 05/03/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}
