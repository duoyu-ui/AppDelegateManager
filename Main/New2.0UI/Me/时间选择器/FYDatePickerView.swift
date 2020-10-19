//
//  FYDatePickerView.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/9.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

typealias completion =  (_ date: String) -> ()

class FYDatePickerView: UIView {
    
    var time : String?
    
    var completionHandlers : completion?
    
    // MARK: - lazy var
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.maximumDate = Date()
        picker.backgroundColor = UIColor.white
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        picker.locale = Locale(identifier: "zh-Hans") //默认中文显示
        picker.datePickerMode = .date
        return picker
    }()
    
    lazy var backdropView: UIView = {
        let view = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancel))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var toolBar: UIToolbar = {
        let tool = UIToolbar()
        let cancelItem = UIBarButtonItem(title: "   取消", style: .plain, target: self, action: #selector(cancel))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let determineItem = UIBarButtonItem(title: "确定  ", style: .plain, target: self, action: #selector(determine))
        tool.setItems([cancelItem, spaceItem, determineItem], animated: false)
        return tool
    }()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" //默认格式
        formatter.locale = Locale.current
        return formatter
    }()
    
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(backdropView)
        self.addSubview(datePicker)
        self.addSubview(toolBar)
        
        backdropView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        datePicker.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(216)
        }
        
        toolBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(datePicker.snp.top)
            make.height.equalTo(40)
        }
    }
    
    
    static func show(completionHandler:@escaping(_ time:String) -> ()){
        let window = UIApplication.shared.keyWindow
        let datePick = FYDatePickerView()
        window?.addSubview(datePick)
        datePick.snp.makeConstraints { (make) in
            make.left.top.height.right.equalToSuperview()
        }
        datePick.completionHandlers = { time in
            completionHandler(time)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension FYDatePickerView {
    
    /// 传入日期选择到对应日期(默认格式：yyyy/MM/dd)
    ///
    /// - Parameter dateString: 日期
    func selectToDate(_ dateString: String) {
        if dateString.isEmpty == false {
            if let date = self.dateFormatter.date(from: dateString) {
                self.datePicker.setDate(date, animated: false)
            }
        }
    }
}


// MARK: - Action

extension FYDatePickerView {
    
    @objc private func dateChanged(datePicker: UIDatePicker) {
        self.time = dateFormatter.string(from: datePicker.date)
    }
    
    ///取消
    @objc func cancel() {
        dismiss()
    }
    
    ///确定
    @objc func determine(){
        self.completionHandlers?(self.time ?? String.time())
        dismiss()
    }
    
    ///消失
    func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: kScreenHeight);
        }) { (_) in
            self.isHidden = true
            for v in self.subviews {
                v.removeFromSuperview()
            }
        }
    }
    
}
