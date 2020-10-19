//
//  GameSearchModel.swift
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/30.
//  Copyright © 2019 CDJay. All rights reserved.
//

import HandyJSON

struct GameCheckStatusModel:HandyJSON {
    var data: GameListData?
    var code: Int = 0
    var errorcode: String?
    var msg: String?
    var alterMsg: String?
}
