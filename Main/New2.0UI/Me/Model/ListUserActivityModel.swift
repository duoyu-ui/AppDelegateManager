//
//  ListUserActivityModel.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/8.
//  Copyright © 2019 CDJay. All rights reserved.
//

import Foundation
import HandyJSON
struct ListUserActivityModel:HandyJSON {
    var data: [ListUserData]?
    var code: Int = 0
    var msg: String?
}

struct ListUserCategory: HandyJSON {
    var value: Int = 0
    var name: String?
    var title: String?
}

struct ListUserChildList: HandyJSON {
    var category: [ListUserCategory]?
    var openFlag: Bool = false
    var parentId: Int = 0
    var id: Int = 0
    var type: Int = 0
    var name: String?
    var icon: String?
    
}

struct ListUserData: HandyJSON {
    /// 父id
    var parentId: Int = 0
    var id: Int = 0
    ///子活动
    var childList: [ListUserChildList]?
    ///活动类型
    var type: Int = 0
    ///是否开放
    var openFlag: Bool = false
    var icon: String?
    var name: String?
    var selectedIcon: String?
}
