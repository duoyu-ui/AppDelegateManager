//
//  BaseNewNavViewController.swift
//  Project
//
//  Created by 汤姆 on 2019/8/19.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

class BaseNewNavViewController: CFCNavigationController, UIGestureRecognizerDelegate {
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加手势代理
        self.interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
        setupBackItem()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var childForStatusBarStyle: UIViewController?{
        return self.topViewController
    }
    
    func setupBackItem() {
//        let navBar = UINavigationBar.appearance()
//        navBar.isTranslucent = false
//        //导航标题文字
//        navBar.titleTextAttributes = [
//            NSAttributedString.Key.foregroundColor : UIColor.white,
//            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)
//        ]
//        // 设置导航栏背景图片
//        let backgroundImage = UIImage(named: "navBarBg")?.withRenderingMode(.alwaysOriginal)
//        navBar.barTintColor = UIColor(patternImage: backgroundImage!)
//        navBar.shadowImage = nil
//        
//        let item = UIBarButtonItem.appearance()
//        item.tintColor = UIColor.white
    }

    func setBackItem(viewController: UIViewController){
         let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
         let image = UIImage(named: ICON_NAVIGATION_BAR_BUTTON_BLACK_ARROW)?.withRenderingMode(.alwaysOriginal)
         
         viewController.navigationController?.navigationBar.backIndicatorImage = image
         viewController.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
    
         viewController.navigationItem.backBarButtonItem = backItem
     }
}

// MARK: - UINavigationControllerDelegate

extension BaseNewNavViewController: UINavigationControllerDelegate {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            //手势可用
            self.interactivePopGestureRecognizer?.isEnabled = true
            //添加手势识别
            viewController.hidesBottomBarWhenPushed = true
        }
        
        //是否开启动画由传入决定，不会造成冲突
        super.pushViewController(viewController, animated: animated)
        setBackItem(viewController: viewController)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.count == 1 {
            self.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
}
