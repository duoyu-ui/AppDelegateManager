//
//  MyNetwork.swift
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/31.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

class MyNetwork: DYBaseNetwork {

    /**
     * 获取消所有银行卡列表
     */
    class func getBankList() -> MyNetwork {
        
        let obj = MyNetwork.init();
        
        obj.dy_baseURL = AppModel.shareInstance()!.serverUrl;
        obj.dy_requestUrl = "pay/cashDraws/getSysBankcard";
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        return obj;
        
    }
    
    /**
     * "/pay/cashDraws/getMyBankcard";//获取我的银行卡列表
     */
    class func getMyBankcard() -> MyNetwork {
        
        let obj = MyNetwork.init();
        
        obj.dy_baseURL = AppModel.shareInstance()!.serverUrl;
        obj.dy_requestUrl = "/pay/cashDraws/getMyBankcard/V2";
//                obj.dy_requestUrl = "/kong-pay/cashDraws/getMyBankcard";

        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        return obj;
        
    }
    
    /**
     * 添加提现银行卡
     */
    class func addBankcard(userName: String, bankId: String , cardNO: String, bankCode: String, address: String) -> MyNetwork {
        let obj = MyNetwork.init();
        
        obj.dy_baseURL = AppModel.shareInstance()!.serverUrl;
        obj.dy_requestUrl = "pay/cashDraws/savePayment";
        obj.dy_requestArgument = [
            "user":userName,
            "upaytId":bankId,
            "upayNo":cardNO,
            "code": bankCode,
            "bankRegion":address
        ];
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        return obj;
       
    }
    
    /**
     * 提款
     amount//金额
     userPaymentId//银行id
     uppPayName//名字
     uppayBank//银行名
     uppayAddress//地址
     uppayNo //卡号
     remark //备注
     */
    class func withdraw(amount: String, userPaymentId: String, uppPayName: String, uppayBank: String, uppayAddress: String, uppayNo: String) -> MyNetwork {
        
        let obj = MyNetwork.init();
        obj.dy_baseURL = AppModel.shareInstance()!.serverUrl;
        obj.dy_requestUrl = "pay/cashDraws/cash";
        obj.dy_requestArgument = [
            "amount":amount,
            "userPaymentId":userPaymentId,
            "uppPayName":uppPayName,
            "uppayBank": uppayBank,
            "uppayAddress":uppayAddress,
            "uppayNo":uppayNo
        ];
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        return obj;
        
    }
    
    /**
     * 解绑银行卡
     */
    class func unbindBankcard(_ paymentId: Int) -> MyNetwork {
        
        let obj = MyNetwork.init();
        
        obj.dy_baseURL = AppModel.shareInstance()!.serverUrl;
        obj.dy_requestUrl = "pay/cashDraws/unbandingPayment";
        obj.dy_requestArgument = [
            "paymentId" : paymentId,
        ];
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        return obj;
        
    }
}
