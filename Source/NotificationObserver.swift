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
//  Copyright © 2015-present Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation

/// Describes a notification's userInfo dictionary
public typealias UserInfo = [NSObject : AnyObject]


/**
 - parameter lhs: A UserInfo instance.
 - parameter rhs: A UserInfo instance.

 - returns: True if `lhs` is equal to `rhs`, false otherwise.
 */
public func ==(lhs: UserInfo, rhs: UserInfo) -> Bool {
    guard lhs.count == rhs.count else {
        return false
    }

    for (key, value) in lhs {
        guard let rhsValue = rhs[key] else {
            return false
        }

        if !rhsValue.isEqual(value) {
            return false
        }
    }
    return true
}


/**
 A typed notification that contains a name and optional sender.

 - note: The `Value` type parameter acts as a phantom type, restricting the notification to posting only values of this type.
 */
public struct Notification <Value, Sender: AnyObject> {

    // MARK: Properties

    /// The name of the notification.
    public let name: String

    /// The object that posted the notification.
    public let sender: Sender?

    // MARK: Initialization

    /**
    Constructs a new notification instance having the specified name and sender.

    - parameter name:   The name of the notification.
    - parameter sender: The object sending the notification. The default is `nil`.

    - returns: A new `Notification` instance.
    */
    public init(name: String, sender: Sender? = nil) {
        self.name = name
        self.sender = sender
    }

    /**
     Posts the notification with the given value to the specified center.

     - parameter value:  The data to be sent with the notification.
     - parameter center: The notification center from which the notification should be dispatched.
     The default is `NSNotificationCenter.defaultCenter()`.
     */
    public func post(value: Value, center: NSNotificationCenter = .defaultCenter()) {
        center.postNotificationName(name, object: sender, userInfo: userInfo(value))
    }

    /**
     Returns a new notification with the receiver's name and the specified sender.

     - warning: Note that this function returns a new `Notification` instance.

     - parameter sender: The instance posting this notification.

     - returns: A new `Notification` instance.
     */
    public func withSender(sender: Sender?) -> Notification {
        return Notification(name: name, sender: sender)
    }
}


/**
 An instance of `NotificationObserver` is responsible for observing notifications.

 - note: When an observer is initialized, it will immediately begin listening for its specified notification
 by registering with the specified notification center.
 */
public final class NotificationObserver <V, S: AnyObject> {

    // MARK: Typealiases

    /**
    The closure to be called when a `Notification` is received.

    - parameter value:  The data sent with the notification.
    - parameter sender: The object that sent the notification, or `nil` if the notification is not associated with a specific sender.
    */
    public typealias ValueSenderHandler = (value: V, sender: S?) -> Void

    /**
     The closure to be called when an `NSNotification` is received.

     - parameter notification: The notification received.
     */
    public typealias NotificationHandler = (notification: NSNotification) -> Void


    // MARK: Properties

    private let observerProxy: NSObjectProtocol

    private let center: NSNotificationCenter


    // MARK: Initialization

    /**
    Constructs a new `NotificationObserver` instance and immediately registers to begin observing the specified `notification`.

    - warning: To unregister this observer and end listening for notifications, dealloc the object by setting it to `nil`.

    - parameter notification: The notification for which to register the observer.
    - parameter queue:        The operation queue to which `handler` should be added.
    If `nil` (the default), the block is run synchronously on the posting thread.
    - parameter center:       The notification center from which the notification should be dispatched.
    The default is `NSNotificationCenter.defaultCenter()`.
    - parameter handler:      The closure to execute when the notification is received.

    - returns: A new `NotificationObserver` instance.
    */
    public convenience init(
        notification: Notification<V, S>,
        queue: NSOperationQueue? = nil,
        center: NSNotificationCenter = .defaultCenter(),
        handler: ValueSenderHandler) {
            self.init(notification: notification, queue: queue, center: center, handler: { (notification: NSNotification) in
                if let value: V = unboxUserInfo(notification.userInfo) {
                    handler(value: value, sender: notification.object as? S)
                }
            })
    }

    /**
     Constructs a new `NotificationObserver` instance and immediately registers to begin observing the specified `notification`.

     - warning: To unregister this observer and end listening for notifications, dealloc the object by setting it to `nil`.

     - parameter notification: The notification for which to register the observer.
     - parameter queue:        The operation queue to which `handler` should be added.
     If `nil` (the default), the block is run synchronously on the posting thread.
     - parameter center:       The notification center from which the notification should be dispatched.
     The default is `NSNotificationCenter.defaultCenter()`.
     - parameter handler:      The closure to execute when the notification is received.

     - returns: A new `NotificationObserver` instance.
     */
    public init(
        notification: Notification<V, S>,
        queue: NSOperationQueue? = nil,
        center: NSNotificationCenter = .defaultCenter(),
        handler: NotificationHandler) {
            self.center = center
            observerProxy = center.addObserverForName(notification.name, object: notification.sender, queue: queue, usingBlock: handler)
    }

    /// :nodoc:
    deinit {
        center.removeObserver(observerProxy)
    }
}


// MARK: Private


// Key for user info dictionary
private let UserInfoValueKey = "UserInfoValueKey"


// This class allows the "boxing up" instances that are not reference types
private final class Box<T> {
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
private func unboxUserInfo<T>(userInfo: UserInfo?) -> T? {
    if let box = userInfo?[UserInfoValueKey] as? Box<T> {
        return box.value
    }
    return nil
}
