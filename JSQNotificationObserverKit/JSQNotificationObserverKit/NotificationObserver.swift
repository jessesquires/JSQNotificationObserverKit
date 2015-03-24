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

///  Describes a notification's userInfo dictionary
public typealias UserInfo = [NSObject : AnyObject]


///  A typed notification that contains a name and optional sender.
///  A `Notification` has the following type parameters: `<Value, Sender: AnyObject>`.
///  The `Value` type parameter acts as a phantom type, restricting the notification to posting only values of this type.
public struct Notification <Value, Sender: AnyObject> {

    // MARK: Properties

    ///  The name of the notification.
    public let name: String

    ///  The object that posted the notification.
    public let sender: Sender?

    // MARK: Initialization

    ///  Constructs a new notification instance having the specified name and sender.
    ///
    ///  :param: name   The name of the notification.
    ///  :param: sender The object sending the notification. The default parameter value is `nil`.
    ///
    ///  :returns: A new `Notification` instance.
    public init(name: String, sender: Sender? = nil) {
        self.name = name
        self.sender = sender
    }

}


///  Posts the given notification to the specified center.
///  This function has the same type parameters as `Notification`, namely `<V, S: AnyObject>`, which restricts the type of value that can be posted.
///
///  :param: notification The notification to post.
///  :param: value        The data value to be sent with the notification.
///  :param: center       The notification center from which the notification should be dispatched.
///                       The default parameter value is `NSNotificationCenter.defaultCenter()`.
public func postNotification<V, S: AnyObject> (notification: Notification<V, S>, #value: V, center: NSNotificationCenter = NSNotificationCenter.defaultCenter()) {
    center.postNotificationName(notification.name, object: notification.sender, userInfo: userInfo(value))
}


///  An instance of `NotificationObserver` is responsible for observing notifications.
///  It has the same type parameters as `Notification`, namely `<V, S: AnyObject>`.
///  When an observer is initialized, it will immediately begin listening for its specified notification
///  by registering with the specified notification center.
public final class NotificationObserver <V, S: AnyObject> {

    // MARK: Typealiases

    ///  The closure to be called when a notification is received.
    ///
    ///  :param: value  The data value sent with the notification.
    ///  :param: sender The object that sent the notification, or `nil` if the notification is not associated with a specific sender.
    public typealias Handler = (value: V, sender: S?) -> Void

    private let observerProxy: NSObjectProtocol

    private let center: NSNotificationCenter

    // MARK: Initialization

    ///  Constructs a new `NotificationObserver` instance and immediately registers to begin observing the specified `notification`.
    ///  To unregister this observer and end listening for notifications, dealloc the object by setting it to `nil`.
    ///
    ///  :param: notification The notification for which to register the observer.
    ///  :param: queue        The operation queue to which `handler` should be added.
    ///                       If `nil`, the block is run synchronously on the posting thread. The default parameter value is `nil`.
    ///  :param: center       The notification center from which the notification should be dispatched.
    ///                       The default parameter value is `NSNotificationCenter.defaultCenter()`.
    ///  :param: handler      The closure to execute when the notification is received.
    ///
    ///  :returns: A new `NotificationObserver` instance.
    public init(notification: Notification<V, S>, queue: NSOperationQueue? = nil, center: NSNotificationCenter = NSNotificationCenter.defaultCenter(), handler: Handler) {
        self.center = center
        observerProxy = center.addObserverForName(notification.name, object: notification.sender, queue: queue, usingBlock: { (notification: NSNotification!) -> Void in
            if let value: V = unboxUserInfo(notification.userInfo) {
                handler(value: value, sender: notification.object as? S)
            }
        })
    }

    ///  Deinitializer for this class.
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
