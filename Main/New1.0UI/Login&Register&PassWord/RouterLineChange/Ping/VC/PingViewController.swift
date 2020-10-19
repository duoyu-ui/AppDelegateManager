//
//  PingViewController.swift
//  NetworkLineDemo
//
//  Created by Tom on 2019/10/29.
//  Copyright © 2019 Tom. All rights reserved.
//

import UIKit

class PingViewController: FYBaseCoreViewController {
    
    fileprivate let kPingViewCellId = "kPingViewCellId"
    fileprivate let goodsNumber : String = UserDefaults.standard.value(forKey: "kTenant_Defaults") as? String ?? ""
    
    // MARK: - var lazy
    
    lazy var bannerHeaderView: PingHeaderBannerview = {
        let bannerView = PingHeaderBannerview()
        return bannerView
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.tableHeaderView = self.bannerHeaderView
        table.tableFooterView = UIView()
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.backgroundColor = UIColor(red: 235.0 / 255.0, green: 237.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
        table.register(PingViewCell.self, forCellReuseIdentifier: kPingViewCellId)
        table.dataSource = self
        table.delegate = self
        table.emptyDataSetSource = self
        table.emptyDataSetDelegate = self
        return table
    }()
    var pingsData=[HostPingManager]()
    var currentSelectedPingData: HostPingManager?
    let collectionView:UICollectionView = {
        let mainSize = UIScreen.main.bounds.size
        let layout = UICollectionViewFlowLayout()
        let space:CGFloat = 50.0
        let width = (mainSize.width - (space * 3 + 5)) / 2
        layout.minimumInteritemSpacing = space;
        layout.minimumLineSpacing = space;
        layout.headerReferenceSize = CGSize.init(width: mainSize.width, height: 150)
        layout.footerReferenceSize = CGSize.init(width: mainSize.width, height: 90)
        layout.itemSize = CGSize.init(width: width, height: width)
        layout.sectionInset = UIEdgeInsets.init(top: space, left: space, bottom: space, right: space);
        let coll = UICollectionView.init(frame: UIScreen.main.bounds, collectionViewLayout: layout);
        coll.register(FYPingCircleCell.self, forCellWithReuseIdentifier: "FYPingCircleCell")
        coll.register(PingTitleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PingTitleHeaderView")
        coll.register(PingTitleFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "PingTitleFooterView")
        coll.backgroundColor = UIColor.clear;
        
        return coll
    }()
    
    let backGroundView = UIView();
    
    
    var loadSteper = 1
    var dataUrls = [String]()
    var dataSource = [PingItem]()
    let releaseUrls = [
                    "https://hbapk.oss-cn-shenzhen.aliyuncs.com/",
                    "https://file.em558.com/"
                    ]
    let debugUrls = ["https://hbapk.oss-cn-shenzhen.aliyuncs.com/",
                     "http://10.10.95.235:9000/"
                    ]
    ///商户公共线路接口
    lazy var publicUrl: String = {
        var url = "https://hbapk.oss-cn-shenzhen.aliyuncs.com/"
        #if DEBUG
        url.append("tenantroutertest/common.json")
        return url
        #else
        url.append("tenantrouter/common.json")
        return url
        #endif
    }()
    let pingColors = [HexColor("#97E7C6"),
                      HexColor("#59C57E"),
                      HexColor("#B5D3F3"),
                      HexColor("#6C94EF"),
                      HexColor("#98A4E0"),
                      HexColor("#AE94F1"),
                      HexColor("#F6CBA6"),
                      HexColor("#F59262"),
                      HexColor("#F3B5C6"),
                      HexColor("#F196A5"),
                      HexColor("#FC7152"),
                      HexColor("#E73031")]
    
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .baseBackgroundColor
        collectionView.dataSource = self;
        collectionView.delegate = self;
        setupSubview()
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
    }
    
    @objc func buttonAction(sender:UIButton){
        if currentSelectedPingData?.hostName.count ?? 0 > 0 {
            var currentURL = ""
            if (currentSelectedPingData?.hostName.hasPrefix("http"))! == false {
                #if DEBUG
                currentURL = "http://"
                #else
                currentURL = "https://"
                #endif
            }
            currentURL.append(currentSelectedPingData!.hostName)
            if (currentSelectedPingData?.hostName.hasSuffix("/"))! == false {
                currentURL.append("/")
            }
            
            UserDefaults.standard.setValue(currentURL, forKey: "currentURL")
            var fetchIndex = 0
            for pppp in pingsData {
                if pppp == currentSelectedPingData {
                    break
                }
                fetchIndex += 1
            }
            
            UserDefaults.standard.setValue("\(NSLocalizedString("线路", comment: ""))\(fetchIndex + 1)", forKey: "currentURLIndex")
            UserDefaults.standard.synchronize()
            AppModel.shareInstance()?.serverUrl = currentURL
            navigationController?.popViewController(animated: true);
        }
    }
}

extension PingViewController {
    
