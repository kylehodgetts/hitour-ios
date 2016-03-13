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
                    if(finished == sessions.count) {
                        dispatch_async(dispatch_get_main_queue(), {
                            // update some UI
                            _ = chain.map({$0()});
                        });
                    }
                }
                for session in sessions {
                    self.fetchTour(session, chain: {_ in
                        finished++;
                        tryUpdate();
                    })
                }
            }

        });
    }
    
    
    func deletePoint(point: Point) -> Void {
        guard let pointData = point.pointData?.array as? [PointData] else {
            coreDataStack.delete(point);
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
    
    func deleteSession(session: Session) -> Void{
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
    ///
    func fetchTour(session: Session, chain: (() -> Void)? = nil) -> Void {
        print(session)
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
                return false;
            }
            return true // return true as default... mostlikely will result into an error anyway...
            
        }

        client.requestObject(session.sessionCode!, onResponse: tourOnResponse) { (dict:[String: AnyObject] ) -> Void in
            guard let tour = dict["tours"] as? [String: AnyObject] else {
                //TODO allert in case something wrong...
                return
            }
            
            guard let points = tour["points"] as? [[String: AnyObject]] else {
                //TODO alert in case points do not exist or smthing
                return
            }
            
            var audiencesS = Set<Audience>()
            
            guard let nsTour = Tour.jsonReader.read(tour, stack: self.coreDataStack).map({self.coreDataStack.insert(Tour.entityName, callback: $0)}) else {
                return
            }
            
            session.tour = nsTour;
            
            _ = points.flatMap({pDict -> [Point] in
                guard let data = pDict["data"] as? [[String: AnyObject]] else {
                    return []
                }
                
                guard let nsPoint = Point.jsonReader.read(pDict, stack: self.coreDataStack).map({self.coreDataStack.insert(Point.entityName, callback: $0)}) else {
                    return []
                }
                
                func dowloadPointData(){
                    if let url = pDict["url"] as? String {
                        self.client.binaryReques(url, cb: { (data) -> Void in
                            nsPoint.data = data
                        })
                    }
                }
                
                let pointUpdated = pDict["updated_at"] as? String;
                
                if let date = nsPoint.dateUpdated {
                    if(pointUpdated != date){
                        dowloadPointData()
                    }
                } else {
                    dowloadPointData();
                }
                nsPoint.dateUpdated = pointUpdated;
                
                if let tourPoint = PointTour.jsonReader.read(pDict, stack: self.coreDataStack).map({self.coreDataStack.insert(PointTour.entityName, callback: $0)}) {
                    tourPoint.tour = nsTour
                    tourPoint.point = nsPoint
                }

                
               _ = data.flatMap({dDict -> [Data] in
                    guard let audiences = dDict["audiences"] as? [[String: AnyObject]] else {
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
                        
                        if let dataPoint = PointData.jsonReader.read(dDict, stack: self.coreDataStack).map({self.coreDataStack.insert(PointData.entityName, callback: $0)}) {
                            dataPoint.point = nsPoint
                            dataPoint.data = nsData
                        }
                        
                        func downloadDataData() {
                            if let url = dDict["url"] as? String {
                                self.client.binaryReques(url, cb: { (data) -> Void in
                                    nsData.data = data
                                })
                            }
                        }
                        
                        let dataUpdated = dDict["updated_at"] as? String;
                        
                        if let dataDate = nsData.dataUpdated {
                            if(dataUpdated != dataDate){
                                downloadDataData()
                            }
                        } else {
                            downloadDataData();
                        }

                        nsData.dataUpdated = dataUpdated;
                        
                        return [nsData]
                    }
                    return []
                
                
                })
                
                return [nsPoint]
                
            })
            
            if let audienceId = tour["audience_id"] as? Int {
                nsTour.audience = audiencesS.filter({$0.audienceId! == audienceId}).last
            }
        
        }
    }
}