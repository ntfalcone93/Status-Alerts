//
//  ViewController.swift
//  StatusAlertPractice
//
//  Created by Nathan on 7/12/16.
//  Copyright © 2016 Falcone Development. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setupStatusAlertView() {
        
        // Corner radius
//        statusAlertView.statusView.layer.cornerRadius = 15
//        // Border
//        statusAlertView.statusView.layer.borderWidth = 1.2
//        statusAlertView.statusView.layer.borderColor = UIColor.blackColor().CGColor
//        // Shadow
//        statusAlertView.statusView.layer.shadowColor = UIColor.blackColor().CGColor
//        statusAlertView.statusView.layer.shadowOpacity = 0.8
//        statusAlertView.statusView.layer.shadowOffset = CGSizeZero
//        statusAlertView.statusView.layer.shadowRadius = 5
//        
//        statusAlertView.statusView.backgroundColor = .grayColor()
//        statusAlertView.alertLabel.textColor = .whiteColor()
    }
    
    @IBAction func sendAlertTapped(sender: AnyObject) {

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.statusAlertView?.showStatusAlert(NSAttributedString(string: "Please  asdlkfja;slkdjfa;"), subtitle: nil, statusType: .Sent, width: view.frame.width)
    }
}

