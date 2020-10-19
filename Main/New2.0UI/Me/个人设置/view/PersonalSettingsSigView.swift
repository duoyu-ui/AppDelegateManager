//
//  PersonalSettingsSigView.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/8/31.
//  Copyright © 2019 CDJay. All rights reserved.
//  设置签名

import UIKit


class PersonalSettingsSigView: UIView {
    
    // MARK: - var lazy
    
    var didDetermineBlock: ((String) -> (Void))?
    
    lazy var nickTxField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.clearButtonMode = .always
        return textField
    }()
    
    /// 确定
    lazy var determineBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle(NSLocalizedString("确定", comment: ""), for: .normal)
        btn.addTarget(self, action: #selector(determine), for: .touchUpInside)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = UIColor.kRedColor
        return btn
    }()
    
    
    lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle(NSLocalizedString("取消", comment: ""), for: .normal)
        btn.setTitleColor(UIColor.kTextColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return btn
    }()
    
    lazy var centerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    //背景
    lazy var dropbackView: UIView = {
        let view = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        view.addGestureRecognizer(tap)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
    }()
    

    // MARK: - life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(dropbackView)
        addSubview(centerView)
        centerView.addSubview(nickTxField)
        
        centerView.addSubview(determineBtn)
        centerView.addSubview(cancelBtn)
        dropbackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        centerView.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 150)
        nickTxField.snp.makeConstraints { (make) in
            make.centerX.top.equalToSuperview()
            make.left.equalTo(20)
            make.height.equalTo(50)
        }
        
        determineBtn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(nickTxField.snp.bottom)
            make.height.equalTo(50)
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(determineBtn.snp.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Action

extension PersonalSettingsSigView {
    
    static func showViewAnimate(rect:CGRect,placeholder:String , nick: @escaping (_ nick: String?) -> ()) {
        let window = UIApplication.shared.keyWindow
        let superView = PersonalSettingsSigView()
        superView.isHidden = false
        window?.addSubview(superView)
        superView.frame = window!.bounds
        superView.didDetermineBlock = { text in
            nick(text)
        }
        
        if placeholder.length == 0 {
            superView.nickTxField.placeholder = NSLocalizedString("请输入", comment: "")
        }else {
            superView.nickTxField.text = placeholder
        }
        superView.show(rect: rect)
    }
    
    
    func show(rect: CGRect) {
        nickTxField.becomeFirstResponder()
        UIView.animate(withDuration: 0.25) {
            self.centerView.frame = CGRect(x: 0, y: rect.origin.y + 50 + kStatusHeight + 44, width: kScreenWidth, height: 150)
        }
    }
    
    func hideAnimate()  {
        UIView.animate(withDuration: 0.25, animations: {
            self.centerView.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 150)
        }) { (finished) in
            self.isHidden = true
            self.removeFromSuperview()
        }
    }
    
    
    @objc func dismiss()  {
        nickTxField.resignFirstResponder()
        hideAnimate()
    }
       
    @objc func determine(){
        if ((self.didDetermineBlock) != nil) {
            self.didDetermineBlock?(nickTxField.text ?? "")
        }
        
        dismiss()
    }
}

