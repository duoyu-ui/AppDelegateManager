//
//  MeQueryLogCell.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/9.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

class MeQueryLogCell: UITableViewCell {
    
    var model :MeQueryLogRecords?{
        didSet{
            guard let mode = model else {
                return
            }
            titleLab.text = mode.name ?? ""
            timerLab.text = mode.createTime ?? ""
            moneyLab.text = "\(mode.money)"
            moneyLab.textColor = (mode.money >= 0.0) ? HexColor("#2B7822") : HexColor("#FE4C56")
            if mode.detailButtonDisplayFlag || mode.niuniuFlag {
                detailsLab.isHidden = false
                imgView.isHidden = false
            }else{
                detailsLab.isHidden = true
                imgView.isHidden = true
            }
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.baseBackgroundColor
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///名称
    private lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.kTextColor
        lab.font = UIFont.systemFont(ofSize: 13)
        return lab
    }()
    ///时间
    private lazy var timerLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.kTextColor
        lab.font = UIFont.systemFont(ofSize: 13)
        return lab
    }()
    ///金额
    private lazy var moneyLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.RGB(r: 0, g: 137, b: 30)
        lab.font = UIFont.systemFont(ofSize: 13)
        return lab
    }()
    ///详情
    private lazy var detailsLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.orange
        lab.text = "详情"
        lab.font = UIFont.systemFont(ofSize: 11)
        return lab
    }()
    
    private lazy var imgView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "xiangqing")
        return img
    }()
    ///背景
    private lazy var bgView: UIView = {
        let bg = UIView()
        bg.backgroundColor = UIColor.white
        bg.addRound(8)
        return bg
    }()
}
extension MeQueryLogCell{
    func initUI() {
        self.addSubview(bgView)
        self.bgView.addSubview(titleLab)
        self.bgView.addSubview(imgView)
        self.bgView.addSubview(detailsLab)
        self.bgView.addSubview(moneyLab)
        self.bgView.addSubview(timerLab)
        bgView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(10)
            make.top.equalTo(2)
        }
        imgView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(-10)
            make.width.height.equalTo(10)
        }
        detailsLab.snp.makeConstraints { (make) in
            make.right.equalTo(imgView.snp.left).offset(-3)
            make.centerY.equalTo(imgView)
        }
        titleLab.snp.makeConstraints { (make) in
            make.top.left.equalTo(10)
        }
        timerLab.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.bottom.equalTo(-10)
        }
        moneyLab.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.right.equalTo(-10)
        }
    }
}
