//
//  PersonalCardView.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/2.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit
import Kingfisher

class PersonalCardView: UIView {
    
    var qrCode: String? {
        didSet {
            kLog(qrCode)
            guard let url = qrCode else {
                return
            }
            
            qrCodeView.image = UIImage.createQRForString(url, qrScale: 180)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addRounded(radius: 8)
        addSubview(headerView)
        addSubview(qrCodeView)
        addSubview(nameLab)
        addSubview(IinviteCodeBtn)
        addSubview(singLab)
        addSubview(ssLab)
        addSubview(redLab)
        addSubview(genderView)
        headerView.snp.makeConstraints { (make) in
            make.top.left.equalTo(20)
            make.width.height.equalTo(50)
        }
        if appModel?.userInfo.avatar != nil && (appModel?.userInfo.avatar.hasPrefix("http"))! {
            headerView.kf.setImage(with: URL(string: (appModel?.userInfo.avatar!)!))
        }else{
           headerView.image = UIImage(named: "user-default")
        }
        IinviteCodeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(headerView.snp.centerY)
            make.height.equalTo(16)
            make.width.equalTo(80)
            make.left.equalTo(headerView.snp.right).offset(10)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(IinviteCodeBtn)
            make.bottom.equalTo(IinviteCodeBtn.snp.top).offset(-5)
        }
        singLab.snp.makeConstraints { (make) in
            make.left.equalTo(IinviteCodeBtn.snp.left)
            make.top.equalTo(IinviteCodeBtn.snp.bottom).offset(5)
        }
        ssLab.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.top.equalTo(headerView.snp.top)
        }
        redLab.snp.makeConstraints { (make) in
            make.right.equalTo(ssLab.snp.right)
            make.top.equalTo(ssLab.snp.bottom).offset(5)
        }
        genderView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab.snp.right).offset(5)
            make.centerY.equalTo(nameLab)
            make.width.height.equalTo(15)
        }
        qrCodeView.snp.makeConstraints { (make) in
            make.width.height.equalTo(180)
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.snp.bottom).offset(-20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///二维码
    private lazy var qrCodeView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    ///头像
    private lazy var headerView: UIImageView = {
        let img = UIImageView()
        img.addRounded(radius: 8)
        return img
    }()
    
    ///个性签名
    private lazy var singLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.kTextColor
        lab.text = appModel?.userInfo.personalSignature
        lab.font = UIFont.systemFont(ofSize: 12)
        return lab
    }()
    
    ///名字
    private lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.kTextColor
        lab.text = appModel?.userInfo.nick ?? ""
        lab.font = UIFont.systemFont(ofSize: 12)
        return lab
    }()
    
    ///邀请码
    private lazy var IinviteCodeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "IinviteCodeIcon"), for: .normal)
        btn.setTitle("  邀请码:\(appModel?.userInfo.invitecode ?? "0000")", for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 9)
        btn.addRounded(radius: 7)
        btn.backgroundColor = UIColor.orange
        return btn
    }()
    
    private lazy var ssLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.kTextColor
        lab.text = "扫一扫下面的二维码"
        lab.font = UIFont.systemFont(ofSize: 12)
        return lab
    }()
    
    private lazy var redLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.orange
        lab.text = "快来一起游戏领红包"
        lab.font = UIFont.systemFont(ofSize: 12)
        return lab
    }()
    
    ///性别
    private lazy var genderView: UIImageView = {
        let img = UIImageView()
        let icon = appModel?.userInfo.gender == .male ? "nan":"nv"
        img.image = UIImage(named: icon)
        return img
    }()
}
