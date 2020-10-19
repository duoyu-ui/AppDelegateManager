//
//  PingViewCell.swift
//  NetworkLineDemo
//
//  Created by Tom on 2019/10/29.
//  Copyright © 2019 Tom. All rights reserved.
//

import UIKit
import SnapKit
class PingViewCell: UITableViewCell {
    var item = PingItem(){
        didSet{
            msLab.textColor = .darkGray
            singImgView.image = setSingImg(time: item.timeMilliseconds)
            var msStatus = ""
            switch item.status {
            case .normal,.finished:
                msStatus = "\(String(format: "%.2f", item.timeMilliseconds))ms"
                msLab.textColor = UIColor(red: 64.0 / 255.0, green: 142.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
                indicator.stopAnimating()
                break
            case .error:
                msStatus = "网络错误"
                break
            case .timeout:
                msStatus = "网络超时"
                break
            case .abnormal:
                msStatus = "网络异常"
                break
            case .fail:
                msStatus = "连接失败"
                break
            case .start:
                if item.timeMilliseconds == 0 {
                   msStatus = ""
                }
                break
            default:
//                msStatus = "连接中"
                indicator.startAnimating()
                break
            }
            msLab.text = msStatus
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        initUI()
     
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var bgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()
    lazy var lineLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        lab.font = UIFont.systemFont(ofSize: 16)
        return lab
    }()
    lazy var statusLab: UILabel = {
        let lab = UILabel()
        lab.text = "状态:未连接"
        lab.font = UIFont.systemFont(ofSize: 13)
        lab.textColor = UIColor(red: 128.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
        return lab
    }()
    lazy var singImgView: UIImageView = {
        let imgview = UIImageView()
        return imgview
    }()
    lazy var msLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor(red: 64.0 / 255.0, green: 142.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
        lab.font = UIFont.systemFont(ofSize: 16.0)
        return lab
    }()
    lazy var connectionLab: UILabel = {
        let lab = UILabel()
        lab.layer.cornerRadius = 25
        lab.text = "连接"
        lab.font = UIFont.systemFont(ofSize: 16)
        lab.textColor = UIColor(red: 64.0 / 255.0, green: 142.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
        lab.layer.borderColor = UIColor(red: 64.0 / 255.0, green: 142.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0).cgColor
        lab.layer.borderWidth = 2
        lab.textAlignment = .center
        return lab
    }()
    var indicator = UIActivityIndicatorView.init(style: .gray)
    
}
extension PingViewCell{
    func initUI(){
        self.backgroundColor = UIColor(red: 235.0 / 255.0, green: 237.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
        self.contentView.addSubview(bgView)
        bgView.addSubview(lineLab)
        bgView.addSubview(statusLab)
        bgView.addSubview(singImgView)
        bgView.addSubview(connectionLab)
        bgView.addSubview(msLab)
        bgView.addSubview(indicator)
        bgView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.top.equalTo(5)
            make.left.equalTo(10)
        }
        lineLab.snp.makeConstraints { (make) in
            make.top.left.equalTo(10)
        }
        statusLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(-10)
            make.left.equalTo(10)
        }
        singImgView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 36, height: 19))
        }
        msLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(singImgView.snp.bottom)
            make.left.equalTo(singImgView.snp.right).offset(10)
        }
        
        indicator.snp.makeConstraints { (make) in
            make.bottom.equalTo(singImgView.snp.bottom)
            make.left.equalTo(singImgView.snp.right).offset(40)
        }
        indicator.hidesWhenStopped = true
        connectionLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
            make.right.equalTo(-10)
        }
    }
    func setSingImg(time:Double) -> UIImage {
        
        if time > 0 && time < 20 {
            return UIImage(named: "signal_intensity_5")!
        }else if time > 20 && time < 100{
            return UIImage(named: "signal_intensity_4")!
        }else if time > 100 && time < 200{
            return UIImage(named: "signal_intensity_3")!
        }else if time > 200 && time < 300{
            return UIImage(named: "signal_intensity_2")!
        }else if time > 300{
            return UIImage(named: "signal_intensity_1")!
        }else{
            return UIImage(named: "signal_intensity_6")!
        }
        
        
    }
    
    func setStatusLable(isSelect:Bool){
        if isSelect {
            statusLab.text = "状态:已连接"
            statusLab.textColor = UIColor(red: 64.0 / 255.0, green: 142.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
        }else{
            statusLab.text = "状态:未连接"
            statusLab.textColor = UIColor(red: 128.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
        }
    }
}
