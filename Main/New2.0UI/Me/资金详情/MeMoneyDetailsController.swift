//
//  MeMoneyDetailsController.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/10.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit
import ReusableKit

fileprivate enum Reusable {
    static let cell = ReusableCell<MeMoneyDetailsCell>()
}
class MeMoneyDetailsController: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "资金记录"
        setBackgroundColor()
       self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

    }
    let titles = ["充值记录","提款记录","奖金记录","盈亏记录","佣金记录","敬请期待"]
    let imags = ["billType3","billType4","billType2","billType7","billType8","billType11"]
    //接口传值
    let categorys = ["recharge","withdraw","reward","win_loss","commission_in"]
    lazy var collectionView: UICollectionView = {
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.backgroundColor = UIColor.baseBackgroundColor
        coll.register(Reusable.cell)
        coll.delegate = self
        coll.dataSource = self
        return coll
    }()
    lazy var layout: UICollectionViewFlowLayout = {
        let la = UICollectionViewFlowLayout()
        la.minimumLineSpacing = 0.5
        la.minimumInteritemSpacing = 0.5
        return la
    }()
}
extension MeMoneyDetailsController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 5 {
            SVProgressHUD.showInfo(withStatus: "敬请期待")
            return
        }
        let vc = MeMoneyDetailsShowController()
        vc.title = titles[indexPath.row]
        vc.category = categorys[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension MeMoneyDetailsController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeue(Reusable.cell, for: indexPath)
        cell.imgView.image = UIImage(named: imags[indexPath.row])
        cell.titleLab.text = titles[indexPath.row]
        return cell
    }
    
    
}
extension MeMoneyDetailsController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (kScreenWidth - 1) / 2, height: 100)
    }
}


