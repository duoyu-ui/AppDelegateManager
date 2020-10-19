//
//  MeUserInfoModel.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/9.
//  Copyright © 2019 CDJay. All rights reserved.
//

import Foundation
import HandyJSON
struct MeUserInfoData: HandyJSON {
    var nick: String?
    var invitecode: String?
    var id: Int = 0
    var deathFlag: Bool = false
    var personalSignature: String?
    var lastUpdateTime: Int = 0
    var levelId: String?
    var frozenMoney: String?
    var needReadLine: Bool = false
    var isTiedCard: Bool = false
    var wechat: String?
    var lastUpdateIp: String?
    var hiddenName: String?
    var shutupFlag: Bool = false
    var robotFlag: Bool = false
    var delFlag: Bool = false
    var kickLimit: String?
    var managerFlag: Bool = false
    var forbidLimit: String?
    var profit: String?
    var birthday: Int = 0
    var email: String?
    var groupowenFlag: Bool = false
    var recharge: String?
    var innerNumFlag: Bool = false
    var createBy: String?
    var payPassword: String?
    var relName: String?
    var avatar: String?
    var domainUrl: String?
    var mobile: String?
    var lastUpdateBy: Int = 0
    var newFlag: Bool = false
    var agentFlag: Int = 0
    var gender: Int = 0
    var createTime: String?
    var qq: String?
    var forbidCause: String?
    var shutupCause: String?
    var forbidFlag: Bool = false
    var clientId: String?
    var forbidTime: String?
    var createIp: String?
    var balance: String?
    var cashDraw: String?
    var levelName: String?
    var inviteFlag: Bool = false
    var userId: Int = 0
    var kickTime: String?
    var isBindMobile: Bool = false
    
    
}

struct MeUserInfoModel: HandyJSON {
    var code: Int = 0
    var data: MeUserInfoData?
    var errorcode: String?
    var msg: String?
    var alterMsg: String?
    
}
