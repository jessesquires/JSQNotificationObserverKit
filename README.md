# JSQNotificationListenerKit

A general-purpose, single-responsibilty notification listener for iOS

## About

Using [NSNotificationCenter](https://developer.apple.com/library/IOs/documentation/Cocoa/Reference/Foundation/Classes/NSNotificationCenter_Class/index.html#//apple_ref/occ/instm/NSNotificationCenter/) can be cubersome and involve lots of boilerplate code, even when using the newer block-based observer methods.

Additionally, it's common practice to have your view controllers handle notifications. This is not very [light](http://www.objc.io/issue-1/lighter-view-controllers.html), it encourages *massive* view controllers, and often leads to duplicate code across view controllers.

This project aims to provide better semantics regarding notifications and moves the responsibilty of handling notifications to a small, single-purpose object.

**Before JSQNotificationListenerKit**
```objective-c
// code
```

**After JSQNotificationListenerKit**
```objective-c
// code
```

## Contribute

Please follow these sweet [contribution guidelines](https://github.com/jessesquires/HowToContribute).

## License

`JSQNotificationListenerKit` is released under an [MIT License][mitLink]. See `LICENSE` for details.

>**Copyright &copy; 2014 Jesse Squires.**

*Please provide attribution, it is greatly appreciated.*

[mitLink]:http://opensource.org/licenses/MIT
