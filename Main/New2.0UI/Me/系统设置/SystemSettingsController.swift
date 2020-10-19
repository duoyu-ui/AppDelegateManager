//
//  SystemSettingsController.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/8/30.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit
import ReusableKit
import SwiftyJSON
import SafariServices
import Kingfisher


fileprivate enum Reusable {
    static let cell = ReusableCell<SystemSettingsCell>()
}

/// 系统设置
class SystemSettingsController: BaseVC {

    let fileManager = FileManager.default
    
    // MARK: - var lazy
    
    var dataSource = [SettingsModel]()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = UIColor.baseBackgroundColor
        table.register(Reusable.cell)
        return table
    }()

    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackgroundColor()
        self.navigationItem.title = NSLocalizedString("系统设置", comment: "")
        
        makeUI()
        addNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadDataList()
    }
    
    func makeUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        reloadDataList()
    }
    
    func reloadDataList(){
        dataSource.removeAll()
        let model1  = SettingsModel(isOpen: appModel!.granted, icon: "", iconTitle: "", title: NSLocalizedString("消息通知",comment:""), type: .switchType)
        
        let model2 = SettingsModel(isOpen: appModel!.turnOnSound, icon: "", iconTitle: "", title: NSLocalizedString("声音提示",comment:""), type: .switchType)
        
        let title3 = NSLocalizedString("版本",comment:"")
        let model3 = SettingsModel(isOpen: false, icon: "banben", iconTitle: title3 + ": QG\(currentVersion)", title: NSLocalizedString("版本",comment:""), type: .titleIconType)
        
        let model4 = SettingsModel(isOpen: false, icon: "", iconTitle: "", title: NSLocalizedString("清除缓存",comment:""), type: .none)
        var lineLink = NSLocalizedString("默认线路",comment:"")
        let selectedLine = UserDefaults.standard.value(forKey: "currentURLIndex")
        if selectedLine != nil {
            let selectLine = selectedLine as! String
            lineLink = selectLine
        }
        let model5 = SettingsModel(isOpen: false, icon: "", iconTitle: lineLink, title: NSLocalizedString("选择线路",comment:""), type: .titleType)
         let languageKey :String = UserDefaults.standard.object(forKey: "FYUserLanguageKey") as? String ?? ""
        
        var iconTitle = ""
        if (languageKey.hasPrefix("en")) {
            iconTitle = "English"
        }else if (languageKey.hasPrefix("zh-Hans")){
            iconTitle = "简体中文"
        }else if languageKey.length == 0{
            iconTitle = NSLocalizedString("跟随系统", comment: "")
        }
        let model6 = SettingsModel(isOpen: false, icon: "", iconTitle: iconTitle, title: NSLocalizedString("选择语言",comment:""), type: .titleType)
        dataSource = [model1, model2, model3, model4, model5,model6]
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func addNotification() {
        // 监听app进入前台
        NotificationCenter.default.addObserver(self, selector: #selector(appEnterForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    // 通知权限
    @objc func appEnterForeground() {
        let notiSetting = UIApplication.shared.currentUserNotificationSettings
        if notiSetting?.types == UIUserNotificationType.init(rawValue: 0) {
            appModel?.granted = false
            appModel?.save()
        } else {
            appModel?.granted = true
            appModel?.save()
        }
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}


// MARK: - UITableViewDataSource

extension SystemSettingsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(Reusable.cell,for: indexPath)
        switch indexPath.row {
        case 0:
            cell.sySwitch.addTarget(self, action: #selector(messageNotice), for: .valueChanged)
            break
        case 1:
            cell.sySwitch.isOn = appModel!.turnOnSound
            cell.sySwitch.addTarget(self, action: #selector(voiceSwitch), for: .valueChanged)
            break
        default:
            break
        }
        cell.model = self.dataSource[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = SystemSettingFooterView()
        footerView.exitBtn.addTarget(self, action: #selector(securityExit), for: .touchUpInside)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }

}


// MARK: - UITableViewDelegate

extension SystemSettingsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 3 { //清除缓存
            let cache = fileSizeOfCache()
            SVProgressHUD.show(withStatus: NSLocalizedString("计算缓存文件",comment:""))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                SVProgressHUD.dismiss()
                
                let aleVc = UIAlertController(title:"\(NSLocalizedString("缓存文件",comment:""))\(cache)MB", message: nil, preferredStyle: .alert)
                aleVc.addAction(UIAlertAction(title: NSLocalizedString("清除",comment:""), style: .default, handler: { (_) in
                    self.clearCache()
                }))
                aleVc.addAction(UIAlertAction(title: NSLocalizedString("取消",comment:""), style: .cancel, handler: nil))
                self.present(aleVc, animated: true, completion: nil)
            }
        }
        else if indexPath.row == 2 {
            if let commonInfo = JSON(appModel?.commonInfo as Any).dictionaryObject {
                let systemVersion = currentVersion
                let serviceVersion = JSON(commonInfo["ios.version"] ?? "").string
                // 比较版本号
                if compareNowVersion(systemVersion, serviceVersion: serviceVersion!) {
                    // 去更新
                    let vc = UIAlertController(title: NSLocalizedString("更新版本",comment:""), message: nil, preferredStyle: .alert)
                    let update = UIAlertAction(title: NSLocalizedString("确定",comment:""), style: .default, handler: { (_) in
                        let url = "\(commonInfo["ios.download.path"] ?? "")"
                        if url.hasPrefix("http") {
                            let vc = SFSafariViewController(url: URL(string: url)!)
                            self.present(vc, animated: true, completion: nil)
                        }
                    })
    
                    vc.addAction(update)
                    vc.addAction(UIAlertAction(title: NSLocalizedString("取消",comment:""), style: .cancel, handler: nil))
                    self.present(vc, animated: true, completion: nil)
                }
                else {
                    
                    SVProgressHUD.showInfo(withStatus: NSLocalizedString("已是最新版本QG",comment:"") + systemVersion)
                }
            }
        }else if indexPath.row == 4 {
            self.navigationController!.pushViewController(PingViewController(), animated: true)
        }else if indexPath.row == 5{
            let vc = FYLanguageSelectionController()
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func compareNowVersion(_ systemVersion: String, serviceVersion: String) -> Bool {
        let system = systemVersion.replacingOccurrences(of: ".", with: "")
        let service = serviceVersion.replacingOccurrences(of: ".", with: "")
        let floatSystem = system.floatValue
        let floatService = service.floatValue
        // 如果后台版本大于当前应用系统版本
        if floatService > floatSystem {
            return true
        }
        return false
    }
}


extension SystemSettingsController {
    //缓存文件路径
    func cachePath() -> String? {
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        return cachePath
    }
    
    //缓存文件所有文件夹
    func cachePathFiles() -> [String] {
        guard let cachePath = cachePath(),
        let files = fileManager.subpaths(atPath: cachePath) else { return []}
        return files
    }
    
    ///清除缓存
    func clearCache() {
        let files = cachePathFiles()
        for file in files {
            let path = cachePath()! + ("/\(file)")
            
            let isExists = fileManager.fileExists(atPath: path)
            //判断文件是否存在
            if isExists {
                do {
                    try fileManager.removeItem(atPath: path)
                } catch  {
                    print(error.localizedDescription)
                }
            }
        }
        
        // 清除缓存的图片
        kingfisherClear()
    }
    
    func kingfisherClear() {
        let cache = KingfisherManager.shared.cache
        cache.clearDiskCache()//清除硬盘缓存
        cache.clearMemoryCache()//清理网络缓存
        cache.cleanExpiredDiskCache()//清理过期的，或者超过硬盘限制大小的
    }
    
    func fileSizeOfCache()-> Int {
        // 获取Caches目录路径和目录下所有文件
        let files = cachePathFiles()
        //枚举出所有文件，计算文件大小
        var folderSize :Int = 0
        for file in files {
            // 路径拼接
            let path = cachePath()! + ("/\(file)")
            // 计算缓存大小
            folderSize += fileSizeAtPath(path:path)
        }
        
        return folderSize / (1024 * 1024)
    }
    
    func fileSizeAtPath(path: String) -> Int {
        if fileManager.fileExists(atPath: path) {
            kLog(path)
            let attr = try! fileManager.attributesOfItem(atPath: path)
            return Int(CGFloat(attr[FileAttributeKey.size] as! UInt64))
        }
        return 0
    }
    
    ///声音
    @objc func voiceSwitch(switchView: UISwitch) {
        let switchKey = AppModel.shareInstance()?.userInfo.userId
        UserDefaults.standard.set(switchView.isOn, forKey: switchKey!)
        UserDefaults.standard.synchronize()
        // 保存设置
        appModel!.turnOnSound = switchView.isOn
        appModel!.save()
    }
    
    ///消息通知
    @objc func messageNotice(switchView: UISwitch) {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:]) { (result) in
                if result {
                    let notiSetting = UIApplication.shared.currentUserNotificationSettings
                    if notiSetting?.types == UIUserNotificationType.init(rawValue: 0) {
                        switchView.isOn = false
                    } else {
                        switchView.isOn = true
                    }
                }
            }
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(url)
        }
    }
    
    @objc func securityExit() {
        EasyAlertView.shared.confirmAlert(title: NSLocalizedString("是否退出",comment:""), message: "", vc: self) {
            appModel!.logout()
        }
        
    }
}

