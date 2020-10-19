//
//  PersonalCardController.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/2.
//  Copyright © 2019 CDJay. All rights reserved.
//  个人名片

import UIKit
import SwiftyJSON

class PersonalCardController: BaseVC {
    
    lazy var cardView: PersonalCardView = {
        let view = PersonalCardView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackgroundColor()
        self.navigationItem.title = NSLocalizedString("个人名片", comment: "")
        
        makeUI()
        requestData()
    }
    
    func makeUI() {
        self.view.addSubview(cardView)
        cardView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view).inset(5)
            make.height.equalTo(300)
        }
    }
    
    func requestData() {
        SVProgressHUD.show()
        NetRequestManager.sharedInstance()?.getShareUrl(withCode: "1", success: { (object) in
            guard let data = object else {
                return
            }
            
            let JSONObject = JSON(data).dictionaryObject
            let code = JSON(JSONObject?["code"] as Any).intValue
            if code == 0 {
                SVProgressHUD.dismiss()
                if let baseURL = JSON(JSONObject?["data"] as Any).string {
                    let invitecode = appModel?.userInfo.invitecode ?? ""
                    self.cardView.qrCode = baseURL + invitecode
                }
            }else {
                let message = JSON(JSONObject?["msg"] as Any).string
                SVProgressHUD.showInfo(withStatus: message)
            }
        }, fail: { (object) in
            
            SVProgressHUD.dismiss()
        })
    }
}
