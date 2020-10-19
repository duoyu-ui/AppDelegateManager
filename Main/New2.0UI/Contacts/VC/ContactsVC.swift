//
//  ContactsVC.swift
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/24.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit
import SwiftyJSON
import ReusableKit

/// 通讯录数据类型
enum ContactsDataType: Int {
    case serviceData = 0
    case friendsData = 1
    case myJoinGroup = 2
}

fileprivate struct Reusable {
    static let kContactsCell = ReusableCell<ContactsCell>()
}

class ContactsVC: BaseVC {
    
    private let kSpace: CGFloat = 30
    
    // MARK: - var lazy
    
    /// 当前对应类型数据
    var dataSource: [AnyObject] = []
    
    var selectedView: SessionHeaderSubView?
    var selectedType: ContactsDataType = .myJoinGroup
    
    /// 通讯录所有数据
    var allContacts: [Int : [AnyObject]] = [:]
    
    lazy var addServices: ContactsModel = {
        let model = ContactsModel()
        model.nick = "在线客服"
        model.avatar = "onlineServiceMsgicon"
        model.personalSignature = "有问题 找客服"
        return model
    }()
    
    lazy var leftItemBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "msg-operation-1"), for: .normal)
        button.addTarget(self, selector: #selector(leftItemClick))
        return button
    }()

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UINib.init(nibName: "IMSessionCell", bundle: nil), forCellReuseIdentifier: "kSessionCellIdentifier")
        table.rowHeight = 68
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.backgroundColor = UIColor.clear
        table.register(Reusable.kContactsCell)
        table.separatorStyle = .none
        return table
    }()
    
    var pwdView: EnterPwdBoxView?
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .colorWithHexStr("ffffff")
        return view
    }()
    
    lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .colorWithHexStr("f02835")
        return view
    }()
    
    lazy var menuView: FYMenu = {
        let data: [[String : Any]] = [
            ["icon":"nav_agent","title":"代理中心","class": "AgentCenterViewController"],
            ["icon":"nav_help","title":"新手教程","class": "HelpCenterWebController"],
            ["icon":"nav_redp_play","title":"玩法规则","class":"WebViewController" ],
            ["icon":"nav_createGroupIcon","title":"创建群组","class": "CreateGroupChatController"],
        ]
        
        var array: [FYMenuItem] = []
        for (index, item) in data.enumerated() {
            if index == 1 {
                let menuItem = FYMenuItem.init(image: UIImage.init(named: item["icon"] as! String), title: item["title"] as! String, action: { [weak self] (item) in
                    let vc = HelpCenterWebController(url:"")
                    vc!.hidesBottomBarWhenPushed = true
                    self!.navigationController?.pushViewController(vc!, animated: true)
                })
                array.append(menuItem)
            }else if index == 2 {
                let menuItem = FYMenuItem.init(image: UIImage.init(named: item["icon"] as! String), title: item["title"] as! String, action: { [weak self] (item) in
                    let vc = WebViewController(url: appModel!.ruleString ?? "")
                    vc!.hidesBottomBarWhenPushed = true
                    vc!.navigationItem.title = "玩法规则"
                    self!.navigationController?.pushViewController(vc!, animated: true)
                })
                array.append(menuItem)
            }else if index == 3 {
                let clsStr = item["class"] as! String
                let cls = NSClassFromString(clsStr) as! UIViewController.Type
                let menuItem = FYMenuItem.init(image: UIImage.init(named: item["icon"] as! String), title: item["title"] as! String, action: { [weak self] (item) in
                    if (appModel?.isGuest())! {
                        return;
                    }
                    tryToCreateGroup(fromVC: self!, toVC: clsStr)
                })
                array.append(menuItem)
            }else{
                let clsStr = item["class"] as! String
                let cls = NSClassFromString(clsStr) as! UIViewController.Type
                let menuItem = FYMenuItem.init(image: UIImage.init(named: item["icon"] as! String), title: item["title"] as! String, action: { [weak self] (item) in
                    if (appModel?.isGuest())! {
                        return;
                    }
                    let vc = cls.init()
                    vc.hidesBottomBarWhenPushed = true
                    self!.navigationController?.pushViewController(vc, animated: true)
                })
                array.append(menuItem)
            }
        }
        
        let menu = FYMenu.init(items: array)
        menu.menuCornerRadiu = 5.0
        menu.showShadow = false
        menu.minMenuItemHeight = 48
        menu.titleColor = UIColor.darkGray
        menu.menuBackGroundColor = UIColor.white
        return menu
    }()
    
    lazy var menuList: [HaderWavesIconModel] = {
        let list = [HaderWavesIconModel(icon: "msg-group", title: "我的群组"),
                    HaderWavesIconModel(icon: "msg-friends", title: "我的好友"),
                    HaderWavesIconModel(icon: "msg-operation", title: "在线客服")]
        return list
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "通讯录"
        self.view.backgroundColor = UIColor.white
        
        setupSubview()
        buidRefreshing()
        addNotification()
    }
    
    func setupNavItem() {
        let searchItem = UIBarButtonItem.init(barButtonSystemItem: .search, target: self, action: #selector(searchBtnClick))
        let addMenuItem = UIBarButtonItem.init(image: UIImage.init(named: "nav_add_r"), style: .plain, target: self, action: #selector(showMenuClick))
        self.navigationItem.rightBarButtonItems = [addMenuItem, searchItem]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.leftItemBtn)
    }
    
    func setupSubview() {
        setupNavItem()
        setupHeaderView()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom)
            make.left.right.equalTo(self.view)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(self.view.snp.bottomMargin)
            }
        }
    }
    
    func setupHeaderView() {
        view.addSubview(self.headerView)
        view.addSubview(self.indicatorView)
        
        headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(72)
        }
        
        for (index, model) in menuList.enumerated() {
            let width = kScreenWidth / CGFloat(menuList.count)
            let subview = SessionHeaderSubView(model.icon ?? "", title: model.title ?? "")
            subview.tag = index
            headerView.addSubview(subview)
            subview.snp.makeConstraints { (make) in
                make.width.equalTo(width)
                make.top.bottom.equalToSuperview()
                make.left.equalTo(headerView).offset(CGFloat(index) * width)
            }
            subview.circleView.isHidden = true
            subview.addTarget(self, selector: #selector(headerItemClick(_:)))
            if index == 0 {
                subview.btn.isSelected = true
                selectedView = subview
                let kWidth = (kScreenWidth - kSpace * 4) / 3
                indicatorView.snp.makeConstraints { (make) in
                    make.width.equalTo(kWidth)
                    make.height.equalTo(2)
                    make.bottom.equalTo(headerView)
                    make.centerX.equalTo(selectedView!)
                }
            }
        }
    }
    
    // MARK: - Refreshing
    
    func buidRefreshing() {
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.handleContactsListWithType(self?.selectedType ?? .serviceData)
        })
        
        SVProgressHUD.show()
        handleContactsListWithType(.myJoinGroup)
    }
    
    func endRefreshing() {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        
        if (self.tableView.mj_header != nil && self.tableView.mj_header!.isRefreshing) {
            self.tableView.mj_header?.endRefreshing()
        }
        if (self.tableView.mj_footer != nil && self.tableView.mj_footer!.isRefreshing) {
            self.tableView.mj_footer?.endRefreshing()
        }
    }
  
    // MARK: - Notification
    
    func addNotification() {
        //收到好友或者客服的离线或上线消息
        NotificationCenter.default.addObserver(self, selector: #selector(updateFirend(_:)), name: .init(kNotificationUserOnOffStatusChange), object: nil)
        //加入群,被踢出,被邀请到自建群
        NotificationCenter.default.addObserver(self, selector: #selector(onGroupMessage(_:)), name: .init(kNotificationJoinOrDeletedDidUserGroup), object: nil)
        //主动退出群
        NotificationCenter.default.addObserver(self, selector: #selector(onGroupMessage(_:)), name: .init("kUserExitGroupNotification"), object: nil)
        //群信息刷新
        NotificationCenter.default.addObserver(self, selector: #selector(onGroupMessage(_:)), name: .init("kReloadMyMessageGroupList"), object: nil)
    }
    
    /// 退出群/被加入/被踢出群通知
    @objc func onGroupMessage(_ info: Notification) {
        DispatchQueue.main.async {
            if (self.selectedType == .myJoinGroup) {
                self.handleContactsListWithType(.myJoinGroup)
            }
        }
    }
    
    /// 更新好友数据
    @objc func updateFirend(_ : (Notification)? = nil) {
        DispatchQueue.main.async {
            if (self.selectedType == .friendsData) {
                self.handleContactsListWithType(.friendsData)
            }else if (self.selectedType == .serviceData) {
                self.handleContactsListWithType(.serviceData)
            }
        }
    }
      
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - Handle Contacts List

extension ContactsVC {
    
    /// 根据当前类型获取对应列表数据
    /// - Parameter dataType: 列表类型
    func handleContactsListWithType(_ dataType: ContactsDataType) {
        dataSource.removeAll()
        
        switch dataType {
        case .serviceData:
            handleCustomerServiceData()
            break
        case .friendsData:
            handleMyFriendDataList()
            break
        default:
            handleMyGroupDataList()
            break
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    

    /// 获取客服数据
    func handleCustomerServiceData() {        
        var serviceData: [AnyObject] = []
        serviceData.append(addServices)
        // 先拉取本地记录
        IMUserModule.sharedInstance().getAllServices()
        // 后台获取
        NetRequestManager.sharedInstance()?.requestCustomerServiceSuccess({ (response) in
            if JSON(response as Any).dictionaryObject != nil {
                self.endRefreshing()
                if let JSONObject = JSON(response!).dictionaryObject {
                    if let dataObject = JSON(JSONObject["data"] as Any).dictionaryObject {
                        if let serviceMembers = JSON(dataObject["serviceMembers"] as Any).arrayObject {
                            // deserialize
                            for item in serviceMembers {
                                if let dict = JSON(item).dictionaryObject {
                                    if let model = ContactsModel.deserialize(from: dict) {
                                        model.type = 0
                                        if model.userId != AppModel.shareInstance()?.userInfo.userId {
                                            serviceData.append(model)
                                        }
                                        
                                        let session = IMSessionModule.sharedInstance().getSessionWithUserId(model.userId!)
                                        session?.status = Int32(model.status)
                                        if session != nil {
                                            IMSessionModule.sharedInstance().updateSeesion(session!)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                if (serviceData.count > 0) {
                    self.allContacts[0] = serviceData as [AnyObject]
                    self.dataSource.append(contentsOf: serviceData)
                }
                
                self.reloadDataBySetEmpty(self.tableView)
            }
            self.endRefreshing()
        }, fail: { (error) in
            self.endRefreshing()
            self.reloadDataBySetEmpty(self.tableView)
        })
    }
    
    /// 处理好友数据
    func handleMyFriendDataList() {
        // 后台拉取最新
        NetRequestManager.sharedInstance()?.requestCustomerServiceSuccess({ (response) in
            self.endRefreshing()
            if JSON(response as Any).dictionaryObject != nil {
                var newFriends = [AnyObject]()
                if let JSONObject = JSON(response!).dictionaryObject {
                    if let dataArray = JSON(JSONObject["data"] as Any).dictionaryObject {
                        self.dataSource.removeAll()
                        // 邀请我的好友
                        if let superior = JSON(dataArray["superior"] as Any).arrayObject, superior.count > 0 {
                            let data1 = self.handyContactsModel(superior)
                            for model1 in data1 {
                                newFriends.append(model1)
                            }
                            self.dataSource.append(data1 as AnyObject)
                        }
                        
                        // 我邀请的好友
                        if let subordinate = JSON(dataArray["subordinate"] as Any).arrayObject, subordinate.count > 0 {
                            let data2 = self.handyContactsModel(subordinate)
                            for model2 in data2 {
                                newFriends.append(model2)
                            }
                            self.dataSource.append(data2 as AnyObject)
                        }
                    }
                }
                
                if newFriends.count > 0 {
                    self.allContacts[1] = newFriends as [AnyObject]
                }
            }
            
            self.tableView.reloadData()
            self.endRefreshing()
        }, fail: { (error) in
            self.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    
    func handyContactsModel(_ data: [Any]) -> [ContactsModel] {
        var modelArray: [ContactsModel] = []
        for item in data {
            if let dict = JSON(item).dictionaryObject {
                let model = ContactsModel.deserialize(from: dict)!
                model.type = 1 //好友
                modelArray.append(model)
                let session = IMSessionModule.sharedInstance().getSessionWithUserId(model.userId!)
                session?.status = Int32(model.status)
                if session != nil {
                    session?.friendNick = model.friendNick.isBlank == true ? model.nick : model.friendNick
                    IMSessionModule.sharedInstance().updateSeesion(session!)
                }
            }
        }
        return modelArray
    }
    
    
    /// 处理群组数据
    func handleMyGroupDataList() {
        // 先拉取一次本地
        IMGroupModule.sharedInstance().getAllGroups()
        // 再获取后台
        NetRequestManager.sharedInstance()?.requestSelfJionGrouIsOfficeFlag(false, success: { (response) in
            self.endRefreshing()
            if let JSONObject = JSON(response as Any).dictionaryObject {
                if let JSONData = JSON(JSONObject["data"] as Any).dictionaryObject {
                    var myGroups: [MessageItem] = []
                    if let records = JSON(JSONData["records"] as Any).arrayObject {
                        for item in records {
                            if let dict = JSON(item).dictionaryObject {
                                if let model = MessageItem.initWithDict(dict) {
                                    myGroups.append(model)
                                    if model.officeFlag == false {
                                        IMGroupModule.sharedInstance().updateGroup(withGroupId: model)
                                        updateGroupSession(model.groupId, name: model.chatgName)
                                    }
                                }
                            }
                        }
                        
                        
                        // 更新数据源
                        if myGroups.count > 0 {
                            self.allContacts[2] = myGroups
                            self.dataSource.removeAll()
                            self.dataSource.append(contentsOf: myGroups)
                        }
                        
                        self.tableView.reloadData()
                    }
                }
            }else {
                
                self.tableView.reloadData()
            }
            self.endRefreshing()
        }, fail: { (error) in
            self.endRefreshing()
            self.tableView.reloadData()
            FunctionManager.sharedInstance()?.handleFailResponse(error)
        })
    }
    
    //如果有密码（就调用输入密码）
    private func checkOfficeGroupPwd(_ model: MessageItem, password: String) {
        if password.length > 0 {
            let view = EnterPwdBoxView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight));
            view.joinGroupBtnBlock = {
                [weak self] (pwd) in
                tryJoinToOfficeGroup(model: model, pwd: pwd, formVC: self!)
                self?.pwdView?.remover()
            };
            view.show(in: self.view);
            self.pwdView = view;
            self.tableView.allowsSelection = true
        }else {
            
            tryJoinToOfficeGroup(model: model, pwd: password, formVC: self)
        }
    }
}

// MARK: - Handle ContactsCell Click

extension ContactsVC {
    
    /// 处理客服cell点击
    /// - Parameter model: 客服数据
    func handleCustomerServiceCellClick(_ model: AnyObject) {
        guard let realModel = model as? ContactsModel else {
            return
        }
        
        if realModel.chatId != nil {
            var session = IMSessionModule.sharedInstance().getSessionWithSessionId(realModel.chatId ?? "")
            if session.id == nil {
                session = FYContacts.init(propertiesDictionary: realModel.toJSON())
            }
            let vc = ChatViewController.init(conversationType: .conversationType_CUSTOMERSERVICE, targetId: realModel.chatId)
            vc?.hidesBottomBarWhenPushed = true
            vc?.navigationItem.title = realModel.nick
            vc?.toContactsModel = session
            self.navigationController?.pushViewController(vc!, animated: true)
        }else {
            // web客服
            if let url = AppModel.shareInstance()?.commonInfo["pop"] {
                let webVC = WebViewController(url: url as? String)
                webVC?.title = "联系客服"
                self.navigationController?.pushViewController(webVC!, animated: true)
            }
        }
    }
    
    /// 处理好友cell点击
    /// - Parameter model: 好友数据
    func handleMyFriendCellClick(_ model: AnyObject) {
        guard let model = model as? ContactsModel else {
            return
        }
        
        var session = IMSessionModule.sharedInstance().getSessionWithSessionId(model.chatId ?? "")
        if session.id == nil {
            session = FYContacts.init(propertiesDictionary: model.toJSON())
        }
        
        let vc = ChatViewController.privateChat(withModel: session)
        vc?.toContactsModel = session
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    /// 处理群组cell点击
    /// - Parameter model: 群组数据
    func handleMyGroupCellClick(_ model: AnyObject) {
        if model.isKind(of: MessageItem.self) {
            if let msgItem = model as? MessageItem {
                if msgItem.tryPlayFlag != true {
                    if appModel?.isGuest() ?? false {
                        return;
                    }
                }
                if msgItem.officeFlag {
                     checkOfficeGroupPwd(msgItem, password: msgItem.password ?? "")
                }else {
                    //设置红包游戏类型
                    AppModel.shareInstance()?.gameType = msgItem.type
                    AppModel.shareInstance()?.officeFlag = msgItem.officeFlag
                    let vc = ChatViewController.groupChat(withObj: msgItem)
                    vc?.navigationItem.title = msgItem.chatgName
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
        }
   }
       
}

// MARK: - Header Item Action

extension ContactsVC {
    
    /// 搜索内容处理
    @objc func searchBtnClick() {
        let searchVC = DYSearchVC.searchVC()
        searchVC.selectedSearchBtnCallback = {
           (tableView, text) in
            tableView?.loadLocalDataCallback = {
            [weak self] (result) in
                guard let nowContacts = self?.allContacts else {
                    return
                }
                var handySource: [AnyObject] = []
                for index in 0..<nowContacts.count {
                    if let list = nowContacts[index] {
                        list.forEach { (model) in
                            handySource.append(model)
                        }
                    }
                }

                if handySource.count > 0 {
                    let newSource = handySource.filter({ (data) -> Bool in
                        if let person = data as? ContactsModel {
                            return (person.nick.contains(text)) || (person.friendNick.contains(text))
                        } else if let group = data as? MessageItem {
                            return (group.chatgName.contains(text))
                        }
                        return false
                    })
                    
                    searchVC.searchContents = newSource
                    result(newSource)
                }
            }
            
            tableView?.loadLocalData()
        }
       
        
        searchVC.tableView?.didSelectedCellModelCallback = {
            [weak self] (model) in
            self?.dismiss(animated: true, completion: nil)
            
            if let person = model as? ContactsModel {
                if person.type == 0 {
                    // Servicer
                    self?.handleCustomerServiceCellClick(person)
               } else {
                    // Firends
                    self?.handleMyFriendCellClick(person)
                }
            } else if model.self is MessageItem {
                // Grouped
                self?.handleMyGroupCellClick(model as AnyObject)
           }
       }
       
        self.navigationController?.present(searchVC, animated: true, completion: nil)
    }
    
    @objc func leftItemClick() {
        if let URLString = AppModel.shareInstance()?.commonInfo["pop"] {
            let webVC = WebViewController(url: URLString as? String)
            webVC?.title = "联系客服"
            self.navigationController?.pushViewController(webVC!, animated: true)
        }
    }
    
    @objc func showMenuClick() {
        
        self.menuView.show(from: self.navigationController!, withX: kScreenWidth - 32)
    }
    
    @objc func headerItemClick(_ sender: UITapGestureRecognizer) {
        let subview = sender.view as! SessionHeaderSubView
        if subview.btn.isSelected {
            return
        }
        
        selectedView?.btn.isSelected = false
        subview.btn.isSelected = true
        selectedView = subview
        
        // 滚动索引
        var type = subview.tag
        if type == 0 {
            type = 2
        }else if type == 2 {
            type = 0
        }
        scrollSelectedAtIndex(type, view: selectedView!)
    }
    
    func scrollSelectedAtIndex(_ index: Int, view: SessionHeaderSubView) {
        guard let dataType = ContactsDataType(rawValue: index) else {
            return
        }
        // begin refreshing
        selectedType = dataType
        tableView.mj_header?.beginRefreshing()
        
        let kWidth = (kScreenWidth - kSpace * 4) / 3
        indicatorView.snp.remakeConstraints { (make) in
            make.width.equalTo(kWidth)
            make.height.equalTo(2)
            make.bottom.equalTo(headerView)
            make.centerX.equalTo(view)
        }
        
        self.view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}


// MARK: - UITableViewDataSource && Delegate

extension ContactsVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectedType == .friendsData { //我的好友
            return self.dataSource.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedType == .friendsData {
            return self.dataSource[safe: section]?.count ?? 0
        }
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(Reusable.kContactsCell,for: indexPath)
        if selectedType == .friendsData {
            if self.dataSource.count > indexPath.section {
                if let rowArray = dataSource[safe: indexPath.section] as? [AnyObject] {
                    cell.model = rowArray[safe: indexPath.row]
                }
                // 点击跳转好友详情
                cell.didAvartarClosure = { [weak self] (flag, model) in
                     self?.didCheckFriendInfo(flag, model: model)
                }
            }
        }else {
            
            cell.model = dataSource[safe: indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedType == .friendsData {
            if appModel?.isGuest() ?? false {
                return
            }
            if self.dataSource.count > indexPath.section {
                if let rowArray = dataSource[safe: indexPath.section] as? [AnyObject] {
                    if let dataModel = rowArray[safe: indexPath.row] {
                        handleMyFriendCellClick(dataModel)
                    }
                }
            }
        }else {
            if self.dataSource.count > indexPath.row {
                if let dataModel = dataSource[safe: indexPath.row] {
                    if selectedType == .serviceData {
                        handleCustomerServiceCellClick(dataModel)
                    }else if (selectedType == .myJoinGroup) {
                        handleMyGroupCellClick(dataModel)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if selectedType == .friendsData {
            return 30
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if selectedType == .friendsData {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14)
            label.backgroundColor = UIColor.white
            label.textColor = UIColor.gray
            label.isHidden = dataSource.count > 0 ? false : true
            label.text = section == 0 ? "  邀请我的好友" : "  我邀请的好友"
            return label
        }
        
        return UIView()
    }
    
    /// 查看好友详情
    func didCheckFriendInfo(_ flag: Int, model: AnyObject) {
        if flag == 1003 && model is ContactsModel {
            if let model = model as? ContactsModel {
                var session = IMSessionModule.sharedInstance().getSessionWithSessionId(model.chatId ?? "")
                if session.id != nil {
                    session = FYContacts.init(propertiesDictionary: model.toJSON())
                }else {
                    session = FYContacts()
                    session.sessionId = model.chatId
                    session.userId = model.userId
                    session.avatar = model.avatar;
                    session.nick = model.nick
                }
                
                // detail
                PersonalSignatureVC.push(fromVC: self, requestParams: session,
                                         success: { (any) in
                                            self.updateFirend()
                })
            }
        }
    }
}


// MARK:- DZNEmptyDataSetSource && Delegate

extension ContactsVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.colorWithHexStr("CCCCCC")]
        return NSAttributedString(string: "暂无数据", attributes: attributes)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        self.tableView.mj_header?.beginRefreshing()
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "state_empty")
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return self.dataSource.count == 0
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 5
    }
}
