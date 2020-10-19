//
//  FYRedGameController.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/18.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit
import JXSegmentedView
import ReusableKit
import SwiftyJSON

fileprivate struct Reusable {
    static let cell = ReusableCell<FYRedGameCell>()
    static let bannerCell = ReusableCell<FYRedGameBannerCell>()
    static let baseCell = ReusableCell<UITableViewCell>()
}


class FYRedGameController: UIViewController {
    
    var successBlock: DataBlock?
    
    var requestParams :Any?
    var dataType :NSInteger = 0;
    
    var dataSource = [GameListData]()
    var gameSource = [GameListData]()
    
    lazy var tableView: UITableView = {
        let tabView = UITableView()
        tabView.tableFooterView = UIView()
        tabView.backgroundColor = UIColor.white
        tabView.register(Reusable.cell)
        tabView.register(Reusable.bannerCell)
        tabView.register(Reusable.baseCell)
        tabView.separatorStyle = .none
        tabView.delegate = self
        tabView.dataSource = self
        return tabView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        assembleData()
    }
 
     func makeUI() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.dataSource.removeAll()
            self.requestData()
            // 刷新轮播图数据
            NotificationCenter.default.post(name: .init(rawValue: "kNeedRefreshBannerData"), object: nil)
        })
    }
}

// MARK:- class 方法

extension FYRedGameController {
    
    static func getVC(requestParams:Any, block:@escaping DataBlock) ->  UIViewController{
        let vc: FYRedGameController = FYRedGameController.init()
        vc.successBlock = block
        vc.requestParams = requestParams
        if requestParams is GameTypesData {
            if let tempGame = requestParams as? GameTypesData {
                vc.dataType = tempGame.type;
            }
        }
        
        return vc
    }
}

// MARK: - Handler data

extension FYRedGameController {
   
    func assembleData() {
        if self.requestParams is Int {
            let index = self.requestParams as! Int
            if index == 0 {
                self.dataSource.removeAll()
                self.tableView.mj_header?.endRefreshing()
                self.tableView.reloadData()
                
                self.reloadDataBySetEmpty(self.tableView)
            }
        }
        else if self.requestParams is GameTypesData {
            let typesData =  self.requestParams as! GameTypesData;
            for item in (typesData.list)!{
                item.iconSize = typesData.iconSize
                dataSource.append(item)
                
                if item.openFlag! &&
                !item.maintainFlag!  {
                    gameSource.append(item)
                }
            }
            self.tableView.mj_header?.endRefreshing()
            self.tableView.reloadData()
            
            self.reloadDataBySetEmpty(self.tableView)
            
            guard gameSource.count > 0 else {
                return
            }
            for (index,item) in gameSource.enumerated(){
                item.index = index
            }
        }
    }
    
    func requestData() {
        if self.requestParams is Int {
            let index = self.requestParams as! Int
            if index == 0 {
                guard let _ = self.successBlock else {
                    return
                }
                self.successBlock!(index)
            }
        }
        else if self.requestParams is GameTypesData {
            let typesData =  self.requestParams as! GameTypesData;
            guard let _ = self.successBlock else {
                return
            }
            self.successBlock!(typesData.index)
        }
    }
}

// MARK: - UITableViewDataSource

extension FYRedGameController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let item = dataSource[safe: indexPath.row] {
            if item.iconSize!.boolValue {
               let cell = tableView.dequeue(Reusable.bannerCell,for: indexPath)
                cell.model = item
                appModel?.officeFlag = (item.openFlag != nil)
                return cell
            }else {
                let cell = tableView.dequeue(Reusable.cell,for: indexPath)
                cell.list = item
                appModel?.officeFlag = (item.openFlag != nil)
                return cell
            }
            
        }
        let cell = tableView.dequeue(Reusable.baseCell,for: indexPath)
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension FYRedGameController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataType != 1 {
            if appModel?.isGuest() ?? false {
                return
            }
        }
        if let model = dataSource[safe: indexPath.row] {
//            HTTPCheckJoin(gameId: model.id!, indexRow: indexPath.row, model.index)
            didSelectedGameWithId(gameId: model.id!, indexRow: indexPath.row, model.index)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let item = dataSource[safe: indexPath.row] {
            if item.iconSize!.boolValue {
                return FYRedGameBannerCell.cellHeightWithModel(1)
            }else {
                return FYRedGameCell.cellHeightWithModel(0)
            }
        }
        
        return 80
    }
}

// MARK: - JXSegmentedListContainerViewListDelegate

extension FYRedGameController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

// MARK: - GameCheckStatusRequest

extension FYRedGameController {
    
    func HTTPCheckJoin(gameId: String, indexRow: Int, _ modelIndex: (Int)? = 0){
        NetRequestManager.sharedInstance()?.checkJoin(["id":"\(String(describing: gameId))"], successBlock: { (response) in
//            self.handleEnterGame(model: model)
            self.didSelectedGameWithId(gameId: gameId, indexRow: indexRow, modelIndex)
        }, failureBlock: { (failure) in
            FunctionManager.sharedInstance()?.handleFailResponse(failure);
        })
    }
    
