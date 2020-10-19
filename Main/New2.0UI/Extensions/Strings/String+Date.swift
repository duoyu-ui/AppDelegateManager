//
//  String+Date.swift
//  FY-IMChat
//
//  Created by Jetter on 2019/2/28.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit
import Foundation
import SwiftDate

extension String {
    
    /// 通用时间 HH:mm MM-dd
    ///
    /// - Returns: 本地时间
    func commonDateString() -> String? {
        let region = Region.current
        let update = self.toISODate(region: region)
        let date = update?.date.convertTo(region: region)
        let now = date?.toFormat("HH:mm MM-dd", locale: region.locale)
        return now
    }
    
    /// 日期时间 yyyy-MM-dd HH:mm:ss
    ///
    /// - Returns: 本地时间
    func allDateString() -> String? {
        let region = Region.current
        let update = self.toISODate(region: region)
        let date = update?.date.convertTo(region: region)
        let now = date?.toFormat("yyyy-MM-dd HH:mm:ss", locale: region.locale)
        return now
    }
    
    /// 日期 yyyy-MM-dd
    ///
    /// - Returns: 本地时间
    func dateDayString() -> String? {
        let region = Region.current
        let update = self.toISODate(region: region)
        let date = update?.date.convertTo(region: region)
        let now = date?.toFormat("yyyy-MM-dd", locale: region.locale)
        return now
    }
    
    /// 日期 yyyy.MM.dd
    ///
    /// - Returns: 本地时间
    func dotDateString() -> String? {
        let region = Region.current
        let update = self.toISODate(region: region)
        let date = update?.date.convertTo(region: region)
        let now = date?.toFormat("yyyy.MM.dd", locale: region.locale)
        return now
    }
    
    /**
     时间戳转为时间
     
     - returns: 时间字符串
     */
    func timeStampToString() -> String {
        let string = NSString(string: self)
        let timeSta: TimeInterval = string.doubleValue / 1000.0
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: date)
    }
    
    /**
     时间戳转为NSDate
     
     - returns: NSDate
     */
    func timeStampToDate() -> Date {
        let string = NSString(string: self)
        let timeSta: TimeInterval = string.doubleValue
        let date = Date(timeIntervalSince1970: timeSta)
        return date
    }
    
    /**
     时间转为时间戳
     
     - returns: 时间戳字符串
     */
     func stringToTimeStamp() -> String {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dfmatter.date(from: self)
        let dateStamp: TimeInterval = date!.timeIntervalSince1970
        let dateSt:Int = Int(dateStamp)
        return String(dateSt)
    }
    
    
    /**
     获取当前为毫秒的时间戳
     
     - returns: 时间戳字符串
     */
    func stringToMilliStamp() -> String {
        let timeInterval = Date().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        let stamp = "\(millisecond)"
        return stamp
    }
    
    /**
     时间戳处理(当前时间比较)
     
     - returns: 对比时间
     */
    func compareCurrentTime() -> String {
        let string = NSString(string: self)
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let timeDate = formatter.date(from: string as String)
        let currentDate = Date()
        let timeInterval: TimeInterval = currentDate.timeIntervalSince(timeDate!)
        
        var temp: Double = 0
        var result = String()
        if (timeInterval/60 < 1) {
            result = "刚刚"
        }else if ((timeInterval/60)<60){
            temp = timeInterval/60
            result = String(format:"%ld分钟前", Int(temp))
            
        }else if ((timeInterval/60/60)<24){
            temp = timeInterval/60/60
            result = String(format:"%ld小时前", Int(temp))
            
        }else if ((timeInterval/60/60/24)<30){
            temp = timeInterval/60/60/24
            result = String(format:"%ld天前", Int(temp))
            
        }else if ((timeInterval/60/60/24/30)<12){
            temp = timeInterval/60/60/24/30
            result = String(format:"%ld月前", Int(temp))
            
        }else{
            temp = timeInterval/60/60/24/30/12
            result = String(format:"%ld年前", Int(temp))
        }
        
        return result
    }
    
}

// MARK: - 当前时间比较显示

extension String {
    
    /// 比较当前时间显示对应日期
    /// - Parameter date: 需要比较的时间
    /// - Parameter dateFormat: 时间显示格式
    func compareCurrentTimeWithDate(date: Date, dateFormat: String? = "yyyy/MM/dd") -> String {
        let calendar = Calendar.current
        
        let unit: Set<Calendar.Component> = [Calendar.Component.day, Calendar.Component.month , Calendar.Component.year]
        let nowCp = calendar.dateComponents(unit, from: Date.init())
        let myCp = calendar.dateComponents(unit, from: date)
        
        let dateForm = DateFormatter.init()
        
        let component = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.weekday] , from: date)
        
        if nowCp != myCp {
            dateForm.dateFormat = dateFormat
        } else {
            if nowCp == myCp {
                dateForm.amSymbol = "上午"
                dateForm.pmSymbol = "下午"
                dateForm.dateFormat = "aaa hh:mm"
            } else if (nowCp.day! - myCp.day!) == 1 {
                dateForm.amSymbol = "上午"
                dateForm.pmSymbol = "下午"
                dateForm.dateFormat = "昨天"
            } else {
                if (nowCp.day! - myCp.day!) <= 7 {
                    switch component.weekday {    
                    case 1:
                        dateForm.dateFormat = "星期日"
                        break
                    case 2:
                        dateForm.dateFormat = "星期一"
                        break
                    case 3:
                        dateForm.dateFormat = "星期二"
                        break
                    case 4:
                        dateForm.dateFormat = "星期三"
                        break
                    case 5:
                        dateForm.dateFormat = "星期四"
                        break
                    case 6:
                        dateForm.dateFormat = "星期五"
                        break
                    case 7:
                        dateForm.dateFormat = "星期六"
                        break
                    default:
                        break
                    }
                } else {
                    // 显示具体时间
                    dateForm.dateFormat = dateFormat
                }
            }
        }
        
        return dateForm.string(from: date)
    }
}

extension String {
    /// 获取当前时间
    static func currentTime() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        return dateformatter.string(from: Date.init())
    }
}
