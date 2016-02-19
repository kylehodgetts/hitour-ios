//
//  BarcodeScannerViewController.swift
//  hiTour
//
//  Created by Charlie Baker on 18/02/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import AVFoundation
import UIKit

class BarcodeScannerViewController : UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let session = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var identifiedBorder : DiscoveredBardCodeView?
    var timer : NSTimer!
    
    
    // MARK: Initialiser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do
        {
            let inputDevice = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(inputDevice)
        }
        catch
        {
            print("Error With Input Device")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        addPreviewLayer()
        
        identifiedBorder = DiscoveredBardCodeView(frame: self.view.bounds)
        identifiedBorder?.backgroundColor = UIColor.clearColor()
        identifiedBorder?.hidden = true
        self.view.addSubview(identifiedBorder!)
        
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.startRunning()
        
    }
    
    // MARK: Overrides
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        session.stopRunning()
    }

    
    // MARK: Actions
    
    func addPreviewLayer()
    {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer?.bounds = self.view.bounds
        previewLayer?.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))
        self.view.layer.addSublayer(previewLayer!)
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
                self.identifiedBorder?.hidden = false
                
                let alertView = UIAlertController()
                alertView.title = "Result"
                alertView.message = unwraped.stringValue
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                    action in alertView.dismissViewControllerAnimated(true, completion: nil)
                    self.startTimer()
                    self.session.startRunning()
                }
                alertView.addAction(okAction)
                presentViewController(alertView, animated: true, completion: nil)
                
                session.stopRunning()
            }
        }
    }

    
    
    
}
