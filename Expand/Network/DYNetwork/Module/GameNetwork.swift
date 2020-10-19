//
//  GameNetwork.swift
//  ProjectCSHB
//
//  Created by fangyuan on 2019/9/6.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

@objcMembers class GameNetwork: DYBaseNetwork {

    /**
     * 获取所有的红包游戏
     */
    class func getPacketGames() -> GameNetwork {
        
        let obj = GameNetwork.init();
        
        obj.dy_baseURL = AppModel.shareInstance()!.serverUrl;
        obj.dy_requestUrl = "social/redBonusTypeConfig/listRedBonusType";
       
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        return obj;
        
    }
    /**
     * 获取所有的红包子游戏
     */
    class func getPacketSubGames(_ type: Int) -> GameNetwork {
        
        let obj = GameNetwork.init();
        
        obj.dy_baseURL = AppModel.shareInstance()!.serverUrl;
        obj.dy_requestUrl = "social/skChatGroup/listOfficialGroup";
        obj.dy_requestArgument = [
            "type" : type,
        ];
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        return obj;
        
    }
}
