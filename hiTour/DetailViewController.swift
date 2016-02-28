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
    
    override func viewDidLoad() {
        
        textDetail = UITextView()
        textDetail.editable = false
        
        
        stackView.addArrangedSubview(textDetail)
        
        self.imageDetail!.image = UIImage(named: prototypeData.imageName)
        self.imageDetail!.contentMode = .ScaleAspectFill

        self.titleDetail.text = prototypeData.title
        self.textDetail.text = prototypeData.description
        textDetail.sizeToFit()
        textDetail.heightAnchor.constraintEqualToConstant(textDetail.contentSize.height + 100).active = true
        textDetail.widthAnchor.constraintEqualToConstant(textDetail.contentSize.width).active = true
        
        loadDynamicContent()
        
    }
    
    
    func loadDynamicContent() {
        let pointData = PrototypeDatum.getPointData(prototypeData.title)
        
        for item in pointData {
            let urlString = item[PrototypeDatum.DataURLKey]
            let urlFileName = (urlString! as NSString).substringToIndex(Int((urlString?.characters.count)!)-4)
            let urlFileExt = (urlString! as NSString).substringFromIndex(Int((urlString?.characters.count)!)-3)
            
            var contentItem :ContentView!
            let path : String!
            if urlFileExt != "jpg" {
                path = NSBundle.mainBundle().pathForResource(urlFileName, ofType: urlFileExt)
            }
            else {
                path = urlFileName
            }
            
            contentItem = ContentView(frame: CGRect (x: 0, y: 0, width: self.view.bounds.width, height: 350))
            contentItem.populateView(path!, titleText: item[PrototypeDatum.DataTitleKey]!, descriptionText: item[PrototypeDatum.DataDescriptionKey]!)
            contentItem.heightAnchor.constraintEqualToConstant(300).active = true
            contentItem.widthAnchor.constraintEqualToConstant(300).active = true
            
            stackView.addArrangedSubview(contentItem)
        }
        
    }
        
}
