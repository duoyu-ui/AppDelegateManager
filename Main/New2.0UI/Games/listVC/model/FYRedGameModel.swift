//
//  FYRedGameModel.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/18.
//  Copyright © 2019 CDJay. All rights reserved.
//

import HandyJSON
struct FYRedGameList: HandyJSON {
    
    var type: Int = 0
    var openFlag: Bool = false
    var thumbnail: String?
    var abbreviation: String?
    var ruleImage: String?
    var icon: String?
    var name: String?
}

struct FYRedGameData: HandyJSON {
    
    var list: [FYRedGameList]?
}

struct FYRedGameModel: HandyJSON {
    var code: Int = 0
    var data: FYRedGameData?
    var msg: String?
    
}
