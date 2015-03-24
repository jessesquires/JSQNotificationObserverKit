//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://www.jessesquires.com/JSQNotificationObserverKit
//
//
//  GitHub
//  https://github.com/jessesquires/JSQNotificationObserverKit
//
//
//  License
//  Copyright (c) 2015 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation


public struct Notification <Value, Sender: AnyObject> {

    public let name: String

    public init(name: String) {
        self.name = name
    }

}


public func postNotification<V, S: AnyObject> (notification: Notification<V, S>, #value: V, sender: S? = nil, center: NSNotificationCenter = NSNotificationCenter.defaultCenter()) {
    center.postNotificationName(notification.name, object: sender, userInfo: userInfo(value))
}


public final class NotificationObserver <V, S: AnyObject> {

    public typealias Handler = (value: V, sender: S?) -> Void

    public typealias NotificationHandler = (NSNotification) -> Void

    private let observerProxy: NSObjectProtocol

    private let center: NSNotificationCenter

    public init(notification: Notification<V, S>, sender: S? = nil, queue: NSOperationQueue? = nil, center: NSNotificationCenter = NSNotificationCenter.defaultCenter(), handler: NotificationHandler) {
        self.center = center
        observerProxy = center.addObserverForName(notification.name, object: sender, queue: queue, usingBlock: { (note) -> Void in
            handler(note)
        })
    }

    public init(notification: Notification<V, S>, sender: S? = nil, queue: NSOperationQueue? = nil, center: NSNotificationCenter = NSNotificationCenter.defaultCenter(), handler: Handler) {
        self.center = center
        observerProxy = center.addObserverForName(notification.name, object: sender, queue: queue, usingBlock: { (notification: NSNotification!) -> Void in
            if let value: V = unboxUserInfo(notification.userInfo) {
                handler(value: value, sender: notification.object as? S)
            }
        })
    }

    deinit {
        center.removeObserver(observerProxy)
    }
}


// MARK: Private

// Key for user info dictionary
private let UserInfoValueKey = "value"

// This class allows the "boxing up" instances that are not objects
private class Box<T> {
    let value: T

    init(_ value: T) {
        self.value = value
    }
}

// Create user info dictionary
private func userInfo<T>(value: T) -> [String : Box<T>] {
    return [UserInfoValueKey : Box(value)]
}

// Unbox user info dictionary
private func unboxUserInfo<T>(userInfo: [NSObject: AnyObject]?) -> T? {
    if let box = userInfo?[UserInfoValueKey] as? Box<T> {
        return box.value
    }
    return nil
}
