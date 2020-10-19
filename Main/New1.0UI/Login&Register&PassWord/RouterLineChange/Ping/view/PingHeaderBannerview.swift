//
//  PingHeaderBannerview.swift
//  NetworkLineDemo
//
//  Created by Tom on 2019/10/29.
//  Copyright © 2019 Tom. All rights reserved.
//

import UIKit

class PingHeaderBannerview: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let scale: CGFloat = 384.0 / 702.0
        self.frame =  CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * scale)
        self.addSubview(banerView)
     
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        banerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var banerView: UIImageView = {
        let imgview = UIImageView(image: UIImage(named: "pingBanner_icon"))
        return imgview
    }()
  
}

class PingTitleHeaderView: UICollectionReusableView {
    let labelTitle = UILabel()
    let labelMessage = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(labelTitle)
        addSubview(labelMessage)
        labelTitle.font = UIFont.systemFont(ofSize: 26);
        labelMessage.font = UIFont.systemFont(ofSize: 15)
        labelTitle.textColor = .black
        labelMessage.textColor = .red
        labelMessage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(16)
            make.bottom.equalToSuperview()
        }
        labelTitle.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
            make.bottom.equalTo(labelMessage.snp.top).offset(-15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PingTitleFooterView: UICollectionReusableView {
    let button = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(15)
            make.height.equalTo(55)
        }
        
        button.setTitle(NSLocalizedString("确定", comment: ""), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage.init(named: "icon_login_button"), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 8, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
