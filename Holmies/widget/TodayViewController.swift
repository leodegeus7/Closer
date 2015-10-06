//
//  TodayViewController.swift
//  widget
//
//  Created by Leonardo Koppe Malanski on 30/09/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var widgetTimeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        widgetTimeLabel.text = "Still not sure"
        if let label = widgetTimeLabel {
           let defaults = NSUserDefaults(suiteName: "group.com.bepid.Holmies2.widget")
            if let timeString:String = defaults?.objectForKey("timeString") as? String {
                widgetTimeLabel?.text = "Your last ran the main app at: " + timeString
            }
        }
    
//        let timeString:String = (defaults?.objectForKey("timeString") as? String)!
//        widgetTimeLabel.text = "Your last ran the main app at: " + timeString
        
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData


        completionHandler(NCUpdateResult.NewData)
    }
    
}
