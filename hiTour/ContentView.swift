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

//  Custom UIView class that is used to populate a content data item for a particular point
//  that normally consists of either a video, image or text along with its title and description.
//  This view can place the relevant media content.
class ContentView : UIView, UIGestureRecognizerDelegate {
    
    //  Stackview to display the items vertically in the right order
    var stackView : UIStackView!
    
    //  Textview to display the data item's title
    var txtTitle : UITextView!
    
    //  Textview to display the data item's description
    var txtDescription : UITextView!
    
    //  AVPlayer in order to play the data item's video
    var videoPlayer : AVPlayer!
    
    //  Video Player View Controller to handle the view and controls for the user to play the video
    var playerController : AVPlayerViewController!
    
    //  TextView to hold the data item's text should there not be a video or image
    var txtText : UITextView!
    
    //  ImageView to display the data item's image
    var imageView : UIImageView!
    
    //  Reference to the view controller that is instantiating this content view
    var presentingViewController : DetailViewController!
    
    
    //  View initializer that constructs and initializes the views
    override init(frame: CGRect) {
        super.init(frame: frame)
        txtTitle = UITextView()
        txtDescription = UITextView()
        stackView = UIStackView()
        txtText = UITextView()
        imageView = UIImageView()
    }
    
    //  Required initializer by the super parent class
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //  Function that populates the views with their respective data and decides on the correct
    //  media type views to use e.g. video, image or just text.
    func populateView(data: NSData, titleText: String, descriptionText: String, url: String, dataId: String) {
        
        stackView.bounds = self.bounds
        stackView.frame = stackView.bounds
        stackView.axis = UILayoutConstraintAxis.Vertical
        stackView.alignment = UIStackViewAlignment.Fill
        stackView.spacing = 0
        self.addSubview(stackView)
        
        addTitle(titleText)
        addDescription(descriptionText)
        
        if url.containsString(".mp4") {
            addVideoContent(dataId, data: data)
        }
        else if url.containsString(".txt"){
            addTextContent(url) //FIXME? why does this even exist? only binary files will be added this way, rest is description?
        }
        else {
            addImageContent(data)
        }

    }
    
    //  Function that handles a tap gesture to the video view controller display so that it shows or hides the
    //  video player controls upon a tap.
    func showVideoControls(sender: UITapGestureRecognizer? = nil) {
        playerController.showsPlaybackControls = true
    }
    
    //  Function that adds to the stack view a video and sets up its constraints and tap gesture to display its controls.
    func addVideoContent(dataId: String, data: NSData) {
        let tmpDirURL = NSURL.fileURLWithPath(NSTemporaryDirectory(), isDirectory: true)
        let fileURL = tmpDirURL.URLByAppendingPathComponent(dataId).URLByAppendingPathExtension("mp4")
        let checkValidation = NSFileManager.defaultManager()
        
        if !checkValidation.fileExistsAtPath(fileURL.absoluteString) {
            data.writeToURL(fileURL, atomically: true)
        }

        videoPlayer = AVPlayer(URL: fileURL)
        playerController = AVPlayerViewController()
        playerController.videoGravity = AVLayerVideoGravityResizeAspect
        playerController.player = videoPlayer
        stackView.addArrangedSubview(playerController.view)
        playerController.view.heightAnchor.constraintEqualToConstant(playerController.view.frame.height).active = true
        playerController.view.widthAnchor.constraintEqualToConstant(playerController.view.frame.width).active = true
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("showVideoControls"))
        tap.delegate = self
        playerController.view.addGestureRecognizer(tap)
    }
    
    //  Function that adds text content to the stack view from a file.
    func addTextContent(url: String) {
        do {
            try txtText.text = String(contentsOfFile: url, encoding: NSUTF8StringEncoding)
        }
        catch {
            print("Error reading text file resource")
        }
        txtText.editable = false
        txtTitle.selectable = false
        txtText.widthAnchor.constraintEqualToConstant(txtText.contentSize.width).active = true
        txtText.heightAnchor.constraintEqualToConstant(txtText.contentSize.height + 250).active = true
        stackView.addArrangedSubview(txtText)
    }
    
    //  Function that adds an image to the stackview from its url resource.
    func addImageContent(data: NSData) {
        imageView.contentMode = .ScaleAspectFill
        imageView.image = UIImage(data: data)
        imageView.layoutIfNeeded()
        imageView.sizeToFit()
        imageView.userInteractionEnabled = true
        imageView.heightAnchor.constraintEqualToConstant(imageView.frame.height).active = true
        imageView.widthAnchor.constraintEqualToConstant(imageView.frame.width).active = true
        
        let tapFullScreenGesture = UITapGestureRecognizer(target: self, action: Selector("displayImageFullScreen"))
        tapFullScreenGesture.delegate = self
        imageView.addGestureRecognizer(tapFullScreenGesture)
        
        stackView.addArrangedSubview(imageView)
    }
    
    //  Function that adds and populates the title of the data item to the stack view
    func addTitle(titleText: String) {
        txtTitle.text = titleText
        txtTitle.editable = false
        txtTitle.selectable = false
        txtTitle.scrollEnabled = false
        txtTitle.font = UIFont.boldSystemFontOfSize(16)
        stackView.addArrangedSubview(txtTitle)
        
        txtTitle.layoutIfNeeded()
        txtTitle.sizeToFit()
        txtTitle.heightAnchor.constraintEqualToConstant(txtTitle.contentSize.height).active = true
    }
    
    //  Function that adds and populates a description to the stackview of the item data
    func addDescription(descriptionText: String) {
        txtDescription.text = descriptionText
        txtDescription.editable = false
        txtDescription.scrollEnabled = true
        txtDescription.selectable = false
        
        stackView.addArrangedSubview(txtDescription)
        txtDescription.sizeToFit()
        
        txtDescription.widthAnchor.constraintEqualToConstant(txtDescription.bounds.width).active = true
        txtDescription.heightAnchor.constraintEqualToConstant(txtDescription.contentSize.height + 10).active = true
    }
    
    //  Function that handles when an image is tapped so that it is presented full screen by performing a segue to the 
    //  FullScreenImageViewController
    func displayImageFullScreen() {
        presentingViewController.performSegueWithIdentifier("imageFullScreenSegue", sender: imageView)
    }
    
}
