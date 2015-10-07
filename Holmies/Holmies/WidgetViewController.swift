//
//  WidgetViewController.swift
//  Holmies
//
//  Created by Leonardo Koppe Malanski on 29/09/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class WidgetViewController: UIViewController {
    var timeLabel: UILabel?
    var timer: NSTimer?
    let INTERVAL_SECONDS = 0.2
    var dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configurando o DateFormatter
        self.dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        //Criando label
        timeLabel = UILabel(frame: self.view.frame)
        updateTimeLabel(nil)
        timeLabel?.numberOfLines = 0
        timeLabel?.textAlignment = .Center
        timeLabel?.font = UIFont.systemFontOfSize(28.0)
        self.view.addSubview(timeLabel!)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(INTERVAL_SECONDS, target: self, selector: "updateTimeLabel:", userInfo: nil, repeats: true)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateTimeLabel(timer:NSTimer!) {
        if let label = timeLabel {
            let now = NSDate.init(timeIntervalSinceNow: 0)
            print("DateFormatter\(now)")
            let dateString = dateFormatter.stringFromDate(now)
            label.text = dateString
            
            let defaults = NSUserDefaults(suiteName: "group.com.bepid.Holmies2.widget")
            defaults?.setObject(dateString, forKey: "timeString")
            defaults?.synchronize()
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
