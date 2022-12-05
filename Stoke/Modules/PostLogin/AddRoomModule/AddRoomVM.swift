//
//  AddRoomVM.swift
//  Stoke
//
//  Created by Admin on 22/03/21.
//

import Foundation
import SwiftyJSON

class AddRoomVM {
    
    let web:NetworkLayer!
    var isUploading = false
    
    var dummyImage:UIImage? =  #imageLiteral(resourceName: "ic_profile_placeholder")
    var room:ChatRoom? = nil{
        didSet{
            image = room?.image ?? ""
            if !image.isEmpty{
                dummyImage = nil
            }
            chatRoomName = room?.name ?? ""
            roomDesc = room?.description ?? ""
            roomType = room?.roomType ?? ._public
            roomId = room?._id ?? ""
            eventId = room?.event.id ?? ""
            if let tap = notifyTOReload { tap()}
        }
    }
    var searchQuery:String = ""{
        didSet{
            searchUser()
        }
    }
    var roomCreated:(()->())?
    var roomUpdated:((String)->())?
    var roomDeleted:(()->())?
    var notifyTOReload:(()->())?
    var notifyLimitreached:(()->())?
    var didEnableSaveBtn:((Bool)->())?
    var inviteIds:[String] = []
    var isInviteAll:Bool = true
    var image = ""
    var chatRoomName = ""{
        didSet{
            let flag = roomDesc.isEmpty || chatRoomName.isEmpty
            if let enable = didEnableSaveBtn { enable(!flag)}
        }
    }
    var roomDesc = ""{
        didSet{
            let flag = roomDesc.isEmpty || chatRoomName.isEmpty
            if let enable = didEnableSaveBtn { enable(!flag)}
        }
    }
    var roomType:RoomType = ._public
    var roomId = ""
    var eventId:String = ""
    
    var userList = UserListModel(JSON()){
        didSet{
            if let tap = notifyTOReload { tap()}
        }
    }
    
    init(_ web:NetworkLayer,eventId:String){
        self.web = web
        self.eventId = eventId
    }
    
    func createRoom(){
        guard validate() else { return }
        let param:JSONDictionary = ["name":chatRoomName,
                                    "image":image,
                                    "eventId":eventId,
                                    "roomType":roomType.rawValue,
                                    "description":roomDesc,
                                    "isInviteAll":isInviteAll,
                                    "inviteIds":inviteIds]
        web.request(from: WebService.getChatRooms, param: param, method: .POST, header: [:], loader: true) { [weak self](data, er) in
            if let e = er{
                CommonFunctions.showToastWithMessage(e.localizedDescription)
            }else{
                guard let d = data else { return }
                Parser.shared.getJSONData(data: d) { (json) in
                    let code = json[ApiKey.code].intValue
                    if code == 201{
                        if let success = self?.roomCreated { success()}
                    }else if code == 418{
                        if let limit = self?.notifyLimitreached{ limit()}
                    }
                    print(json)
                } failure: { (e) in
                    CommonFunctions.showToastWithMessage(e.localizedDescription)
                }
            }
        }
    }
    
    func validate() -> Bool {
        if image.isEmpty{
            CommonFunctions.showToastWithMessage("Please add image for the chat room")
            return false
        }else if chatRoomName.isEmpty{
            CommonFunctions.showToastWithMessage("Please enter the chat room name")
            return false
        }else if roomDesc.isEmpty{
            CommonFunctions.showToastWithMessage("Please enter the chat room description")
            return false
        }else{
            return true
        }
    }
    
    
    func editroom(){
        guard validate() else { return }
        let param:JSONDictionary = ["name":chatRoomName,
                                    "image":image,
                                    "eventId":eventId,
                                    "roomType":roomType.rawValue,
                                    "description":roomDesc,
                                    "isInviteAll":isInviteAll,
                                    "inviteIds":inviteIds,
                                    "chatroomId":roomId]
        web.request(from: WebService.getChatRooms, param: param, method: .PUT, header: [:], loader: true) { [weak self](data, er) in
            if let e = er{
                CommonFunctions.showToastWithMessage(e.localizedDescription)
            }else{
                guard let d = data else { return }
                Parser.shared.getJSONData(data: d) { (json) in
                    let msg = json[ApiKey.message].stringValue
                    if let update = self?.roomUpdated { update(msg)}
                    print(json)
                } failure: { (e) in
                    CommonFunctions.showToastWithMessage(e.localizedDescription)
                }

            }
        }
    }
    
    func deleteChatRooms(){
        let param:JSONDictionary = ["chatroomId":roomId,"status":"deleted"]
        web.request(from: WebService.getChatRooms, param: param, method: .PUT, header: [:], loader: true) { [weak self](data, er) in
            if let e = er{
                CommonFunctions.showToastWithMessage(e.localizedDescription)
            }else{
                guard let d = data else { return }
                Parser.shared.getJSONData(data: d) { (json) in
                    CommonFunctions.showToastWithMessage(json[ApiKey.message].stringValue)
                    if let update = self?.roomDeleted { update()}
                    print(json)
                } failure: { (e) in
                    CommonFunctions.showToastWithMessage(e.localizedDescription)
                }

            }
        }
    }
    
    private func searchUser(){
        var param:JSONDictionary = [:]
         param["search"] = searchQuery
        param["page"] = 1
        param["limit"] = 10
        if let _ = room{
            param["chatroomId"] = room?._id ?? ""

        }
        web.request(from: WebService.chatroomInviteList, param: param, method: .GET, header: [:], loader: true) { [weak self](data, er) in
            if let e = er{
                CommonFunctions.showToastWithMessage(e.localizedDescription)
            }else{
                if let d = data{
                    Parser.shared.getJSONData(data: d) { (json) in
                        self?.userList = UserListModel(json[ApiKey.data])
                    } failure: { (e) in
                        CommonFunctions.showToastWithMessage(e.localizedDescription)
                    }
                }
            }
        }
    }
    
}
