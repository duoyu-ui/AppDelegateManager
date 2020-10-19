//
//  IMMessageNetwork.swift
//  Project
//
//  Created by fangyuan on 2019/8/20.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

/**
 * 即时通讯消息功能 相关接口
 */
@objcMembers class IMMessageNetwork: DYBaseNetwork {

    /**
    * 获取我加入/创建的自建群群组列表
    * officeFlag是否自建群 0：自建群 1:官方群
    */
//    class func getJoinSelfGroupGroupList(_ pageIndex: Int, pageSize: Int, officeFlag: Bool) -> IMMessageNetwork {
//
//        let obj = IMMessageNetwork.init();
//
//        obj.dy_baseURL = AppModel.shareInstance()!.serverUrl;
//        obj.dy_requestUrl = "li-social/skChatGroup/joinSelfGroupPage";
//        obj.dy_requestArgument = [
//                "size":pageSize,
//                "sort":"id",
//                "isAsc":false,
//                "current":pageIndex,
//                "officeFlag":officeFlag
//        ];
//        obj.dy_requestMethod = .POST;
//        obj.dy_requestSerializerType = .JSON;
//        return obj;
//    }
    
    /**
     * 获取我加入的群组列表
     * officeFlag是否自建群 0：自建群 1:官方群
     */
//    class func getMyGroupList(_ pageIndex: Int, pageSize: Int, officeFlag: Bool) -> IMMessageNetwork {
//        
//        let obj = IMMessageNetwork.init();
//        
//        obj.dy_baseURL = AppModel.shareInstance()!.serverUrl;
//        obj.dy_requestUrl = "social/skChatGroup/joinGroupPage";
//        obj.dy_requestArgument = [
//                "size":pageSize,
//                "sort":"id",
//                "isAsc":false,
//                "current":pageIndex,
//                "officeFlag":officeFlag
//        ];
//        obj.dy_requestMethod = .POST;
//        obj.dy_requestSerializerType = .JSON;
//        return obj;
//        
//    }
    
    /**
     * 根据群组id获取群组信息
     */
//    class func getGroupInfo(groupId: String) -> IMMessageNetwork {
//        let obj = IMMessageNetwork.init();
//
//        obj.dy_baseURL = AppModel.shareInstance()!.serverUrl;
//        obj.dy_requestUrl = "social/skChatGroup/";
//        obj.dy_requestArgument = [
//            "id":groupId
//        ];
//        obj.dy_requestMethod = .POST;
//        obj.dy_requestSerializerType = .JSON;
//        return obj;
//
//    }
    
    /**
     * 加入群
     */
//    class func addGroup(groupId: String, pwd: String) -> IMMessageNetwork {
//        let obj = IMMessageNetwork.init();
//
//        obj.dy_baseURL = AppModel.shareInstance()!.serverUrl;
//        obj.dy_requestUrl = "social/skChatGroup/join";
//        obj.dy_requestArgument = [
//            "id":groupId,
//            "pwd": pwd,
//        ];
//        obj.dy_requestMethod = .POST;
//        obj.dy_requestSerializerType = .JSON;
//        return obj;
//
//    }
    
    
    /**
     * 邀请入群
     */
//    class func inviteToGroup(_ groupId: String, usersId: [String]) -> IMMessageNetwork {
//        let obj = IMMessageNetwork.init();
//
//        obj.dy_baseURL = AppModel.shareInstance()!.serverUrl;
//        obj.dy_requestUrl = "social/skChatGroup/invite";
//        obj.dy_requestArgument = [
//            "id":groupId,
//            "userIds": usersId,
//        ];
//        obj.dy_requestMethod = .POST;
//        obj.dy_requestSerializerType = .JSON;
//        return obj;
//
//    }
    
    /**
     * 自建群-邀请入群
     */
//    class func selfGroupToInvite(_ groupId: String, usersId: [String]) -> IMMessageNetwork {
//        let obj = IMMessageNetwork.init();
//
//        obj.dy_baseURL = AppModel.shareInstance()!.serverUrl;
//        obj.dy_requestUrl = "li-social/skChatGroup/selfGroupInvite";
//        obj.dy_requestArgument = [
//            "id":groupId,
//            "userIds": usersId,
//        ];
//        obj.dy_requestMethod = .POST;
//        obj.dy_requestSerializerType = .JSON;
//        return obj;
//    }
    
    /**
     * 分页查询群邀请记录
     */
//    class func getMyGroupVerifications(_ pageIndex: Int, pageSize: Int) -> IMMessageNetwork {
//        let obj = IMMessageNetwork.init();
//
//        obj.dy_baseURL = AppModel.shareInstance()!.serverUrl;
//        obj.dy_requestUrl = "social/skChatGroupInvite/selectPage";
//        obj.dy_requestArgument = [
//            "current":pageIndex,
//            "size": pageSize,
//        ];
//        obj.dy_requestMethod = .POST;
//        obj.dy_requestSerializerType = .JSON;
//        return obj;
//
//    }
    
    /**
     * 拒绝或同意群邀请 opFlag 0：发起邀请；1：同意邀请；2：删除
     */
//    class func operateGroupVerification(_ id: String, opFlag: Int) -> IMMessageNetwork {
//        let obj = IMMessageNetwork.init();
//
//        obj.dy_baseURL = AppModel.shareInstance()!.serverUrl;
//        obj.dy_requestUrl = "social/skChatGroupInvite/updateInvite";
//        obj.dy_requestArgument = [
//            "id":id,
//            "opFlag": opFlag,
//        ];
//        obj.dy_requestMethod = .POST;
//        obj.dy_requestSerializerType = .JSON;
//        return obj;
//
//    }
    
    
    /**
     * 退出群组
     */
//    class func quitGroup(_ id: String) -> IMMessageNetwork {
//        let obj = IMMessageNetwork.init();
//
//        obj.dy_baseURL = AppModel.shareInstance()!.serverUrl;
//        obj.dy_requestUrl = "social/skChatGroup/quit";
//        obj.dy_requestArgument = [
//            "id":id,
//        ];
//        obj.dy_requestMethod = .POST;
//        obj.dy_requestSerializerType = .JSON;
//        return obj;
//
//    }
    
    /**
     * 获取消息公告  0查系统公告，1查平台公告
     */
//    class func getMessageNotifications(_ pageIndex: Int, pageSize: Int, type: Int) -> IMMessageNetwork {
//        let obj = IMMessageNetwork.init();
//
//        obj.dy_baseURL = AppModel.shareInstance()!.serverUrl;
////        obj.dy_baseURL = "http://10.10.95.19:16000";
//        obj.dy_requestUrl = "social/basic/noticePage";
//        obj.dy_requestArgument = [
//            "current":pageIndex,
//            "size": pageSize,
//            "queryParam":["noticeType": type]
//        ];
//        obj.dy_requestMethod = .POST;
//        obj.dy_requestSerializerType = .JSON;
//        return obj;
//
//    }
}
