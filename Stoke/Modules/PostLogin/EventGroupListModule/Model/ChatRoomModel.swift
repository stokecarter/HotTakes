//
//  ChatRoomModel.swift
//  Stoke
//
//  Created by Admin on 21/03/21.
//

import Foundation
import SwiftyJSON


enum RoomType:String{
    case _public = "public"
    case _private = "private"
    
    init(val:String){
        if val == "public"{
            self = ._public
        }else{
            self = ._private
        }
    }
}

struct ChatRoom {
    let noOfUsers:String
    let _id:String
    let createdBy:User
    let event:Event
    let noOfFollowings:String
    let image:String
    let roomType:RoomType
    let isLive:Bool
    let name:String
    let createdAt:String
    
    let description:String
    var isSaved:Bool
    let inviteString:String
    let amount:Double
    let paidType:String
    let tags:[Tags]
    let isFree:Bool
    
    
    let category:Categories
    init(_ json:JSON){
        noOfUsers = json["noOfUsers"].stringValue
        _id = json["_id"].stringValue
        createdBy = User(json["createdBy"])
        event = Event(json["event"])
        noOfFollowings = json["noOfFollowings"].stringValue
        image = json["image"].stringValue
        roomType = RoomType(val: json["roomType"].stringValue)
        isLive = json["isLive"].boolValue
        name = json["name"].stringValue
        createdAt = json["createdAt"].stringValue
        category = Categories(json["category"])
        description = json["description"].stringValue
        isSaved = json["isSaved"].boolValue
        inviteString = json["inviteString"].stringValue
        amount = json["amount"].doubleValue
        paidType = json["paidType"].stringValue
        isFree = paidType == "free"
        tags = Tags.returnTaggsArray(json["tags"])
    }
    var isCreatedByMe:Bool{
        return createdBy.id == UserModel.main.userId
    }
    
    var startDateObject:Date{
        let dt = event.startDate
        print(dt)
        return dt 
    }
    
    var isToday:Bool{
        return Calendar.current.isDateInToday(startDateObject)
    }
    
    static func returnArray(_ json:JSON) -> [ChatRoom]{
        return json.arrayValue.map { ChatRoom($0)}
    }
}

struct ChatRoomModel {
    let page:Int
    let limit:Int
    let totalCount:Int
    let nextPage:Int
    var chatRooms:[ChatRoom]
    
    init(_ json:JSON){
        page = json["page"].intValue
        limit = json["limit"].intValue
        totalCount = json["totalCount"].intValue
        nextPage = json["nextPage"].intValue
        chatRooms = ChatRoom.returnArray(json[ApiKey.data])
    }

}
