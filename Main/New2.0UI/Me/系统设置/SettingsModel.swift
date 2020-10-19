//
//  SettingsModel.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/8/30.
//  Copyright © 2019 CDJay. All rights reserved.
//

import Foundation
///设置模型
struct SettingsModel {
    ///开关按钮是否开启,默认关闭
    var isOpen : Bool = false

    ///图片
    var icon : String = ""
    ///图片旁边的文字
    var iconTitle : String = ""
    ///标题文字
    var title: String = ""
    
    /// cell类型
    var type:SettingsCellType
}


///cell的类型
enum SettingsCellType {
    ///开关
    case switchType
    ///文字
    case titleType
    ///文字和icon
    case titleIconType
    ///图片
    case iconType
    
    case none
    
    ///开关是否隐藏
    var isSwitchHidden:Bool{
        switch self {
        case .switchType:
            return false
        default:
            return true
        }
    }
    
    ///是否隐藏view
    var isHidden:Bool{
        switch self {
        case .none:
            return true
        default:
            return false
        }
    }
    ///是否隐藏箭头,默认隐藏
    var isArrowHidden :Bool{
        switch self {
        case .switchType:
            return true
        default:
            return false
        }
    }
    
}
