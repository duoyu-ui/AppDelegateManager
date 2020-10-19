//
//  MeMoneyDetailsShowCell.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/10.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

class MeMoneyDetailsShowCell: UITableViewCell {
    
    var model: MeMoneyDetailsRecords? {
        didSet {
            guard let model = model else {
                return
            }
            
            if model.intro!.length > 0 {
                titleLabel.text = model.title! + "（\(model.intro!)）"
            }else {
                titleLabel.text = model.title ?? ""
            }
            
            if model.money >= 0.0 {
                moneyLabel.textColor = HexColor("#2B7822");
            }else {
                moneyLabel.textColor = HexColor("#FE4C56");
            }
            
            dateLable.text = model.createTime
            
            moneyLabel.text = "\(model.money)"
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///名称
    private lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        lab.textColor = UIColor.kTextColor
        lab.font = UIFont.systemFont(ofSize: 13)
        return lab
    }()
    
    ///时间
    private lazy var dateLable: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.kTextColor
        lab.font = UIFont.systemFont(ofSize: 13)
        return lab
    }()
    
    ///金额
    private lazy var moneyLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.RGB(r: 0, g: 137, b: 30)
        lab.font = UIFont.systemFont(ofSize: 13)
        lab.textAlignment = .right
        return lab
    }()

    ///背景
    private lazy var backdropView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.addRound(8)
        return view
    }()
}


extension MeMoneyDetailsShowCell {
    
    func makeUI() {
        self.backgroundColor = UIColor.baseBackgroundColor
        
        self.addSubview(backdropView)
        self.backdropView.addSubview(titleLabel)
        self.backdropView.addSubview(moneyLabel)
        self.backdropView.addSubview(dateLable)
        
        backdropView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(10)
            make.top.equalTo(2)
        }
        
        moneyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.width.equalTo(90)
            make.right.equalTo(-10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(10)
            make.right.equalTo(moneyLabel.snp.left).offset(-10)
        }
        
        dateLable.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.bottom.equalTo(-10)
        }
    }
}
