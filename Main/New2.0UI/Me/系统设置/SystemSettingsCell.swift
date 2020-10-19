
//
//  SystemSettingsCell.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/8/30.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

class SystemSettingsCell: UITableViewCell {
    
    var model: SettingsModel? {
        didSet {
            if model!.title == "声音提示" {
                sySwitch.isOn = appModel!.turnOnSound
            }else {
                sySwitch.isOn = appModel!.granted
            }
            
            titleLab.text = model?.title
            sySwitch.isHidden = (model?.type.isSwitchHidden)!
            arrowView.isHidden = (model?.type.isArrowHidden)!
            iconImageView.image = UIImage(named: (model?.icon)!)
            contentLab.text = model?.iconTitle
            iconImageView.isHidden = (model?.type.isHidden)!
            contentLab.isHidden = (model?.type.isHidden)!
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.white
        
        addSubview(titleLab)
        addSubview(contentLab)
        addSubview(iconImageView)
        addSubview(arrowView)
        addSubview(sySwitch)
        
        
        titleLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
        }
        
        sySwitch.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
        }
        
        arrowView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(12)
            make.height.equalTo(18)
            make.right.equalTo(-10)
        }
        
        contentLab.snp.makeConstraints { (make) in
            make.right.equalTo(arrowView.snp.left).offset(-5)
            make.centerY.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
            make.right.equalTo(contentLab.snp.left).offset(-5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    ///标题
    private lazy var titleLab: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.kTextColor
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    /// 内容
    private lazy var contentLab: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.kTextColor
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    /// 箭头
    private lazy var arrowView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "right_arrow")
        return imageView
    }()
    
    /// 开关
    lazy var sySwitch: UISwitch = {
        let switchView = UISwitch()
        return switchView
    }()
}

