//
//  ViewController.swift
//  SSummary
//
//  Created by Javier Jara on 1/5/16.
//  Copyright © 2016 Roco Soft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if (!defaults.boolForKey("loadingOAuthToken")) {
            let helper = HTTPHelper()
            helper.loadInitialData()
        } else {
            print("currently Loading OAuth")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

