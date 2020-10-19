//
//  MeMoneyDetailsCell.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/10.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

class MeMoneyDetailsCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(imgView)
        addSubview(titleLab)
        imgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-15)
            make.width.height.equalTo(35)
            
        }
        titleLab.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imgView.snp.bottom).offset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var imgView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.black
        lab.font = UIFont.systemFont(ofSize: 14.px)
        return lab
    }()
}
