//
//  PrecisionManager.swift
//  MK-LWallet
//
//  Created by fisker.zhang on 2019/3/15.
//  Copyright © 2019 mtop.one. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON
@objcMembers class PrecisionManager: NSObject {
    
    static let manager = PrecisionManager()
    
    /// 文本输入框小数点位数限制（适用于代理方法）
    func precisionDotNum(_ precision: Int, range: NSRange, allText: String, replaceText: String) -> Bool {
        let newString = (allText as NSString).replacingCharacters(in: range, with: replaceText)
        let expression = "^[0-9]*((\\.|,)[0-9]{0,\(precision)})?$"
        let regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpression.Options.allowCommentsAndWhitespace)
        let numberOfMatches = regex.numberOfMatches(in: newString, options:NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, (newString as NSString).length))
        return numberOfMatches != 0
    }
    
    override init() {}
}

// MARK: - GroupInfo Handler

/// 校验是否能创建群
func tryToCreateGroup(fromVC: UIViewController, toVC: String) -> Void {
    SVProgressHUD.show()
    NetRequestManager.sharedInstance()?.isDisplayCreateGroup([:], successBlock: { (response) in
        guard let result = JSON(response as Any).dictionaryObject else {
            return
        }
        
        if let code = JSON(result["code"] as Any).int {
            if code == 0 {
                SVProgressHUD.dismiss()
                let cls = NSClassFromString(toVC) as! UIViewController.Type
                let vc = cls.init()
                vc.hidesBottomBarWhenPushed = true
                fromVC.navigationController?.pushViewController(vc, animated: true)
            }else {
                
                SVProgressHUD.showError(withStatus: "游戏暂未开放，敬请期待")
            }
        }
        
    }, failureBlock: { (error) in
        
        FunctionManager.sharedInstance()?.handleFailResponse(error)
    })
}


///  进入群游戏
/// - Parameters:
///   - model: 群模型配置
///   - pwd: 群密码
func tryJoinToOfficeGroup(model: MessageItem, pwd: String, formVC: UIViewController? = nil) -> Void {
    appModel?.gameType = model.type
    appModel?.officeFlag = model.officeFlag
    
    //加入群 -> 退出聊天时 -> 再退出群
    SVProgressHUD.show()
    NetRequestManager.sharedInstance()?.getChatGroupJoin(withGroupId: model.groupId, pwd: pwd, success: { (response) in
        guard let object = response else {
            return
        }
       
        
        let result = GameErroeModel.deserialize(from: JSON(object).dictionaryObject)
        
        if result?.code == 0 || result?.errorcode == "19" {
            SVProgressHUD.dismiss()
            let chatVC = ChatViewController.groupChat(withObj: model)
            if formVC != nil {
                formVC?.navigationController?.pushViewController(chatVC!, animated: true)
            }else {
                UIViewController.currentViewController()?.navigationController?.pushViewController(chatVC!, animated: true)
            }
        }else if result?.errorcode == "40001" {
            appModel?.isGuest()
        }else {
            
            SVProgressHUD.showInfo(withStatus: (result?.alterMsg))
        }
        
    }, fail: { (error) in
        SVProgressHUD.dismiss()
        if let error = error as? NSDictionary {
            let errorCode = error["errorcode"] as? String;
            if errorCode == "40001" {
                appModel?.isGuest()
                return;
            }
        }
        FunctionManager.sharedInstance()?.handleFailResponse(error)
    })
}


/// 刷新最新群组信息
func tryHandleCurrentGroupChat() {
    // 先拉取一次本地
    IMGroupModule.sharedInstance().getAllGroups()
    // 再获取后台
    NetRequestManager.sharedInstance()?.requestSelfJionGrouIsOfficeFlag(false, success: { (response) in
        if let JSONObject = JSON(response as Any).dictionaryObject {
            if let JSONData = JSON(JSONObject["data"] as Any).dictionaryObject {
                var myGroups: [MessageItem] = []
                if let records = JSON(JSONData["records"] as Any).arrayObject {
                    for item in records {
                        if let dict = JSON(item).dictionaryObject {
                            if let model = MessageItem.initWithDict(dict) {
                                myGroups.append(model)
                                if model.officeFlag == false {
                                    IMGroupModule.sharedInstance().updateGroup(withGroupId: model)
                                    updateGroupSession(model.groupId, name: model.chatgName)
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }, fail: { (error) in
        
        FunctionManager.sharedInstance()?.handleFailResponse(error)
    })
}

func updateGroupSession(_ groupId: String, name: String) {
    guard let seesion = IMSessionModule.sharedInstance().getSessionWithUserId(groupId) else {
        return
    }
    seesion.name = name
    IMSessionModule.sharedInstance().updateSeesion(seesion)
}

/// 处理好友数据（主要是更新好友状态）
func tryHandleCurrentFriendsData() {
    // 后台拉取最新
    NetRequestManager.sharedInstance()?.requestCustomerServiceSuccess({ (response) in
        
        if JSON(response as Any).dictionaryObject != nil {
            if let JSONObject = JSON(response!).dictionaryObject {
                if let dataArray = JSON(JSONObject["data"] as Any).dictionaryObject {
                    // 邀请我的好友
                    if let superior = JSON(dataArray["superior"] as Any).arrayObject, superior.count > 0 {
                        let data1 = tryHandlerContactsModel(superior)
                        print(data1)
                    }
                    // 我邀请的好友
                    if let subordinate = JSON(dataArray["subordinate"] as Any).arrayObject, subordinate.count > 0 {
                        let data2 = tryHandlerContactsModel(subordinate)
                        print(data2)
                    }
                }
            }
        }
        
    }, fail: { (error) in
        
    })
}


func tryHandlerContactsModel(_ data: [Any]) -> [ContactsModel] {
    var modelArray: [ContactsModel] = []
    for item in data {
        if let dict = JSON(item).dictionaryObject {
            let model = ContactsModel.deserialize(from: dict)!
            model.type = 1 //好友
            modelArray.append(model)
            let session = IMSessionModule.sharedInstance().getSessionWithUserId(model.userId!)
            session?.status = Int32(model.status)
            if session != nil {
                session?.friendNick = model.friendNick.isBlank == true ? model.nick : model.friendNick
                IMSessionModule.sharedInstance().updateSeesion(session!)
            }
        }
    }
    return modelArray
}


/// 比较当前系统和后台应用版本
/// - Parameter systemVersion: 应用系统版本
/// - Parameter serviceVersion: 后台版本
func compareNowVersion(_ systemVersion: String, serviceVersion: String) -> Bool {
    let system = systemVersion.replacingOccurrences(of: ".", with: "")
    let service = serviceVersion.replacingOccurrences(of: ".", with: "")
    let floatSystem = system.floatValue
    let floatService = service.floatValue
    // 如果后台版本大于当前应用系统版本
    if floatService > floatSystem {
        return true
    }
    return false
}

struct GameErroeModel:HandyJSON {
    var code: Int = 0
    var errorcode: String?
    var msg: String?
    var alterMsg: String?
}

