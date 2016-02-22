//
//  BarcodeScannerViewController.swift
//  hiTour
//
//  Created by Charlie Baker on 18/02/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import AVFoundation
import UIKit

class BarcodeScannerViewController : UIViewController, AVCaptureMetadataOutputObjectsDelegate, UITextFieldDelegate {
    
    let session = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var identifiedBorder : DiscoveredBardCodeView?
    var timer : NSTimer!
    var errorAlert : UIAlertController!
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var codeInputView: UIView!
    @IBOutlet weak var txtInput: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    
    // MARK: Initialiser
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do
        {
            let inputDevice = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(inputDevice)
            let output = AVCaptureMetadataOutput()
            session.addOutput(output)
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        }
        catch
        {
            print("Error With Input Device")
            errorAlert = UIAlertController()
            errorAlert.title = "Input Device Error"
            errorAlert.message = "There appears to be a problem with the camera. Please check the app has permission and try again"
            let errorAlertOkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) {
                action in self.errorAlert.dismissViewControllerAnimated(true, completion: nil)
            }
            errorAlert.addAction(errorAlertOkAction)
        }
    }
    
    // MARK: Overrides
    
    override func viewDidAppear(animated: Bool) {
        addPreviewLayer()
        self.view.bringSubviewToFront(codeInputView)
        session.startRunning()
        txtInput.delegate = self
        
        if errorAlert != nil {
            errorAlert.popoverPresentationController?.sourceView = self.cameraView
            errorAlert.popoverPresentationController?.sourceRect = self.cameraView.frame
            self.presentViewController(errorAlert, animated: true, completion: nil)
        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        session.stopRunning()
    }
    
    
    // MARK: Actions
    
    func addPreviewLayer()
    {
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
    
    
    func translatePoints(points: [AnyObject], fromView: UIView, toView: UIView) -> [CGPoint]
    {
        var translatedPoints : [CGPoint] = []
        for point in points
        {
            let dict = point as! NSDictionary
            let x = CGFloat((dict.objectForKey("X") as! NSNumber).floatValue)
            let y = CGFloat((dict.objectForKey("Y") as! NSNumber).floatValue)
            let curr = CGPointMake(x, y)
            let currFinal = fromView.convertPoint(curr, toView: toView)
            translatedPoints.append(currFinal)
        }
        return translatedPoints
    }
    
    func startTimer()
    {
        if timer?.valid != true
        {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "removeBorder", userInfo: nil, repeats: false)
        }
        else
        {
            timer?.invalidate()
        }
    }
    
    func removeBorder()
    {
        self.identifiedBorder?.hidden = true
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!)
    {
        for data in metadataObjects
        {
            let metaData = data as! AVMetadataObject
            let transformed = previewLayer?.transformedMetadataObjectForMetadataObject(metaData) as? AVMetadataMachineReadableCodeObject
            
            if let unwraped = transformed
            {
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

    @IBAction func textInputDone(sender: UITextField)
    {
        sender.resignFirstResponder()
    }
    
    @IBAction func returnSwipeToPreviousView(sender: UISwipeGestureRecognizer)
    {
        performSegueWithIdentifier("returnToViewController", sender: self)
    }
    
    
}
