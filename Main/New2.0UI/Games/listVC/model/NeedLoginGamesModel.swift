//
//  NeedLoginGamesModel.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/19.
//  Copyright © 2019 CDJay. All rights reserved.
//

import HandyJSON

class GameCardModel: NSObject, HandyJSON {
    var image: String?
    var isShow: Bool = false
    
    /// 具体游戏列表
    var list: [HaderWavesIconModel]?
    
    init(image: String, list: [HaderWavesIconModel], isShow: Bool) {
        self.image = image
        self.list = list
        self.isShow = isShow
    }
    
    required override init() { }
}


struct FYBoardGamesData: HandyJSON {
    var url: String?
    var returnCode: String?
}

struct NeedLoginGamesModel: HandyJSON {
    var data: FYBoardGamesData?
    var code: Int = 0
    var msg: String?
    var alterMsg: String?
}
