//
//  UIViewExtension.swift
//  Feed Me
//
//  Created by Ron Kliffer on 8/30/14.
//  Copyright (c) 2014 Ron Kliffer. All rights reserved.
//

import UIKit

extension UIView {
  
  func lock() {
    if let _ = viewWithTag(10) {
      //View is already locked
    }
    else {
      let lockView = UIView(frame: bounds)
      lockView.backgroundColor = UIColor(white: 0.0, alpha: 0.75)
      lockView.tag = 10
      lockView.alpha = 0.0
      let activity = UIActivityIndicatorView(activityIndicatorStyle: .White)
      activity.hidesWhenStopped = true
      activity.center = lockView.center
      lockView.addSubview(activity)
      activity.startAnimating()
      addSubview(lockView)
      
      UIView.animateWithDuration(0.2) {
        lockView.alpha = 1.0
      }
    }
  }
  
  func unlock() {
    if let lockView = self.viewWithTag(10) {
      UIView.animateWithDuration(0.2, animations: {
        lockView.alpha = 0.0
        }) { finished in
          lockView.removeFromSuperview()
      }
    }
  }
  
  func fadeOut(duration: NSTimeInterval) {
    UIView.animateWithDuration(duration) {
      self.alpha = 0.0
    }
  }
  
  func fadeIn(duration: NSTimeInterval) {
    UIView.animateWithDuration(duration) {
      self.alpha = 1.0
    }
  }

    
    func fadeIn(duration: NSTimeInterval, completion: (didComplete: Bool) -> Void ) {
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.alpha = 1.0
            })
            { (animationCompleted) -> Void in
                completion (didComplete: true)
        }
        
    }
    
    
    func fadeOut(duration: NSTimeInterval, completion: (didComplete: Bool) -> Void ) {
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.alpha = 0.0
            })
            { (animationCompleted) -> Void in
                completion (didComplete: true)
        }
        
    }
    
    
    
//    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
//        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
//        rotateAnimation.fromValue = 0.0
//        rotateAnimation.toValue = CGFloat(M_PI)
//        rotateAnimation.duration = duration
//        
//        
//        if let delegate: AnyObject = completionDelegate {
//            rotateAnimation.delegate = delegate
//        }
//        self.layer.addAnimation(rotateAnimation, forKey: nil)
//
//    }
//    
//    func rotateMinus360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
//        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
//        rotateAnimation.fromValue = 0.0
//        rotateAnimation.toValue = -(CGFloat(M_PI))
//        rotateAnimation.duration = duration
//        
//        
//        if let delegate: AnyObject = completionDelegate {
//            rotateAnimation.delegate = delegate
//        }
//        self.layer.addAnimation(rotateAnimation, forKey: nil)
//        
//    }
  
  class func viewFromNibName(name: String) -> UIView? {
    let views = NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil)
    return views.first as? UIView
  }
    
    
}
