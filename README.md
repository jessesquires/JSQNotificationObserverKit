# JSQNotificationObserverKit

[![Build Status](https://secure.travis-ci.org/jessesquires/JSQNotificationObserverKit.svg)](http://travis-ci.org/jessesquires/JSQNotificationObserverKit) [![Version Status](https://img.shields.io/cocoapods/v/JSQNotificationObserverKit.svg)][podLink] [![license MIT](https://img.shields.io/cocoapods/l/JSQNotificationObserverKit.svg)][mitLink] [![codecov.io](https://img.shields.io/codecov/c/github/jessesquires/JSQNotificationObserverKit.svg)](http://codecov.io/github/jessesquires/JSQNotificationObserverKit) [![Platform](https://img.shields.io/cocoapods/p/JSQNotificationObserverKit.svg)][docsLink] [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

*Generic notifications and observers for Cocoa and CocoaTouch, inspired by [objc.io](http://www.objc.io/snippets/16.html)*

## About

This library aims to provide better semantics regarding notifications and moves the responsibilty of observing and handling notifications to a lightweight, single-purpose object. It also brings type-safety and a cleaner interface to `NSNotificationCenter`. See objc.io's [snippet #16](http://www.objc.io/snippets/16.html) on *Typed Notification Observers* for more information.

## Requirements

* Xcode 7.2+
* iOS 8.0+
* OSX 10.10+
* tvOS 9.1+
* watchOS 2.0+
* Swift 2.0+

## Installation

#### [CocoaPods](http://cocoapods.org) (recommended)

````ruby
use_frameworks!

# For latest release in cocoapods
pod 'JSQNotificationObserverKit'

# Feeling adventurous? Get the latest on develop
pod 'JSQNotificationObserverKit', :git => 'https://github.com/jessesquires/JSQNotificationObserverKit.git', :branch => 'develop'
````

#### [Carthage](https://github.com/Carthage/Carthage)

````bash
github "jessesquires/JSQNotificationObserverKit"
````

## Documentation

Read the [docs][docsLink]. Generated with [jazzy](https://github.com/realm/jazzy). Hosted by [GitHub Pages](https://pages.github.com). More information on the [`gh-pages`](https://github.com/jessesquires/JSQNotificationObserverKit/tree/gh-pages) branch.

## Getting Started

````swift
import JSQNotificationObserverKit
````

>See the included unit tests for more examples and usage.

#### Example

````swift
// Suppose we have a UIView that posts a notification when its size changes
let myView = UIView()

// This notification posts a CGSize value from a UIView sender
let notification = Notification<CGSize, UIView>(name: "NewViewSizeNotif", sender: myView)

// This observer listens for the notification described above
var observer: NotificationObserver<CGSize, UIView>?

// Register observer, start listening for the notification
observer = NotificationObserver(notification: notification) { (value, sender) in
    // handle notification
    // the value and sender are both passed here
}

// Post the notification with the updated CGSize value
notification.post(CGSizeMake(200, 200))

// Unregister observer, stop listening for notifications
observer = nil
````

#### Notifications without a sender

Not all notifications are associated with a specific sender object. Here's how to handle `nil` sender in `JSQNotificationObserverKit`. This observer will respond to notifications *regardless* of the instances sending them.

````swift
// This notification posts a string value, the sender is nil
let notification = Notification<String, AnyObject>(name: "StringNotif")

// Post the notification
notification.post("new string")

// Register observer, this handles notifications from *any* sender
var observer: NotificationObserver<String, AnyObject>?
observer = NotificationObserver(notification: notification) { (value, sender) in
    // handle notification
    // the value is passed here, sender is nil
}

// unregister observer, stop listening for notifications
observer = nil
````

#### Using a custom queue and notification center

You can optionally pass an `NSOperationQueue` and `NSNotificationCenter`. The default values are `nil` and `NSNotificationCenter.defaultCenter()`, respectively.

````swift
// Initialize an observer and post a notification
// with a custom notification center and operation queue
let c = NSNotificationCenter.defaultCenter()

let q = NSOperationQueue.mainQueue()

let observer = NotificationObserver(notification: n, queue: q, center: c) { (value, sender) in
    // handle notification
}

notification.post(v, center: c)
````

#### Notifications without a value

Not all notifications are associated with a specific value. Sometimes notifications are used to simply broadcast an event, for example `UIApplicationDidReceiveMemoryWarningNotification`.

````swift
let notification = Notification<Any?, AnyObject>(name: "MyEventNotification")

let observer = NotificationObserver(notification: notification) { (value, sender) in
    // handle notification
    // value is nil, sender is nil
}

// notification value is `Any?`, so pass nil
notification.post(nil)
````

#### Working with "traditional" Cocoa notifications

The library can also handle "traditional" notifications that are posted by the OS. Instead of using the `(value, sender)` handler, use the `(notification)` handler which passes the full `NSNotification` object.

````swift
let notification = Notification<Any, AnyObject>(name: UIApplicationDidReceiveMemoryWarningNotification)

let observer = NotificationObserver(notification: notification, handler: { (notification: NSNotification) in
    // handle the notification
})

// the notification will be posted by iOS
````

## Unit tests

There's a suite of unit tests for the `JSQNotificationObserverKit.framework`. To run them, open `JSQNotificationObserverKit.xcodeproj`, select the `JSQNotificationObserverKit` scheme, then &#x2318;-u.

These tests are well commented and serve as further documentation for how to use this library.

## Contribute

Please follow these sweet [contribution guidelines](https://github.com/jessesquires/HowToContribute).

## Credits

Created and maintained by [**@jesse_squires**](https://twitter.com/jesse_squires).

## License

`JSQNotificationObserverKit` is released under an [MIT License][mitLink]. See `LICENSE` for details.

>**Copyright &copy; 2014-present Jesse Squires.**

*Please provide attribution, it is greatly appreciated.*

[mitLink]:http://opensource.org/licenses/MIT
[docsLink]:http://www.jessesquires.com/JSQNotificationObserverKit
[podLink]:https://cocoapods.org/pods/JSQNotificationObserverKit