    func setupSubview() {
        let rightItem = createBarButtonItem(withImage: ICON_NAV_BAR_BUTTON_REFRESH, target: self, action: #selector(refreshPing), offsetType: CFCNavBarButtonOffsetType.right, imageSize: NAVIGATION_BAR_BUTTON_IMAGE_SIZE)
        self.navigationItem.rightBarButtonItem = rightItem
        view.backgroundColor = .white
        view.addSubview(backGroundView)
        backGroundView.layer.contents = UIImage.init(named: "icon_router_bg")?.cgImage
        backGroundView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(view.snp.width).multipliedBy(1280 / 720.0)
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(kSafeAreaBottom)
            } else {
                make.bottom.equalTo(self.view.snp.bottomMargin)
            }
        }
        
        collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            self?.loadUrlData()
        })
        collectionView.mj_header?.beginRefreshing()
//        view.addSubview(tableView)
//        tableView.snp.makeConstraints { (make) in
//            make.top.left.right.equalTo(self.view)
//            if #available(iOS 11.0, *) {
//                make.bottom.equalTo(kSafeAreaBottom)
//            } else {
//                make.bottom.equalTo(self.view.snp.bottomMargin)
//            }
//        }
//
//        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
//            self?.loadUrlData()
//        })
//        tableView.mj_header?.beginRefreshing()
    }
    
    func loadUrlData() {
        self.dataUrls.removeAll()
        loadSteper += 1
        var URLS:[String] = []
        #if DEBUG
        URLS = debugUrls
        #else
        URLS = releaseUrls
        #endif
        
        let fetchUrl = URLS[loadSteper % 2]
        let urlPath = "\(fetchUrl)\(goodsNumber)/line.json"
        
        let queue = DispatchQueue.init(label: "com.line.json")//定义队列
        let group = DispatchGroup()//创建一个组
        queue.async(group: group, execute: {[weak self] in
            guard let `self` = self else{return}
            group.enter()//开始线程
            NetRequestManager.sharedInstance()?.urlRoutes(self.publicUrl, successBlock: { (enString) in
                if let sourceString = enString {
                    let json = sourceString.aesDecryption
                    let model = PingModel.deserialize(from: json)
                    for item in model?.router ?? [] {
                        self.dataUrls.append(item.domain ?? "")
                    }
                }
                group.leave()//线程结束
                }, failureBlock: { (error) in
                    group.leave()//线程结束
//                    self.tableView.mj_header?.endRefreshing()
                    self.collectionView.mj_header?.endRefreshing()
            })
        })
        //将队列放进组里
        queue.async(group: group, execute: {[weak self] in
            guard let `self` = self else{return}
            group.enter()//开始线程
            NetRequestManager.sharedInstance()?.urlRoutes(urlPath, successBlock: { (enString) in
                if let sourceString = enString{
                    let json = sourceString.aesDecryption
                    let model = PingModel.deserialize(from: json)
                    for item in model?.router ?? [] {
                        self.dataUrls.append(item.domain ?? "")
                    }
                }
                group.leave()//线程结束
            }, failureBlock: { (error) in
                group.leave()//线程结束
//                self.tableView.mj_header?.endRefreshing()
                self.collectionView.mj_header?.endRefreshing()
            })
        })
        //队列中线程全部结束
        if pingsData.count > 0 {
            pingsData.removeAll()
        }
        
        group.notify(queue: queue){
            DispatchQueue.main.async {
                var pingFinishCount = 0
                let currentUrlString = AppModel.shareInstance()?.serverUrl
                for hostname in self.dataUrls {
                    
                    let pingmanager = HostPingManager()
                    if currentUrlString != nil {
                        if (currentUrlString?.contains(hostname))! {
                            pingmanager.isCurrentSelected = true
                            self.currentSelectedPingData = pingmanager
                        }
                    }
                    pingmanager.tryToPingAddress(address: hostname) { (finishPing) in
                        pingFinishCount += 1
                        if pingFinishCount == self.dataUrls.count {
                            self.reArrangePingData()
                        }
                    }
                    self.pingsData.append(pingmanager)
                }
                self.collectionView.reloadData();
//                PingManager.getFastestAddress(addressList: self.dataUrls) { [weak self](items) in
//                    guard let `self` = self else{return}
//                    self.dataSource = items
////                    self.tableView.reloadData()
//                    self.collectionView.reloadData();
//                }
////                self.tableView.mj_header?.endRefreshing()
                self.collectionView.mj_header?.endRefreshing()
            }
        }
    }
    
    func reArrangePingData(){
        print("reArrangePingData")
        pingsData.sort { (pingA, pingB) -> Bool in
            return pingA.avrageTimes < pingB.avrageTimes
        }
        collectionView.reloadData()
    }
    
    @objc func refreshPing(){
//        tableView.mj_header?.beginRefreshing()
        collectionView.mj_header?.beginRefreshing()
    }
}

