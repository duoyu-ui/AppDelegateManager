////
////  MeNewMoreController.swift
////  ProjectCSHB
////
////  Created by 汤姆 on 2019/9/8.
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
/////更多
//class MeNewMoreController: UIViewController {
//    weak var delegate: QueryLogDelegate?
//    
//    var lists : ListUserData?{
//        didSet{
//            guard let childList = lists!.childList else {
//                return
//            }
//            for list in childList {
//                dataSource.append(list)
//            }
//            self.collectionView.reloadData()
//            
//        }
//    }
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
//    var dataSource = [ListUserChildList]()
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
////        collectionView.kCornerRad(rectCorner: [.bottomLeft,.bottomRight], cornerRad: 10)
//        
//    }
//    
//}
//
//extension MeNewMoreController{
//    func initUI() {
//        
//        view.addSubview(collectionView)
////        let row : Int = (dataSource.count % 4) > 0 ? 1 : 0
//        collectionView.snp.makeConstraints { (make) in
////            make.left.equalToSuperview().offset(10)
////            make.right.equalToSuperview().offset(-10)
////            make.top.equalToSuperview()
////            make.height.equalTo(cellH * CGFloat(abs(dataSource.count / 4) + row))
//            make.edges.equalToSuperview()
//        }
//        
//    }
//}
////MARK: - 代理
//extension MeNewMoreController:UICollectionViewDataSource{
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
//extension MeNewMoreController:UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: cellW, height: cellH)
//    }
//}
//extension MeNewMoreController:UICollectionViewDelegate{
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let model = dataSource[indexPath.row]
//        self.delegate?.didSelectItemAt(model: model,type:lists!.type)
//    }
//}
//extension MeNewMoreController:JXSegmentedListContainerViewListDelegate{
//    func listView() -> UIView {
//        return view
//    }
//}
