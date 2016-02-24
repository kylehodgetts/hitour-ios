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
        self.imageDetail!.contentMode = .ScaleAspectFill

        self.titleDetail.text = prototypeData.title
        self.textDetail.text = prototypeData.description
        
        self.tabBarController?.tabBar.hidden = true
        
        self.view.setNeedsUpdateConstraints()
        self.view.layoutIfNeeded()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
}