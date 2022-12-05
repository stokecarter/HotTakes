//
//  FeatureVM.swift
//  Stoke
//
//  Created by Admin on 17/03/21.
//

import Foundation
import SwiftyJSON

class FeatureListVM{
    
    var dataSource:FeaturedList = FeaturedList(JSON()){
        didSet{
            if let noti = notify { noti() }
        }
    }
    
    var currentPage:Int = 1
    var web:NetworkLayer!
    var notify:(()->())?
    
    init(_ web:NetworkLayer){
        self.web = web
        hitFeaturesApi(loader: true)
    }
    
    func hitFeaturesApi(loader:Bool = false){
        let param:JSONDictionary = ["page":currentPage,
                                    "limit":10]
        web.request(from: WebService.featureList, param: param, method: .GET, header: [:], loader: loader) { [weak self](data, e) in
            guard let self = self else { return }
            if let e = e{
                CommonFunctions.showToastWithMessage(e.localizedDescription)
            }else{
                if let d = data{
                    Parser.shared.getJSONData(data: d) { (json) in
                        if self.currentPage == 1{
                            self.dataSource = FeaturedList(json[ApiKey.data])
                        }else{
                            self.dataSource.data.append(contentsOf: FeaturedList(json[ApiKey.data]).data)
                        }
                    } failure: { (e) in
                        CommonFunctions.showToastWithMessage(e.localizedDescription)
                    }
                }
            }
        }
    }
}
