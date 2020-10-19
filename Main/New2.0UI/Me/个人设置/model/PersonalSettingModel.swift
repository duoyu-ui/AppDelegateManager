//
//  PersonalSetting.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/8/31.
//  Copyright © 2019 CDJay. All rights reserved.
//

import Foundation
struct PersonalSettingModel {
    var type : PersonalSettingCellType?
    ///图片
    var icon : String?
    ///左边标题文字
    var leftTitle: String?
    ///右边文字
    var rightTitle: String?
    
}
enum PersonalSettingCellType {
    ///图片类型
    case iconType
    ///标题类型
    case titleType
    ///没箭头
    case noneType
    
    ///隐藏右边文字
    var isTitle:Bool{
        switch self {
        case .titleType:
            return false
        default:
            return true
        }
    }
    ///隐藏头像
    var isIcon:Bool{
        switch self {
        case .iconType:
            return false
        default:
            return true
        }
    }
    //隐藏箭头
    var isHideed:Bool{
        switch self {
        case .noneType:
            return true
        default:
            return false
        }
    }
    
    
}
