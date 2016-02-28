//
//  DetailViewController.swift
//  hiTour
//
//  Created by Dominik Kulon on 23/02/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation

import UIKit

class DetailViewController : UIViewController {
    
    var prototypeData : PrototypeDatum!
    
    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var titleDetail: UILabel!
    @IBOutlet weak var textDetail: UITextView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.imageDetail!.image = UIImage(named: prototypeData.imageName)
        //self.imageDetail!.contentMode = .ScaleAspectFill
        self.imageDetail!.autoresizingMask = UIViewAutoresizing.FlexibleWidth
            
        self.titleDetail.text = prototypeData.title
        self.textDetail.text = prototypeData.description
    }
    
}