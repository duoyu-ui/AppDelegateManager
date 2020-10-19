//
//  SessionHeaderSubView.swift
//  ProjectCSHB
//
//  Created by fangyuan on 2019/9/18.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

class SessionHeaderSubView: UIView {
    
    // MARK: - lazy var
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.kLineColor
        return view
    }()
    
    lazy var circleView: UIView = {
        let view = UIView()
        view.addRounded(radius: 5)
        view.backgroundColor = UIColor.HWColorWithHexString(hex: "#f02835")
        return view
    }()
    
    lazy var btn: DYButton = {
        let btn = DYButton.init(type: .custom)
        btn.direction = 1
        btn.setTitleColor(UIColor.HWColorWithHexString(hex: "#6d6c6e"), for: .normal);
        btn.setTitleColor(UIColor.HWColorWithHexString(hex: "#f02835"), for: .selected);
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 11);
        btn.isUserInteractionEnabled = false
        btn.margin = 10
        return btn
    }()
    
    // MARK: - Life cycle
    
    required init(_ image: String, title: String) {
        super.init(frame: .zero);
        
        self.addSubview(self.btn)
        self.addSubview(self.circleView)
        self.addSubview(self.lineView)
        
        btn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let space: CGFloat = 5
        circleView.snp.makeConstraints { (make) in
            make.width.height.equalTo(10)
            make.right.equalTo(btn.imageView!.snp_right).offset(space)
            make.bottom.equalTo(btn.imageView!.snp_bottom).offset(space)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.btn.setTitle(title, for: .normal)
        self.btn.setImage(UIImage.init(named: image), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
