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

import XCTest
import Foundation
import UIKit

import JSQNotificationObserverKit



// MARK: Fakes

class TestSender: Equatable {
    let sender = NSUUID().UUIDString
}

struct TestValue: Equatable {
    let value = NSUUID().UUIDString
}

func ==(lhs: TestSender, rhs: TestSender) -> Bool {
    return lhs.sender == rhs.sender
}

func ==(lhs: TestValue, rhs: TestValue) -> Bool {
    return lhs.value == rhs.value
}



// MARK: Test cases

let timeout = NSTimeInterval(5)


final class NotificationObserverTests: XCTestCase {

    func test_ThatWithSender_ReturnsNewNotification() {
        // GIVEN: a notification and sender
        let sender = TestSender()
        let notif = Notification<Int, TestSender>(name: "Notif", sender: sender)
        XCTAssertEqual(notif.sender, sender)

        let newNotif = notif.withSender(nil)
        XCTAssertEqual(newNotif.name, notif.name, "Notification names should be equal")
        XCTAssertNil(newNotif.sender, "New notification sender should be updated")

        XCTAssertNotNil(notif.sender, "Original notification sender should remain unchanged")

        let anotherSender = TestSender()
        let anotherNotif = notif.withSender(anotherSender)
        XCTAssertEqual(anotherNotif.name, notif.name, "Notification names should be equal")
        XCTAssertEqual(anotherNotif.sender, anotherSender, "New notification sender should be updated")

        XCTAssertEqual(notif.sender, sender, "Original notification sender should remain unchanged")
    }

    func test_ThatWithSender_PostsCorrectNotification() {
        // GIVEN: a notification
        let notif = Notification<Int, TestSender>(name: "Notif")
        XCTAssertNil(notif.sender)

        let sender = TestSender()
        let value = 666
        let expect = self.expectationWithDescription("\(#function)")

        // GIVEN: an observer
        let observer = NotificationObserver(notification: notif, handler: { (v, s) in
            XCTAssertEqual(s, sender)
            XCTAssertEqual(v, value)
            expect.fulfill()
        })

        XCTAssertNotNil(observer)

        // WHEN: the notification is posted using a new sender
        let newNotif = notif.withSender(sender)
        newNotif.post(value)

        XCTAssertEqual(newNotif.sender, sender, "New notification sender should be updated")
        XCTAssertNil(notif.sender, "Original notification sender should remain unchanged")

        // THEN: the observer receives the correct notification and executes its handler
        self.waitForExpectationsWithTimeout(timeout, handler: { (error) in
            XCTAssertNil(error, "Expectation should not error")
        })
    }

    func test_ThatNotificationIsPostedAndReceived_WithEmptyTupleAndNoSender() {
        // GIVEN: a notification
        let notif = Notification<Void, AnyObject>(name: "Notification")

        let expect = self.expectationWithDescription("\(#function)")

        // GIVEN: an observer
        let observer = NotificationObserver(notification: notif, handler: { (value, sender) in
            XCTAssertNil(sender, "Sender should be nil")
            expect.fulfill()
        })

        XCTAssertNotNil(observer)

        // WHEN: the notification is posted with an empty tuple and no sender
        notif.post(())

        // THEN: the observer receives the notification and executes its handler
        self.waitForExpectationsWithTimeout(timeout, handler: { (error) in
            XCTAssertNil(error, "Expectation should not error")
        })
    }

