//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQNotificationListenerKit
//
//
//  GitHub
//  https://github.com/jessesquires/JSQNotificationListenerKit
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation

public typealias NotificationHandler = (notification: NSNotification) -> ()

public class NotificationListener: NSObject {
    
    public let name: String
    private let handler: NotificationHandler
    
    public init (name: String, object: AnyObject?, handler: NotificationHandler) {
        self.name = name
        self.handler = handler
        
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didReceiveNotification:"), name: name, object: object)
    }
    
    public convenience init(name: String, handler: NotificationHandler) {
        self.init(name: name, object: nil, handler: handler)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    internal func didReceiveNotification(notification: NSNotification) {
        self.handler(notification: notification)
    }
}