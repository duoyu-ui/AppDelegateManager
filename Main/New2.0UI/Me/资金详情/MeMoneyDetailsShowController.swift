//
//  MeMoneyDetailsShowController.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/10.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit
import SwiftyJSON
import ReusableKit

fileprivate struct Reusable {
    static let cell = ReusableCell<MeMoneyDetailsShowCell>()
}

class MeMoneyDetailsShowController: BaseVC {
    
    // MARK: - var lazy
    
    var page: Int = 1
    var startTime: String?
    var endTime: String?
    
    @objc var category: String?
    @objc var billName: String = ""
    
    var categorys = [ListUserCategory]()
    var dataSource = [MeMoneyDetailsRecords]()

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.tableFooterView = UIView()
        table.backgroundColor = UIColor.baseBackgroundColor
        table.register(Reusable.cell)
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    lazy var headerView: MeQueryLogHeaderView = {
        let view = MeQueryLogHeaderView()
        view.delegate = self
        return view
    }()
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        makeRefresh()
        loadCategorys()
    }
    
    func makeUI() {
        if navigationItem.title == "盈亏记录" {
            headerView.moneyView.titleLab.text = "余额"
        }else {
            headerView.moneyView.titleLab.text = "累计金额"
        }
        
        self.setBackgroundColor()
        self.view.addSubview(headerView)
        self.view.addSubview(tableView)
        
        headerView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(160)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(1)
        }
    }
    
    
    func makeRefresh() {
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.page = 1
            SVProgressHUD.show()
            self?.loadRecordData()
        })
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.page += 1
            self?.loadRecordData()
        })
        
        tableView.mj_header?.beginRefreshing()
    }
    
    func endRefreshing() {
        SVProgressHUD.dismiss()
        
        if (tableView.mj_header != nil && tableView.mj_header!.isRefreshing) {
            tableView.mj_header?.endRefreshing()
            tableView.mj_footer!.state = .idle
        }
        if (tableView.mj_footer != nil && tableView.mj_footer!.isRefreshing) {
            tableView.mj_footer!.endRefreshing()
        }
    }
  
}

// MARK: - Request

extension MeMoneyDetailsShowController {
    
    /// 获取记录列表
    func loadRecordData() {
        
        let start = (self.startTime ?? String.time()) + " 00:00:00"
        let end = (self.endTime ?? String.time()) + " 23:59:59"
        NetRequestManager.sharedInstance()?.requestBillList(withName: billName, categoryStr: self.category, beginTime: start , endTime: end, page: self.page, pageSize: 20, success: {[weak self] (data) in
            self?.endRefreshing()
            
            if let JSONObject = JSON(data as Any).dictionaryObject {
                if self?.page == 1 {
                    self?.dataSource.removeAll()
                }
                
                let model = MeMoneyDetailsModels.deserialize(from: JSONObject)
                if model!.data!.records!.count < 20 {
                    self?.tableView.mj_footer?.endRefreshingWithNoMoreData()
                }
                
                for item in model!.data!.records! {
                    self?.dataSource.append(item)
                }
                
                self?.headerView.moneyView.conteLab.text = "¥\(model!.data!.extras!.money_sum)"
            }
            
            
            self?.tableView.reloadData()
            self?.reloadDataBySetEmpty(self?.tableView)
            
            }, fail: { (fail) in
                self.endRefreshing()
                self.reloadDataBySetEmpty(self.tableView)
                FunctionManager.sharedInstance()?.handleFailResponse(fail)
        })
    }
    
    //TODO: 获取所有类型
    ///获取所有类型
    func loadCategorys() {
        
        NetRequestManager.sharedInstance()?.requestBillType(withType: self.category, success: { (data) in
            if let JSONData = JSON(data as Any).dictionaryObject {
                if let dictArray = JSON(JSONData["data"] as Any).arrayObject {
                    if let modelArray = [ListUserCategory].deserialize(from: dictArray) {
                        self.categorys = modelArray as! [ListUserCategory]
                    }
                }
            }
            
            kLog(JSON(data!))
            
        }, fail: { (fail) in
            
            SVProgressHUD.dismiss()
        })
    }
}


// MARK: - UITableViewDataSource

extension MeMoneyDetailsShowController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(Reusable.cell, for: indexPath)
        cell.model = dataSource[safe: indexPath.row]
        return cell
    }
}


// MARK: - UITableViewDelegate

extension MeMoneyDetailsShowController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let model = dataSource[safe: indexPath.row] {
            return model.cellHeight
        }
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = dataSource[safe: indexPath.row] {
            pushDetails(model.bizId, userId: model.userId, billtId: model.billtId)
        }
    }
    
    /// 查看详情
    func pushDetails(_ bizId: Int, userId: Int, billtId: Int) {
        
        EnvelopeNet.shareInstance()?.getUnityRedpDetail(bizId, withType: billtId, successBlock: { (data) in
            SVProgressHUD.dismiss()
            kLog(data)
            let vc = FYRedEnvelopePublicViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }, failureBlock: { (fail) in
            
        })
    }
}

// MARK: - MeQueryLogEvent

extension MeMoneyDetailsShowController: MeQueryLogEvent {
    
    func startTime(time: String) {
        self.startTime = time
        self.tableView.mj_header?.beginRefreshing()
    }
    
    func endTime(time: String) {
        self.endTime = time
        self.tableView.mj_header?.beginRefreshing()
    }
    
    func allType(btn: UIButton) {
        let attr = NSMutableAttributedString(string: "选择类型")
        attr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.red], range: NSRange(location: 0, length: 4))
        attr.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 23)], range: NSRange(location: 0, length: 4))
        let vc = UIAlertController(title: "选择类型", message: nil, preferredStyle: .actionSheet)
        vc.setValue(attr, forKey: "attributedTitle")
        vc.addAction(UIAlertAction(title: "全部类型", style: .default, handler: { [weak self](_) in
            btn.setTitle("全部类型", for: .normal)
            self?.billName = ""
            self?.tableView.mj_header?.beginRefreshing()
        }))
        
        for model in categorys {
            vc.addAction(UIAlertAction(title: model.title, style: .default, handler: { [weak self] (_) in
                btn.setTitle(model.title, for: .normal)
                self?.billName = model.name!
                self?.tableView.mj_header?.beginRefreshing()
            }))
        }
        vc.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(vc, animated: true, completion: nil)
    }
}


// MARK:- DZNEmptyDataSetSource && Delegate

extension MeMoneyDetailsShowController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        let text = "暂无数据"
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.colorWithHexStr("cccccc")]
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
