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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        txtTitle = UITextView()
        txtDescription = UITextView()
        stackView = UIStackView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func populateView(url: String, titleText: String, descriptionText: String) {
        
        stackView.bounds = self.bounds
        stackView.frame = stackView.bounds
        stackView.axis = UILayoutConstraintAxis.Vertical
        stackView.alignment = UIStackViewAlignment.Fill
        stackView.spacing = 5
        self.addSubview(stackView)
        
        if url.containsString(".mp4") {
            let nsUrl = NSURL(fileURLWithPath: url)
            videoPlayer = AVPlayer(URL: nsUrl)
            playerController = AVPlayerViewController()
            playerController.videoGravity = AVLayerVideoGravityResizeAspect
            playerController.player = videoPlayer
            playerController.view.heightAnchor.constraintEqualToConstant(150).active = true
            playerController.view.widthAnchor.constraintEqualToConstant(150).active = true
            
            let tap = UITapGestureRecognizer(target: self, action: Selector("showVideoControls"))
            tap.delegate = self
            playerController.view.addGestureRecognizer(tap)

            stackView.addArrangedSubview(playerController.view)
        }
        else if url.containsString(".jpg") {
            let imageView = UIImageView()
            imageView.contentMode = .ScaleAspectFit
            imageView.image = UIImage(named: url)
            imageView.heightAnchor.constraintEqualToConstant(150).active = true
            imageView.widthAnchor.constraintEqualToConstant(150).active = true
            stackView.addArrangedSubview(imageView)
        }
        else if url.containsString(".txt"){
            let txtText = UITextView()
            do {
                try txtText.text = String(contentsOfFile: url, encoding: NSUTF8StringEncoding)
            }
            catch {
                print("Error reading text file resource")
            }
            txtText.editable = false
            txtText.scrollEnabled = false
            txtText.sizeToFit()
            txtText.heightAnchor.constraintEqualToConstant(txtText.frame.height).active = true
            txtText.widthAnchor.constraintEqualToConstant(txtText.frame.width).active = true
            stackView.addArrangedSubview(txtText)
        }
        
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
    
    func showVideoControls(sender: UITapGestureRecognizer? = nil) {
        playerController.showsPlaybackControls = true
    }
    
}
