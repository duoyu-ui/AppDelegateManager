//
//  UIViewController+Extend.swift
//  FY-IMChat
//
//  Created by Jetter on 2019/8/18.
//  Copyright © 2019 development. All rights reserved.
//

import Foundation

extension UIViewController {
    
    /// Configuration back
    @objc func back(_ animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    // Get currentController
    class func currentViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return currentViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return currentViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return currentViewController(controller: presented)
        }
        return controller
    }
}


extension UIViewController {
    
    /// 设置空页面时机(在第一个加载的时候)
    func reloadDataBySetEmpty(_ view: UIView?) {
        if view is UITableView {
            let table = view as! UITableView
            if table.emptyDataSetSource == nil {
                table.emptyDataSetDelegate = self as? DZNEmptyDataSetDelegate
                table.emptyDataSetSource = self as? DZNEmptyDataSetSource
                table.reloadEmptyDataSet()
            }
            table.reloadData()
            
        }else if view is UICollectionView {
            let collection  = view as! UICollectionView
            if collection.emptyDataSetSource == nil {
                collection.emptyDataSetDelegate = self as? DZNEmptyDataSetDelegate
                collection.emptyDataSetSource = self as? DZNEmptyDataSetSource
                collection.reloadEmptyDataSet()
            }
            collection.reloadData()
        }
    }
}
