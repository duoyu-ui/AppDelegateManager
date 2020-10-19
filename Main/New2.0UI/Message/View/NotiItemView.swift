//
//  NotifiesView.swift
//  ProjectCSHB
//
//  Created by fangyuan on 2019/9/18.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

class NotiItemView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.init(x: 0, y: 0, width: 40, height: 60)
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        addSubview(bellButton)
        addSubview(numberLabel)
        
        bellButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        
        numberLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(3);
            make.right.equalToSuperview().offset(-3);
        }
    }
    
    lazy var bellButton: UIButton = {
        let button = UIButton.init(type: .custom);
        button.setImage(UIImage.init(named: "msg-bell"), for: .normal);
        button.isEnabled = false;
        return button;
    }()
    
    @objc lazy var numberLabel: DYUnreadView = {
        let view = DYUnreadView.init();
        view.setUnreadNumber(0);
        view.bgColor = UIColor.white;
        view.textColor = UIColor.red
        return view;
    }()
}
