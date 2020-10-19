//
//  FYGamesCategoryController.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/19.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit
import JXSegmentedView
import SwiftyJSON
import ReusableKit

fileprivate struct Reusable {
    static let cell = ReusableCell<FYGamesCategoryCell>()
}

class FYGamesCategoryController: UIViewController {
    
    var type: Int = 0
    var isAllType: Bool = false;
    var currentPage: Int = 1;
    var dataSource: [MessageItem] = []
    
    var pwdView: EnterPwdBoxView?
    
    lazy var tableView: UITableView = {
        let tabView = UITableView()
        tabView.tableFooterView = UIView()
        tabView.backgroundColor = UIColor.white
        tabView.register(Reusable.cell)
        tabView.separatorStyle = .none
        tabView.delegate = self
        tabView.dataSource = self
        return tabView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
    }
    
    func makeUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.dataSource.removeAll()
            self?.loadGameList(type: self!.type)
        })
        tableView.mj_header?.beginRefreshing()
        if isAllType {
            tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {[weak self] in
                self?.HTTPAllGame(isFirst: false)
            })
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshGroupInfo(_:)), name: .init("kReloadMyMessageGroupList"), object: nil)
    }
}


extension FYGamesCategoryController {
    
    //刷新群
    @objc func refreshGroupInfo(_ info: Notification) {
        guard let object = info.object else {
            return
        }
        
        let dict = JSON(object).dictionaryObject
        guard let data = JSON(dict!["data"] as Any).dictionaryObject, let chatInfo = data["chatInfo"]  else {
            return
        }
        
        
        let list = FYGamesCategorySkChatGroups.deserialize(from: JSON(chatInfo).dictionaryObject)
        //判断更新的type 是否一样,一样的话就更新新
        if list!.type == self.type {
            DispatchQueue.main.async(execute: {
                self.dataSource.removeAll()
                self.loadGameList(type: list!.type)
            })
        }
    }
   
    func loadGameList(type: Int) {
        self.tableView.allowsSelection = true
        if isAllType {
            HTTPAllGame(isFirst: true)
            return
        }
        SVProgressHUD.show()
        NetRequestManager.sharedInstance()?.requestListOfficialGroup(type, success: {[weak self] (data) in
            SVProgressHUD.dismiss()
            guard let `self` = self,let datas = data else {
                return
            }
            self.dataSource.removeAll()
            self.tableView.mj_header?.endRefreshing()
            
            if let model = FYGamesCategoryModel.deserialize(from: JSON(datas).dictionaryObject) {
                if let skChatGroups = model.data?.skChatGroups {
                    for item in skChatGroups {
                        self.dataSource.append(MessageItem.initWithDict(item))
                    }
                }
            }
            
            self.tableView.reloadData()
            self.configChatList(self.dataSource)
            
            self.reloadDataBySetEmpty(self.tableView)
            
        }, fail: {[weak self] (fail) in
            guard let `self` = self else{return}
            self.tableView.mj_header?.endRefreshing()
            self.reloadDataBySetEmpty(self.tableView)
            FunctionManager.sharedInstance()?.handleFailResponse(fail)
        })
    }
    
    
    func HTTPAllGame(isFirst:Bool){
        SVProgressHUD.show()
        if isFirst {
            currentPage = 1
            dataSource.removeAll()
            tableView.reloadData()
        }else{
            currentPage += 1
        }
        let playFlag = appModel?.loginType() == FYLoginTypeGuest ? "1" : "0"
        let senderDict = ["current":"\(currentPage)",
                          "size":"20",
                          "queryParam":["tryPlayFlag":"\(playFlag)"]] as [String : Any]
        print("request json data:\n\(senderDict.toJSonString())");
        NetRequestManager.sharedInstance()?.listOfficialGroupPage(senderDict, successBlock: {[weak self] (data) in
            SVProgressHUD.dismiss()
            guard let `self` = self,let datas = data else {
                return
            }
            self.tableView.mj_header?.endRefreshing()
            if self.isAllType {
                self.tableView.mj_footer?.endRefreshing()
            }
            if let response = FYGamesCategoryResponseModel.deserialize(from: JSON(datas).dictionaryObject) {
                if let recordsData = response.data {
                    print("page:\(recordsData.pages);current:\(recordsData.current);total:\(recordsData.total)")
                    for item in recordsData.records ?? [[:]] {
                        self.dataSource.append(MessageItem.initWithDict(item))
                    }
                    if recordsData.records?.count ?? 0 < 20 {
                        self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }
            }
            
            self.tableView.reloadData()
            self.configChatList(self.dataSource)
            
            self.reloadDataBySetEmpty(self.tableView)
        }, failureBlock: {[weak self] (failure) in
            guard let `self` = self else{return}
            self.tableView.mj_header?.endRefreshing()
            print("falure data:\(failure)")
            if self.isAllType {
                self.tableView.mj_footer?.endRefreshing()
            }
            self.reloadDataBySetEmpty(self.tableView)
            FunctionManager.sharedInstance()?.handleFailResponse(failure)
        })
    }
    
    func configChatList(_ dataSource: [MessageItem]) {
        var list:[[String:String]] = [[String:String]]()
        for data in dataSource {
            let time = String().stringToMilliStamp()
            list.append(["chatId":data.groupId!,"msgCreateTime":time])
        }
        
        // 此类中已经删除
        // FYIMMessageManager.shareInstance().sendGetOnlyGroupChatNewUnreadMessage(list)
    }
    
    func HTTPCheckJoin(model: MessageItem){
        NetRequestManager.sharedInstance()?.checkJoin(["id":"\(String(describing: model.groupId))"], successBlock: { (response) in
            self.handleEnterGame(model: model)
        }, failureBlock: { (failure) in
            FunctionManager.sharedInstance()?.handleFailResponse(failure);
        })
    }
    
    // MARK: - 进入官方群游戏
    
    func handleEnterGame(model: MessageItem) {
        //点击以后,禁止点击cell
        self.tableView.allowsSelection = false
        guard let password = model.password, password.length > 0 else {
            tryJoinToOfficeGroup(model: model, pwd: "")
            self.tableView.allowsSelection = true
            return
        }
        
        let view = EnterPwdBoxView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight));
        view.joinGroupBtnBlock = { [weak self] (pwd) in
            tryJoinToOfficeGroup(model: model, pwd: pwd)
            self?.pwdView?.remover()
        };
        
        view.show(in: self.view);
        self.pwdView = view;
        self.tableView.allowsSelection = true
    }
    
    func loadDataForFirst() {
        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        self.tableView.mj_header?.beginRefreshing()
    }
}

// MARK: - UITableViewDataSource && Delegate

extension FYGamesCategoryController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(Reusable.cell,for: indexPath)
        if let model = dataSource[safe:indexPath.row] {
            cell.model = model
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = dataSource[safe: indexPath.row] {
            if appModel?.loginType() == FYLoginTypeGuest {
                if model.tryPlayFlag == false {
                    appModel?.isGuest()
                    return;
                }
            }
//            self.HTTPCheckJoin(model: model)
            self.handleEnterGame(model: model)
        }
    }
}


extension FYGamesCategoryController:JXSegmentedListContainerViewListDelegate{
    func listView() -> UIView {
        return view
    }
}


// MARK:- DZNEmptyDataSetSource && Delegate

extension FYGamesCategoryController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        let text = "暂无数据"
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.colorWithHexStr("cccccc")]
        return NSAttributedString(string: text, attributes: attributes)
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
