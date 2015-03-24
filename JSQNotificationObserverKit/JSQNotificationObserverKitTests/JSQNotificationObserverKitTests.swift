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

import XCTest
import JSQNotificationObserverKit


// MARK: Fakes

class TestSender {
    let sender = NSUUID().UUIDString
}

struct TestValue {
    let value = NSUUID().UUIDString
}


// MARK: Test case

class JSQNotificationObserverKitTests: XCTestCase {

    func test_ThatNotificationIsPosted_AndReceivedByObserver_WithValueAndSender() {

        // GIVEN: a sender, value, notification, and observer
        let fakeSender = TestSender()
        let fakeValue = TestValue()
        let notification = Notification<TestValue, TestSender>(name: "\(__FUNCTION__)", sender: fakeSender)

        let expectation = self.expectationWithDescription("\(__FUNCTION__)")

        let observer = NotificationObserver(notification: notification) { (value, sender) -> Void in

            XCTAssertEqual(value.value, fakeValue.value, "Values should be equal")
            XCTAssertEqual(fakeSender.sender, sender!.sender, "Senders should be equal")

            expectation.fulfill()
        }

        // WHEN: the notification is posted
        postNotification(notification, value: fakeValue)

        // THEN: the observer receives the notification and executes its handler
        self.waitForExpectationsWithTimeout(2, handler: { (error) -> Void in
            XCTAssertNil(error, "Expectation should not error")
        })
    }

    func test_ThatNotificationIsPosted_AndReceivedByObserver_WithValueOnly() {

        // GIVEN: value, notification without a sender, and observer
        let fakeValue = TestValue()
        let notification = Notification<TestValue, AnyObject>(name: "\(__FUNCTION__)")

        let expectation = self.expectationWithDescription("\(__FUNCTION__)")

        let observer = NotificationObserver(notification: notification) { (value, sender) -> Void in

            XCTAssertEqual(value.value, fakeValue.value, "Values should be equal")
            XCTAssertNil(sender, "Sender should be nil")

            expectation.fulfill()
        }

        // WHEN: the notification is posted without a specific sender
        postNotification(notification, value: fakeValue)

        // THEN: the observer receives the notification and executes its handler
        self.waitForExpectationsWithTimeout(2, handler: { (error) -> Void in
            XCTAssertNil(error, "Expectation should not error")
        })
    }

    func test_ThatObserverUnregistersForNotificationsOnDeinit_WithValueSenderHandler() {

        // GIVEN: a value, notification, and observer
        let fakeValue = TestValue()
        let notification = Notification<TestValue, AnyObject>(name: "\(__FUNCTION__)")

        var didCallHandler = false
        var observer: NotificationObserver? = NotificationObserver(notification: notification) { (value, sender) -> Void in
            didCallHandler = true
        }

        observer = nil

        // WHEN: the notification is posted after the observer is dealloc'd
        postNotification(notification, value: fakeValue)

        // THEN: the observer does not receive the notification and does not execute its handler
        XCTAssertFalse(didCallHandler)
    }

    
}
