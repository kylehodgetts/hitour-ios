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
                func tryUpdate() -> Void {
                    if(finished >= sessions.count) {
                        dispatch_async(dispatch_get_main_queue(), {
                            // update some UI
                            _ = chain.map({$0()});
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
        
        for pd in pointData {
            let data = pd.data!
            if (data.pointData?.count == 1){
                coreDataStack.delete(data);
            }
            
            coreDataStack.delete(pd);
        }
        
        coreDataStack.delete(point);
    }
    
    ///
    /// Deletes a tour from the core data
    ///
    ///
    func deleteTour(tour: Tour) -> Void {
        guard let tourPoints = tour.pointTours?.array as? [PointTour] else {
            coreDataStack.delete(tour);
            return
        }
        
        for tourPoint in tourPoints {
            let point = tourPoint.point!
            if (point.pointTours?.count == 1){
                deletePoint(point);
            }
            
            coreDataStack.delete(tourPoint);
        }
        
        coreDataStack.delete(tour);
    
    }
    
    ///
    /// Deletes a session from core data
    ///
    ///
    func deleteSession(session: Session) -> Void{
        print("DELETING SES")
        //TODO: Delete all data that has smthing to do with this session
        guard let tour = session.tour else {
            coreDataStack.delete(session);
            return;
        }
        
        guard let sessions = tour.sessions?.allObjects as? [Session] else {
            deleteTour(tour);
            coreDataStack.delete(session);
            return;
        }
        
        //Multiple session keys loaded, no need to delete tour
        if(sessions.count > 1){
            coreDataStack.delete(session);
            return;
        }
        
        deleteTour(tour);
        coreDataStack.delete(session);
        
    }
    
    ///
    /// !!! ATTENTIONE !!!
    /// DO NOT TOUCH THIS UNLESS YOU ARE REALLY SURE WHAT YOU ARE DOING
    /// HAS WEIRD ASS DEPENDEDNCIES ALL OVER THE FUNCTION...
    ///
    /// It is a function with many sub functions, that are being called
    ///
    func fetchTour(session: Session, chain: ((Tour?) -> Void)? = nil) -> Void {
        var outStandingRequests = 0;
        var audiencesS = Set<Audience>()
        
        func tryCallBack(tour: Tour){
            if(outStandingRequests <= 0) {
                _ = chain.map({$0(tour)})
            }
        }
        
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
        
        func parsePoints(nsTour: Tour) -> ([String: AnyObject]) -> [Point] {
            func parse(pDict: [String: AnyObject]) -> [Point] {
                guard let
                    data = pDict["data"] as? [[String: AnyObject]]
                    ,nsPoint = Point.jsonReader.read(pDict, stack: self.coreDataStack).map({self.coreDataStack.insert(Point.entityName, callback: $0)})
                    ,pointUpdated = pDict["updated_at"] as? String
                else {
                    return []
                }
                
                func dowloadPointData(){
                    downloadBinary(pDict["url"] as? String, nsTour: nsTour){ data in
                        nsPoint.data = data
                        nsPoint.dateUpdated = pointUpdated;
                    }
                }
                
                nsPoint.dateUpdated.fold(dowloadPointData())({(date: String) in
                    if(pointUpdated != date) {return dowloadPointData()}
                    else { return {}() }
                })

                (nsPoint.pointTours?.array as? [PointTour]).forEach{pts in
                    if(!pts.contains({$0.tour == nsTour})){
                        PointTour.jsonReader.read(pDict, stack: self.coreDataStack).map({self.coreDataStack.insert(PointTour.entityName, callback: $0)}).forEach{tourPoint in
                            tourPoint.tour = nsTour
                            tourPoint.point = nsPoint
                        }
                    }
                }
                
                _ = data.flatMap(parseData(nsPoint, nsTour: nsTour))
                
                return [nsPoint]
                
            }
            return parse
        }
        
        func parseData(nsPoint: Point, nsTour: Tour) -> ([String: AnyObject]) -> [Data] {
            func parse(dDict: [String: AnyObject]) -> [Data] {
                guard let audiences = dDict["audiences"] as? [[String: AnyObject]], dataUpdated = dDict["updated_at"] as? String else {
                    return []
                }
                
                let dataAudience = audiences.flatMap({aDict -> [Audience] in
                    if let audience = Audience.jsonReader.read(aDict, stack: self.coreDataStack).map({self.coreDataStack.insert(Audience.entityName, callback: $0)}) {
                        audiencesS.insert(audience)
                        return [audience]
                    }
                    return []
                })
                
                if let nsData = Data.jsonReader.read(dDict, stack: self.coreDataStack).map({self.coreDataStack.insert(Data.entityName, callback: $0)}) {
                    let nAudience = (dataAudience as [AnyObject]) + nsData.audience!.allObjects
                    nsData.audience = NSSet(array: nAudience)
                    
                    if let pds = nsData.pointData?.allObjects as? [PointData] {
                        if(!pds.contains({$0.point == nsPoint})){
                            if let dataPoint = PointData.jsonReader.read(dDict, stack: self.coreDataStack).map({self.coreDataStack.insert(PointData.entityName, callback: $0)}) {
                                dataPoint.point = nsPoint
                                dataPoint.data = nsData
                            }
                        }
                    }
                    
                    func downloadDataData() {
                        downloadBinary(dDict["url"] as? String, nsTour: nsTour){data in
                            nsData.data = data
                            nsData.dataUpdated = dataUpdated;
                        }
                    }
                    
                    nsData.dataUpdated.fold(downloadDataData())({ (date: String) in
                        if(dataUpdated != date){ downloadDataData()}
                        else { return {}() }
                    })
                    
                    return [nsData]
                }
                return []
            }
            return parse
        }

        
        func tourOnResponse(response: NSURLResponse?) -> Bool{
            guard let resp = response as? NSHTTPURLResponse else {
                return true; //NO RESPONSE.. most likely an error, should return true as default
            }
                        
            if (resp.statusCode == 200) {
                //SHOULD BE OK
                return true;
            } else if (resp.statusCode == 401) {
                //WRONG SESSION KEY, procede to delete all to do with seš
                deleteSession(session);
                _ = chain.map({$0(nil)})
                return false;
            }
            return true // return true as default... mostlikely will result into an error anyway...
            
        }
        

        client.requestObject(
            session.sessionCode!
            , onResponse: tourOnResponse
            , onError: {_ in _ = chain.map({$0(nil)})}
            , onParseFail: {_ in
                self.deleteSession(session)
                _ = chain.map({$0(nil)})
            }
        ) { (dict:[String: AnyObject] ) -> Void in
            print("Shoul happen only once...")
            guard let
                tour = dict["tours"] as? [String: AnyObject]
                , points = tour["points"] as? [[String: AnyObject]]
                , tourSession = dict["tour_session"] as? [String:AnyObject]
                , start = tourSession["start_date"] as? String
                , duration = tourSession["duration"] as? Int
            else {
                //TODO allert in case something wrong...
                return
            }
            
            Tour.jsonReader.read(tour, stack: self.coreDataStack).map({self.coreDataStack.insert(Tour.entityName, callback: $0)}).forEach{ nsTour in
                session.tour = nsTour;
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








