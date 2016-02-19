//
//  ViewController.swift
//  hiTour
//
//  Created by Kyle Hodgetts on 15/02/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var scanButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func scanBarcode(sender: UIButton) {
        let scanViewController = BarcodeScannerViewController()
        presentViewController(scanViewController, animated: true, completion: nil)
    }
}