    func didSelectedGameWithId(gameId: String, indexRow: Int, _ modelIndex: (Int)? = 0) {
        SVProgressHUD.show()
        NetRequestManager.sharedInstance()?.requestGameCheckStatus(withId: gameId, success: { (data) in
            SVProgressHUD.dismiss();
            guard let data = data else {
                return
            }
            
            let checkStatusModel = GameCheckStatusModel.deserialize(from: JSON(data).dictionaryObject)
            
            guard let openFlag = checkStatusModel?.data!.openFlag else {
                return
            }
            guard let powerFlag = checkStatusModel?.data!.powerFlag else {
                return
            }
            guard let maintainFlag = checkStatusModel?.data!.maintainFlag else {
                return
            }
            
            
            if openFlag && powerFlag {
               if !maintainFlag {
                    if checkStatusModel?.data!.accessWay?.integerValue == 1 {
                        if (appModel?.isGuest())! {
                            return;
                        }
                        guard let web = WebViewController(url: checkStatusModel!.data!.linkUrl) else {
                            return
                        }
                        //web.isHidden = true
                        //web.gameType = 4 //与QG棋牌游戏一致
                        web.title = checkStatusModel!.data!.showName
                        UIViewController.currentViewController()?.navigationController?.pushViewController(web, animated: true)
                    }
                    else if checkStatusModel?.data!.accessWay?.integerValue == 2 {
                        if (appModel?.isGuest())! {
                            return;
                        }
                        self.playingGame(gameId: (checkStatusModel?.data!.id)!, gameType: (checkStatusModel?.data!.type)!, model: (checkStatusModel?.data)!)
                    }
                    else if checkStatusModel?.data!.accessWay?.integerValue == 0 {
                        let vc = FYGamesController()
                        vc.gameSource = self.gameSource
                        vc.selectedIndex = modelIndex!
                        vc.navigationItem.title = "红包游戏"
                        UIViewController.currentViewController()?.navigationController?.pushViewController(vc, animated: true)
                    }
               }
               else {
                    SVProgressHUD.showInfo(withStatus: String.init(format:"游戏维护中...\n%@",(checkStatusModel?.data!.maintTotalTime)!))
                }
            }
            else {
                
                SVProgressHUD.showInfo(withStatus: "敬请期待!")
            }
        
        }, fail: { (fail) in
            SVProgressHUD.dismiss();
            if let response = fail as? Dictionary<String, Any> {
                let alterMsg = response["alterMsg"] as! String;
                SVProgressHUD.showError(withStatus: alterMsg);
            }else{
                FunctionManager.sharedInstance()?.handleFailResponse(fail)
            }
        })
    }
}

// MARK: - 棋牌游戏登入

extension FYRedGameController {
    
    func playingGame(gameId: String, gameType: Int, model: GameListData) {
        if (appModel?.isGuest())! {
            return;
        }
        let dict = ["userid": appModel?.userInfo.userId,
                    "gameid": "1",
                    "playerType": "1"]
        
        var linkUrl = ""
        if model.accessWay?.integerValue == 2 {
            linkUrl = model.linkUrl ?? ""
        }
        
        SVProgressHUD.show()
        NetRequestManager.sharedInstance()?.requestGamesThirdPartyLogin(withParameters: dict as [AnyHashable : Any], gameType: gameType, linkUrl: linkUrl, success: { (data) in
            guard let data = data else { return }
            
            if let model = NeedLoginGamesModel.deserialize(from:JSON(data).dictionaryObject) {
                if model.code == 0 {
                    SVProgressHUD.dismiss()
                    self.joinGameRoom((model.data?.url)!, type: gameType)
                }else {
                    SVProgressHUD.showError(withStatus: model.alterMsg!)
                }
            }else {
                
                SVProgressHUD.dismiss()
            }
            
        }, failure: { (fail) in
            
            FunctionManager.sharedInstance()?.handleFailResponse(fail)
        })
    }
    
    /// 进入游戏房间
    func joinGameRoom(_ url: String, type: Int) {
        if (appModel?.isGuest())! {
            return;
        }
        
        NetRequestManager.sharedInstance()?.requestUserInfo(success: { (data) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                SVProgressHUD.dismiss()
            }
            guard let JSONObject = JSON(data as Any).dictionaryObject else {
                return
            }
            let model = MeUserInfoModel.deserialize(from: JSONObject)
            appModel?.userInfo.nick = model?.data?.nick
            appModel?.userInfo.userId = "\(model!.data!.userId)"
            appModel?.userInfo.avatar = model?.data?.avatar
            appModel?.userInfo.balance = model?.data?.balance
            appModel?.userInfo.gender = FYUserGender(rawValue: (model?.data?.gender)!)!
            appModel?.userInfo.profit = model?.data?.profit
            appModel?.userInfo.recharge = model?.data?.relName
            appModel?.userInfo.cashDraw = model?.data?.cashDraw
            appModel?.userInfo.agentFlag = (model?.data!.agentFlag)!
            appModel?.userInfo.isTiedCard = (model?.data!.isTiedCard)!
            appModel?.userInfo.isBindMobile = model?.data?.isBindMobile ?? false
            appModel?.save()
            self.toWebViewController(url, type: type)
        }, fail: { (error) in

            FunctionManager.sharedInstance()?.handleFailResponse(error)
        })
        
//        toWebViewController(url, type: type)
    }
    
    func toWebViewController(_ url: String, type: Int){
        let web = WebViewController(url: url, gameType: type)
        web?.isNavBarHidden = true
        web?.userid = appModel?.userInfo.userId
        UIViewController.currentViewController()?.navigationController?.pushViewController(web!, animated: true)
    }

}

// MARK:- DZNEmptyDataSetSource && Delegate

extension FYRedGameController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
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
