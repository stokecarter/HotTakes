//
//  GroupDetailVM.swift
//  Stoke
//
//  Created by Admin on 24/03/21.
//

import Foundation
import SwiftyJSON

class GroupDetailVM {
    
    private let web:NetworkLayer!
    var room:ChatRoom!
    var notifyChatSave:(()->())?
    
    init(_ web:NetworkLayer, room:ChatRoom) {
        self.web = web
        self.room = room
    }
    
    func hitForUnsaveChatRoom(completion:@escaping (()->())){
        let url = WebService.saveChatRoom.path + "/" + room._id
        web.requestString(from: url, param: [:], method: .DELETE, header: [:], loader: true) { (data, er) in
            if let e = er{
                CommonFunctions.showToastWithMessage(e.localizedDescription)
            }else{
                guard let d = data else { return }
                Parser.shared.getJSONData(data: d) { (json) in
                    DispatchQueue.main.async {
                        completion()
                    }
                } failure: { (e) in
                    CommonFunctions.showToastWithMessage(e.localizedDescription)
                }
            }
        }
    }
    
    func hitForSaveChatRoom(){
        let param:JSONDictionary = ["chatroomId":room._id]
        web.request(from: WebService.saveChatRoom, param: param, method: .POST, header: [:], loader: true) { [weak self](data, er) in
            if let e = er{
                CommonFunctions.showToastWithMessage(e.localizedDescription)
            }else{
                guard let d = data else { return }
                Parser.shared.getJSONData(data: d) { (json) in
                    if let noti = self?.notifyChatSave { noti()}
                } failure: { (e) in
                    CommonFunctions.showToastWithMessage(e.localizedDescription)
                }
            }
        }
    }
}
