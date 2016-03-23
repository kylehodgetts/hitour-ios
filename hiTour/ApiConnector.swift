//
//  ApiConnector.swift
//  hiTour
//
//  Created by Adam Chlupacek on 18/02/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import CoreData

///
/// App that servers a s connection to the server and handles all calls to the api
///
class ApiConnector{
    
    let client: HTTPClient
    let coreDataStack: CoreDataStack

    /// The original data that are being used.
    /// This is to be able to detect data that are not valid anymore, we fill this with the data that are in
    /// core data at the beginig of fetching, the for every data we use we will delete it from this set. 
    /// At the end of all fetching we will delete all of the outstanding data in this set, this way we can ensure
    /// that each point still has only valid data
    ///
    var originalData = Set<Data>()

    ///
    /// Constructor for the api connector
    ///
    init(HTTPClient client: HTTPClient, stack coreDataStack: CoreDataStack){
        self.client = client
        self.coreDataStack = coreDataStack
    }
    
    
    ///
    /// Drops all data from the coreData and updates them with new values from the server
    ///
    func updateAll(chain: (() -> Void)? = nil) -> Void {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            if let sessions = self.coreDataStack.fetch(name: Session.entityName).flatMap({$0 as? [Session]}){
                var finished = 0;
                self.originalData = Set<Data>(self.coreDataStack.fetch(name: Data.entityName)! as [Data])
                func tryUpdate() -> Void {
                    if(finished >= sessions.count) {
                        self.originalData.flatMap{$0.pointData?.allObjects as! [PointData]}.forEach(self.checkAndDeletePointData)
                        dispatch_async(dispatch_get_main_queue(), {
                            _ = chain.map({$0()}) // update some UI

                        });
                    } else {
                        fetchBySession(sessions[finished])
                    }
                }
                
                func fetchBySession(session: Session){
                    print("Fetching", session.sessionCode)
                    self.fetchTour(session, chain: {_ in
                        finished++
                        self.coreDataStack.saveMainContext()
                        tryUpdate()
                    })
                }

                tryUpdate()
            }

        });
    }
    
    ///
    /// Delets a point from the core data, as well as data assigned to the point, in case they are not being used anywhere else
    ///
    ///
    func deletePoint(point: Point) -> Void {
        guard let pointData = point.pointData?.array as? [PointData] else {
            coreDataStack.delete(point)
            return
        }
        
        pointData.forEach(checkAndDeletePointData)
        
        coreDataStack.delete(point);
    }
    
    ///
    /// Deletes a point data connection, in case its nessesary it deletes the data as well
    ///
    private func checkAndDeletePointData(pd: PointData) -> Void {
        let data = pd.data!
        let point = pd.point!
        if (data.pointData?.count == 1){
            coreDataStack.delete(data);
        }
        coreDataStack.delete(pd);
        let originalTourPoints = point.pointData!.array as! [PointData]
        point.pointData = NSOrderedSet(array: originalTourPoints.filter{$0.data != data})
    }
    
    ///
    /// Deletes a tour from the core data
    ///
    func deleteTour(tour: Tour) -> Void {
        guard let tourPoints = tour.pointTours?.array as? [PointTour] else {
            coreDataStack.delete(tour);
            return
        }
        
        tourPoints.forEach(checkAndDeletePointTour)

        coreDataStack.delete(tour);
    }
    
    ///
    /// Deletes a point tour connection, in case its nessesary it deletes the point as well
    ///
    private func checkAndDeletePointTour(pt: PointTour) -> Void {
        let point = pt.point!
        let tour = pt.tour!
        if (point.pointTours?.count == 1){
            deletePoint(point);
        }
        coreDataStack.delete(pt);
        let originalTourPoints = tour.pointTours!.array as! [PointTour]
        tour.pointTours = NSOrderedSet(array: originalTourPoints.filter{$0.point != point})
    }
    
    ///
    /// Deletes a session from core data
    ///
    func deleteSession(session: Session) -> Void{
        guard let tour = session.tour else {
            coreDataStack.delete(session);
            return;
        }
        
        guard let sessions = tour.sessions?.allObjects as? [Session] else {
            deleteTour(tour);
            coreDataStack.delete(session);
            return;
        }
        
        // Multiple session keys loaded, no need to delete tour
        if(sessions.count > 1){
            coreDataStack.delete(session);
            return;
        }
        
        deleteTour(tour);
        coreDataStack.delete(session);
        
    }
    
    ///
    /// Fetches a tour from the server, deals with all of the parsing for all points and data in a tour
    /// Downloads the binary data for the Data in the tour, downloads them only in case that the data has been updated
    /// Also deletes a tour in case the session is not valid anymore, in case we have multiple sessions, it only deletes the session
    ///
    func fetchTour(session: Session, chain: ((Tour?) -> Void)? = nil) -> Void {
        var outStandingRequests = 0;
        var audiencesS = Set<Audience>()
        var oldPoints = Set<PointTour>()
        
        ///
        /// A try to call to a finish of the tour fetch, this does nothing if all of the data fetches are not finished yet
        /// Otherwise it deletes old unsued points and then calls the chaining callback
        ///
        func tryCallBack(tour: Tour){
            if(outStandingRequests <= 0) {
                oldPoints.forEach(checkAndDeletePointTour) //Deletes the outstanding point tours
                chain.forEach({$0(tour)})
            }
        }
        
        ///
        /// A convenience function to download binary data from a given url, once finished it tries to callback
        ///
        func downloadBinary(url: String?, nsTour: Tour, after: (NSData?) -> Void) {
            outStandingRequests++
            url.forEach({
                self.client.binaryReques($0, cb: { (data) -> Void in
                    after(data)
                    outStandingRequests--
                    tryCallBack(nsTour)
                })
 
            })
        }
        
        ///
        /// Parses point and all of the data required to parse and conenct point in the core data
        ///
        func parsePoints(nsTour: Tour) -> ([String: AnyObject]) -> [Point] {
            func parse(pDict: [String: AnyObject]) -> [Point] {
                guard let
                    data = pDict["data"] as? [[String: AnyObject]]
                    ,nsPoint = Point.jsonReader.read(pDict, stack: self.coreDataStack).map({self.coreDataStack.insert(Point.entityName, callback: $0)})
                    ,pointUpdated = pDict["updated_at"] as? String
                else {
                    return []
                }
                
                /// Downloads overlay data for the point
                func dowloadPointData(){
                    downloadBinary(pDict["url"] as? String, nsTour: nsTour){ data in
                        nsPoint.data = data
                        nsPoint.dateUpdated = pointUpdated;
                    }
                }
                
                // Checks whether the point data has to be updated
                nsPoint.dateUpdated.fold(dowloadPointData)({(date: String) -> (() -> Void) in
                    if(pointUpdated != date) {
                        return dowloadPointData
                    }else { return {} }
                })()

                // Creates a connection between point and tour if it doesnt already exist
                (nsPoint.pointTours?.array as? [PointTour]).forEach{pts in
                    let idx = pts.indexOf{$0.tour == nsTour}
                    if(idx == nil){
                        PointTour.jsonReader.read(pDict, stack: self.coreDataStack).map({self.coreDataStack.insert(PointTour.entityName, callback: $0)}).forEach{tourPoint in
                            tourPoint.tour = nsTour
                            tourPoint.point = nsPoint
                        }
                    } else {
                        let point = pts[idx!]
                        point.rank = (pDict["rank"] as? Int).getOrElse(point.rank!.integerValue)
                        oldPoints.remove(pts[idx!]) // Remove the point since its still a valid point in the tour
                    }
                }
                
                _ = data.flatMap(parseData(nsPoint, nsTour: nsTour))
                
                return [nsPoint]
                
            }
            return parse
        }
        
        ///
        /// Parses the data from the data json, also parses audience ids that are conencted to this data
        ///
        func parseData(nsPoint: Point, nsTour: Tour) -> ([String: AnyObject]) -> [Data] {
            func parse(dDict: [String: AnyObject]) -> [Data] {
                guard let audiences = dDict["audiences"] as? [[String: AnyObject]], dataUpdated = dDict["updated_at"] as? String else {
                    return []
                }
                
                // Parses audiences
                let dataAudience = audiences.flatMap({aDict -> [Audience] in
                    if let audience = Audience.jsonReader.read(aDict, stack: self.coreDataStack).map({self.coreDataStack.insert(Audience.entityName, callback: $0)}) {
                        audiencesS.insert(audience)
                        return [audience]
                    }
                    return []
                })
                
                // Parses the actual data
                if let nsData = Data.jsonReader.read(dDict, stack: self.coreDataStack).map({self.coreDataStack.insert(Data.entityName, callback: $0)}) {
                    let nAudience = (dataAudience as [AnyObject]) + nsData.audience!.allObjects
                    nsData.audience = NSSet(array: nAudience)
                    originalData.remove(nsData)
                    
                    // Creates connection between point and data
                    if let pds = nsData.pointData?.allObjects as? [PointData] {
                        let idx = pds.indexOf{$0.point == nsPoint}
                        if(idx == nil){
                            if let dataPoint = PointData.jsonReader.read(dDict, stack: self.coreDataStack).map({self.coreDataStack.insert(PointData.entityName, callback: $0)}) {
                                dataPoint.point = nsPoint
                                dataPoint.data = nsData
                            }
                        } else {
                            pds[idx!].rank = (dDict["rank"] as? Int).getOrElse(pds[idx!].rank!.integerValue)
                        }
                    }
                    
                    /// Downloads the binary data for the data
                    func downloadDataData() {
                        downloadBinary(dDict["url"] as? String, nsTour: nsTour){data in
                            nsData.data = data
                            nsData.dataUpdated = dataUpdated;
                        }
                    }
                    
                    // Checks whether the binary data has to be updated
                    nsData.dataUpdated.fold(downloadDataData)({ (date: String) -> (() -> Void) in
                        if(dataUpdated != date){
                            return downloadDataData
                        } else { return {} }
                    })()
                    
                    return [nsData]
                }
                return []
            }
            return parse
        }

        ///
        /// Filters the action on the request to the server, decides whether it should continue parsing the received data
        /// or where we can already decide from the status code what we should do with the incoming data
        ///
        func tourOnResponse(response: NSURLResponse?) -> Bool{
            guard let resp = response as? NSHTTPURLResponse else {
                return true; // NO RESPONSE.. most likely an error, should return true as default
            }
                        
            if (resp.statusCode == 200) {
                // SHOULD BE OK
                return true;
            } else if (resp.statusCode == 401) {
                // WRONG SESSION KEY, procede to delete all to do with session
                deleteSession(session);
                _ = chain.map({$0(nil)})
                return false;
            }
            return true // return true as default
            
        }
        
        // Stars up the show
        client.requestObject(
            session.sessionCode.getOrElse("THIS/IS/NOT/A/VALID/SESSION")
            , onResponse: tourOnResponse
            , onError: {_ in _ = chain.map({$0(nil)})}
            , onParseFail: {_ in
                self.deleteSession(session)
                _ = chain.map({$0(nil)})
            }
        ) { (dict:[String: AnyObject] ) -> Void in
            guard let
                tour = dict["tours"] as? [String: AnyObject]
                , points = tour["points"] as? [[String: AnyObject]]
                , tourSession = dict["tour_session"] as? [String:AnyObject]
                , start = tourSession["start_date"] as? String
                , duration = tourSession["duration"] as? Int
            else {
                _ = chain.map({$0(nil)}) // Chaining so that other calls can be made afterwars
                return
            }
            
            /// Parses the tour
            Tour.jsonReader.read(tour, stack: self.coreDataStack).map({self.coreDataStack.insert(Tour.entityName, callback: $0)}).forEach{ nsTour in
                session.tour = nsTour;
                oldPoints = Set<PointTour>(nsTour.pointTours?.array as! [PointTour])
                let dateFormater = NSDateFormatter()
                dateFormater.dateFormat =  "yyyy-MM-dd"
                session.endData = dateFormater.dateFromString(start)?.dateByAddingTimeInterval(NSTimeInterval(60*60*24*duration))
                
                _ = points.flatMap(parsePoints(nsTour))
                
                (tour["audience_id"] as? Int).forEach { audienceId in
                    nsTour.audience = audiencesS.filter({$0.audienceId! == audienceId}).last
                }
                
                tryCallBack(nsTour)
            }
        }
    }
}








