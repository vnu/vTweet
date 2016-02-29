//
//  HamburgerViewController.swift
//  vTweetz
//
//  Created by Vinu Charanya on 2/28/16.
//  Copyright © 2016 vnu. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    var originalLeftMargin: CGFloat!
    
    var menuViewController: UIViewController!{
        didSet{
            view.layoutIfNeeded()
            menuView.addSubview(self.menuViewController.view)
        }
    }
    
    var contentViewController: UIViewController!{
        didSet(oldContentViewController){
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                oldContentViewController.willMoveToParentViewController(nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMoveToParentViewController(nil)
            }
            contentViewController.willMoveToParentViewController(self)
            contentView.addSubview(self.contentViewController.view)
            contentViewController.didMoveToParentViewController(self)
            menuViewChange(0)
        }
    }
    
    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began{
            originalLeftMargin = leftMarginConstraint.constant
        }else if sender.state == UIGestureRecognizerState.Changed{
            leftMarginConstraint.constant = originalLeftMargin + translation.x
        }else if sender.state == UIGestureRecognizerState.Ended{
            if velocity.x > 0{
               menuViewChange(self.view.frame.size.width - 80)
            }else{
                menuViewChange(0)
            }
        }
    }
    
    func menuViewChange(value: CGFloat){
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.leftMarginConstraint.constant = value
            self.view.layoutIfNeeded()
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
    }
    
    func setupMenu(){
        let vStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let menuController = vStoryboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        menuController.hamburgerViewController = self
        self.menuViewController = menuController

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
