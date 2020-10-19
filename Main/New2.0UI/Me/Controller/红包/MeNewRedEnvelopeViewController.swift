////
////  MeNewRedEnvelopeViewController.swift
////  ProjectXZHB
////
////  Created by 汤姆 on 2019/8/21.
////  Copyright © 2019 CDJay. All rights reserved.
////
//
//import UIKit
//import JXSegmentedView
//import ReusableKit
//fileprivate enum Reusable {
//    static let cell = ReusableCell<MeNewRedEnvelopeCell>()
//}
/////cell高度
//fileprivate let cellH = 100.px
//fileprivate let cellW = (kScreenWidth - 20) / 4 - 1
//class MeNewRedEnvelopeViewController: UIViewController {
//    
//    weak var delegate: QueryLogDelegate?
//    var dataSource = [ListUserChildList]()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        initUI()
//       
//    }
//    
//    private lazy var collectionView: UICollectionView = {
//        let colle = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        colle.register(Reusable.cell)
//        colle.backgroundColor = UIColor.white
//        colle.showsVerticalScrollIndicator = false
//        colle.showsHorizontalScrollIndicator = false
//        colle.delegate = self
//        colle.dataSource = self
//        return colle
//    }()
//    
//    private lazy var layout: UICollectionViewFlowLayout = {
//        let lay = UICollectionViewFlowLayout()
//        lay.minimumLineSpacing = 0
//        lay.minimumInteritemSpacing = 0
//        return lay
//    }()
//    
//    var lists : ListUserData?{
//        didSet{
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
//           
//        }
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
////        collectionView.kCornerRad(rectCorner: [.bottomLeft,.bottomRight], cornerRad: 10)
//
//    }
//  
//}
//
//extension MeNewRedEnvelopeViewController{
//    func initUI() {
////        self.navigationController?.navigationBar.isTranslucent = false
//        view.addSubview(collectionView)
////        let row : Int = (dataSource.count % 4) > 0 ? 1 : 0
//        collectionView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
////            make.left.equalToSuperview().offset(10)
////            make.right.equalToSuperview().offset(-10)
////            make.top.equalToSuperview()
////            make.height.equalTo(cellH * CGFloat(abs(dataSource.count / 4) + row))
//
//        }
//     
//    }
//}
////MARK: - 代理
//extension MeNewRedEnvelopeViewController:UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return dataSource.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeue(Reusable.cell, for: indexPath)
//        if dataSource.count > indexPath.row{
//            cell.model = dataSource[indexPath.row]
////            cell.lineView.isHidden = ((indexPath.row + 1) % 4 == 0)
//        }
//        return cell
//    }
//    
//    
//}
//extension MeNewRedEnvelopeViewController:UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: cellW, height: cellH)
//    }
//}
//extension MeNewRedEnvelopeViewController:UICollectionViewDelegate{
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let model = dataSource[indexPath.row]
//        
//        self.delegate?.didSelectItemAt(model: model,type:lists!.type)
//       
//    }
//}
//extension MeNewRedEnvelopeViewController:JXSegmentedListContainerViewListDelegate{
//    func listView() -> UIView {
//        return view
//    }
//}
//
//// MARK:- DZNEmptyDataSetSource && Delegate
//
//extension MeNewRedEnvelopeViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
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
