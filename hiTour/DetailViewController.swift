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
    var textDetail: UITextView!

    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var titleDetail: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        textDetail = UITextView()
        textDetail.editable = false
        textDetail.scrollEnabled = false
        textDetail.setNeedsLayout()
        
        stackView.addArrangedSubview(textDetail)
        
        self.imageDetail!.image = UIImage(named: prototypeData.imageName)
        self.imageDetail!.contentMode = .ScaleAspectFill

        self.titleDetail.text = prototypeData.title
        self.textDetail.text = prototypeData.description
        
        var contentItem :ContentView!
        let path = NSBundle.mainBundle().pathForResource("ctscan", ofType: "mp4")
        
        contentItem = ContentView(frame: CGRect (x: 0, y: 0, width: self.view.bounds.width, height: 350))
        contentItem.populateView(path!, titleText: prototypeData.title, descriptionText: "An example of an image being dynamically put here")
        contentItem.heightAnchor.constraintEqualToConstant(300).active = true
        contentItem.widthAnchor.constraintEqualToConstant(300).active = true
        
        stackView.addArrangedSubview(contentItem)
        
        var contentItem2 : ContentView!
        let path2 = NSBundle.mainBundle().pathForResource("prototype", ofType: "txt")
        contentItem2 = ContentView(frame: CGRect (x: 0, y: 0, width: self.view.bounds.width, height: 350))
        contentItem2.populateView(path2!, titleText: "Text Title", descriptionText: "An example of text")
        contentItem2.heightAnchor.constraintEqualToConstant(300).active = true
        contentItem2.widthAnchor.constraintEqualToConstant(300).active = true

        stackView.addArrangedSubview(contentItem2)


    }
        
}
