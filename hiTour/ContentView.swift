//
//  ContentView.swift
//  hiTour
//
//  Created by Charlie Baker on 27/02/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import MediaPlayer

class ContentView : UIView, UIGestureRecognizerDelegate {
    
    var stackView : UIStackView!
    
    var txtTitle : UITextView!
    var txtDescription : UITextView!
    var videoTap : UIButton!
    var videoPlayer : AVPlayer!
    var playerController : AVPlayerViewController!
    var txtText : UITextView!
    var imageView : UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        txtTitle = UITextView()
        txtDescription = UITextView()
        stackView = UIStackView()
        txtText = UITextView()
        imageView = UIImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func populateView(url: String, titleText: String, descriptionText: String) {
        
        stackView.bounds = self.bounds
        stackView.frame = stackView.bounds
        stackView.axis = UILayoutConstraintAxis.Vertical
        stackView.alignment = UIStackViewAlignment.Fill
        stackView.spacing = 0
        self.addSubview(stackView)
        
        addTitle(titleText)
        addDescription(descriptionText)
        
        if url.containsString(".mp4") {
            addVideoContent(url)
        }
        else if url.containsString(".txt"){
            addTextContent(url)
        }
        else {
            addImageContent(url)
        }

    }
    
    func showVideoControls(sender: UITapGestureRecognizer? = nil) {
        playerController.showsPlaybackControls = true
    }
    
    func addVideoContent(url: String) {
        let nsUrl = NSURL(fileURLWithPath: url)
        videoPlayer = AVPlayer(URL: nsUrl)
        playerController = AVPlayerViewController()
        playerController.videoGravity = AVLayerVideoGravityResizeAspect
        playerController.player = videoPlayer
        playerController.view.heightAnchor.constraintEqualToConstant(playerController.view.frame.height).active = true
        playerController.view.widthAnchor.constraintEqualToConstant(playerController.view.frame.width).active = true
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("showVideoControls"))
        tap.delegate = self
        playerController.view.addGestureRecognizer(tap)
        
        stackView.addArrangedSubview(playerController.view)
    }
    
    func addTextContent(url: String) {
        do {
            try txtText.text = String(contentsOfFile: url, encoding: NSUTF8StringEncoding)
        }
        catch {
            print("Error reading text file resource")
        }
        txtText.editable = false
        txtText.widthAnchor.constraintEqualToConstant(txtText.contentSize.width).active = true
        txtText.heightAnchor.constraintEqualToConstant(txtText.contentSize.height + 250).active = true
        stackView.addArrangedSubview(txtText)
    }
    
    func addImageContent(url: String) {
        imageView.contentMode = .ScaleAspectFill
        imageView.image = UIImage(named: url)
        imageView.layoutIfNeeded()
        imageView.sizeToFit()
        imageView.heightAnchor.constraintEqualToConstant(imageView.frame.height).active = true
        imageView.widthAnchor.constraintEqualToConstant(imageView.frame.width).active = true
        stackView.addArrangedSubview(imageView)
    }
    
    func addTitle(titleText: String) {
        txtTitle.text = titleText
        txtTitle.editable = false
        txtTitle.scrollEnabled = false
        txtTitle.font = UIFont.boldSystemFontOfSize(16)
        stackView.addArrangedSubview(txtTitle)
        
        txtTitle.layoutIfNeeded()
        txtTitle.sizeToFit()
        txtTitle.heightAnchor.constraintEqualToConstant(txtTitle.contentSize.height).active = true
    }
    
    func addDescription(descriptionText: String) {
        txtDescription.text = descriptionText
        txtDescription.editable = false
        txtDescription.scrollEnabled = true
        
        stackView.addArrangedSubview(txtDescription)
        txtDescription.sizeToFit()
        
        txtDescription.widthAnchor.constraintEqualToConstant(txtDescription.bounds.width).active = true
        txtDescription.heightAnchor.constraintEqualToConstant(txtDescription.bounds.height + 20).active = true

    }
    
}
