//
//  MeQueryLogController.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/8.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit
import ReusableKit
import SwiftyJSON

fileprivate enum Reusable {
    static let cell = ReusableCell<MeQueryLogCell>()
}

///查询记录
@objcMembers class MeQueryLogController: BaseVC {
    
    // MARK: - lazy var
    
    var type: Int = 0
    var page: Int = 1
    
    var category = 1
    var endTime: String?
    var startTime:String?
    
    var list: ListUserChildList?
    
    var dataSource = [MeQueryLogRecords]()
    
    lazy var headerView: MeQueryLogHeaderView = {
        let view = MeQueryLogHeaderView()
        view.moneyView.titleLab.text = "累计金额"
        view.delegate = self
        return view
    }()
    
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
    
    // MARK: - Life cycle
        
    required init(withParams params: Dictionary<String, Any>) {
        super.init(nibName: nil, bundle: nil)
        if params["type"] != nil {
            self.type = params["type"] as! Int
        }
        if params["list"] != nil {
            self.list = params["list"] as? ListUserChildList
        }
        if params["jsonOfList"] != nil {
            let jsonOfList = params["jsonOfList"] as! String
            if !jsonOfList.isEmpty {
                let listUserChildList = ListUserChildList.deserialize(from: jsonOfList)
                self.list = listUserChildList
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        makeRefresh()
    }
    
    func makeUI() {
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
        
        if (self.tableView.mj_header != nil && self.tableView.mj_header!.isRefreshing) {
            self.tableView.mj_header!.endRefreshing()
        }
        if (self.tableView.mj_footer != nil && self.tableView.mj_footer!.isRefreshing) {
            self.tableView.mj_footer!.endRefreshing()
        }
    }
}

// MARK: - Request

extension MeQueryLogController {
    
    func loadRecordData() {
        let end = (self.endTime ?? String.time()) + " 23:59:59"
        let start = (self.startTime ?? String.lastTime()) + " 00:00:00"
        let dict = ["current":self.page,
                    "isAsc":false,
                    "size":20,
                    "queryParam":[
                        "category":self.category,
                        "endTime":end,
                        "parentType":type,
                        "startTime":start,
                        "type":list!.type,
                        "parentId":list!.parentId,
                        "id":list!.id
                        ]
                    ] as [String : Any]

        NetRequestManager.sharedInstance()?.requestUserListRecordDict(dict, success: {[weak self] (json) in
            guard let data = json else {
                return
            }
            kLog(JSON(data))
            
            self?.endRefreshing()
            if self?.page == 1 {
                self?.dataSource.removeAll()
            }
            
            let model = MeQueryLogModel.deserialize(from: JSON(data).dictionaryObject)
            self?.headerView.moneyView.conteLab.text = "\(String(describing: model!.data!.totalMoney))"
            
            for item in model!.data!.records!{
                self?.dataSource.append(item)
            }
            
            if model!.data!.records!.count < 20 {
                self?.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
            
            self?.tableView.reloadData()
            self?.reloadDataBySetEmpty(self?.tableView)
            
        }, fail: { (json) in
            self.endRefreshing()
            FunctionManager.sharedInstance()?.handleFailResponse(json)
        })
    }
}


extension MeQueryLogController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(Reusable.cell, for: indexPath)
        if let model = dataSource[safe: indexPath.row] {
            cell.model = model
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = dataSource[safe: indexPath.row] {
            if model.niuniuFlag || model.detailButtonDisplayFlag {
                let vc = FYRedEnvelopePublicViewController()
//                vc.redPackedId = "\(model.id)"
                    vc.packetId = "\(model.id)"
//                vc.isCowCow = model.niuniuFlag
//                vc.isRightBarButton = model.detailButtonDisplayFlag
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

// MARK: - MeQueryLogEvent

extension MeQueryLogController: MeQueryLogEvent {
    
    func startTime(time: String) {
        self.startTime = time
        tableView.mj_header?.beginRefreshing()
    }
    
    func endTime(time: String) {
        self.endTime = time
        tableView.mj_header?.beginRefreshing()
    }
    
    func allType(btn: UIButton) {
        guard let categorys = list!.category else {
            return
        }
        
        let attr = NSMutableAttributedString(string: "选择类型")
        attr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.red], range: NSRange(location: 0, length: 4))
        attr.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 23)], range: NSRange(location: 0, length: 4))
        let vc = UIAlertController(title: "选择类型", message: nil, preferredStyle: .actionSheet)
        vc.setValue(attr, forKey: "attributedTitle")
        
        for category in categorys {
            vc.addAction(UIAlertAction(title: category.name, style: .default, handler: { [weak self](_) in
                self?.category = category.value
                btn.setTitle(category.name, for: .normal)
                self?.tableView.mj_header?.beginRefreshing()
            }))
        }
        vc.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(vc, animated: true, completion: nil)
    }
}


// MARK:- DZNEmptyDataSetSource && Delegate

extension MeQueryLogController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
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
