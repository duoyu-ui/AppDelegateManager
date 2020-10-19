//
//  PersonalSettingCell.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/8/31.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit
import Kingfisher

class PersonalSettingCell: UITableViewCell {
    
    var model: PersonalSettingModel? {
        didSet {
            arrowImageView.isHidden = (model?.type!.isHideed)!
            if (model?.type!.isHideed)! && model?.type == .noneType {
                rightTitleLab.snp.remakeConstraints { (make) in
                    make.right.equalTo(-10)
                    make.centerY.equalToSuperview()
                }
            }
            
            titleLabel.text = model?.leftTitle
            iconImageView.isHidden = (model?.type!.isIcon)!
            rightTitleLab.text = model?.rightTitle
            rightTitleLab.isHidden = !(model?.type!.isIcon)!
            
            if model?.rightTitle == "未设置" {
                rightTitleLab.textColor = UIColor.kRedColor
            }
                        
            if let imageURL = model?.icon {
                if (imageURL.hasPrefix("http")) {
                    iconImageView.setImageWithURL(imageURL, placeholder: UIImage(named: "user-default")!)
                }else {
                    iconImageView.image = UIImage(named: imageURL)
                }
            }
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.colorWithHexStr("FFFFFF")
        self.contentView.backgroundColor = UIColor.colorWithHexStr("FFFFFF")
        
        addSubview(titleLabel)
        addSubview(rightTitleLab)
        addSubview(iconImageView)
        addSubview(arrowImageView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
            make.right.equalTo(self.snp.centerX)
        }
        
        arrowImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
            make.width.equalTo(12)
            make.height.equalTo(18)
        }
        
        rightTitleLab.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.right.equalTo(arrowImageView.snp.left).offset(-5)
            make.centerY.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(35)
//            make.top.equalTo(5)
//            make.width.lessThanOrEqualTo(self.snp.height).offset(-10)
            make.right.equalTo(arrowImageView.snp.left).offset(-5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - var lazy
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.kTextColor
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    ///右边
    lazy var rightTitleLab: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.kTextColor
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "user-default")
        imageView.addRounded(radius: 8)
        return imageView
    }()
    
    /// 箭头
    lazy var arrowImageView: UIImageView = {
        let arrowView = UIImageView()
        arrowView.image = UIImage(named: "right_arrow")
        return arrowView
    }()
}