    func test_ThatNotificationIsPostedAndReceived_WithUserInfoAndSender() {
        // GIVEN: a userInfo dictionary
        let userInfo: UserInfo = ["someKey": 100, "anotherKey": NSDate()]

        // GIVEN: a notification
        let notif = Notification<UserInfo, NotificationObserverTests>(name: "ExampleNotification", sender: self)

        let expect = self.expectationWithDescription("\(#function)")

        // GIVEN: an observer
        let observer = NotificationObserver(notification: notif, handler: { [weak self] (value, sender) in
            XCTAssertTrue(value == userInfo, "Value should equal expected value")
            XCTAssertEqual(sender!, self, "Sender should equal expected sender")
            expect.fulfill()
            })

        XCTAssertNotNil(observer)

        // WHEN: the notification is posted with userInfo and no sender
        notif.post(userInfo)

        // THEN: the observer receives the notification and executes its handler
        self.waitForExpectationsWithTimeout(timeout, handler: { (error) in
            XCTAssertNil(error, "Expectation should not error")
        })
    }

    func test_ThatNotificationIsPostedAndReceived_WithUserInfoAndNoSender() {
        // GIVEN: a userInfo dictionary
        let userInfo = ["someKey": 100, "anotherKey": NSDate()]

        // GIVEN: a notification without a sender
        let notif = Notification<[String: NSObject], AnyObject>(name: "ExampleNotification")

        let expect = self.expectationWithDescription("\(#function)")

        // GIVEN: an observer
        let observer = NotificationObserver(notification: notif, queue: .mainQueue(), center: .defaultCenter(), handler: { (value, sender) in
            XCTAssertEqual(value, userInfo, "Value should equal expected value")
            XCTAssertNil(sender, "Sender should be nil")
            expect.fulfill()
        })

        XCTAssertNotNil(observer)

        // WHEN: the notification is posted with userInfo
        notif.post(userInfo)

        // THEN: the observer receives the notification and executes its handler
        self.waitForExpectationsWithTimeout(timeout, handler: { (error) in
            XCTAssertNil(error, "Expectation should not error")
        })
    }

    func test_ThatNotificationIsPostedAndReceived_WithValueAndSender() {
        // GIVEN: a sender, value, and notification
        let fakeSender = TestSender()
        let fakeValue = TestValue()
        let notification = Notification<TestValue, TestSender>(name: "NotificationName", sender: fakeSender)

        let expectation = self.expectationWithDescription("\(#function)")

        // GIVEN: an observer
        let observer = NotificationObserver(notification: notification, handler: { (value, sender) in
            XCTAssertEqual(value, fakeValue, "Values should be equal")
            XCTAssertEqual(sender, fakeSender, "Senders should be equal")
            expectation.fulfill()
        })

        XCTAssertNotNil(observer)

        // WHEN: the notification is posted
        notification.post(fakeValue)

        // THEN: the observer receives the notification and executes its handler
        self.waitForExpectationsWithTimeout(timeout, handler: { (error) in
            XCTAssertNil(error, "Expectation should not error")
        })
    }

    func test_ThatNotificationIsPostedAndReceived_WithValueAndNoSender() {
        // GIVEN: a value, and notification without a sender
        let fakeValue = TestValue()
        let notification = Notification<TestValue, AnyObject>(name: "NotificationName")

        let expectation = self.expectationWithDescription("\(#function)")

        // GIVEN: an observer
        let observer = NotificationObserver(notification: notification, handler: { (value, sender) in
            XCTAssertEqual(value.value, fakeValue.value, "Values should be equal")
            XCTAssertNil(sender, "Sender should be nil")
            expectation.fulfill()
        })

        XCTAssertNotNil(observer)

        // WHEN: the notification is posted without a specific sender
        notification.post(fakeValue)

        // THEN: the observer receives the notification and executes its handler
        self.waitForExpectationsWithTimeout(timeout, handler: { (error) in
            XCTAssertNil(error, "Expectation should not error")
        })
    }

