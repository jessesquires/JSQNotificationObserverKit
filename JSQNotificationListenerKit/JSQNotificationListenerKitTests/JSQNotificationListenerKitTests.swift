//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  GitHub
//  https://github.com/jessesquires/JSQNotificationListenerKit
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import XCTest
import JSQNotificationListenerKit

class JSQNotificationListenerKitTests: XCTestCase {
    
    func testNotificationListener() {
        
        // GIVEN: a notification name and a listener
        let notificationName = "MyCustomNotification"
        
        let expectation = self.expectationWithDescription(__FUNCTION__)
        
        let listener = NotificationListener(notificationName: notificationName) { (notification) -> () in
            XCTAssertEqual(notification.name, notificationName, "Notification names should match")
            expectation.fulfill()
        }
        
        // WHEN: the notification is posted
        NSNotificationCenter.defaultCenter().postNotificationName(notificationName, object: nil)
        
        // THEN: the handler closure is called with the expected notification
        self.waitForExpectationsWithTimeout(5) { (error) -> Void in
            XCTAssertNil(error, "Expectation should not error")
        }
    }
    
    func testNotificationListenerForObject() {
        
        // GIVEN: a notification name, an object to post, and a listener
        let notificationName = "MyCustomNotification"
        let notificationPoster = NSObject()
        
        let expectation = self.expectationWithDescription(__FUNCTION__)
        
        let listener = NotificationListener(notificationName: notificationName, object: notificationPoster) { (notification) -> () in
            XCTAssertEqual(notification.name, notificationName, "Notification names should match")
            expectation.fulfill()
        }
        
        // WHEN: the notification is posted from the specific object
        NSNotificationCenter.defaultCenter().postNotificationName(notificationName, object: notificationPoster)
        
        // THEN: the handler closure is called with the expected notification
        self.waitForExpectationsWithTimeout(5) { (error) -> Void in
            XCTAssertNil(error, "Expectation should not error")
        }
    }
    
    func testNotificationListenerForObjectFailure() {
        
        // GIVEN: a notification name, an object to post, and a listener
        let notificationName = "MyCustomNotification"
        let notificationPoster = NSObject()
        
        var didCallHandler = false
        let listener = NotificationListener(notificationName: notificationName, object: notificationPoster) { (notification) -> () in
            XCTAssertEqual(notification.name, notificationName, "Notification names should match")
            didCallHandler = true
        }
        
        // WHEN: the notification is posted, but *not* from the specific object
        NSNotificationCenter.defaultCenter().postNotificationName(notificationName, object: nil)
        
        // THEN: the handler closure is not called
        XCTAssertFalse(didCallHandler)
    }
    
    func testNotificationListenerDeinitStopListening() {
        
        // GIVEN: a notification name and a listener
        let notificationName = "MyCustomNotification"
        
        var listener: NotificationListener? = nil
        
        var didCallHandler = false
        
        listener = NotificationListener(notificationName: notificationName) { (notification) -> () in
            didCallHandler = true
        }
        
        listener = nil
        
        // WHEN: the notification is posted after the listen has been dealloc'd
        NSNotificationCenter.defaultCenter().postNotificationName(notificationName, object: nil)
        
        // THEN: the handler closure is not called
        XCTAssertFalse(didCallHandler)
    }
}
