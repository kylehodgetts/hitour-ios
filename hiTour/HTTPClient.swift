//
//  HTTPClient.swift
//  hiTour
//
//  Created by Adam Chlupacek on 19/02/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation

typealias DataTaskResult = (NSData?, NSURLResponse?, NSError?) -> Void

///
/// The protocol that any of the URLsessions have to comfort, in case mockup of the session is needed
///
protocol URLSessionProtocol {
    ///
    /// Creates a task that at some point retrieves a data from given url, then the completetion hanler is called
    ///
    /// Parameters:
    ///  - url: The url where the request is being made
    ///  - completetionHandler: A closure that is called once the request is finished
    ///
    func dataTaskWithURL(url: NSURL, completionHandler: DataTaskResult) -> NSURLSessionDataTask
    
    ///
    /// Used to tear down the session, new requests cannot be made, but the current will be finished
    ///
    func finishTasksAndInvalidate() -> Void
}

///
/// A wrap for URLSession, with some base url, used to abstract the calls onto the session
///
class HTTPClient {
    private let session: URLSessionProtocol
    private let baseUrl: String
    
    init(session: URLSessionProtocol = NSURLSession.sharedSession(), baseUrl: String) {
        self.session = session
        self.baseUrl = baseUrl
    }
    
    ///
    /// Makes a request to given url, once it finishes the calls a callback closure that has the results of this request as 
    /// an array of dictionaries of String -> AnyObject
    ///
    /// Parameters:
    ///  - url: The end of the url that is appended to the base url of the HTTPClient, should not contain the preceding /
    ///  - cb:  The callback that is called once the request is finished and parsed
    ///
    func request(url: String, cb: ([[String: AnyObject]]) -> Void, onResponse: (NSURLResponse -> Void)? = nil) -> Void {
        let nsURL = NSURL(string: baseUrl + "/\(url)")!
        let task = self.session.dataTaskWithURL(
            nsURL
            , completionHandler: { (data, response, error) -> Void in
                _ = onResponse.map({f in response.map(f)})
                if let er = error {
                    print(er)
                    cb([])
                    return
                }
                //TODO: error handling and such
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? [[String: AnyObject]]
                    guard let ret = json else {
                        return
                    }
                    cb(ret)
                } catch {
                    fatalError("Could not perform the a request to: \(nsURL) due to: \(error)")
                }
        })
        task.resume()
    }

    func requestObject(
        url: String
        , onResponse: (NSURLResponse? -> Bool) = {(a:NSURLResponse?) -> Bool in return true}
        , onError: (() -> Void)? = nil
        , onParseFail: (() -> Void)? = nil //HERE just because of how we are returning the data now..., the onResponse should work properly once we fix the statusCOdes of our reply messages, ie getting 401 for wrong SessionKey
        ,cb: ([String: AnyObject]
        ) -> Void) -> Void {
        let nsURL = NSURL(string: baseUrl + "/\(url)")!
        let task = self.session.dataTaskWithURL(
            nsURL
            , completionHandler: { (data, response, error) -> Void in
                if let er = error {
                    print(er)
                    _ = onError.map({$0()})
                    return
                }
                if (onResponse(response)) {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? [String: AnyObject]
                        guard let ret = json else {
                            return
                        }
                        cb(ret)
                    } catch {
                        print("Could not perform the a request to: \(nsURL) due to: \(error)")
                        _ = onParseFail.map({$0()})
                    }
                }
            })
        task.resume()
    }
    
    func binaryReques(fullUrl: String, cb:(NSData?) -> Void) -> Void {
        let nsURL = NSURL(string: fullUrl)!
        let task = self.session.dataTaskWithURL(nsURL, completionHandler:{ (data, response, error) -> Void in
            if let er = error {
                print(er)
                cb(nil)
                return
            }
            cb(data)
        })
        task.resume()
    }
    
    ///
    /// Tears down the HTTPClient
    ///
    func tearDown() -> Void {
        session.finishTasksAndInvalidate()
    }

}

///
/// Just a hack so that NSURLSession comforts the protocol, event though the metods are already implemented
///
extension NSURLSession: URLSessionProtocol {}
