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
        
        var imageItem :ContentView!
        imageItem = ContentView(frame: CGRect (x: 0, y: 0, width: self.view.bounds.width, height: 250))
        imageItem.populateView(prototypeData.imageName, titleText: prototypeData.title, descriptionText: "An example of an image being dynamically put here")
        stackView.addArrangedSubview(imageItem)
    }
        
}