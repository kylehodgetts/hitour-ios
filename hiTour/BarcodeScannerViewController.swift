//
//  BarcodeScannerViewController.swift
//  hiTour
//
//  Created by Charlie Baker on 18/02/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import AVFoundation
import UIKit

/// Delegate used to inform the TabBarController that a modal view has been dismissed on a tablet.
protocol BarcodeScannerDelegate: class {
    func didModalDismiss(sender: BarcodeScannerViewController)
    func didItemScan(tour: Tour, sender: BarcodeScannerViewController)
    func didPointScan(currentTour: Tour, startIndex: Int, sender: BarcodeScannerViewController)
}

/// Class that implements a QR Barcode Scanner within a UIView by using the device main camera.
/// Then inputs the results into the text field on the view.
class BarcodeScannerViewController : UIViewController, AVCaptureMetadataOutputObjectsDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    /// Capture session for receiving input from the camera */
    let session = AVCaptureSession()
    
    /// Video Preview layer to provide a live video camera feevaro the view */
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    /// View that provides a red rectangle when a QR code has been discovered */
    var identifiedBorder : DiscoveredBardCodeView?
    
    /// Timer to remove the red rectangle after a small moment */
    var timer : NSTimer!
    
    /// Error Alert to be displayed */
    var errorAlert : UIAlertController!
    
    /// Reference to the Storyboards camera view */
    @IBOutlet weak var cameraView: UIView!
    
    /// Reference to the View containing the text field and button */
    @IBOutlet weak var codeInputView: UIView!
    
    /// Reference to the input text field */
    @IBOutlet weak var txtInput: UITextField!
    
    /// Reference to the delegate
    weak var delegate: BarcodeScannerDelegate?
    
    
    // MARK: Initialiser
    
    
    ///  Starts a new capture device session which only accepts QR codes as the output produced by the session
    ///  Handles error if the camera can't be accessed.
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
    
    
    /// When the view appears on the device, the preview layer is added and the input view brought forward.
    /// The capture session is started to start the live camera feed.
    override func viewDidAppear(animated: Bool) {
        addPreviewLayer()
        session.startRunning()
        txtInput.delegate = self
        
        if errorAlert != nil {
            errorAlert.popoverPresentationController?.sourceView = self.cameraView
            errorAlert.popoverPresentationController?.sourceRect = self.cameraView.frame
            self.presentViewController(errorAlert, animated: true, completion: nil)
        }
        
        let avConnection = self.previewLayer?.connection
        let statusBarOrientation = UIApplication.sharedApplication().statusBarOrientation
        
        if statusBarOrientation.isPortrait {
            avConnection?.videoOrientation = .Portrait
        }
        else if statusBarOrientation.isLandscape {
            avConnection?.videoOrientation = .LandscapeLeft
        }
    }
    
    
    ///  Stops the capture session when the view is no longer visible
    override func viewWillDisappear(animated: Bool) {
        session.stopRunning()
    }
    
    
    // MARK: Actions
    
    
    /// Sets up the video preview layer to handle the live camera feed and prepares the view to be displayed when a
    /// QR code has been discovered.
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
    
    
    ///  Translates the points for each received from the capture session by the camera.
    ///  - Returns: Array of CGPoint's
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
    
    
    ///  Starts the timer to remove the discovered red rectangle view around a found QR code when the session is to be started again.
    func startTimer() {
        if timer?.valid != true {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "removeBorder", userInfo: nil, repeats: false)
        }
        else {
            timer?.invalidate()
        }
    }
    
    
    /// Hides the discovered red rectangle from the view.
    func removeBorder() {
        self.identifiedBorder?.hidden = true
    }
    
    
    ///  When a QR code has been discovered puts the result into the textfield and stops the capture session.
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for data in metadataObjects {
            let metaData = data as! AVMetadataObject
            let transformed = previewLayer?.transformedMetadataObjectForMetadataObject(metaData) as? AVMetadataMachineReadableCodeObject
            
            if let unwraped = transformed {
                identifiedBorder?.frame = unwraped.bounds
                identifiedBorder?.hidden = false
                let identifiedCorners = self.translatePoints(unwraped.corners, fromView: self.view, toView: self.identifiedBorder!)
                identifiedBorder?.drawBorder(identifiedCorners)
                
                txtInput.text = unwraped.stringValue
                processInput(unwraped.stringValue)
                
                session.stopRunning()
            }
        }
    }

    
    ///  Closes the keyboard view when the user presses the done button on the keyboard
    @IBAction func textInputDone(sender: UITextField) {
        sender.resignFirstResponder()
        submit()
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
    
    /// Invoke a delegate when the view disappears on the tablet to toggle the segmented control.
    override func viewDidDisappear(animated: Bool) {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            delegate?.didModalDismiss(self)
        }
    }

    /// Dismiss a dialog after clicking the Cancel button.
    @IBAction func dismissDialog(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func submit() {
        if txtInput.text?.characters.count > 0 {
            processInput(txtInput.text!)
            txtInput.resignFirstResponder()
        }
    }
    
    func processInput(text: String){
        if(text.hasPrefix("SN")) {
            handleSessionScan(text.substringFromIndex(text.startIndex.advancedBy(2)))
        } else  if(text.hasPrefix("POINT-")){
            navigateToPoint(text.substringFromIndex(text.startIndex.advancedBy(6)))
        }
    
    }
    
    func handleSessionScan(session: String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate?
        let coreData = appDelegate?.getCoreData();
        let fetch = coreData?.fetch(name: Session.entityName, predicate: NSPredicate(format: "sessionCode = %@", session));
        var ses = fetch?.last as? Session
        if var _ = ses  { } else {
            ses = coreData?.insert(Session.entityName, callback: {entity, context in
                let s = Session(entity: entity, insertIntoManagedObjectContext: context);
                s.sessionCode = session;
                return s;
            }) as? Session
        }
        
        coreData?.saveMainContext();
        
        
        let overlay = UIView(frame: self.view.frame)
        let label = UILabel(frame: overlay.frame)
        label.text = "Updating, please wait..."
        label.center = overlay.center
        label.textAlignment = .Center
        overlay.addSubview(label)
        overlay.backgroundColor = UIColor.grayColor()
        overlay.alpha = 0.5
        tabBarController?.view.addSubview(overlay)
        
        appDelegate?.getApi()?.fetchTour(ses!, chain: {t in
            dispatch_async(dispatch_get_main_queue(), {
                if let tour = t {
                    coreData?.saveMainContext();
                    appDelegate?.setTour(tour)
                    if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                        self.delegate!.didItemScan(tour, sender: self)
                        overlay.removeFromSuperview()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.tabBarController?.selectedIndex = 0
                        let feedControlelr = self.tabBarController?.selectedViewController?.childViewControllers.first! as! FeedController
                        feedControlelr.assignTour(tour)
                        overlay.removeFromSuperview()
                    }
                } else {
                    let alertView = UIAlertController()
                    alertView.title = "Session invalid"
                    alertView.message = "The session key: \(session) is not valid"
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                        action in alertView.dismissViewControllerAnimated(true, completion: nil)
                        self.startTimer()
                        self.session.startRunning()
                    }
                    alertView.addAction(okAction)
                    self.presentViewController(alertView, animated: true, completion: nil)

                    overlay.removeFromSuperview()
                }
            });
        });
        
        
    }
    
    /// Checks if the point id received as input has already been discovered returning a boolean
    func isPointFound(pointId : String) -> PointTour! {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate?
        let currentTour = appDelegate?.getTour()
        // TODO: The app crashes if the tour was not explicitly selected from the collection view
        let currentTourPoints = currentTour?.pointTours?.array as! [PointTour]
        for tourPoint in currentTourPoints {
            if tourPoint.point?.valueForKey("pointId") as? Int == Int(pointId) {
                return tourPoint
            }
        }
        return nil
    }
    
    /// Finds an array of all the currently discovered points on the tour and returns a PointTour array
    func findDiscoveredPointIndex() -> [PointTour] {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let tour = delegate.getTour()
        let allPoints = tour?.pointTours?.array as! [PointTour]
        var discoveredPoints : [PointTour] = []
        for point in allPoints {
            if point.scanned == true {
                discoveredPoints.append(point)
            }
        }
        return discoveredPoints
    }
    
    /// Navigates to the detail view if the point id received as input is a valid point in the currently selected tour.
    /// Otherwise a Point Not Found dialog is displayed to the user
    func navigateToPoint(pointId : String) {

        if let pointFound = isPointFound(pointId) {
            if pointFound.scanned?.boolValue == false {
                pointFound.setValue(true.boolValue, forKey: "scanned")
            }
            
            (UIApplication.sharedApplication().delegate as! AppDelegate?)?.getCoreData().saveMainContext()
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate?
            let currentTour = appDelegate?.getTour()
            let startIndex = findDiscoveredPointIndex().indexOf(pointFound)
            
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                
                let pageView = self.storyboard!.instantiateViewControllerWithIdentifier("FeedPageViewController") as! FeedPageViewController
                
                pageView.points = currentTour?.pointTours?.array as! [PointTour]
                pageView.audience = currentTour?.audience
                pageView.startIndex = startIndex
                
                (self.tabBarController?.viewControllers?[0] as! UINavigationController).pushViewController(pageView, animated: true)
                self.tabBarController?.selectedIndex = 0
                
            } else {
                
                self.dismissViewControllerAnimated(true, completion: nil)
                delegate?.didPointScan(currentTour!, startIndex: startIndex!, sender: self)
            }
        }
        else {
            let alertView = UIAlertController()
            alertView.title = "Point Not Found"
            alertView.message = "Unable to find " + pointId + "\nPlease check and try again."
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                action in alertView.dismissViewControllerAnimated(true, completion: nil)
                self.startTimer()
                self.session.startRunning()
               
            }
            alertView.addAction(okAction)
            presentViewController(alertView, animated: true, completion: nil)
        }
        self.txtInput.text = ""
        self.identifiedBorder?.hidden = true
    }
    
}
