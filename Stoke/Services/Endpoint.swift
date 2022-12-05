//
//  Endpoint.swift
//  Covid-19 Dependecy_Injection
//
//  Created by Arpit Srivastava on 01/11/20.
//  Copyright © 2020 Arpit Srivastava. All rights reserved.
//

enum ServerType {
    case dev
    case qa
    case staging
    case production
}

var server:ServerType = .staging

protocol Endpoint {
  var path: String { get }
}

enum WebService:String {
    case username = "/check-username"
    case signup = "/signup"
    case login = "/login"
    case guestLogin = "/guest-signup"
    case otp = "/verify-otp"
    case resendOtp = "/send-otp"
    case resendForgotOtp = "/send-forget-otp"
    case checkSocail = "/check-social-id"
    case socailLogin = "/social-login"
    case forgotPassword = "/forgot-password"
    case resetPassword = "/reset-password"
    case verifyResetOtp = "/verify-forget-otp"
    
    
    case featureList = "/featured-events"
    case category = "/category"
    case todayEvents = "/today-events"
    case recomendedChatRooms = "/recommended-chatrooms"
    case recomendedEvents = "/recommended-events"
    case users = ""
    case events = "/events"
    case allEvents = "/events/all"
    case tags = "/tags"
    
    case inviteChatroom = "/chatroom/invite-string"
    case getChatRooms = "/chatrooms"
    case inviteUserChatRoom = "/chatrooms/invite"
    case chatroomInviteList = "/chatrooms/invite-list"
    case saveUnsaveTags = "/chatrooms/tags"
    case getChatRoomDetail = "/chatrooms/"
    case saveChatRoom = "/my-chatrooms"
}

extension WebService: Endpoint {
    private var baseUrl:String{
        switch server {
        case .dev:
            return "http://chatroomsdevapi.appskeeper.in:7151/api/v1/users"
        case .qa:
            return "http://chatroomsqaapi.appskeeper.in:7152/api/v1/users"
        case .staging:
            return "http://chatroomsstgapi.appskeeper.in:7153/api/v1/users"
        default:
            return ""
        }
    }
    
    
  var path: String {
    return (baseUrl + self.rawValue)
  }
}
