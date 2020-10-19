//
//  FYBannerModel.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/14.
//  Copyright © 2019 CDJay. All rights reserved.
//

import Foundation
import HandyJSON

class FYBannerSkAdvDetailList:NSObject, HandyJSON {
    var advLinkUrl: String?
    var id: Int = 0
    var advSpaceId: Int = 0
    var advPicUrl: String?
    var name: String?
    var linkType: Int = 0
    required override init() {}
}

class FYBannerData:NSObject, HandyJSON {
    var skAdvDetailList: [FYBannerSkAdvDetailList]?
    var id: Int = 0
    var displayWay: Int = 0
    var carouselTime: CGFloat = 0
    var carouselSecTime: Int = 0
    required override init() {}
}

class FYBannerModel:NSObject, HandyJSON {
    var msg: String?
    var data: FYBannerData?
    var code: Int = 0
    required override init() {}
}

@objcMembers
class MarqueeRecords: NSObject, HandyJSON {
    var releaseTime: String?
    var content: String?
    var delFlag: Bool = false
    var id: Int = 0
    var title: String?
    var lastUpdateTime: String?
    var noticeType: Int = 0
    var releaseFlag: Bool = false
    var stickFlag: Int = 0
    var createTime: String?
    
    required override init() {}
}

struct MarqueeData: HandyJSON {
    var size: Int = 0
    var pages: Int = 0
    var current: Int = 0
    var records: [MarqueeRecords]?
    var total: Int = 0
}

struct MarqueeModels: HandyJSON {
    var msg: String?
    var data: MarqueeData?
    var code: Int = 0
}
