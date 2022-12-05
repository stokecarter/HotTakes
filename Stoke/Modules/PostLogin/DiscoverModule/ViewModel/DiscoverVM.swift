//
//  DiscoverVM.swift
//  Stoke
//
//  Created by Admin on 18/03/21.
//

import Foundation
import SwiftyJSON

class DiscoverVM {
    
    
    private var web:NetworkLayer!
    
    var categories:[Categories] = []{
        didSet{
            DispatchQueue.main.async { [unowned self] in
                if let noti = self.notify { noti()}
            }
        }
    }
    
    var events:[Event] = []{
        didSet{
            DispatchQueue.main.async { [unowned self] in
                if let noti = self.notify { noti()}
            }
        }
    }
    
    var notify:(()->())?
    
    init(_ web:NetworkLayer){
        self.web = web
        hitApiForCategories()
        hitTodaysEvents()
    }
    
    func hitApiForCategories(loader:Bool = true){
        let param:JSONDictionary = ["limit":10,"page":1]
        web.request(from: WebService.category, param: param, method: .GET, header: [:], loader: loader) { [weak self](data, er) in
            guard let self = self else { return }
            if let e = er {
                CommonFunctions.showToastWithMessage(e.localizedDescription)
            }else{
                if let d = data{
                    Parser.shared.getJSONData(data: d) { (json) in
                        self.categories = CategoryListModel(json[ApiKey.data]).data
                    } failure: { (e) in
                        CommonFunctions.showToastWithMessage(e.localizedDescription)
                    }
                }
            }
        }
    }
    
    func hitTodaysEvents(){
        let param:JSONDictionary = ["limit":20,"page":1,"sortBy":"time"]
        web.request(from: WebService.todayEvents, param: param, method: .GET, header: [:], loader: false) { [weak self](data, er) in
            guard let self = self else { return }
            if let e = er{
                CommonFunctions.showToastWithMessage(e.localizedDescription)
            }else{
                if let d = data{
                    Parser.shared.getJSONData(data: d) { (json) in
                        self.events = Event.returnEventArray(json[ApiKey.data][ApiKey.data])
                    } failure: { (e) in
                        CommonFunctions.showToastWithMessage(e.localizedDescription)
                    }
                }
            }
        }
    }
}
