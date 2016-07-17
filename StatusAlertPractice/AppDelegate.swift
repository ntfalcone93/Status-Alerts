//
//  AppDelegate.swift
//  StatusAlertPractice
//
//  Created by Nathan on 7/12/16.
//  Copyright © 2016 Falcone Development. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var statusAlertView: StatusAlertView? = {
        return StatusAlertView.viewFromNib("StatusAlert") as? StatusAlertView
    }()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        return true
    }
}

