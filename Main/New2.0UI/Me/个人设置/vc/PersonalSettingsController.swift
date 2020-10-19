//
//  PersonalSettingsController.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/8/30.
//  Copyright © 2019 CDJay. All rights reserved.
//  个人信息

import UIKit
import ReusableKit
import CropViewController
import SwiftyJSON

fileprivate enum Reusable {
   static let cell = ReusableCell<PersonalSettingCell>()
}

class PersonalSettingsController: BaseVC {

    // MARK: - var lazy
    
    var dataSource = [PersonalSettingModel]()
    
    var imagePickerCtr = UIImagePickerController()
    
    /// 昵称
    var nick : String?
    /// 签名
    var sign : String?
    /// 头像
    var headPortrait : UIImage?
    /// 性别
    var gender : Int = 0
    
    var imageUrl : String?
    
    // MARK: - Life cyele
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackgroundColor()
        self.navigationItem.title = NSLocalizedString("个人信息", comment: "")
        
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTableData()
    }
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = UIColor.baseBackgroundColor
        table.register(Reusable.cell)
        table.tableFooterView = footerView
        return table
    }()
    
    lazy var footerView: PersonalSettingsFooterView = {
        let view = PersonalSettingsFooterView()
        view.saveBtn.addTarget(self, action: #selector(saveUpInside), for: .touchUpInside)
        return view
    }()
    
    func setupTableView() {
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}


extension PersonalSettingsController {
    
    func setupTableData() {
        self.sign = appModel?.userInfo.personalSignature ?? NSLocalizedString("这个人什么都没留下", comment: "")
        //性别
        var sex = ""
        switch appModel?.userInfo.gender {
        case .male?:
            sex = NSLocalizedString("男", comment: "")
            break
        default:
            sex = NSLocalizedString("女", comment: "")
            break
        }
        
        let model = PersonalSettingModel(type: .iconType, icon: appModel?.userInfo.avatar ?? "user-default", leftTitle: NSLocalizedString("头像", comment: ""), rightTitle: "")
        
        let model1 = PersonalSettingModel(type: .titleType, icon:"", leftTitle: NSLocalizedString("昵称", comment: ""), rightTitle: appModel?.userInfo.nick)
        
        let model10 = PersonalSettingModel(type: .titleType, icon:"", leftTitle: NSLocalizedString("个性签名", comment: ""), rightTitle: appModel?.userInfo.personalSignature ?? NSLocalizedString("这个人什么都没留下", comment: ""))
        
        let model2 = PersonalSettingModel(type: .titleType, icon: "", leftTitle: NSLocalizedString("性别", comment: ""), rightTitle: sex)
        
        let model3 = PersonalSettingModel(type: .noneType, icon: "", leftTitle: NSLocalizedString("账户ID", comment: ""), rightTitle: appModel?.userInfo.userId)
        let model4 = PersonalSettingModel(type: .noneType, icon: "", leftTitle: NSLocalizedString("手机号", comment: ""), rightTitle: appModel?.userInfo.mobile)
        let model5 = PersonalSettingModel(type: .noneType, icon: "", leftTitle: NSLocalizedString("邀请码", comment: ""), rightTitle: appModel?.userInfo.invitecode)
        let model11 = PersonalSettingModel(type: .iconType, icon: "erweima", leftTitle: NSLocalizedString("个人名片", comment: ""), rightTitle: "")
        let model6 = PersonalSettingModel(type: .titleType, icon: "", leftTitle: NSLocalizedString("修改登录密码", comment: ""), rightTitle: NSLocalizedString("设置", comment: ""))
        let model7 = PersonalSettingModel(type: .titleType, icon: "", leftTitle: NSLocalizedString("修改支付密码", comment: ""), rightTitle: NSLocalizedString("设置", comment: ""))
        let model8 = PersonalSettingModel(type: .titleType, icon: "", leftTitle: NSLocalizedString("密码保护", comment: ""), rightTitle: NSLocalizedString("设置", comment: ""))
        let model9 = PersonalSettingModel(type: .titleType, icon: "", leftTitle: NSLocalizedString("绑定银行卡", comment: ""), rightTitle: NSLocalizedString("设置", comment: ""))
        
        dataSource = [model, model1, model10, model2, model3, model4,
                      model5, model11, model6, model7, model8, model9]
        tableView.reloadData();
    }
}


// MARK: - UITableViewDataSource

extension PersonalSettingsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(Reusable.cell, for: indexPath)
        cell.model = dataSource[indexPath.row]
        if indexPath.row == 0 {
            guard let img = self.headPortrait else{ return cell }
            cell.iconImageView.image = img
        }else if indexPath.row == 1 {
            guard let nick = self.nick else{ return cell }
            cell.rightTitleLab.text = nick
        }else if indexPath.row == 2 {
            guard let sign = self.sign else{ return cell }
            cell.rightTitleLab.text = sign
        }else if indexPath.row == 3 {
            guard self.gender > 0 else { return cell }
            cell.rightTitleLab.text = self.gender == 1 ? NSLocalizedString("男", comment: "") : NSLocalizedString("女", comment: "")
        }else if indexPath.row == 5 {
            if appModel?.userInfo.isBindMobile == false {
                let preString = NSAttributedString.init(string: NSLocalizedString("绑定", comment: ""), attributes: [NSAttributedString.Key.foregroundColor:UIColor.blue])
                let valuesString = NSAttributedString.init(string: "  \(cell.model?.rightTitle ?? "")");
                let allString = NSMutableAttributedString.init();
                allString.append(preString)
                allString.append(valuesString)
                cell.rightTitleLab.attributedText = allString
            }
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PersonalSettingsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.row {
            case 0:
                replacePicture()
             break
            
            case 1:
                individualitySignature(indexPath: indexPath, placeholder: appModel?.userInfo.nick ?? "", type: 1) { (content) in
                    self.nick = content ?? ""
                }
             break
            
            case 2:
                individualitySignature(indexPath: indexPath,placeholder: appModel?.userInfo.personalSignature ?? NSLocalizedString("这个人什么都没留下", comment: ""), type: 2) {(content) in
                    self.sign = content ?? ""
                }
             break
            case 3://性别
                sexSelection(indexPath: indexPath)
             break
            case 5:
                if appModel?.userInfo.isBindMobile == false {
                    let vc = FY2020ForgetController()
                    vc.title = NSLocalizedString("绑定手机", comment: "")
                    vc.isNeedChangeNavigation = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                break;
            case 7://个人名片
                let vc = PersonalCardController()
                self.navigationController?.pushViewController(vc, animated: true)
             break
            case 8:
            let vc = FY2020ForgetController()
            vc.title = NSLocalizedString("登录密码修改", comment: "")
            vc.isNeedChangeNavigation = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
            case 9://支付密码
                let vc = FY2020ForgetController()
                vc.title = NSLocalizedString("重设支付密码", comment: "")
                vc.isNeedChangeNavigation = true
                self.navigationController?.pushViewController(vc, animated: true)
             break
            case 10:
                SVProgressHUD.showInfo(withStatus: NSLocalizedString("暂未开放!", comment: ""))
            break
            case 11://设置银行卡
                if ((appModel?.userInfo.isTiedCard)!) {
                    let VC = FYBankcardSelectViewController();
                    VC.isFromPersonSetting = true;
                    self.navigationController?.pushViewController(VC, animated: true)
                } else {
                    let VC = FYAddBankcardViewController();
                    VC.isFromPersonSetting = true;
                    self.navigationController?.pushViewController(VC, animated: true)
                }
             break
        default:
            break
        }
    }
}


// MARK: - Request

extension PersonalSettingsController {
    
    @objc func saveUpInside()  {
        SVProgressHUD.show()
        guard let image = self.headPortrait else {//没换头像
            updateUserInfo()
            return
        }
        
        NetRequestManager.sharedInstance()?.upLoadImageObj(image, success: { [weak self](json) in
            guard let data = json else {
                return
            }
            
            self?.imageUrl = "\(JSON(data).dictionaryObject!["data"]!)"
            self?.updateUserInfo()
            
        }, fail: { (error) in
            
            FunctionManager.sharedInstance()?.handleFailResponse(error)
        })
    }
    
    func updateUserInfo() {
        if (self.sign?.length == 0) {
            self.sign = NSLocalizedString("这个人什么都没留下", comment: "")
        }
        
        NetRequestManager.sharedInstance()?.editUserInfo(withUserAvatar: self.imageUrl ?? appModel?.userInfo.avatar, personalSignature: sign, userNick: self.nick ?? appModel?.userInfo.nick, gender: (appModel?.userInfo.gender)!.rawValue, success: {
            (response) in

            guard let data = response else {
                return
            }
            
            let JSONData = JSON(data).dictionaryObject
            let code = JSON(JSONData?["code"] as Any).int
            if code == 0 {
                SVProgressHUD.showSuccess(withStatus: "\(JSONData?["alterMsg"] ?? "")")
                
                appModel?.userInfo.avatar = self.imageUrl
                appModel?.userInfo.nick = self.nick
                appModel?.userInfo.gender = FYUserGender(rawValue: self.gender)!
                appModel?.userInfo.personalSignature = self.sign
                appModel?.save()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    SVProgressHUD.dismiss()
                    self.navigationController?.popViewController(animated: true)
                })
            }else {
                
                SVProgressHUD.showError(withStatus: "\(JSONData?["alterMsg"] ?? "")")
            }
        }, fail: { (error) in
            guard let data = error else {
                return
            }
            
            let JSONData = JSON(data).dictionaryObject
            if let code = JSON(JSONData?["code"] as Any).int {
                if code == 1 {
                    SVProgressHUD.showInfo(withStatus: "\(JSONData?["alterMsg"] ?? "")")
                }else {
                    FunctionManager.sharedInstance()?.handleFailResponse(JSONData)
                }
            }
        })
    }
    
    ///更换头像
    func replacePicture() {
        
        let alertVc = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVc.addAction(UIAlertAction(title: NSLocalizedString("相册", comment: ""), style: .default, handler: { (_) in
            self.chooseImg(type: .photoLibrary)
        }))
        alertVc.addAction(UIAlertAction(title: NSLocalizedString("拍照", comment: ""), style: .default, handler: { (_) in
            self.chooseImg(type: .camera)
            
        }))
        alertVc.addAction(UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: .cancel, handler: nil))
        self.present(alertVc, animated: true, completion: nil)
    }
    
    ///相册选择或拍照
    func chooseImg(type:UIImagePickerController.SourceType){
        imagePickerCtr.delegate = self
        imagePickerCtr.sourceType = type
        if UIImagePickerController.isSourceTypeAvailable(type){
            self.present(imagePickerCtr, animated: true, completion: nil)
        }else {
            switch type {
            case .camera:
                SVProgressHUD.showInfo(withStatus: NSLocalizedString("请打开照相机权限!", comment: ""))
                break
            case .photoLibrary:
                SVProgressHUD.showInfo(withStatus: NSLocalizedString("请打开相册权限!", comment: ""))
                break
            case .savedPhotosAlbum:
                break
            @unknown default:
                break
            }
        }
        
    }
    
    /// 修改个性签名,昵称
    func individualitySignature(indexPath: IndexPath, placeholder: String, type: Int, content: @escaping (_ content: String?) -> ())  {
        let cell  = self.tableView.cellForRow(at: indexPath) as! PersonalSettingCell
        let index = self.tableView.indexPath(for: cell)
        let rect  = self.tableView.rectForRow(at: index!)
        
        PersonalSettingsSigView.showViewAnimate(rect: rect, placeholder: placeholder) { (text) in
            if (type == 1) {
                if (text?.length == 0) {
                    SVProgressHUD.showInfo(withStatus: NSLocalizedString("昵称", comment: "") + "不能为空！")
                    return
                }
            }
            cell.rightTitleLab.text = text
            content(text)
        }
    }
    
    ///性别选择
    func sexSelection(indexPath: IndexPath) {
        let alertVc = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVc.addAction(UIAlertAction(title: NSLocalizedString("男", comment: ""), style: .default, handler: { (_) in
            appModel?.userInfo.gender = .male
            appModel?.save()
            let cell = self.tableView.cellForRow(at: indexPath) as! PersonalSettingCell
            cell.rightTitleLab.text = NSLocalizedString("男", comment: "")
            self.gender = (appModel?.userInfo.gender)!.rawValue
        }))
        alertVc.addAction(UIAlertAction(title: NSLocalizedString("女", comment: ""), style: .destructive, handler: { (_) in
            appModel?.userInfo.gender = .female
            appModel?.save()
            let cell = self.tableView.cellForRow(at: indexPath) as! PersonalSettingCell
            cell.rightTitleLab.text = NSLocalizedString("女", comment: "")
            self.gender = (appModel?.userInfo.gender)!.rawValue

        }))
        alertVc.addAction(UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: .cancel, handler: nil))
        self.present(alertVc, animated: true, completion: nil)
    }
}

//MARK: - 相册,照相机
extension PersonalSettingsController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        let cropController = CropViewController(croppingStyle: CropViewCroppingStyle.default, image: image)
        cropController.delegate = self
        cropController.aspectRatioPickerButtonHidden = true
        cropController.aspectRatioPreset = .presetSquare
        picker.dismiss(animated: true) {
            self.present(cropController, animated: true, completion: nil)
        }

    }
}


//MARK: - 剪切图片
extension PersonalSettingsController: CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.headPortrait = image.kCrop(ratio: 1)
        let indexPath = IndexPath(row: 0, section: 0)
         let cell = self.tableView.cellForRow(at: indexPath) as! PersonalSettingCell
        cell.iconImageView.image = image.kCrop(ratio: 1)
        cropViewController.dismissAnimatedFrom(self, toView: cell.iconImageView, toFrame: .zero, setup: nil, completion: nil)
    }
}
