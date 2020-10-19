//
//  ContactsCell.swift
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/24.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit
import Kingfisher

class ContactsCell: DYTableViewCell {
    
    
    // MARK: - var lazy
    
    /// 点击头像
    var didAvartarClosure: ((Int, AnyObject)->Void)?
    
    lazy var placeholdImage: UIImage = {
        let image = UIImage(named: "msg3")
        return image!
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.HWColorWithHexString(hex: "#6d6c6e")
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var subtitleLab: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.HWColorWithHexString(hex: "#8d8d8d")
        return label
    }()
    
    lazy var avartarView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.image = self.placeholdImage
        imageView.addRounded(radius: 5)
        return imageView
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .colorWithHexStr("c9c9c9")
        return view
    }()
    
    lazy var dropBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .colorWithHexStr("FFFFFF")
        return view
    }()
    
    lazy var agreeBtn: UIButton  = {
        let btn = UIButton.init()
        btn.addRounded(radius: 3)
        btn.setTitle("同意", for: .normal)
        btn.backgroundColor = UIColor.hex("#49af29")
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        btn.addTarget(self, action: #selector(agreeBtnClick), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    lazy var refuseBtn: UIButton = {
        let refuseBtn = UIButton.init()
        refuseBtn.addRounded(radius: 3)
        refuseBtn.setTitle("拒绝", for: .normal)
        refuseBtn.backgroundColor = UIColor.red
        refuseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        refuseBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        refuseBtn.addTarget(self, action: #selector(refuseBtnClick), for: .touchUpInside)
        refuseBtn.isHidden = true
        return refuseBtn
    }()
    
    // MARK: - Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeUI()
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeUI() {
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        
        contentView.addSubview(dropBackView)
        dropBackView.addSubview(avartarView)
        dropBackView.addSubview(nameLabel)
        dropBackView.addSubview(subtitleLab)
        dropBackView.addSubview(lineView)
        
        dropBackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        avartarView.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(14)
            make.top.equalToSuperview().offset(8)
            make.size.equalTo(48)
        })

        nameLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.avartarView.snp.right).offset(8)
            make.top.equalTo(self.avartarView.snp.top)
        })

        subtitleLab.snp.makeConstraints({ (make) in
            make.left.equalTo(self.avartarView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-14)
            make.bottom.equalTo(self.avartarView.snp.bottom).offset(-5)
        })

        lineView.snp.makeConstraints({ (make) in
            make.left.equalTo(nameLabel).offset(-2)
            make.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        })
    }
    
    // MARK: - setter
    
    override var model: AnyObject? {
        didSet {
            guard model != nil else {
                return
            }
            
            if (self.model?.isKind(of: ContactsModel.self))! {
                let realModel = model as! ContactsModel
                
                if (realModel.avatar?.hasPrefix("http"))! {
                    avartarView.setImageWithURL(realModel.avatar!, placeholder: placeholdImage)
                }else {
                    avartarView.setLocalGifWithImage(realModel.avatar ?? "", placeholder: placeholdImage)
                }
                if realModel.type == 1 {
                    avartarView.isUserInteractionEnabled = true
                    avartarView.addTarget(self, selector: #selector(avatorBtnClick))
                }
                if let personalSignature = realModel.personalSignature {
                    if (personalSignature.isBlank) {
                        subtitleLab.text = "个性签名"
                    }else {
                        subtitleLab.text = personalSignature
                    }
                }else {
                    subtitleLab.text = "个性签名"
                }
                
                if (realModel.nick.hasPrefix("在线客服")) {
                    nameLabel.text = realModel.nick
                }else {
                    var username = "-"
                    if (realModel.friendNick.isBlank == true) {
                        username = realModel.nick
                    }else {
                        username = realModel.friendNick
                    }
                    
                    let attrM = NSMutableAttributedString.init(string: username, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.HWColorWithHexString(hex: "#6d6c6e")])
                    let isOnline = NSAttributedString.init(string: realModel.status == 1 ? "在线" : "离线", attributes: [NSAttributedString.Key.foregroundColor : realModel.status == 1 ? UIColor.HWColorWithHexString(hex: "#15cd79") : UIColor.HWColorWithHexString(hex: "#8d8d8d")])
                    attrM.append(NSAttributedString.init(string: "("))
                    attrM.append(isOnline)
                    attrM.append(NSAttributedString.init(string: ")"))
                    nameLabel.attributedText = attrM
                }
                
            } else if (self.model?.isKind(of: MessageItem.self))! {
                let realModel = self.model as! MessageItem
                
                avartarView.setImageWithURL(realModel.img, placeholder: placeholdImage)
                nameLabel.text = realModel.chatgName
                subtitleLab.text = realModel.notice
                
            }else if (self.model?.isKind(of: FYGamesCategorySkChatGroups.self))! {
                let realModel = self.model as! FYGamesCategorySkChatGroups
                
                avartarView.setImageWithURL(realModel.img!, placeholder: placeholdImage)
                nameLabel.text = realModel.chatgName
                subtitleLab.text = realModel.notice
                
            }else if (self.model?.isKind(of: FYGroupVerifiEntity.self))!  {
                let realModel = self.model as! FYGroupVerifiEntity
                
                self.nameLabel.text = realModel.groupName
                self.subtitleLab.text = "邀请您加入此群"
                self.subtitleLab.textColor = UIColor.hex("#49af29")
                self.agreeBtn.isHidden = false
                self.refuseBtn.isHidden = false
                avartarView.setImageWithURL(realModel.groupImg, placeholder: placeholdImage)
            }
        }
    }
    
    // MARK: - Action
    
    @objc private func agreeBtnClick() {
        if self.otherClickFlag != nil {
            self.otherClickFlag?(self.model as Any, 1001)
        }
    }
    
    @objc private func refuseBtnClick() {
        if self.otherClickFlag != nil {
            if self.otherClickFlag != nil {
                self.otherClickFlag?(self.model as Any, 1002)
            }
        }
    }
    
    @objc private func avatorBtnClick() {
        if (self.didAvartarClosure != nil) {
            self.didAvartarClosure?(1003, self.model!)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


