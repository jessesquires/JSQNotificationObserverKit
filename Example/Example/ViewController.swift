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

import UIKit
import JSQNotificationListenerKit

class ViewController: UIViewController {
    
    var listener: NotificationListener? = nil
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        listener = NotificationListener(notificationName: "CustomNotification", handler: { (notification) -> Void in
            // handle notification
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        listener = nil
    }
}

//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleNotification", name: "CustomNotification", object: nil)
//    }
//    
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: "CustomNotification", object: nil)
//    }
//    
//    private func handleNotification:(notif: NSNotification) {
//        // handle notification
//    }
//}
