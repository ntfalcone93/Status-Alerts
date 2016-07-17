//
//  StatusAlertView.swift
//  StatusAlertPractice
//
//  Created by Nathan on 7/12/16.
//  Copyright © 2016 Falcone Development. All rights reserved.
//

import UIKit

enum Status {
    case Posted
    case Sent
    case Failed
    case Message
}

class StatusAlertView: UIView {
    
    // MARK: - Properties and outlets
    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    
    private var duration: NSTimeInterval = 0.4
    private var extendedDuration: NSTimeInterval = 0.6
    private var delay: NSTimeInterval = 3.0
    private var damping: CGFloat = 1.0
    private var velocity: CGFloat = 0.1
    private var elasticity: CGFloat = 0.0
    private var landingRect: CGRect = CGRectMake(0.0, 0.0, 0.0, 0.0)
    private var startRect: CGRect = CGRectMake(0.0, 0.0, 0.0, 0.0)
    private var notificationHeight: CGFloat {
        return statusView.frame.height
    }
    
    lazy var statusAlertViewWindow: UIWindow? = {
        let w = UIWindow(frame: CGRectZero)
        return w
    }()
    
    private(set) var delayTimer: NSTimer?
    
    private var statusAlertType: Status = .Sent {
        didSet {
            switch statusAlertType {
            case .Posted:
                break
            case .Sent:
                break
            case .Failed:
                break
            case .Message:
                break
            }
        }
    }

    
    // MARK: - StatusAlertView setup methods
    
    private func statusText(title: NSAttributedString, subtitle: NSAttributedString?) {
        alertLabel.attributedText = title
        messageLabel.attributedText = subtitle ?? nil
    }
    
    func showStatusAlert(title: NSAttributedString, subtitle: NSAttributedString?, statusType: Status, width: CGFloat) {
        
        statusText(title, subtitle: subtitle)
        statusAlertType = statusType
        // The y position is the notification height + 30 so the alert fully leaves the view
        self.startRect = CGRectMake(0, -(notificationHeight + 30), width, notificationHeight)
        self.landingRect = CGRectMake(0, 20, width, notificationHeight)
        
        
        statusAlertViewWindow!.windowLevel = UIWindowLevelStatusBar + 1
        statusAlertViewWindow!.hidden = false
        statusAlertViewWindow!.addSubview(self)
        
        if self.delayTimer == nil {
            self.frame = self.startRect
            UIView.animateWithDuration(self.duration, delay: 0.0, usingSpringWithDamping: self.damping, initialSpringVelocity: self.velocity, options: (.CurveEaseOut), animations:{
                self.frame = self.landingRect
                }, completion: { (value: Bool) in
                    self.startDelay()
            })
        } else {
            self.frame = self.landingRect
            self.startDelay()
        }
    }
    
    private func startDelay() {
        assert(NSThread.isMainThread(), "Must be on main!")
        if self.delayTimer != nil {
            //  reset
            self.delayTimer?.invalidate()
            self.delayTimer = nil
        }
        self.delayTimer = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: #selector(hide), userInfo: nil, repeats: false)
    }
    
    func hide() {
        self.delayTimer?.invalidate()
        self.delayTimer = nil
        self.hideStatusNotification()
    }
    
    private func hideStatusNotification() {
        UIView.animateWithDuration(self.duration, delay: 0.0, usingSpringWithDamping: self.damping, initialSpringVelocity: self.velocity, options: (.CurveEaseInOut), animations:{
            self.frame = self.startRect
            }, completion: { (value: Bool) in
                self.delayTimer = nil
                self.statusAlertViewWindow?.hidden = true
        })
    }
}
