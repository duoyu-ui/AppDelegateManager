//
//  FYGamesCategoryCell.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/19.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

class FYGamesCategoryCell: UITableViewCell {

    // MARK: - setter
    
    var model: MessageItem? {
        didSet {
            guard let dataModle = model else {
                return
            }
            
            self.nameLabel.text = dataModle.chatgName;
            self.noticeLabel.text = dataModle.notice;
            self.logoImageView.setImageWithURL(dataModle.img, placeholder: "msg3")
        }
    }
    
    // MARK: - life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.addSubview(logoImageView)
        self.addSubview(nameLabel)
        self.addSubview(noticeLabel)
        self.addSubview(lineView)
        
        logoImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            make.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageView.snp.top).offset(5)
            make.left.equalTo(logoImageView.snp.right).offset(10)
            make.right.equalTo(-20)
        }
        
        noticeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(logoImageView.snp.bottom).offset(-10)
            make.left.equalTo(nameLabel)
            make.right.equalTo(-20)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.left)
            make.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - getter
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.addRound(4)
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16.px)
        return label
    }()
    
    private lazy var noticeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.kTextColor
        label.font = UIFont.systemFont(ofSize: 14.px)
        return label
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.kLineColor
        return view
    }()
}
