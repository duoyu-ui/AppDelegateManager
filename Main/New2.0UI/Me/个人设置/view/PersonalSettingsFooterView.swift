//
//  PersonalSettingsFooterView.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/8/31.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

class PersonalSettingsFooterView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 100)
        addSubview(saveBtn)
        saveBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(kScreenWidth * 0.7)
            make.height.equalTo(40)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var saveBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle(NSLocalizedString("保存", comment: ""), for: .normal)
        btn.backgroundColor = UIColor.kRedColor
        btn.addRounded(radius: 6)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return btn
    }()
}
