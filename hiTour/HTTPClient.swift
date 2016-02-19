//
//  HTTPClient.swift
//  hiTour
//
//  Created by Adam Chlupacek on 19/02/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation

typealias DataTaskResult = (NSData?, NSURLResponse?, NSError?) -> Void

protocol URLSessionProtocol {
    func dataTaskWithURL(url: NSURL, completionHandler: DataTaskResult)
        -> NSURLSessionDataTask
    
    func finishTasksAndInvalidate() -> Void
}

class HTTPClient {
    private let session: URLSessionProtocol
    private let baseUrl: String
    
    init(session: URLSessionProtocol = NSURLSession.sharedSession(), baseUrl: String) {
        self.session = session
        self.baseUrl = baseUrl
    }
    
    func request(url: String, cb: ([[String: AnyObject]]) -> Void) -> Void {
        let nsURL = NSURL(string: baseUrl + "/\(url)")!
        let task = self.session.dataTaskWithURL(
            nsURL
            , completionHandler: { (data, response, error) -> Void in
                //TODO: error handling and such
                do {
                    print(error)
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? [[String: AnyObject]]
                    guard let ret = json else {
                        return
                    }
                    cb(ret)
                } catch {
                    //TODO: ^^ error handling
                    fatalError("DETH TO all... :D \(error)")
                }
        })
        task.resume()
    }
    
    func tearDown() -> Void {
        session.finishTasksAndInvalidate()
    }

}

extension NSURLSession: URLSessionProtocol {}
