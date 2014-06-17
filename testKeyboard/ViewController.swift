//
//  ViewController.swift
//  testKeyboard
//
//  Created by Francesco Frison on 6/17/14.
//  Copyright (c) 2014 Yammer-inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var textField : UITextField?
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textField!.backgroundColor = UIColor.redColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

