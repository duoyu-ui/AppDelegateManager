//
//  SystemSettingHeaderView.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/8/31.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

class SystemSettingFooterView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(exitBtn)
        exitBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(kScreenWidth * 0.7)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var exitBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.kRedColor
        btn.setTitle(NSLocalizedString("安全退出", comment: ""), for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addRounded(radius: 6)
        return btn
    }()

}
