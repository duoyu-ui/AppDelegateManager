//
//  MeQueryLogHeaderView.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/8.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

protocol MeQueryLogEvent: AnyObject {
    func startTime(time:String)
    func endTime(time:String)
    func allType(btn:UIButton)
}

class MeQueryLogHeaderView: UIView {
    
    // MARK: - var lazy
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.kLineColor
        return view
    }()
    
    lazy var lineView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.kLineColor
        return view
    }()
    
    ///累计金额
    lazy var moneyView: QuerLogTapView = {
        let view = QuerLogTapView()
        //view.titleLab.text = "累计金额"
        view.imageView.image = UIImage(named: "my-icon1")
        view.conteLab.textColor = .red
        view.conteLab.text = "¥ 0.0"
        return view
    }()
    

    ///开始时间
    lazy var startTimeView: QuerLogTapView = {
        let view = QuerLogTapView()
        view.imageView.image = UIImage(named: "my-icon3")
        view.titleLab.text = "开始时间"
        view.conteLab.textColor = UIColor.kTextColor
        view.conteLab.text = String.time()
        let tap = UITapGestureRecognizer(target: self, action: #selector(startTime))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    /// 结束时间
    lazy var endTimeView: QuerLogTapView = {
        let view = QuerLogTapView()
        view.imageView.image = UIImage(named: "my-icon4")
        view.titleLab.text = "结束时间"
        view.conteLab.textColor = UIColor.kTextColor
        view.conteLab.text = String.time()
        let tap = UITapGestureRecognizer(target: self, action: #selector(endTime))
        view.addGestureRecognizer(tap)
        return view
    }()

    /// 全部类型
    lazy var allTypeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "my-icon6"), for: .normal)
        btn.setTitle("  全部类型", for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15.px)
        btn.addTarget(self, action: #selector(allType), for: .touchUpInside)
        return btn
    }()
    
    weak var delegate : MeQueryLogEvent?
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    private func makeUI() {
        self.backgroundColor = .white
        self.addSubview(lineView)
        self.addSubview(lineView1)
        self.addSubview(allTypeBtn)
        self.addSubview(moneyView)
        self.addSubview(startTimeView)
        self.addSubview(endTimeView)
        let w = kScreenWidth /  2
        let h = 160.0 / 2
        lineView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalToSuperview()
        }
        lineView1.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(0.5)
            make.top.equalToSuperview()
        }
        allTypeBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(w / 2)
            make.height.equalTo(45)
            make.centerY.equalTo(h / 2)
            make.width.equalTo(120)
        }
        moneyView.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.left.equalTo(lineView1.snp.right)
            make.bottom.equalTo(lineView.snp.top)
        }
        endTimeView.snp.makeConstraints { (make) in
            make.bottom.right.equalToSuperview()
            make.left.equalTo(lineView1.snp.right)
            make.top.equalTo(lineView.snp.bottom)
        }
        startTimeView.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.right.equalTo(lineView1.snp.left)
            make.top.equalTo(lineView.snp.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MeQueryLogHeaderView{
    
   @objc private func startTime()  {
        FYDatePickerView.show { [weak self] time in
            self?.startTimeView.conteLab.text = time
            self?.delegate?.startTime(time: time)
        }
    }
    
    @objc private func endTime() {
        FYDatePickerView.show { [weak self] time in
            self?.endTimeView.conteLab.text = time
            self?.delegate?.endTime(time: time)
        }
    }
    
    @objc private func allType(btn : UIButton){
        self.delegate?.allType(btn: btn)
    }

//   private func time() -> String {
//        let today = Date()//当前时间
//        let zone = NSTimeZone.system
//        let interval = zone.secondsFromGMT()
//        let now = today.addingTimeInterval(TimeInterval(interval))
//        let dateformatter = DateFormatter()
//        dateformatter.dateFormat = "YYYY-MM-dd"
//        return dateformatter.string(from: now)
//
//    }
}


class QuerLogTapView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLab)
        self.addSubview(conteLab)
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-40.px)
            make.width.height.equalTo(45)
        }
        
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(5)
            make.bottom.equalTo(imageView.snp.centerY)
        }
        
        conteLab.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(5)
            make.top.equalTo(imageView.snp.centerY).offset(3)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLab: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 15.px)
        return label
    }()
    
    lazy var conteLab: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.kTextColor
        label.font = UIFont.systemFont(ofSize: 13.px)
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
}
