//
//  AlertExample.swift
//  StatusAlertPractice
//
//  Created by Nathan on 7/12/16.
//  Copyright © 2016 Falcone Development. All rights reserved.
//

//
//  StatusNotificationView.swift
//  Hayabusa
//

import UIKit

private let TITLE_ONLY_TOP: CGFloat = 0.0
private let TITLE_AND_SUBTITLE_TOP: CGFloat = 0.0
private let SUCCESS_COLOR: UIColor = UIColor(red: 85/255, green: 158/255, blue: 35/255, alpha: 1.0)
private let ERROR_COLOR: UIColor = UIColor(red: 197/255, green: 35/255, blue: 35/255, alpha: 1.0)
private let WARNING_COLOR: UIColor = UIColor(red: 237/255, green: 177/255, blue: 24/255, alpha: 1.0)
private let MESSAGE_COLOR: UIColor = UIColor.blueColor()
private let NOTIFICATION_HEIGHT:CGFloat = 64
private let SUBTITLE_TOP: CGFloat = 11

enum StatusNotificationViewType {
    case Success
    case Error
    case Warning
    case Blue
    case Message
}

class StatusNotificationView: UIView {
    private var duration:NSTimeInterval = 0.4
    private var extendedDuration: NSTimeInterval = 0.6
    private var delay:NSTimeInterval = 3.0
    private var damping:CGFloat = 1.0
    private var velocity:CGFloat = 0.1
    private var elasticity:CGFloat = 0.0
    private var landingRect: CGRect = CGRectMake(0.0, 0.0, 0.0, 0.0)
    private var startRect: CGRect = CGRectMake(0.0, 0.0, 0.0, 0.0)
    lazy var statusNotificationWindow: UIWindow? = {
        let w = UIWindow(frame: CGRectZero)
        return w
    }()
    private(set) var delayTimer: NSTimer?
    
    /// Sets the status notification type. Controls the color of the view.
    var statusNotificationType: StatusNotificationViewType = .Success {
        didSet {
            switch statusNotificationType {
            case .Success:
                self.backgroundColor = SUCCESS_COLOR
                self.delay = 2.5
            case .Error:
                self.backgroundColor = ERROR_COLOR
                self.delay = 3.0
            case .Warning:
                self.backgroundColor = WARNING_COLOR
                self.delay = 2.5
            case .Blue:
                self.backgroundColor = UIColor.blueColor()
                self.delay = 3.0
            case .Message:
                self.backgroundColor = MESSAGE_COLOR
                self.delay = 3.0
                //            default:
                //                self.backgroundColor = SUCCESS_COLOR
                //                self.delay = 1.0
            }
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
//    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var subtitleHeightConstraint: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Sets the title and subtitle for the status notification.
    ///
    /// If there is no subtitle, the title centers itself vertically.
    private func statusText(title: NSAttributedString, subtitle: NSAttributedString?) {
        self.titleLabel.attributedText = title
        if subtitle != nil {
            self.subtitleLabel.attributedText = subtitle
        } else {
//            self.titleTopConstraint.constant = (self.bounds.size.height / 2.0) - (self.titleLabel.bounds.size.height / 2.0)
        }
    }
    
    /// Displays a StatusNotificationView
    ///
    /// Uses +showStatusNotificationWithAttributedTitle:attributedSubtitle:statusType:
    ///
    /// :param: title The title for the status view
    /// :param: subtitle The subtitle for the status view
    /// :param: statusType The type of status notification
    class func showStatusNotificationWithTitle(title: String, subtitle: String? = nil, statusType: StatusNotificationViewType) {
        showStatusNotificationWithAttributedTitle(NSAttributedString(string: title), attributedSubtitle: (subtitle != nil ? NSAttributedString(string: subtitle!) : nil), statusType: statusType)
    }
    
    /// Displays a StatusNotificationView
    ///
    /// Once a new window is added, it cannot be removed. The statusNotificationWindow is lazy loaded by the AppDelegate, and the window is reused for all status notifications. The statusNotificationWindow.hidden property is toggled.
    ///
    /// :param: title The title for the status view
    /// :param: subtitle The subtitle for the status view
    /// :param: statusType The type of status notification
    class func showStatusNotificationWithAttributedTitle(title: NSAttributedString, attributedSubtitle subtitle: NSAttributedString? = nil, statusType: StatusNotificationViewType) {
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
//            let width:CGFloat = delegate.window!.bounds.size.width
//            let notificationView = delegate.statusNotificationView
//            notificationView?.showStatusNotificationWithAttributedTitle(title, subtitle: subtitle, statusType: statusType, width:width)
//        })
    }
    
    private func showStatusNotificationWithAttributedTitle(title: NSAttributedString, subtitle: NSAttributedString?, statusType: StatusNotificationViewType, width:CGFloat) {
        
        var sub = subtitle
        if sub == nil {
            sub = NSAttributedString(string: "")
        }
        self.frame = CGRectMake(0, 0, width, NOTIFICATION_HEIGHT)
        
        self.startRect = CGRectMake(0, -NOTIFICATION_HEIGHT, width, NOTIFICATION_HEIGHT)
        self.landingRect = CGRectMake(0, 0, width, NOTIFICATION_HEIGHT)

        // TODO: Setup constraints
//        if subtitle == nil {
//            self.subtitleHeightConstraint.constant = 0
//        } else {
//            self.titleTopConstraint.constant = SUBTITLE_TOP
//        }
        self.statusText(title, subtitle: sub)
        self.statusNotificationType = statusType
        
        self.alpha = 0.98
        
        //  window layout...
        self.statusNotificationWindow!.windowLevel = UIWindowLevelStatusBar + 1
        self.statusNotificationWindow!.hidden = false
        self.statusNotificationWindow!.addSubview(self)
        
        if self.delayTimer == nil {
            self.frame = self.startRect
            UIView.animateWithDuration(self.duration,
                                       delay: 0.0,
                                       usingSpringWithDamping: self.damping,
                                       initialSpringVelocity: self.velocity,
                                       options: (.CurveEaseOut),
                                       animations:{
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
    
    /// Hides and removes the statusNotificationView from the statusNotificationWindow
    ///
    /// Note: Failure to hide the statusNotificationWindow will break the default statusBar appearance throughout the app.
    private func hideStatusNotification() {
        UIView.animateWithDuration(self.duration,
                                   delay: 0.0,
                                   usingSpringWithDamping: self.damping,
                                   initialSpringVelocity: self.velocity,
                                   options: (.CurveEaseInOut),
                                   animations:{
                                    self.frame = self.startRect
            }, completion: {
                (value: Bool) in
                self.delayTimer = nil
                self.statusNotificationWindow?.hidden = true
        })
    }
}

extension UIView {
    
    static func viewFromNib(nib: String) -> UIView {
        let view = NSBundle.mainBundle().loadNibNamed(nib, owner: self, options: nil)[0] as? UIView
        return view!
    }
}

