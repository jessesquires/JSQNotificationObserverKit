# CHANGELOG

The changelog for `JSQNotificationObserverKit`. Also see the [releases](https://github.com/jessesquires/JSQNotificationObserverKit/releases) on GitHub.

--------------------------------------

4.0.0
-----

This release closes the [4.0.0 milestone](https://github.com/jessesquires/JSQNotificationObserverKit/issues?q=milestone%3A4.0.0). :tada:

* The previously added `withSender()` function on `Notification` has changed from `mutating` to non-mutating and now returns a new `Notification` instance. See discussion at #26. See the [docs](http://www.jessesquires.com/JSQNotificationObserverKit/Structs/Notification.html#/s:FV26JSQNotificationObserverKit12Notification10withSenderu0_Rq0_Ss9AnyObject_FGS0_q_q0__FGSqq0__GS0_q_q0__) for details.

This is a minor, but breaking, change.

3.1.0
-----

This release closes the [3.1.0 milestone](https://github.com/jessesquires/JSQNotificationObserverKit/issues?q=milestone%3A3.1.0). :tada:

### New

* Support for [Swift package manager](https://github.com/apple/swift-package-manager) :package:

* `Notification` now has a `withSender()` function to add/remove a sender. (#22, Thanks @grosch! :clap:)

This is valuable if you want to declare global notifications where the specific sender instance isn't available in the global scope. This function can be chained with `post()`.

Example usage:

```swift
// in a view controller, for example

notification.withSender(self).post(value)
```

See the [docs](http://www.jessesquires.com/JSQNotificationObserverKit/Structs/Notification.html#/s:FV26JSQNotificationObserverKit12Notification10withSenderu0_Rq0_Ss9AnyObject_FRGS0_q_q0__FGSqq0__GS0_q_q0__) for details.

3.0.0
-----

This release closes the [3.0.0 milestone](https://github.com/jessesquires/JSQNotificationObserverKit/issues?q=milestone%3A3.0.0).

### New

Official support for OS X, tvOS, watchOS via CocoaPods. :tada:

### Changes

The `postNotification()` global function has moved to be a function on `Notification`. Thanks @grosch!
See the [updated docs](http://www.jessesquires.com/JSQNotificationObserverKit/Structs/Notification.html) for details.

2.0.0
-----

This release closes the [2.0.0 milestone](https://github.com/jessesquires/JSQNotificationObserverKit/issues?q=milestone%3A2.0.0).

- Swift 2.0 :tada:
- A few refinements
- More unit tests
- Updated [docs](http://www.jessesquires.com/JSQNotificationObserverKit)

1.0.0
-----

It's here! :tada:

Checkout the `README` and documentation.
