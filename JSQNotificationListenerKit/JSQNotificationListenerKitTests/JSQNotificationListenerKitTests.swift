//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQNotificationListenerKit
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
        
        let listener = NotificationListener(name: notificationName) { (notification) -> () in
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
}
