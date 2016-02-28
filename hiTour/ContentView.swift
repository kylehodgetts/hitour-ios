//
//  ContentView.swift
//  hiTour
//
//  Created by Charlie Baker on 27/02/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import UIKit

class ContentView : UIView {
    
    var stackView : UIStackView!
    
    var imageView : UIImageView!
    var txtTitle : UITextView!
    var txtDescription : UITextView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        txtTitle = UITextView()
        txtDescription = UITextView()
        stackView = UIStackView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func populateView(imageKey: String, titleText: String, descriptionText: String) {
        
        stackView.bounds = self.bounds
        stackView.frame = stackView.bounds
        stackView.axis = UILayoutConstraintAxis.Vertical
        stackView.alignment = UIStackViewAlignment.Fill
        stackView.spacing = 5
        self.addSubview(stackView)
        
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage(named: imageKey)
        imageView.heightAnchor.constraintEqualToConstant(150).active = true
        imageView.widthAnchor.constraintEqualToConstant(150).active = true
        stackView.addArrangedSubview(imageView)
        
        txtTitle.text = titleText
        txtTitle.editable = false
        txtTitle.scrollEnabled = false
        txtTitle.font = UIFont.boldSystemFontOfSize(16)
        txtTitle.sizeToFit()
        stackView.addArrangedSubview(txtTitle)
        
        txtDescription.text = descriptionText
        txtDescription.editable = false
        txtDescription.scrollEnabled = true
        txtDescription.sizeToFit()
        stackView.addArrangedSubview(txtDescription)
        
        self.sizeToFit()
        
    }
    
}
