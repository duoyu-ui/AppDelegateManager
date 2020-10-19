//
//  NSArray+Extension.swift
//  EmiotAppCode
//
//  Created by 张炯枫 on 2017/5/27.
//  Copyright © 2017年 Zehuihong. All rights reserved.
//

import UIKit


extension Array {
    
    subscript (safe index:Int) -> Element? {
        return (0..<count).contains(index) ? self[index] : nil
    }
    
    func toJSonString() -> String {
        let data = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        let JSONString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
    
    func toData() -> Data {
        let data = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        return data!
    }
}

extension Array where Element: Hashable {
    // 数组去重处理
    var unique:[Element] {
        var uniq = Set<Element>()
        uniq.reserveCapacity(self.count)
        return self.filter {
            return uniq.insert($0).inserted
        }
    }
}



extension Array {
    
    /// 去重
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}


