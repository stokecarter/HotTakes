//
//  EventModel.swift
//  Stoke
//
//  Created by Admin on 17/03/21.
//

import Foundation
import SwiftyJSON


struct Tags {
    var isSaved:Bool
    let image:String
    let status:String
    let id:String
    let name:String
    
    
    init(_ json:JSON){
        image = json["image"].stringValue
        status = json["status"].stringValue
        id = json["_id"].stringValue
        name = json["name"].stringValue
        isSaved = json["isSaved"].boolValue
    }
    
    static func returnTaggsArray(_ json:JSON) -> [Tags]{
        return json.arrayValue.map { Tags($0) }
    }
}

struct Categories {
    let image:String
    let status:String
    let id:String
    let name:String
    init(_ json:JSON){
        image = json["image"].stringValue
        status = json["status"].stringValue
        id = json["_id"].stringValue
        name = json["name"].stringValue
    }
}

struct Event {
    let id:String
    let image:String
    let noOfChatrooms:Int
    let noOfUsers:Int
    let name:String
    fileprivate let startTime:Double
    fileprivate let endTime:Double
    let isLive:Bool
    let category:Categories
    let squareImage:String
    let tags:[Tags]
    fileprivate let backendCreatedDate:String
    
    init(_ json:JSON) {
        id = json["_id"].stringValue
        image = json["image"].stringValue
        noOfChatrooms = json["noOfChatrooms"].intValue
        noOfUsers = json["noOfUsers"].intValue
        name = json["name"].stringValue
        isLive = json["isLive"].boolValue
        startTime = json["startTime"].doubleValue
        endTime = json["endTime"].doubleValue
        category = Categories(json["category"])
        tags = Tags.returnTaggsArray(json["tags"])
        backendCreatedDate = json["isLive"].stringValue
        squareImage = json["squareImage"].stringValue
    }
    
    var isEventConcluded:Bool{
        return Date().isGreaterThan(endDate)
    }
    
    static func returnEventArray(_ json:JSON) -> [Event]{
        return json.arrayValue.map { Event($0)}
    }
}

extension Event:Comparable{
    
    var weakDay:String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from: startDate)
        return weekDay
    }
    
    
    var startDate:Date{
        return Date(timeIntervalSince1970: startTime/1000)
    }
    var endDate:Date{
        return Date(timeIntervalSince1970: endTime/1000)
    }
    
    var startDateTimeFormat:String{
        let dt = DateFormatter()
        dt.dateFormat = "h:mm a"
        return dt.string(from: startDate)
    }
    var endDateTimeFormat:String{
        let dt = DateFormatter()
        dt.dateFormat = "h:mm a"
        return dt.string(from: endDate)
    }
    
    static func == (lhs:Event,rhs:Event) -> Bool{
        return lhs.startDate == rhs.startDate
    }
    
    static func < (lhs:Event, rhs:Event) -> Bool{
        return lhs.startDate < lhs.startDate
    }
    
}

struct SortedEvents {
    let count:Int
    let startTimeStamp:Double
    let events:[Event]
    let isMoreAvailable:Bool
    let dateString:String
    
    init(_ json:JSON){
        count = json["count"].intValue
        startTimeStamp = json["startTimeStamp"].doubleValue
        events = Event.returnEventArray(json["events"])
        isMoreAvailable = json["isMoreAvailable"].boolValue
        dateString = json["dateString"].stringValue
    }
    static func returnSortedEvents(_ json:JSON) ->[SortedEvents]{
        return json.arrayValue.map { SortedEvents($0)}
    }
    var startDate:Date{
        print(Date(timeIntervalSince1970: startTimeStamp/1000))
        return Date(timeIntervalSince1970: startTimeStamp/1000)
    }
    var weakDay:String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let weekDay = dateFormatter.string(from: startDate)
        return weekDay
    }
    
}



struct FeaturedList{
    let totalCount:Int
    let page:Int
    let limit:Int
    var data:[SortedEvents]
    let nextPage:Int
    
    init(_ json:JSON){
        totalCount = json["totalCount"].intValue
        page = json["page"].intValue
        limit = json["limit"].intValue
        nextPage = json["nextPage"].intValue
        data = SortedEvents.returnSortedEvents(json["data"])
    }
    
}
