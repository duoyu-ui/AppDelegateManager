//
//  GameSearchModel.swift
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/30.
//  Copyright © 2019 CDJay. All rights reserved.
//

import HandyJSON

class GameListData: HandyJSON {
    
    var accessIcon: String?
    
    var accessWay: String?
    
    var countSum: String?
    
    var displayFlag: String?
    
    var id: String?
    
    var lastUpdateBy: String?
    
    var lastUpdateTime: String?
    
    var maintainEnd: String?
    
    var maintainFlag: Bool?
    
    var maintTotalTime: String?
    
    var maintainStart: String?
    
    var maxIcon: String?
    
    var minIcon: String?
    
    var openFlag: Bool?
    
    var powerFlag: Bool?
    
    var closeFlag: Bool?
    
    var parentId: String?
    
    var showName: String?
    
    var sort: String?
    
    var type : Int = 0
    
    var title: String?
    
    var linkUrl: String?
    
    var iconSize: String?
    
    var index : Int = 0
    
    
    required init() {}
}

class GameTypesData: HandyJSON {
    var index : Int = 0
    
    var type : Int = 0
    
    var count: String?
    
    var openFlag: String?
    
    var showName: String?
    
    var sort: String?
    
    var id: String?
    
    var iconSize: String?
    
    var icon: String?
    
    var list: [GameListData]?
    required init() {}

}
struct GameTypesModel:HandyJSON {
    var data: [GameTypesData]?
    var code: Int = 0
    var errorcode: String?
    var msg: String?
    var alterMsg: String?
}
