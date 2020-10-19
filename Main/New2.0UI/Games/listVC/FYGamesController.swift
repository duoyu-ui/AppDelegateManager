//
//  FYGamesController.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/19.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit
import JXSegmentedView

class FYGamesController: UIViewController {
    
    let kSegmentHeight: CGFloat = 100
    
    // MARK: - var lazy
    
    var selectedIndex: Int = 0
    
    var gameSource = [GameListData]()
    
    var listVCArray = [FYGamesCategoryController]()
    
    lazy var segmentedView: JXSegmentedView = {
        let frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kSegmentHeight)
        let segmentView = JXSegmentedView(frame: frame)
        segmentView.backgroundColor = .white
        segmentView.delegate = self
        //contentScrollView
        segmentView.contentScrollView = self.contentScrollView
        segmentView.isContentScrollViewClickTransitionAnimationEnabled = false
        //基本设置
        let lidiView = JXSegmentedIndicatorLineView()
        lidiView.indicatorColor = UIColor.red
        lidiView.indicatorHeight = 0.5
        lidiView.indicatorWidth = 60
        segmentView.indicators = [lidiView]
        segmentView.dataSource = self.segmentedDataSource
        //line
        let lineView = UIView()
        lineView.backgroundColor = .boardLineColor()
        lineView.frame = CGRect(x: 0, y: segmentView.height - 0.55, width: kScreenWidth, height: 0.55)
        segmentView.addSubview(lineView)
        return segmentView
    }()
    
    //初始化数据源
    lazy var segmentedDataSource: JXSegmentedTitleImageDataSource = {
        let dataSource = JXSegmentedTitleImageDataSource()
        dataSource.loadImageClosure = { [weak self] (imageView, image)  in
            imageView.setImageWithURL(image, placeholder: "msg3")
        }
        dataSource.imageSize = CGSize(width: 50, height: 50)
        dataSource.titleImageType = .topImage
        dataSource.titleNormalColor = UIColor.kTextColor
        dataSource.titleSelectedColor = UIColor.red
        dataSource.isTitleColorGradientEnabled = true
        return dataSource
    }()
    
    lazy var contentScrollView: UIScrollView! = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        return scrollView
    }()
    
    lazy var msgNavItem: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("玩法规则", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(HexColor("#ffffff"), for: .normal)
        button.addTarget(self, selector: #selector(msgItemClick))
        return button
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        reloadData()
    }
    
    func makeUI() {
        self.setBackgroundColor()
        self.view.addSubview(segmentedView)
        self.view.addSubview(contentScrollView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.msgNavItem)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        makeLayout()
    }

    func makeLayout() {
        
        segmentedView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: kSegmentHeight)
        contentScrollView.frame = CGRect(x: 0, y: kSegmentHeight, width: view.bounds.size.width, height: view.bounds.size.height - kSegmentHeight)
        contentScrollView.contentSize = CGSize(width: contentScrollView.bounds.size.width*CGFloat(segmentedDataSource.dataSource.count), height: contentScrollView.bounds.size.height)
        for (index, vc) in listVCArray.enumerated() {
            vc.view.frame = CGRect(x: contentScrollView.bounds.size.width*CGFloat(index), y: 0, width: contentScrollView.bounds.size.width, height: contentScrollView.bounds.size.height)
        }
    }
    
}


extension FYGamesController {
    
    @objc func msgItemClick() {
        let vc = WebViewController(url: appModel!.ruleString ?? "")
        vc!.hidesBottomBarWhenPushed = true
        vc!.navigationItem.title = "玩法规则"
        self.navigationController?.pushViewController(vc!, animated: true);
    }
    
    func reloadData() {
        var titles = [String]()
        var normalImageInfos = [String]()
        
        for vc in listVCArray {
            vc.view.removeFromSuperview()
        }
        
        listVCArray.removeAll()
        
        guard gameSource.count > 0 else {
            return
        }
        
        for (index, _) in gameSource.enumerated() {
            if let game = gameSource[safe: index] {
                titles.append(game.showName!)
                if let accessIcon = game.accessIcon {
                    normalImageInfos.append(accessIcon)
                }
                
                let vc = FYGamesCategoryController()
                vc.type = game.type
                contentScrollView.addSubview(vc.view)
                listVCArray.append(vc)
            }
        }
        
        segmentedDataSource.titles = titles
        segmentedDataSource.normalImageInfos = normalImageInfos
        reloadAllListData(selectedIndex)
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    func reloadAllListData(_ index: (Int)? = 0) {
        segmentedDataSource.reloadData(selectedIndex: index!)
        segmentedView.defaultSelectedIndex = index!
        segmentedView.reloadData()
    }
}


// MARK:- JXSegmentedViewDelegate

extension FYGamesController: JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) { listVCArray[index].loadDataForFirst()
    }
}
