//
//  Extension+Notification.swift
//  InstaChain
//
//  Created by John Nik on 2/1/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit

extension Notification.Name {
    
    static let reloadSideMenu = Notification.Name("reloadSideMenu")
    static let resetSideMenuBackground = Notification.Name("resetSideMenuBackground")
    static let resetHomeView = Notification.Name("resetHomeView")
    
    static let DidSetCurrentUser = Notification.Name("did-set-current-user")
    
    static let resetNavBarTintColor = Notification.Name("resetNavBarTintColor")
}
