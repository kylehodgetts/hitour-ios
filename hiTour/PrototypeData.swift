//
//  PrototypeData.swift
//  hiTour
//
//  Created by Dominik Kulon on 22/02/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation

struct PrototypeDatum {
    let title: String
    let description: String
    let imageName: String
    
    static let TitleKey = "TitleKey"
    static let DescriptionKey = "DescriptionKey"
    static let ImageNameKey = "ImageNameKey"
    
    init(dictionary: [String : String]) {
        self.title = dictionary[PrototypeDatum.TitleKey]!
        self.description = dictionary[PrototypeDatum.DescriptionKey]!
        self.imageName = dictionary[PrototypeDatum.ImageNameKey]!
    }
}

extension PrototypeDatum {
    
    static var getAllData: [PrototypeDatum] {
        var data = [PrototypeDatum]()
        
        for datum in localPrototypeData() {
            data.append(PrototypeDatum(dictionary: datum))
        }
        
        return data
    }
    
    static func localPrototypeData() -> [[String: String]] {
        return [
            [PrototypeDatum.TitleKey : "Computed tomography", PrototypeDatum.DescriptionKey : "Computed tomography (CT) is a diagnostic imaging test used to create detailed images of internal organs, bones, soft tissue and blood vessels. \n\nThe cross-sectional images generated during a CT scan can be reformatted in multiple planes, and can even generate three-dimensional images which can be viewed on a computer monitor, printed on film or transferred to electronic media. \n\nCT scanning is often the best method for detecting many different cancers since the images allow your doctor to confirm the presence of a tumor and determine its size and location. CT is fast, painless, noninvasive and accurate. In emergency cases, it can reveal internal injuries and bleeding quickly enough to help save lives.",
                PrototypeDatum.ImageNameKey : "ctscan"],
            [PrototypeDatum.TitleKey : "Fluoroscopy Suite", PrototypeDatum.DescriptionKey : "Fluoroscopy is a radiology technique that takes a real time \"movie\" of the body. A continuous X-ray beam is passed through the body part being examined and is transmitted to a TV-like monitor so that the body part and its motion can be seen in detail.",
                PrototypeDatum.ImageNameKey : "fluoroscopy"],
            [PrototypeDatum.TitleKey: "Magnetic Resonance Imaging Scanner", PrototypeDatum.DescriptionKey : "Magnetic resonance imaging (MRI) is a noninvasive medical test that physicians use to diagnose and treat medical conditions. MRI uses a powerful magnetic field, radio frequency pulses and a computer to produce detailed pictures of organs, soft tissues, bone and virtually all other internal body structures. MRI does not use ionizing radiation (x-rays). \n\nDetailed MR images allow physicians to evaluate various parts of the body and determine the presence of certain diseases. The images can then be examined on a computer monitor, transmitted electronically, printed or copied to a CD.",
                PrototypeDatum.ImageNameKey : "mri"],
            [PrototypeDatum.TitleKey: "Ultrasound scan", PrototypeDatum.DescriptionKey : "An ultrasound scan, sometimes called a sonogram, is a procedure that uses high-frequency sound waves to create an image of part of the inside of the body.",
                PrototypeDatum.ImageNameKey : "ultrasound"]
        ]
    }
}



