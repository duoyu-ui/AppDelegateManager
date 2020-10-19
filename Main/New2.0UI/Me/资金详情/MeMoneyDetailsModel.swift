//
//  MeMoneyDetailsModel.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/10.
//  Copyright © 2019 CDJay. All rights reserved.
//

import Foundation
import HandyJSON

struct MeMoneyDetailsExtras: HandyJSON {
    var money_sum: CGFloat = 0.0
    
}

struct MeMoneyDetailsRecords: HandyJSON {
    var money: CGFloat = 0.0
    var name: String?
    var billtId: Int = 0
    var id: Int = 0
    var userId: Int = 0
    var title: String?
    var bizId: Int = 0
    var intro: String?
    var createTime: String?
    var showDetail: Bool = false
}

extension MeMoneyDetailsRecords {
    
    var cellHeight: CGFloat {
        get {
            var titleContent = self.title ?? ""
            if self.intro!.length > 0 {
                titleContent = self.title! + "（\(self.intro!)）"
                let width = kScreenWidth - 120
                let height = titleContent.getTextMaxHeigh(UIFont.systemFont(ofSize: 13), width: width)
                return height + 55
            }else {
                return 65
            }
        }
    }
}

struct MeMoneyDetailsData: HandyJSON {
    var extras: MeMoneyDetailsExtras?
    var pages: Int = 0
    var size: Int = 0
    var records: [MeMoneyDetailsRecords]?
    var current: Int = 0
    var total: Int = 0
    
}

struct MeMoneyDetailsModels: HandyJSON {
    var msg: String?
    var data: MeMoneyDetailsData?
    var code: Int = 0
    
}
