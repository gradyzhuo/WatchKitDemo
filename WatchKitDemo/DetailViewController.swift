//
//  DetailViewController.swift
//  WatchKitDemo
//
//  Created by Grady Zhuo on 4/25/15.
//  Copyright (c) 2015 Grady Zhuo. All rights reserved.
//

import UIKit
import GZNotificationCenter

class DetailViewController: UIViewController {
    
    var note:Note?
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var descriptionLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.titleLabel.text = self.note?.title
        self.descriptionLabel.text = self.note?.description
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func showInWatch(sender:AnyObject){
        
        let userDefaults = NSUserDefaults.sharedGroupUserDefaults()
        userDefaults.setObject(note?.convertToDataDict(), forKey: "ShowToWatch")
        GZNotificationCenter.defaultCenter().postNotification(name: "ShowToWatch")
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
