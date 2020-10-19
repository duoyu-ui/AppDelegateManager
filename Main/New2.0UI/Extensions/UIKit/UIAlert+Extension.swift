//
//  UIalertVC+Extension.swift
//  FY-IMChat
//
//  Created by Jetter on 2019/2/28.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit


class EasyAlertView: NSObject {
    /// 单利
    static let shared = EasyAlertView()
    
    private override init() {}
}


// MARK:- 自定义Alert样式
extension EasyAlertView {
    
    /// 点击不响应提示框
    func sureActionAlert(title: String, message: String, vc: UIViewController) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let sureAction = UIAlertAction(title: NSLocalizedString("确定",comment:""), style: .default) { (UIAlertAction) in
            
        }
        
        alertVC.addAction(sureAction)
        vc.present(alertVC, animated: true, completion: nil)
    }

    /// 默认带确认&取消事件响应的提示框
    func confirmAlert(title: String, message: String, vc: UIViewController, source: @escaping () -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: NSLocalizedString("确定",comment:""), style: .default) { (UIAlertAction) in
            source()
        }
        let cancleAction = UIAlertAction(title: NSLocalizedString("取消",comment:""), style: .default, handler: nil)

        alertVC.addAction(cancleAction)
        alertVC.addAction(confirmAction)
        vc.present(alertVC, animated: true, completion: nil)
    }

    func defaultConfirm(title: String, message: String, vc: UIViewController, source: @escaping () -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: NSLocalizedString("确定",comment:""), style: .default) { (UIAlertAction) in
            source()
        }

        alertVC.addAction(confirmAction)
        vc.present(alertVC, animated: true, completion: nil)
    }

    /// 默认只带确认事件响应的提示框
    func sheetAction(title: String, message: String, vc: UIViewController, source: @escaping () -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        let confirmAction = UIAlertAction(title: NSLocalizedString("确定",comment:""), style: .default) { (UIAlertAction) in
            source()
        }

        let cancleAction = UIAlertAction(title: NSLocalizedString("取消",comment:""), style: .default, handler: nil)
        alertVC.addAction(cancleAction)
        alertVC.addAction(confirmAction)
        vc.present(alertVC, animated: true, completion: nil)
    }

    /// 完全自定义样式的Alert
    func customAlert(title: String, message: String, confirm: String, cancel: String, vc: UIViewController, confirmBlock: @escaping () -> Void, cancelBlock: @escaping () -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: confirm, style: .default) { (UIAlertAction) in
            confirmBlock()
        }
        let cancelAction = UIAlertAction(title: cancel, style: .default) { (UIAlertAction) in
            cancelBlock()
        }

        alertVC.addAction(confirmAction)
        alertVC.addAction(cancelAction)
        vc.present(alertVC, animated: true, completion: nil)
    }

    func customConfirm(title: String, message: String, confirm: String, vc: UIViewController, source: @escaping () -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: confirm, style: .default) { (UIAlertAction) in
            source()
        }

        alertVC.addAction(confirmAction)
        vc.present(alertVC, animated: true, completion: nil)
    }

    /// 带文本输入的提示框
    func textFiledAlert(title: String, message: String, placeholder: String, vc: UIViewController, source: @escaping (_ text: String) -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertVC.addTextField { (textFiled: UITextField) in
            textFiled.placeholder = placeholder
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("取消",comment:""), style: .default, handler: nil)
        let confirmAction = UIAlertAction(title: NSLocalizedString("确定",comment:""), style: .default) { (UIAlertAction) in
            let login = alertVC.textFields![0]
            source(login.text!)
            print("输入的是：\(String(describing: login.text))")
        }

        alertVC.addAction(cancelAction)
        alertVC.addAction(confirmAction)
        
        vc.present(alertVC, animated: true, completion: nil)
    }
}
