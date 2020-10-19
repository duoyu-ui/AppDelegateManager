//
//  FYPingCircleCell.swift
//  ProjectCSHB
//
//  Created by FangYuan on 2020/2/2.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

import UIKit

class FYPingCircleCell: UICollectionViewCell {
    var pingData:HostPingManager?
    
    func setPingData(ping:HostPingManager){
        if pingData != ping {
            pingData = ping
            ping.setBlock { (title, sinal, sinalColor) in
                self.pingView?.label.text = title;
                self.updateSignal(signal: sinal);
                self.updateColor(color: sinalColor);
            }
        }
        self.pingView?.label.text = ping.msStatus
        self.updateSignal(signal: ping.signal);
        self.updateColor(color: ping.signalColor);
        
    }
    
    func updateSignal(signal:Int){
        pingView?.updateSignal(signal)
    }
    
    func updateColor(color:UIColor){
        pingView?.setCircleColor(color, selected: pingData?.isCurrentSelected ?? false)
    }

    var pingView:FYCircleView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pingView = FYCircleView.init(frame: CGRect.init(origin: .zero, size: frame.size));
        contentView.addSubview(pingView!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HostPingManager: NSObject {
    var hostName:String = ""
    var pingManager:PingServices?
    var pings=[PingItem]()
    var isCurrentSelected = false
    
    func tryToPingAddress(address:String,callBack:@escaping (Int)->Void){
        if hostName == address {
            return;
        }
        hostName = address
        var countSteper = 0
        
        pingManager = PingServices.start(hostName: address, count: 3, pingCallback: { (pingItem) in
            self.pings.append(pingItem);
            self.updateCurrentHostNameDelay()
            countSteper += 1
            if countSteper == 3 {
                callBack(countSteper);
            }
        })
    }
    
    var msStatus = "Loading"
    var signal = 0
    var signalColor: UIColor = UIColor.gray
    var avrageTimes:Double = 0.0
    
    var pingBlock:((String,Int,UIColor)->())?
    
    func setBlock(block:@escaping ((String,Int,UIColor)->())){
        pingBlock = block
    }
    
    func callUpdate(){
        if pingBlock != nil {
            pingBlock!(msStatus,signal,signalColor)
        }
    }
    
    func updateCurrentHostNameDelay(){
        var countTime: Double = 0;
        var countSteper: Int = 0;
        for ping in pings {
            if ping.timeMilliseconds > 0 {
                countTime += ping.timeMilliseconds;
                countSteper += 1
            }
        }
        let avrageTime = countTime / Double(countSteper)
        avrageTimes = avrageTime;
        msStatus = "\(String(format: "%.2f", avrageTime))ms"
        if avrageTime < 100 {
            signal = 4
//            signalColor = .green
        }else if avrageTime < 200 {
            signal = 3
//            signalColor = .blue
        }else if avrageTime < 300 {
            signal = 2
//            signalColor = .yellow
        }else if avrageTime < 400 {
            signal = 1
//            signalColor = .purple
        }else{
            signal = 0
//            signalColor = .red
        }
        if pingBlock != nil {
            pingBlock!(msStatus,signal,signalColor)
        }
    }
}


