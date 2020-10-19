//
//  UITextField+Extend.swift
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/10.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

import Foundation


extension UITextField {
    
    /// 文本输入框小数点位数限制（适用于代理方法）
    ///
    /// - Parameters:
    ///   - precision: 小数点精度
    ///   - allText: 输入框所有文本内容
    ///   - replaceText: 正在输入的文本内容
    /// - Returns: 小数点位数限制
    func precisionDotNum(_ precision: Int, range: NSRange, allText: String, replaceText: String) -> Bool {
        let newString = (allText as NSString).replacingCharacters(in: range, with: replaceText)
        let expression = "^[0-9]*((\\.|,)[0-9]{0,\(precision)})?$"
        let regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpression.Options.allowCommentsAndWhitespace)
        let numberOfMatches = regex.numberOfMatches(in: newString, options:NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, (newString as NSString).length))
        return numberOfMatches != 0
    }
}
