////
////  MeYuEBaoController.swift
////  Project
////
////  Created by 汤姆 on 2019/8/21.
////  Copyright © 2019 CDJay. All rights reserved.
////
//
//import UIKit
//import JXSegmentedView
//import ReusableKit
//
//fileprivate enum Reusable {
//    static let cell = ReusableCell<MeNewRedEnvelopeCell>()
//}
//
//fileprivate let cellH = 100.px
//fileprivate let cellW = (kScreenWidth - 20) / 4 - 1
//
//class MeXiuXianController: UIViewController {
//    
//    // MARK: - var lazy
//    
//    weak var delegate: QueryLogDelegate?
//    
//    var dataSource = [ListUserChildList]()
//    
//    private lazy var collectionView: UICollectionView = {
//        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collection.register(Reusable.cell)
//        collection.backgroundColor = UIColor.white
//        collection.showsVerticalScrollIndicator = false
//        collection.showsHorizontalScrollIndicator = false
//        collection.delegate = self
//        collection.dataSource = self
//        return collection
//    }()
//    
//    private lazy var layout: UICollectionViewFlowLayout = {
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.minimumLineSpacing = 0
//        flowLayout.minimumInteritemSpacing = 0
//        return flowLayout
//    }()
//    
//    var lists: ListUserData? {
//        didSet {
//            guard let childList = lists!.childList else {
//                self.collectionView.reloadData()
//                // 设置占位视图代理
//                self.reloadDataBySetEmpty(self.collectionView)
//                return
//            }
//            for list in childList {
//                dataSource.append(list)
//            }
//            self.collectionView.reloadData()
//        }
//    }
//    // MARK: - Life cycle
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        makeUI()
//    }
//   
//    func makeUI() {
//        view.addSubview(collectionView)
//        collectionView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
//    }
//    
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        //collectionView.kCornerRad(rectCorner: [.bottomLeft,.bottomRight], cornerRad: 10)
//    }
//}
//
//
//
//// MARK: - UICollectionViewDataSource && Delegate
//
//extension MeXiuXianController: UICollectionViewDataSource, UICollectionViewDelegate {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return dataSource.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeue(Reusable.cell, for: indexPath)
//        if dataSource.count > indexPath.row {
//            cell.model = dataSource[safe: indexPath.row]
//            //cell.lineView.isHidden = ((indexPath.row + 1) % 4 == 0)
//        }
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let model = dataSource[safe: indexPath.row] {
//            self.delegate?.didSelectItemAt(model: model, type:lists!.type)
//        }
//    }
//}
//
//// MARK: - UICollectionViewDelegateFlowLayout
//
//extension MeXiuXianController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: cellW, height: cellH)
//    }
//}
//
//extension MeXiuXianController:JXSegmentedListContainerViewListDelegate{
//    func listView() -> UIView {
//        return view
//    }
//}
//// MARK:- DZNEmptyDataSetSource && Delegate
//
//extension MeXiuXianController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
//    
//    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
//        let text = "暂无数据"
//        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.colorWithHexStr("cccccc")]
//        return NSAttributedString(string: text, attributes: attributes)
//    }
//    
//    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
////        self.collectionView.mj_header?.beginRefreshing()
//    }
//    
//    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
//        return UIImage(named: "state_empty")
//    }
//    
//    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
//        return self.dataSource.count == 0
//    }
//    
//    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
//        return true
//    }
//    
//    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
//        return 5
//    }
//}
