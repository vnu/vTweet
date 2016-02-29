//
//  MenuViewController.swift
//  vTweetz
//
//  Created by Vinu Charanya on 2/28/16.
//  Copyright © 2016 vnu. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    private var homeNavigationController: UIViewController!
    private var profileNavigationController: UIViewController!
    private var mentionsNavigationController: UIViewController!
    
    var viewControllers:[UIViewController] = []
    
    var hamburgerViewController: HamburgerViewController!
    
    
    @IBOutlet weak var menuTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initControllers()
    }
    
    func initControllers(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        homeNavigationController = storyBoard.instantiateViewControllerWithIdentifier("HomeNavigationController")
        mentionsNavigationController = storyBoard.instantiateViewControllerWithIdentifier("TimelineController")
        profileNavigationController = storyBoard.instantiateViewControllerWithIdentifier("ProfileNavigationController")
        viewControllers.append(homeNavigationController)
        viewControllers.append(mentionsNavigationController)
        viewControllers.append(profileNavigationController)
        hamburgerViewController.contentViewController = homeNavigationController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MenuViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.vnu.MenuCell",forIndexPath: indexPath) as! MenuCell
        let titles = ["Home", "Mentions", "Profile"]
        cell.menuLabel.text = titles[indexPath.row]
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }
    

}