// MARK: - UITableViewDataSource

extension PingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kPingViewCellId, for: indexPath) as! PingViewCell
        if self.dataSource.count > indexPath.row {
            cell.item = self.dataSource[indexPath.row]
            cell.lineLab.text = "\(NSLocalizedString("线路", comment: ""))\(indexPath.row + 1)"
            let isContainer = AppModel.shareInstance()?.serverUrl.contains(cell.item.hostName ?? "")
            cell.setStatusLable(isSelect: isContainer ?? false)
        }
        return cell
    }

}

// MARK: - UITableViewDelegate

extension PingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = self.dataSource[safe: indexPath.row] {
            var currentURL = ""
            if (item.hostName?.hasPrefix("http"))! == false {
                #if DEBUG
                currentURL = "http://"
                #else
                currentURL = "https://"
                #endif
            }
            currentURL.append(item.hostName!)
            if (item.hostName?.hasSuffix("/"))! == false {
                currentURL.append("/")
            }
            
            UserDefaults.standard.setValue(currentURL, forKey: "currentURL")
            UserDefaults.standard.setValue("\(NSLocalizedString("线路", comment: ""))\(indexPath.row + 1)", forKey: "currentURLIndex")
            UserDefaults.standard.synchronize()
            AppModel.shareInstance()?.serverUrl = currentURL
        }
//        tableView.reloadData()
        collectionView.reloadData()
        AppModel.debugShowCurrentUrl()
    }
    #if DEBUG
     func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
         return true
     }
     func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
         return true
     }
     func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
         if action == #selector(copy(_:)),let item = self.dataSource[safe: indexPath.row] {
             let pasteBoard = UIPasteboard.general
             pasteBoard.string = item.hostName
            
             SVProgressHUD.show(withStatus: NSLocalizedString("复制线路成功!", comment: ""))
             DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                 SVProgressHUD.dismiss()
             }
         }
     }
     #endif
}


// MARK:- DZNEmptyDataSetSource && Delegate

extension PingViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        let text = NSLocalizedString("暂无线路，点击重新获取", comment: "")
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
extension PingViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pingsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PingTitleHeaderView", for: indexPath) as! PingTitleHeaderView
            
            header.labelTitle.text = NSLocalizedString("\(NSLocalizedString("线路选择", comment: ""))", comment: "")
            
            header.labelMessage.text = NSLocalizedString("ms越小，反应时间越小，访问速度越快", comment: "")
            return header
        }else{
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PingTitleFooterView", for: indexPath) as! PingTitleFooterView
            footer.button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            return footer
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FYPingCircleCell", for: indexPath) as! FYPingCircleCell
        if pingsData.count > indexPath.item {
            let hostname = pingsData[indexPath.row];
            if pingColors.count > indexPath.item {
                hostname.signalColor = pingColors[indexPath.item]!
            }else{
                hostname.signalColor = pingColors.last!!
            }
            cell.setPingData(ping: hostname)
        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentSelectedPingData != nil {
            currentSelectedPingData?.isCurrentSelected = false
            currentSelectedPingData?.callUpdate()
        }
        currentSelectedPingData = pingsData[indexPath.row];
        currentSelectedPingData?.isCurrentSelected = true;
        currentSelectedPingData?.callUpdate()
        
    }
}
