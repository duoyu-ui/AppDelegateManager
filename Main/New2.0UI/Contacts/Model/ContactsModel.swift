//
//  ContactsModel.swift
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/24.
//  Copyright © 2019 CDJay. All rights reserved.
//  客服和好友模型

import HandyJSON


class ContactsModel: HandyJSON {
    
    var nick: String = ""
    
    var name: String = ""
    
    var friendNick: String = ""
    
    var avatar: String?
    
    var chatId: String?
    
    var isFriend: String?
    
    var personalSignature: String?
    
    var userId: String?
    
    /// 0:客服，1:好友
    var type: Int = 0
    
    /// 0:离线，1:在线
    var status: Int = 0
    
    /// 0:我邀请的好友，1:邀请我的好友
    var friendType: Int?

    required init() { }
    
}
