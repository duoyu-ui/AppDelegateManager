//
//  MeQueryLogModel.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/9.
//  Copyright © 2019 CDJay. All rights reserved.
//

import Foundation
import HandyJSON

struct MeQueryLogRecords: HandyJSON {
    var id: Int = 0
    var createTime: String?
    var money: CGFloat = 0.0
    var detailButtonDisplayFlag: Bool = false
    var name: String?
    var niuniuFlag: Bool = false
}

struct MeQueryLogData: HandyJSON {
    var totalMoney: CGFloat = 0.0
    var pages: Int = 0
    var current: Int = 0
    var records: [MeQueryLogRecords]?
    var size: Int = 0
    var total: Int = 0
}

struct MeQueryLogModel: HandyJSON {
    var msg: String?
    var data: MeQueryLogData?
    var code: Int = 0
}
