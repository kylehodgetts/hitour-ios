//
//  BarcodeScannerViewController.swift
//  hiTour
//
//  Created by Charlie Baker on 18/02/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import AVFoundation
import UIKit

protocol BarcodeScannerDelegate: class {
    func didModalDismiss(sender: BarcodeScannerViewController)
}

// Class that implements a QR Barcode Scanner within a UIView by using the device main camera.
// Then inputs the results into the text field on the view.
class BarcodeScannerViewController : UIViewController, AVCaptureMetadataOutputObjectsDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    // Capture session for receiving input from the camera */
    let session = AVCaptureSession()
    
    // Video Preview layer to provide a live video camera feed to the view */
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    // View that provides a red rectangle when a QR code has been discovered */
    var identifiedBorder : DiscoveredBardCodeView?
    
    // Timer to remove the red rectangle after a small moment */
    var timer : NSTimer!
    
    // Error Alert to be displayed */
    var errorAlert : UIAlertController!
    
    // Reference to the Storyboards camera view */
    @IBOutlet weak var cameraView: UIView!
    
    // Reference to the View containing the text field and button */
    @IBOutlet weak var codeInputView: UIView!
    
    // Reference to the input text field */
    @IBOutlet weak var txtInput: UITextField!
    
    var tapBGGesture: UITapGestureRecognizer!
    
    weak var delegate: BarcodeScannerDelegate?
    
    
    // MARK: Initialiser
    
    
    //  Starts a new capture device session which only accepts QR codes as the output produced by the session
    //  Handles error if the camera can't be accessed.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            let inputDevice = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(inputDevice)
            let output = AVCaptureMetadataOutput()
            session.addOutput(output)
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        }
        catch {
            print("Error With Input Device")
            errorAlert = UIAlertController()
            errorAlert.title = "Input Device Error"
            errorAlert.message = "There appears to be a problem with the camera. Please check the app has permission and try again"
            let errorAlertOkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) {
                action in self.errorAlert.dismissViewControllerAnimated(true, completion: nil)
            }
            errorAlert.addAction(errorAlertOkAction)
        }
        
        // Notify when a keyboard appears/disappears from the screen.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: Overrides
    
    
    // When the view appears on the device, the preview layer is added and the input view brought forward.
    // The capture session is started to start the live camera feed.
    override func viewDidAppear(animated: Bool) {
        addPreviewLayer()
//        self.view.bringSubviewToFront(codeInputView)
        session.startRunning()
        txtInput.delegate = self
        
        if errorAlert != nil {
            errorAlert.popoverPresentationController?.sourceView = self.cameraView
            errorAlert.popoverPresentationController?.sourceRect = self.cameraView.frame
            self.presentViewController(errorAlert, animated: true, completion: nil)
        }
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            tapBGGesture = UITapGestureRecognizer(target: self, action: "settingsBGTapped:")
            tapBGGesture.delegate = self
            tapBGGesture.numberOfTapsRequired = 1
            tapBGGesture.cancelsTouchesInView = false
        
            self.view.window!.addGestureRecognizer(tapBGGesture)
        }
    }
    
    
    //  Stops the capture session when the view is no longer visible
    
    override func viewWillDisappear(animated: Bool) {
        session.stopRunning()
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.view.window!.removeGestureRecognizer(tapBGGesture)
        }
    }
    
    
    // MARK: Actions
    
    
    // Sets up the video preview layer to handle the live camera feed and prepares the view to be displayed when a
    // QR code has been discovered.
    func addPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer?.bounds = cameraView.bounds
        previewLayer?.position = CGPointMake(CGRectGetMidX(cameraView.bounds), CGRectGetMidY(cameraView.bounds))
        previewLayer?.frame = cameraView.bounds
        cameraView.layer.addSublayer(previewLayer!)
        previewLayer?.backgroundColor = UIColor.clearColor().CGColor
        previewLayer?.shadowColor = UIColor.clearColor().CGColor
        self.view.backgroundColor = UIColor.whiteColor()
        previewLayer?.opaque = false
        
        identifiedBorder = DiscoveredBardCodeView(frame: previewLayer!.bounds)
        identifiedBorder?.backgroundColor = UIColor.clearColor()
        identifiedBorder?.hidden = true
        self.view.addSubview(identifiedBorder!)
    }
    
    
    //  Translates the points for each received from the capture session by the camera.
    //  @return Array of CGPoint's
    func translatePoints(points: [AnyObject], fromView: UIView, toView: UIView) -> [CGPoint] {
        var translatedPoints : [CGPoint] = []
        for point in points {
            let dict = point as! NSDictionary
            let x = CGFloat((dict.objectForKey("X") as! NSNumber).floatValue)
            let y = CGFloat((dict.objectForKey("Y") as! NSNumber).floatValue)
            let curr = CGPointMake(x, y)
            let currFinal = fromView.convertPoint(curr, toView: toView)
            translatedPoints.append(currFinal)
        }
        return translatedPoints
    }
    
    
    //  Starts the timer to remove the discovered red rectangle view around a found QR code when the session is to be started again.
    func startTimer() {
        if timer?.valid != true {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "removeBorder", userInfo: nil, repeats: false)
        }
        else {
            timer?.invalidate()
        }
    }
    
    
    // Hides the discovered red rectangle from the view
    
    func removeBorder() {
        self.identifiedBorder?.hidden = true
    }
    
    
    //  When a QR code has been discovered puts the result into the textfield and stops the capture session.
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for data in metadataObjects {
            let metaData = data as! AVMetadataObject
            let transformed = previewLayer?.transformedMetadataObjectForMetadataObject(metaData) as? AVMetadataMachineReadableCodeObject
            
            if let unwraped = transformed {
                identifiedBorder?.frame = unwraped.bounds
                identifiedBorder?.hidden = false
                let identifiedCorners = self.translatePoints(unwraped.corners, fromView: self.view, toView: self.identifiedBorder!)
                identifiedBorder?.drawBorder(identifiedCorners)
                //self.identifiedBorder?.hidden = false
                
                txtInput.text = unwraped.stringValue
                
                let alertView = UIAlertController()
                alertView.title = "Result"
                alertView.message = unwraped.stringValue
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                    action in alertView.dismissViewControllerAnimated(true, completion: nil)
                    self.startTimer()
                    self.session.startRunning()
                    self.txtInput.text = ""
                }
                alertView.addAction(okAction)
                presentViewController(alertView, animated: true, completion: nil)
                
                session.stopRunning()
            }
        }
    }

    
    //  Closes the keyboard view when the user presses the done button on the keyboard
    @IBAction func textInputDone(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    /// Move the scanner up when the keyboard appears on the screen.
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    /// Adjust the scanner when the keyboard disappears from the screen.
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    func settingsBGTapped(sender: UITapGestureRecognizer){
        if sender.state == UIGestureRecognizerState.Ended{
            guard let presentedView = presentedViewController?.view else {
                return
            }
            
            if !CGRectContainsPoint(presentedView.bounds, sender.locationInView(presentedView)) {
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                })
            }
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func viewDidDisappear(animated: Bool) {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            delegate?.didModalDismiss(self)
        }
    }

    
}
