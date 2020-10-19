//
//  FYGamesCategoryModel.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/19.
//  Copyright © 2019 CDJay. All rights reserved.
//

import HandyJSON

class FYGamesCategorySkChatGroups: NSObject, HandyJSON {
    var robotBettFlag: Bool = false
    var sendWater: Int = 0
    var id: Int = 0
    var delFlag: Bool = false
    var robotTalkPrizeFlag: Bool = false
    var robotBankerFlag: Bool = false
    var lastUpdateBy: Int = 0
    var templateFlag: Int = 0
    var howplayImg: String?
    var rpOverdueTime: Int = 0
    var img: String?
    var password: String?
    var chatWord: Int = 0
    var notice: String?
    var joinSendWater: Int = 0
    var activeFlag: Bool = false
    var minMoney: Int = 0
    var orderNum: Int = 0
    var type: Int = 0
    var simpMaxMoney: Int = 0
    var robotSeniorFlag: Bool = false
    var joinMoney: Int = 0
    var userId: Int = 0
    var robotSeniorTime: Int = 0
    var howplay: String?
    var lastUpdateTime: String?
    var maxCount: Int = 0
    var simpMaxCount: Int = 0
    var foreverDelFlag: Bool = false
    var know: String?
    var robotContinueBankerFlag: Bool = false
    var talkTime: Int = 0
    var groupNum: Int = 0
    var robotSendFlag: Bool = false
    var grabWater: Int = 0
    var robotSendMax: Int = 0
    var robotTalkPrize: Int = 0
    var robotSendTime: Int = 0
    var simpMinMoney: Int = 0
    var rule: String?
    var joinGrabWater: Int = 0
    var robotNormalFlag: Bool = false
    var shutupFlag: Bool = false
    var robotLastFlag: Bool = false
    var robotLastSeniorFlag: Bool = false
    var ruleImg: String?
    var maxMoney: Int = 0
    var robotLastTime: Int = 0
    var robotNormalTime: Int = 0
    var chatgName: String?
    var simpMinCount: Int = 0
    var createTime: String?
    var minCount: Int = 0
    var officeFlag: Bool = false
    var tableOwnerId: String = ""
    
    required override init() { }
}

struct FYGamesCategoryData: HandyJSON {
    var skChatGroups: [[String:Any]]?
    
}

struct FYGamesCategoryModel: HandyJSON {
    var msg: String?
    var data: FYGamesCategoryData?
    var code: Int = 0
    
}

struct FYGamesCategoryDataModel: HandyJSON {
    var records: [[String:Any]]?
    var total: Int = 0
    var pages: Int = 0
    var current: Int = 0
    var size: Int = 0
}

struct FYGamesCategoryResponseModel: HandyJSON {
    var msg: String?
    var data: FYGamesCategoryDataModel?
    var code: Int = 0
}
