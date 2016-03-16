//
//  DetailViewController.swift
//  hiTour
//
//  Created by Dominik Kulon & Charlie Baker on 16/03/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import MediaPlayer

///  View Controller in order to display the detail for a particular point in a tour.
///  This includes a title, description and dyanmic views to populate each peice of data content
///  for that particular point.
class DetailViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, UICollectionViewDelegateFlowLayout {
        
    ///  Reference variable to a point
    var point : Point?
    
    /// Reference to audience that this point if for
    var audience: Audience!
    
    ///  Reference variable to populate the point description text
    var textDetail: UITextView!
    
    ///  AVPlayer in order to play the data item's video
    var videoPlayers : [AVPlayer!] = []
    
    /// Array storing data for the current point.
    var pointData: [PointData] = []
    
    /// Reference to the collection view on the storyboard.
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// Reference to the flow layout on the storyboard.
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    /// Gesture recognizers for images and videos.
    var tapFullScreenGesture: UITapGestureRecognizer!
    
    /// Image dispalyed in a header.
    var imageDetail: UIImage!
    
    
    ///  Set's up and instantiates all of the views including setting the values for the point's
    ///  title, description and image
    ///  Calls the function to populate the view controller with its content data into the stackview
    override func viewDidLoad() {
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.registerNib(UINib(nibName: "ImageDataViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageDataViewCellId")
        collectionView!.registerNib(UINib(nibName: "TextDataViewCell", bundle: nil), forCellWithReuseIdentifier: "TextDataViewCellId")
        collectionView!.registerNib(UINib(nibName: "VideoDataViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoDataViewCellId")
        
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.headerReferenceSize.height = 200
        
        tapFullScreenGesture = UITapGestureRecognizer(target: self, action: Selector("recognizeTapOnCell:"))
        tapFullScreenGesture.delegate = self
        collectionView?.addGestureRecognizer(tapFullScreenGesture)

        guard let _ = point, _ = point!.data else {
            return
        }
        
        pointData = point!.getPointDataFor(audience)
    }
    
    /// Initialize cells with appropriate data for each data view.
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if(indexPath.row == 0) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TextDataViewCellId", forIndexPath: indexPath) as! TextDataViewCell
            
            cell.title.text = point!.name
            cell.dataDescription.text = point!.descriptionP
            cell.dataText.text = ""
            
            return cell
        }
        
        let url = pointData[indexPath.row - 1].data!.url!
       
        if url.containsString(".mp4") {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("VideoDataViewCellId", forIndexPath: indexPath) as! VideoDataViewCell
            
            cell.title.text = pointData[indexPath.row - 1].data!.title!
            cell.dataDescription.text = pointData[indexPath.row - 1].data!.descriptionD!
            addVideoContent(cell, dataId: "\(pointData[indexPath.row - 1].data!.dataId!)-\(audience.audienceId!)", data: pointData[indexPath.row - 1].data!.data!)
            
            return cell
        } else if url.containsString(".txt") {
        
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TextDataViewCellId", forIndexPath: indexPath) as! TextDataViewCell
            
            cell.title.text = pointData[indexPath.row - 1].data!.title!
            cell.dataDescription.text = pointData[indexPath.row - 1].data!.descriptionD!
            addTextContent(cell, url: url)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageDataViewCellId", forIndexPath: indexPath) as! ImageDataViewCell
            
            cell.title.text = pointData[indexPath.row - 1].data!.title!
            cell.dataDescription.text = pointData[indexPath.row - 1].data!.descriptionD!
            cell.imageView.image = UIImage(data: pointData[indexPath.row - 1].data!.data!)
            
            return cell
        }
    }
    