    func test_ThatNotificationIsPostedAndReceived_WithNilValueAndNoSender() {
        // GIVEN: a notification with a sender
        let notification = Notification<Any?, AnyObject>(name: "NotificationName")

        let expectation = self.expectationWithDescription("\(#function)")

        // GIVEN: an observer
        let observer = NotificationObserver(notification: notification, handler: { (value, sender) in
            XCTAssertNil(value, "Value should be nil")
            XCTAssertNil(sender, "Sender should be nil")
            expectation.fulfill()
        })

        XCTAssertNotNil(observer)

        // WHEN: the notification is posted without a specific sender
        notification.post(nil)

        // THEN: the observer receives the notification and executes its handler
        self.waitForExpectationsWithTimeout(timeout, handler: { (error) in
            XCTAssertNil(error, "Expectation should not error")
        })
    }

    func test_ThatNotificationIsPostedAndReceived_TraditionalCocoa() {
        // GIVEN: a "traditional Cocoa" notification
        let notification = CocoaNotification(name: UIApplicationDidReceiveMemoryWarningNotification)
        
        let expectation = self.expectationWithDescription("\(#function)")

        // GIVEN: an "traditional Cocoa" observer
        let observer = CocoaObserver(notification: notification, handler: { (notification: NSNotification) in
            expectation.fulfill()
        })

        XCTAssertNotNil(observer)

        // WHEN: the notification is posted "by the system"
        NSNotificationCenter.defaultCenter().postNotificationName(
            notification.name,
            object: notification.sender,
            userInfo: nil)

        // THEN: the observer receives the notification and executes its handler
        self.waitForExpectationsWithTimeout(timeout, handler: { (error) in
            XCTAssertNil(error, "Expectation should not error")
        })
    }

    func test_ThatObserverUnregistersForNotificationsOnDeinit() {
        // GIVEN: a notification and observer
        let fakeValue = TestValue()
        let notification = Notification<TestValue, TestSender>(name: "NotificationName", sender: TestSender())

        var didCallHandler = false
        var observer: NotificationObserver? = NotificationObserver(notification: notification, handler: { (value, sender) in
            didCallHandler = true
        })

        XCTAssertNotNil(observer)

        observer = nil

        // WHEN: the notification is posted after the observer is dealloc'd
        notification.post(fakeValue)

        // THEN: the observer does not receive the notification and does not execute its handler
        XCTAssertFalse(didCallHandler)
    }

    func test_ThatUserInfoObjectsAreEqual() {
        // GIVEN: two equal user info objects
        let first: UserInfo = [
            "key0": "fake value",
            "key1": 234
        ]

        let second: UserInfo = [
            "key0": "fake value",
            "key1": 234
        ]

        // WHEN: we compare them
        let result = (first == second)

        // THEN: they are equal
        XCTAssertTrue(result)
    }

    func test_ThatUserInfoObjectsAreNotEqual_MissingKeys() {
        // GIVEN: two distinct user info objects
        let first: UserInfo = [
            "key0": "fake value",
            "key1": 234,
            "key2": NSDate()
        ]

        let second: UserInfo = [
            "key0": "fake value"
        ]

        // WHEN: we compare them
        let result = (first == second)

        // THEN: they are not equal
        XCTAssertFalse(result)
    }

    func test_ThatUserInfoObjectsAreNotEqual_DifferentValues() {
        // GIVEN: two distinct user info objects
        let first: UserInfo = [
            "key0": "fake value",
            "key1": 234,
            "key2": NSDate()
        ]

        let second: UserInfo = [
            "key0": "different",
            "key1": 4567,
            "key2": NSDate()
        ]

        // WHEN: we compare them
        let result = (first == second)

        // THEN: they are not equal
        XCTAssertFalse(result)
    }

    func test_ThatUserInfoObjectsAreNotEqual_DifferentKeys() {
        // GIVEN: two distinct user info objects
        let first: UserInfo = [
            "key0": "fake value",
            "key1": 234,
            "key2": NSDate()
        ]
        
        let second: UserInfo = [
            "key7": "different",
            "key8": 4567,
            "key9": NSDate()
        ]
        
        // WHEN: we compare them
        let result = (first == second)
        
        // THEN: they are not equal
        XCTAssertFalse(result)
    }
    
}
