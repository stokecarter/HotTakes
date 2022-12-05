//
//  CatergoriesEventListVM.swift
//  Stoke
//
//  Created by Admin on 21/03/21.
//

import Foundation
import SwiftyJSON


class CategoriesEventList{
    
    enum EventType:String{
        case upcoming
        case history
    }
    
    
    let web:NetworkLayer!
    var notifyUpdate:(()->())?
    let categoryId:String
    var sortingStyle:SortingBy = .time
    var currentpage = 1
    var upcomingEvents:FeaturedList = FeaturedList(JSON()){
        didSet{
            if let noti = notifyUpdate { noti()}
        }
    }
    
    var historyEvents:FeaturedList = FeaturedList(JSON()){
        didSet{
            if let noti = notifyUpdate { noti()}
        }
    }
    
    
    
    init(_ web:NetworkLayer, categoryId:String){
        self.web = web
        self.categoryId = categoryId
    }
    
    private func getRequest(_ type:EventType) -> JSONDictionary{
        let param:JSONDictionary = ["page":currentpage,
                                    "limit":20,
                                    "sortBy":sortingStyle.rawValue,
                                    "type":type.rawValue,
                                    "categoryId":categoryId ?? ""]
        return param
    }
    
    func getEvent(_ type:EventType){
        let param = getRequest(type)
        web.request(from: WebService.events, param: param, method: .GET, header: [:], loader: true) { [weak self] (data, er) in
            if let e = er{
                CommonFunctions.showToastWithMessage(e.localizedDescription)
            }else{
                guard let d = data else { return }
                guard let self = self else { return }
                Parser.shared.getJSONData(data: d) { (json) in
                    DispatchQueue.main.async {
                        if type == .upcoming{
                            self.upcomingEvents = FeaturedList(json[ApiKey.data])
                        }else{
                            self.historyEvents = FeaturedList(json[ApiKey.data])
                        }
                    }
                } failure: { (e) in
                    CommonFunctions.showToastWithMessage(e.localizedDescription)
                }

            }
        }
    }
}