    /// Return the number of cells i.e. points for a given tour plus a tour description at the beginning.
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pointData.count + 1
    }
    
    /// Calculate dynamic height for each cell.
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if(indexPath.row == 0) {
            var height : CGFloat = 24 + calculateTextViewHeight(point!.name!)
            if let descriptionHeight = point!.descriptionP {
                height += calculateTextViewHeight(descriptionHeight)
            }
            return CGSizeMake(collectionView.frame.width, height)
        }
        
        var height : CGFloat = 300 + calculateTextViewHeight(pointData[indexPath.row - 1].data!.descriptionD!)
        let url = pointData[indexPath.row - 1].data!.url!

        if url.containsString(".txt") {
            height = 128
            do {
                let text = try String(contentsOfFile: url, encoding: NSUTF8StringEncoding)
                height += calculateTextViewHeight(text)
            } catch {
                print("Error reading text file resource")
            }
        }
        
        
        return CGSizeMake(collectionView.frame.width, height)
    }
    
    /// Initialize the header with an image.
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "CollectionHeader", forIndexPath: indexPath) as! CollectionHeader
        if let imageData = point!.data {
            headerView.headerImage.image = UIImage(data: imageData)
        }
        return headerView
    }
    
    /// Add text from the .txt file to a cell.
    func addTextContent(let cell: TextDataViewCell, url: String) {
        do {
            try cell.dataText.text = String(contentsOfFile: url, encoding: NSUTF8StringEncoding)
        } catch {
            cell.dataText.text = ""
            print("Error reading text file resource")
        }
    }
    
    /// Invoked by a gesture recognizer to display images in the full screen mode and show media controls for videos.
    func recognizeTapOnCell(recognizer: UIGestureRecognizer) {

        if recognizer.state == UIGestureRecognizerState.Ended {
            let location = recognizer.locationInView(self.collectionView)
            if let tappedIndexPath = collectionView.indexPathForItemAtPoint(location) {
                if let tappedCell = self.collectionView.cellForItemAtIndexPath(tappedIndexPath) as? ImageDataViewCell {
                    // Display the image in the full screen mode.
                    performSegueWithIdentifier("imageFullScreenSegue", sender: tappedCell.imageView)
                } else if let tappedCell = self.collectionView.cellForItemAtIndexPath(tappedIndexPath) as? VideoDataViewCell {
                    //  Handles a tap gesture to the video view controller display so that it shows or hides the
                    //  video player controls upon a tap.
                    if let playerController = tappedCell.playerController {
                        playerController.showsPlaybackControls = true
                    }
                }
            }
        }
    }
    
    ///  Function that adds to the stack view a video and sets up its constraints and tap gesture to display its controls.
    func addVideoContent(cell: VideoDataViewCell, dataId: String, data: NSData) {

        let tmpDirURL = NSURL.fileURLWithPath(NSTemporaryDirectory(), isDirectory: true)
        let fileURL = tmpDirURL.URLByAppendingPathComponent(dataId).URLByAppendingPathExtension("mp4")
        let checkValidation = NSFileManager.defaultManager()
        
        if !checkValidation.fileExistsAtPath(fileURL.absoluteString) {
            
            data.writeToURL(fileURL, atomically: true)
            let videoPlayer = AVPlayer(URL: fileURL)
            let playerController = AVPlayerViewController()
            playerController.videoGravity = AVLayerVideoGravityResizeAspect
            playerController.player = videoPlayer
            cell.playerController = playerController
            cell.videStackView.addArrangedSubview(playerController.view)
        
            videoPlayers.append(videoPlayer)
        }
    }
    
    ///  Prepares the view controller segue for when an image is tapped, the image displays full screen for the user to
    ///  zoom and pan the image. This function prepares the FullScreenImageViewController with the image that the user has tapped on.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "imageFullScreenSegue" {
            let destination = segue.destinationViewController as! FullScreenImageViewController
            let imageV = sender as! UIImageView
            destination.originalImageView = imageV
        }
    }
    
    /// Closes down the view by ensuring any videos that are playing are stopped when the view is dismissed
    override func viewDidDisappear(animated: Bool) {
        for video in videoPlayers {
            if video != nil && video.rate != 0 && video.error == nil {
                video.pause()
            }
        }
    }
    
    /// Calculate the height of a text view in a cell for a given text.
    func calculateTextViewHeight(text: String) -> CGFloat {
        let textView = UITextView()
        textView.scrollEnabled = false
        textView.text = text
        let fixedWidth = collectionView.frame.width * 0.8
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame;
        return textView.frame.height + 16
    }
}
