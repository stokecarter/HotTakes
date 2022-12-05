//
//  UserModel.swift
//  NewProject
//
//  Created by Harsh Vardhan Kushwaha on 30/08/18.
//  Copyright © 2018 Harsh Vardhan Kushwaha. All rights reserved.
//

import Foundation
import SwiftyJSON
/*
 {
     "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2MDM3NTIzNTY0Y2YxYTBlYjg3ZjAzOGUiLCJlbWFpbCI6ImFycGl0OTg0MEBnbWFpbC5jb20iLCJzYWx0IjoiMWM4MGU1ZjdhYmJlMmVjZjUwZmE4ZDYwMjQxMTc4ZTkiLCJpYXQiOjE2MTQyMzk0MjgsImV4cCI6MTYyOTc5MTQyOH0.l0KMkqcpXMOZ9JghQXd258owk9W70iA-DeKlDB5GcWo",
     "refreshToken": "MGYyNjY5YTRlZGE1ZDFhODcyNTVkMzU1OTdjOGIyYmU=",
     "userId": "6037523564cf1a0eb87f038e",
     "firstName": "",
     "lastName": "",
     "email": "arpit9840@gmail.com",
     "profilePicture": "",
     "isEmailVerified": false,
     "isMobileVerified": false,
     "countryCode": "",
     "mobileNo": "",
     "registeredUsing": 1,
     "createdAt": "2021-02-25T07:31:01.396Z",
     "userName": "arpit",
     "userType": "user"
   }
 */

// MARK:- User Model
//====================
struct UserModel {
    
    static var main = UserModel(AppUserDefaults.value(forKey: .fullUserProfile)) {
        didSet {
            main.saveToUserDefaults()
        }
    }
    let userId: String
    let firstName: String
    let lastName:String
    let profilePicture:String
    let isEmailVerified:Bool
    let isMobileVerified:Bool
    let email: String
    let mobileNo: String
    let countryCode:String
    var accessToken, refreshToken : String
    let userName:String
    let userType:String

    
    var isUserLogin:Bool{
        return !accessToken.isEmpty
    }
    
    init() {
        self.init(JSON([:]))
    }
    
    init (_ json: JSON = JSON()) {
        
        userId = json["userId"].stringValue
        firstName = json["firstName"].stringValue
        lastName = json["lastName"].stringValue
        profilePicture = json["profilePicture"].stringValue
        isMobileVerified = json["isMobileVerified"].boolValue
        isEmailVerified = json["isEmailVerified"].boolValue
        email = json["email"].stringValue
        mobileNo = json["mobileNo"].stringValue
        countryCode = json["countryCode"].stringValue
        accessToken = json["accessToken"].stringValue
        refreshToken = json["refreshToken"].stringValue
        userName = json["userName"].stringValue
        userType = json["userType"].stringValue
        
    }
    
    func saveToUserDefaults() {
        
        let dict: JSONDictionary = [ApiKey.email:email,
                                    ApiKey.refreshToken:refreshToken,
                                    "accessToken":accessToken,
                                    "userId":userId,
                                    "firstName":firstName,
                                    "lastName":lastName,
                                    "profilePicture":profilePicture,
                                    "isMobileVerified":isMobileVerified,
                                    "isEmailVerified":isEmailVerified,
                                    "mobileNo":mobileNo,
                                    "countryCode":countryCode,
                                    "userType":"userType",
                                    "userName":userName]
        
        AppUserDefaults.save(value: dict, forKey: .fullUserProfile)
    }
}

