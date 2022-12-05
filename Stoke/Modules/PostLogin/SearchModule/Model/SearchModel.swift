//
//  SearchModel.swift
//  Stoke
//
//  Created by Admin on 18/03/21.
//

import Foundation
import SwiftyJSON

struct User {
    let id:String
    let firstName:String
    let lastName:String
    let userName:String
    let image:String
    let userType:String
    let fullName:String
    var isInvited:Bool = false
    
    init(_ json:JSON){
        id = json["_id"].stringValue
        firstName = json["firstName"].stringValue
        lastName = json["lastName"].stringValue
        userName = json["userName"].stringValue
        image = json["image"].stringValue
        userType = json["userType"].stringValue
        fullName = firstName + " " + lastName
        isInvited = json["isInvited"].boolValue
    }
}

struct UserListModel {
    let totalCount:Int
    let page:Int
    let limit:Int
    let nextPage:Int
    var data:[User]
    
    init(_ json:JSON){
        totalCount = json["totalCount"].intValue
        page = json["page"].intValue
        limit = json["limit"].intValue
        nextPage = json["nextPage"].intValue
        data = json[ApiKey.data].arrayValue.map { User($0)}
    }
}

struct Tag {
    let id:String
    let name:String
    let image:String
    var isSaved:Bool
    
    init(_ json:JSON){
        id = json["_id"].stringValue
        name = json["name"].stringValue
        image = json["image"].stringValue
        isSaved = json["isSaved"].boolValue
    }
}

struct TagListModel {
    let totalCount:Int
    let page:Int
    let limit:Int
    let nextPage:Int
    var data:[Tag]
    
    init(_ json:JSON){
        totalCount = json["totalCount"].intValue
        page = json["page"].intValue
        limit = json["limit"].intValue
        nextPage = json["nextPage"].intValue
        data = json[ApiKey.data].arrayValue.map { Tag($0)}
    }
}
