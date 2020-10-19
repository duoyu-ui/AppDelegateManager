//
//  IMMessageCell.swift
//  Project
//
//  Created by fangyuan on 2019/8/20.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit
import Kingfisher

class IMSessionCell: DYTableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var unReadView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var avartarView: UIImageView!
    @IBOutlet weak var lineView: UIView!
    
    lazy var placeholderImage: UIImage = {
        let image = UIImage(named: "msg3")
        return image!
    }()
    
    var realModel: FYContacts?
    
    // MARK: - setter
    
    override var model: AnyObject? {
        didSet {
            if (model?.isKind(of: FYContacts.self))! {
                self.realModel = self.model as? FYContacts
                
                if (realModel?.avatar.isBlank)! {
                    self.avartarView.image = placeholderImage
                }else {
                    self.avartarView.setImageWithURL(realModel?.avatar ?? "", placeholder: placeholderImage)
                }
                
                let message = IMMessageModule.sharedInstance().getMessageWithMessageId(realModel?.lastMessageId ?? "")
                if message.isDeleted || message.isRecallMessage {
                    self.messageLabel.text = "暂未收到消息"
                    realModel?.lastTimestamp = 0
                } else {
                    var replacLastMsg = realModel?.lastMessage ?? "还没收到消息"
                    if (replacLastMsg.contains("null")) {
                        replacLastMsg = replacLastMsg.replacingOccurrences(of: "(null)：", with: "")
                    }
                    self.messageLabel.text = replacLastMsg
                }
                if realModel?.lastTimestamp == nil || realModel?.lastTimestamp == 0 {
                    self.timeLabel.text = ""
                } else {
                    let date = Date.init(timeIntervalSince1970: realModel!.lastTimestamp / 1000)
                    self.timeLabel.text = String().compareCurrentTimeWithDate(date: date)
                }
                
                self.updateGroupAvartar()
                self.unReadView.isHidden = realModel?.unReadMsgCount ?? 0 > 0 ? false : true
            
                if self.realModel?.sessionType == FYChatConversationType.conversationType_PRIVATE {
                    let username = loadUserNick(realModel!)
                    let attrM = NSMutableAttributedString.init(string: username, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.HWColorWithHexString(hex: "#6d6c6e")])
                    let isOnline = NSAttributedString.init(string: self.realModel?.status == 1 ? "在线" : "离线", attributes: [NSAttributedString.Key.foregroundColor : self.realModel?.status == 1 ? UIColor.HWColorWithHexString(hex: "#15cd79") : UIColor.HWColorWithHexString(hex: "#8d8d8d")])
                    attrM.append(NSAttributedString.init(string: "("))
                    attrM.append(isOnline)
                    attrM.append(NSAttributedString.init(string: ")"))
                    self.nameLabel.attributedText = attrM
                    
                } else {
                    
                    self.nameLabel.text = realModel?.name ?? "-"
                }
            }else {
                let contacts = model as! ContactsModel
                
                self.timeLabel.text = ""
                self.unReadView.isHidden = true
                
                if (contacts.avatar?.hasPrefix("http"))! {
                    self.messageLabel.text = loadLastMessage(contacts)
                    self.avartarView.setImageWithURL(contacts.avatar ?? "", placeholder: placeholderImage)
                }else {
                    self.messageLabel.text = contacts.personalSignature
                    self.avartarView.setLocalGifWithImage(contacts.avatar!)
                }
                
                if ((contacts.nick.hasPrefix("在线客服"))) {
                    self.nameLabel.text = contacts.nick
                }else {
                    let attrM = NSMutableAttributedString.init(string: contacts.nick, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.HWColorWithHexString(hex: "#6d6c6e")])
                    let isOnline = NSAttributedString.init(string: contacts.status == 1 ? "在线" : "离线", attributes: [NSAttributedString.Key.foregroundColor : contacts.status == 1 ? UIColor.HWColorWithHexString(hex: "#15cd79") : UIColor.HWColorWithHexString(hex: "#8d8d8d")])
                    attrM.append(NSAttributedString.init(string: "("))
                    attrM.append(isOnline)
                    attrM.append(NSAttributedString.init(string: ")"))
                    self.nameLabel.attributedText = attrM
                }
            }
        }
    }
    
    
    private func loadLastMessage(_ contacts: ContactsModel) -> String {
        let session = IMSessionModule.sharedInstance().getSessionWithUserId(contacts.userId!)
        return session?.lastMessage ?? contacts.personalSignature ?? "暂未收到消息"
    }
    
    private func loadUserNick(_ contacts: FYContacts) -> String {
        let session = IMSessionModule.sharedInstance().getSessionWithUserId(contacts.userId)
        if (session?.friendNick.isBlank == true) {
            return contacts.nick.length > 0 ? contacts.nick : contacts.name
        }else {
            return session?.friendNick ?? contacts.nick ?? ""
        }
    }
    
    private func updateGroupAvartar() {
        
        if self.realModel?.sessionType == FYChatConversationType.conversationType_GROUP {
            guard let id = self.realModel?.id else {
                return
            }
            
            if self.realModel?.name.isBlank == true || self.realModel?.avatar?.isBlank == true {
                //先从数据库中取
                var entity = IMGroupModule.sharedInstance().getGroupWithGroupId(self.realModel?.id ?? "")
                if realModel == nil {
                    //获取群组信息并且跟新数据库会话信息
                    let sendDict = ["id" : id]
                    NetRequestManager.sharedInstance()?.skChatGroup(sendDict, successBlock: { (response) in
                        if let r = response as? [String : Any] {
                            entity = MessageItem.initWithDict(r)
                            self.realModel?.name = entity?.chatgName
                            self.realModel?.avatar = entity?.img
                            IMSessionModule.sharedInstance().updateSeesion(self.realModel!)
                            IMGroupModule.sharedInstance().updateGroup(withGroupId: entity!)
                            self.avartarView.setImageWithURL(self.realModel?.avatar ?? "", placeholder: self.placeholderImage)
                            self.nameLabel.text = self.model?.name
                        }
                    }, failureBlock: { (error) in
                        
                    })
                    
                } else {
                    self.realModel?.avatar = entity?.img
                    self.realModel?.name = entity?.chatgName
                    IMSessionModule.sharedInstance().updateSeesion(self.realModel!)
                    self.avartarView.setImageWithURL(self.realModel?.avatar ?? "", placeholder: placeholderImage)
                    self.nameLabel.text = self.model?.name
                }
                
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = .white
        
        self.avartarView.radius = 5
        self.lineView.backgroundColor = .colorWithHexStr("c9c9c9")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

