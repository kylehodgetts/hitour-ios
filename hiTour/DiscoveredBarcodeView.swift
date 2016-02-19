//
//  DiscoveredBarcodeView.swift
//  hiTour
//
//  Created by Charlie Baker on 19/02/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import UIKit

class DiscoveredBardCodeView : UIView {
    
    var borderLayer : CAShapeLayer?
    var corners : [CGPoint]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setMyView()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
    
    func drawBorder(points: [CGPoint])
    {
        self.corners = points
        let path = UIBezierPath()
        
        path.moveToPoint(points.first!)
        for(var i = 1; i < points.count; i++)
        {
            path.addLineToPoint(points[i])
        }
        path.addLineToPoint(points.first!)
        borderLayer?.path = path.CGPath
    }
    
    func setMyView()
    {
        borderLayer = CAShapeLayer()
        borderLayer?.strokeColor = UIColor.redColor().CGColor
        borderLayer?.lineWidth = 2.0
        borderLayer?.fillColor = UIColor.clearColor().CGColor
        self.layer.addSublayer(borderLayer!)
    }
    
}
