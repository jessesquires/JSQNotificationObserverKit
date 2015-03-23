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

class FakeSender {
    let sender = NSUUID().UUIDString
}

struct FakeValue {
    let value = NSUUID().UUIDString
}


// MARK: Test case

class JSQNotificationObserverKitTests: XCTestCase {

    func test() {

        // GIVEN: a notification, sender, and observer
        let notification = Notification<FakeValue, FakeSender>(name: "\(__FUNCTION__)")

        let fakeSender = FakeSender()

        let fakeValue = FakeValue()

        let expectation = self.expectationWithDescription("\(__FUNCTION__)")

        let observer = NotificationObserver(notification: notification, sender: fakeSender) { (value, sender) -> Void in

            XCTAssertEqual(value.value, fakeValue.value, "Values should be equal")
            XCTAssertEqual(fakeSender.sender, sender!.sender, "Senders should be equal")

            expectation.fulfill()
        }

        // WHEN: we post the notification
        postNotification(notification, value: fakeValue, sender: fakeSender)

        // THEN: the notification is received
        self.waitForExpectationsWithTimeout(2, handler: { (error) -> Void in
            XCTAssertNil(error, "Expectation should not error")
        })
    }
    
}
