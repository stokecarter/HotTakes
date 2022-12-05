//
//  DayEventsListVM.swift
//  Stoke
//
//  Created by Admin on 23/03/21.
//

import Foundation
import SwiftyJSON

enum EventType:String{
    case upcoming
    case history
    case live
}

class DayEventsListVM {
    
    private let web:NetworkLayer!
    var sort :SortingBy = .time
    var type:EventType = .upcoming
    var startDate:Double?
    var category:Categories?
    var isFeatured:Bool = false
    
    var notify:(()->())?
    
    var dataSource:[Event] = []{
        didSet{
            if let noti = notify { noti() }
        }
    }
    private var isTodays:Bool = false {
        didSet{
            if isTodays{
                hitTodaysEvents()
            }else{
                hitForSpecificDay()
            }
        }
    }
    
    init(_ web:NetworkLayer, isTodays:Bool = true, sd:Double? = nil){
        self.web = web
        self.startDate = sd
        self.isTodays = isTodays
    }

    
    func hitForSpecificDay(){
        let param:JSONDictionary = ["page":1,"limit":10,"sortBy":sort.rawValue,
                                    "type":type.rawValue,
                                    "isFeatured":isFeatured,
                                    "startDateTime":startDate ?? 0.0,
                                    "categoryId":category?.id ?? ""]
        web.request(from: WebService.allEvents, param: param, method: .GET, header: [:], loader: true) { [weak self](data, error) in
            if let e = error{
                CommonFunctions.showToastWithMessage(e.localizedDescription)
            }else{
                guard let d = data else { return }
                guard let self = self else { return }
                Parser.shared.getJSONData(data: d) { (json) in
                    DispatchQueue.main.async {
                        self.dataSource = Event.returnEventArray(json["data"]["data"])                    }
                    
                } failure: { (e) in
                    CommonFunctions.showToastWithMessage(e.localizedDescription)
                }

            }
        }
    }
    
    func hitTodaysEvents(){
        let param:JSONDictionary = ["limit":20,"page":1,"sortBy":sort.rawValue]
        web.request(from: WebService.todayEvents, param: param, method: .GET, header: [:], loader: false) { [weak self](data, er) in
            guard let self = self else { return }
            if let e = er{
                CommonFunctions.showToastWithMessage(e.localizedDescription)
            }else{
                if let d = data{
                    Parser.shared.getJSONData(data: d) { (json) in
                        self.dataSource = Event.returnEventArray(json[ApiKey.data][ApiKey.data])
                    } failure: { (e) in
                        CommonFunctions.showToastWithMessage(e.localizedDescription)
                    }
                }
            }
        }
    }
    
}
