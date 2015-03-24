# JSQNotificationObserverKit

[![Build Status](https://secure.travis-ci.org/jessesquires/JSQNotificationObserverKit.svg)](http://travis-ci.org/jessesquires/JSQNotificationObserverKit) [![Version Status](http://img.shields.io/cocoapods/v/JSQNotificationObserverKit.png)][docsLink] [![license MIT](http://img.shields.io/badge/license-MIT-orange.png)][mitLink]

*Generic notifications and observers for iOS, inspired by [objc.io](http://www.objc.io/snippets/16.html)*

## About

This framework aims to provide better semantics regarding notifications and moves the responsibilty of observing and handling notifications to a lightweight, single-purpose object. It also brings type-saftey and a cleaner interface to `NSNotificationCenter`. See objc.io's [snippet #16](http://www.objc.io/snippets/16.html) on *Typed Notification Observers* for more information.

## Requirements

* iOS 8
* Swift 1.1

## Installation

From [CocoaPods](http://cocoapods.org):

````ruby
use_frameworks!

# For latest release in cocoapods
pod 'JSQNotificationObserverKit'  

# Feeling adventurous? Get the latest on develop
pod 'JSQNotificationObserverKit', :git => 'https://github.com/jessesquires/JSQNotificationObserverKit.git', :branch => 'develop'
````

Manually:

Add the `NotificationObserver.swift` file to your project.

## Documentation

Read the fucking [docs][docsLink]. Generated with [jazzy](https://github.com/realm/jazzy). Hosted by [GitHub Pages](https://pages.github.com).

````bash
# regenerate documentation
$ cd /path/to/JSQNotificationObserverKit/
$ ./build_docs.sh
$ open _docs/
````

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

// Register observer, start lisening for the notification
var observer: NotificationObserver<CGSize, UIView>?

observer = NotificationObserver(notification: notification) { (value, sender) in
    // handle notification
    // the value and sender are both passed here
}

// Post the notification with the updated CGSize value
let newViewSize = CGSizeMake(200, 200)
postNotification(notification, value: newViewSize)

// unregister observer, stop listening for notifications
observer = nil
````

#### Notifications without a sender

````swift
// This notification posts a string value, the sender is nil
let notification = Notification<String, AnyObject>(name: "StringNotif")

// Post the notification
postNotification(notification, value: "new string")

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

````swift
// Initialize an observer and post a notification
// with a custom notification center and operation queue
let c = NSNotificationCenter.defaultCenter()

let q = NSOperationQueue.mainQueue()

let observer = NotificationObserver(notification: n, queue: q, center: c) { (value, sender) in
    // handle notification
}

postNotification(n, value: v, center: c)
````

## Unit tests

There's a suite of unit tests for the `JSQNotificationObserverKit.framework`. To run them, open `JSQNotificationObserverKit.xcodeproj`, select the `JSQNotificationObserverKit` scheme, then &#x2318;-u.

These tests are well commented and serve as further documentation for how to use this library.

## Contribute

Please follow these sweet [contribution guidelines](https://github.com/jessesquires/HowToContribute).

## Credits

Created and maintained by [**@jesse_squires**](https://twitter.com/jesse_squires)

## License

`JSQNotificationObserverKit` is released under an [MIT License][mitLink]. See `LICENSE` for details.

>**Copyright &copy; 2015 Jesse Squires.**

*Please provide attribution, it is greatly appreciated.*

[mitLink]:http://opensource.org/licenses/MIT
[docsLink]:http://www.jessesquires.com/JSQNotificationObserverKit
