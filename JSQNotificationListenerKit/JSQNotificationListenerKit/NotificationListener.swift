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

public class NotificationListener {
    
    public let name: String
    private let handler: NotificationHandler
    
    public init (name: String, handler: NotificationHandler, object: AnyObject?) {
        self.name = name
        self.handler = handler
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveNotification:", name: name, object: object)
    }
    
    public convenience init(name: String, handler: NotificationHandler) {
        self.init(name: name, handler: handler, object: nil)
    }
    
    private func didReceiveNotification(notification: NSNotification) {
        self.handler(notification: notification)
    }
}