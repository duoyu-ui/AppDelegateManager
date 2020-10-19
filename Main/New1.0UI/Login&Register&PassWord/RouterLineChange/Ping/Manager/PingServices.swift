//
//  PingServices.swift


import UIKit

/// ping状态
///
/// - start: 开始ping
/// - fail: 发包失败
/// - normal: 接收到正常包
/// - abnormal: 接收到异常包
/// - timeout: 超时
/// - error: 错误
/// - finished: 完成
enum PingStatus {
    case start
    case fail
    case normal
    case abnormal
    case timeout
    case error
    case finished
}

class PingItem: NSObject {
    
    /// 主机名
    var hostName: String?
    
    /// 单次耗时（单位：毫秒）
    var timeMilliseconds: Double = 0.0
    
    /// ping状态
    var status: PingStatus?
    
    var avg : Double = 0.0
    
}

class PingServices: NSObject {

    fileprivate var hostName: String?
    fileprivate var pinger: SimplePing?
    fileprivate var sendTimer: Timer?
    fileprivate var startDate: Date?
    fileprivate var runloop: RunLoop?
    fileprivate var pingCallback: ((_ pingItem: PingItem) -> ())?
    fileprivate var count: Int = 0
    
    init(hostName: String, count: Int, pingCallback: @escaping (_ pingItem: PingItem) -> ()) {
        super.init()
        self.hostName = hostName
        self.count = count
        self.pingCallback = pingCallback
        let pinger = SimplePing(hostName: hostName)
        self.pinger = pinger
        pinger.addressStyle = .any
        pinger.delegate = self
        pinger.start()
    }
    
    /// 开始ping服务
    ///
    /// - Parameters:
    ///   - hostName: 主机名
    ///   - count: ping次数
    ///   - pingCallback: 回调
    class func start(hostName: String, count: Int, pingCallback: @escaping (_ pingItem: PingItem) -> ()) -> PingServices {
        return PingServices(hostName: hostName, count: count, pingCallback: pingCallback)
    }
    
    /// 停止ping服务
    @objc fileprivate func stop() {
        clean(status: .finished)
    }
    
    /// ping超时
    @objc fileprivate func timeout() {
        clean(status: .timeout)
    }
    
    /// ping失败
    @objc fileprivate func fail() {
        clean(status: .error)
    }
    
    /// 清理数据
    fileprivate func clean(status: PingStatus) {
        
        let pingItem = PingItem()
        pingItem.hostName = self.hostName
        pingItem.status = status
        pingCallback?(pingItem)
        pinger?.stop()
        pinger = nil
        sendTimer?.invalidate()
        sendTimer = nil
        runloop?.cancelPerform(#selector(timeout), target: self, argument: nil)
        runloop = nil
        hostName = nil
        startDate = nil
        pingCallback = nil
        
    }
    
    /// 发送ping指令
    @objc fileprivate func sendPing() {
        if count < 1 {
            stop()
            return
        }
        count -= 1
        startDate = Date()
        pinger!.send(with: nil)
        runloop?.perform(#selector(timeout), with: self, afterDelay: 1.0)
    }
    
}

// MARK: - SimplePingDelegate
extension PingServices: SimplePingDelegate {
    
    /// 开始ping
    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        self.sendPing()
        assert(self.sendTimer == nil)
        self.sendTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(sendPing), userInfo: nil, repeats: true)
        
        let pingItem = PingItem()
        pingItem.hostName = self.hostName
        pingItem.status = .start
        pingCallback?(pingItem)
    }
    
    /// ping失败
    func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
        runloop?.cancelPerform(#selector(timeout), target: self, argument: nil)
        self.fail()
    }
    
    /// 发包成功
    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
        runloop?.cancelPerform(#selector(timeout), target: self, argument: nil)
    }
    
    /// 发包失败
    func simplePing(_ pinger: SimplePing, didfail packet: Data, sequenceNumber: UInt16, error: Error) {
        runloop?.cancelPerform(#selector(timeout), target: self, argument: nil)
        clean(status: .fail)
    }
    
    /// 接收到正常包
    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        runloop?.cancelPerform(#selector(timeout), target: self, argument: nil)
        let timeMilliseconds = Date().timeIntervalSince(self.startDate!) * 1000
//        print(self.hostName! + " #\(sequenceNumber) 已收到, size=\(packet.count) time=\(String(format: "%.2f", timeMilliseconds)) ms")
        let pingItem = PingItem()
        pingItem.hostName = self.hostName
        pingItem.status = .normal
        pingItem.timeMilliseconds = timeMilliseconds
        pingCallback?(pingItem)
    }
    
    /// 异常包 - 不处理
    func simplePing(_ pinger: SimplePing, didabnormal packet: Data) {
        runloop?.cancelPerform(#selector(timeout), target: self, argument: nil)

    }
}

