//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Leonardo Koppe Malanski on 18/11/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var compassImage: WKInterfaceImage!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        compassImage.setImage(<#T##image: UIImage?##UIImage?#>)
        
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
