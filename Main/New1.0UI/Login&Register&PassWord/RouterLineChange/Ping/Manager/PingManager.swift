//
// PingManager.swift


import UIKit

class PingManager: NSObject {
    
    /// 获取ping最低的ip地址
    ///
    /// - Parameter addressList: ip地址列表
    /// - Returns: 最快的ip
    class func getFastestAddress(addressList: [String], finished: @escaping (_ finished: [PingItem]) -> ()) -> () {
        if addressList.count == 0 {
            return
        }
        
        // 存储所有ping值
        var pingResult = [String : [PingItem]]()
        var avgResult = [PingItem]();
        
        for address in addressList {
            pingResult[address] = [PingItem]()
            let item = PingItem()
            item.hostName = address
            avgResult.append(item)
        }
        
        // 存储每个ping服务对象
        var pingServicesDict = [String : PingServices?]()
        // 创建任务组
        let group = DispatchGroup()
        for address in addressList {
            group.enter()
            pingServicesDict[address] = PingServices.start(hostName: address, count: 3, pingCallback: { (pingItem) in
                switch pingItem.status! {

                case .finished:
                    pingServicesDict[pingItem.hostName!] = nil
                    group.leave()
                default:
                    pingResult[pingItem.hostName!]!.append(pingItem)
                    self.results(pingResult,avgResult)
                    finished(avgResult)
                    break
                }

            })
            
        }
     
      
        // 任务执行完毕再计算平均ping值
        group.notify(queue: .main) { () -> Void in
            finished(avgResult)
        }
        
    }
    
}

extension PingManager{
    private class func results(_ pingResult:[String : [PingItem]],_ items:[PingItem]) -> Void{
        for item in items {
            let pitem =  pingResult[item.hostName!]
            var sum = 0.0
            for value in pitem ?? [] {
                sum += value.timeMilliseconds
                item.status = value.status
            }
            let avg = sum / Double(pitem?.count ?? 0)
            item.timeMilliseconds = avg
        }
    }
}
