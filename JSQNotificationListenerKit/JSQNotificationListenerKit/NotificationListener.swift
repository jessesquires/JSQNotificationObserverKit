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

public typealias NotificationHandler = (notification: NSNotification!) -> Void

public class NotificationListener {
    
    public let name: String
    private let proxy: NSObjectProtocol
    
    public init (notificationName: String, object: AnyObject?, queue: NSOperationQueue, handler: NotificationHandler) {
        name = notificationName
        proxy = NSNotificationCenter.defaultCenter().addObserverForName(name,
                                                                        object: object,
                                                                        queue: queue,
                                                                        usingBlock: handler)
    }
    
    public convenience init(notificationName: String, object: AnyObject?, handler: NotificationHandler) {
        self.init(notificationName: notificationName,
                  object: object,
                  queue: NSOperationQueue.mainQueue(),
                  handler: handler)
    }
    
    public convenience init(notificationName: String, handler: NotificationHandler) {
        self.init(notificationName: notificationName,
                  object: nil,
                  queue: NSOperationQueue.mainQueue(),
                  handler: handler)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(proxy)
    }
}