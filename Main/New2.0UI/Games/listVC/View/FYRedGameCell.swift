//
//  FYRedGameCell.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/18.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

class FYRedGameCell: UITableViewCell {
    
    class func cellHeightWithModel(_ item: Any) -> CGFloat {
        return 80
    }
    
    var list : GameListData? {
        didSet {
            guard let list = list else {
                return
            }
            let title = NSMutableAttributedString(string: "\(list.showName!)\n", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
            let gzAttr = NSAttributedString(string: list.title!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12)])
            title.append(gzAttr)
            let paraStyle = NSMutableParagraphStyle()
            paraStyle.lineSpacing = 10
            paraStyle.alignment = .left
            title.addAttributes([NSAttributedString.Key.paragraphStyle : paraStyle], range: NSRange(location: 0, length: title.length))
            playGameBtn.setAttributedTitle(title, for: .normal)
            
            guard let isOpenFlag = list.openFlag else {
                return
            }
            
            if isOpenFlag {
                enterGamelab.text = "进入游戏"
                enterGamelab.textColor = UIColor("#fe3565")
            }else {
                enterGamelab.text = "敬请期待"
                enterGamelab.textColor = UIColor("#808080")
            }
            
            enterGamelab.layer.borderWidth = 1
            enterGamelab.layer.cornerRadius = 15
            enterGamelab.layer.borderColor = enterGamelab.textColor.cgColor;
            enterGamelab.layer.masksToBounds = true
            
            guard let imageURL = list.iconSize!.boolValue ? list.maxIcon : list.minIcon else {
                return
            }
            logoImageView.setImageWithURL(imageURL, placeholder: "icon_loading_200_200")
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(playGameBtn)
        addSubview(logoImageView)
        addSubview(enterGamelab)
        addSubview(lineView)
        
        logoImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            make.width.height.equalTo(60)
        }
        
        enterGamelab.snp.makeConstraints { (make) in
            make.width.equalTo(83)
            make.height.equalTo(30)
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
        }
        
        playGameBtn.snp.makeConstraints { (make) in
            make.left.equalTo(logoImageView.snp.right).offset(10)
            make.centerY.equalTo(logoImageView)
            make.right.equalTo(enterGamelab.snp.left).offset(-10)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.right.left.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - getter
    
    lazy var playGameBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.isUserInteractionEnabled = false
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.addRound(8)
        return imageView
    }()
    
    lazy var enterGamelab: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor("#ffffff")
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.kLineColor
        return view
    }()
}
