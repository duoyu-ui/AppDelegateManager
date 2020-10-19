//
//  DownLoader.swift
//  Swift
//
//  Created by Tom on 2019/10/22.
//  Copyright © 2019 Tom. All rights reserved.
//

import Foundation
import CryptoSwift
//protocol DownLoaderDelegate:AnyObject{
//    func downloadCompletedCallback(_ json:String)
//    
//    func downloadErrorCallback(_ json:String)
//}
//
///// AES加密解密key
//fileprivate let encryptEecodeKey = "1234567887654321"
//class DownLoader:NSObject  {
//    
//    
//    fileprivate var downLoadedPath : String?
//    fileprivate var downLoadingPath : String?
//    fileprivate var outputStream : OutputStream?
//    fileprivate var tmpSize : CLongLong = 0
//    fileprivate var totalSize : CLongLong = 0
//    weak var delegate : DownLoaderDelegate?
//    
//    fileprivate lazy var session : URLSession  = {
//        
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
//        return session
//        
//    }()
//    
//    func downLoader(url : URL) {
//        let fileName = url.lastPathComponent
//
//        guard url.lastPathComponent.count > 0 else {
//            print("url有问题")
//            return
//        }
//        
//        
//        self.downLoadingPath = FileTool.kTempPath + fileName
//        self.downLoadedPath = FileTool.kCachePath! + "/" + fileName
//        if FileTool.fileExists(filePath: self.downLoadedPath!) {
//            FileTool.removeFile(self.downLoadedPath!)
//        }
//        //检查当前路径是否已经下载了该文件
//        if FileTool.fileExists(filePath: self.downLoadedPath!) {
//            getFileData()
//            return
//        }
// 
//        //如果没有下载完成 就看是否有临时文件
//        if !FileTool.fileExists(filePath: self.downLoadingPath!) {
//            //不存在的话 直接开始下载
//            self.downLoadWithURL(url as URL, 0)
//            return
//        }
//        
//        //已经下载了的 先计算 下载的大小,然后继续下载
//        tmpSize = FileTool.fileSize(self.downLoadingPath!)
//        self.downLoadWithURL(url as URL, tmpSize)
//        
//    }
//    
//    
//    // MARK:- 开始请求资源
//   fileprivate func downLoadWithURL(_ url : URL, _ offset : CLongLong) {
//        var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 0)
//        request.setValue("bytes=%lld-", forHTTPHeaderField: "Range")
//        
//       let dataTask = self.session.dataTask(with: request)
//        
//        dataTask.resume()
//    }
//    ///获取文件数据
//    fileprivate func getFileData(){
//        // 不一定是成功
//        if FileTool.fileExists(filePath: self.downLoadedPath!){
//            let url = URL(fileURLWithPath: self.downLoadedPath!)
//            guard let data = try? Data(contentsOf:url) else {
//                return
//            }
//            ///加密字符串
//            let encryptStr = String(data: data, encoding: .utf8)!
//            ///解密后的字符串
//            let decryptStr = encryptStr.aesDecryption
//            
//            self.delegate?.downloadCompletedCallback(decryptStr)
//        }
//                
//    }
//}
//
//
//extension DownLoader : URLSessionDataDelegate {
//    
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void){
//        
//        let resp = response as! HTTPURLResponse
//
//        let string = resp.allHeaderFields["Content-Length"] as! String
//        
//        let stri : String = string.components(separatedBy: "/").last!
//                
//        self.totalSize = CLongLong(stri)!
//        
//       // 比对本地大小, 和 总大小
//        if (self.tmpSize == self.totalSize) {
//            
//            // 1. 移动到下载完成文件夹
//            print("移动文件到下载完成")
//            FileTool.moveFile(self.downLoadingPath!, self.downLoadedPath!)
//            // 2. 取消本次请求
//            completionHandler(URLSession.ResponseDisposition.cancel);
//            
//            return;
//        }
//        //文件不同,重新下载
//        if (self.tmpSize > self.totalSize) {
//            
//            // 1. 删除临时缓存
//            FileTool.removeFile(self.downLoadingPath!)
//            // 2. 从0 开始下载
//            self.downLoader(url: resp.url! as URL)
//
//            // 3. 取消请求
//            completionHandler(URLSession.ResponseDisposition.cancel);
//            
//            return;
//            
//        }
//        // 继续接受数据
//        // 确定开始下载数据
//        self.outputStream = OutputStream(toFileAtPath: self.downLoadingPath!, append: true)
//        
//        self.outputStream?.open()
//        completionHandler(URLSession.ResponseDisposition.allow);
//    }
//    
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
//        
//        var buffer = [UInt8](repeating: 0, count: data.count)
//        data.copyBytes(to: &buffer, count: data.count)
//        
//        self.outputStream?.write(buffer, maxLength: data.count)
//
//    }
//    
//    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
//        
//        if (error == nil) {
//            task.cancel()
//            //请求完成,获取本地文件,
//            FileTool.moveFile(self.downLoadingPath!, self.downLoadedPath!)
//            getFileData()
//           
//        }else {
////            print(error?.localizedDescription as Any)
////            getFileData()
//            self.delegate?.downloadErrorCallback(error?.localizedDescription ?? "downloadError")
//        }
//        self.outputStream?.close()
//    }
//    //data解析成字典
//    func dataToDictionary(data:Data) ->Dictionary<String, Any>?{
//
//        do{
//
//            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
//
//            let dic = json as! Dictionary<String, Any>
//
//            return dic
//
//        }catch _ {
//
//            print("失败")
//
//            return nil
//
//        }
//
//    }
//
//}
//
///// 文件操作
//struct FileTool {
//    //缓存目录
//    static let kCachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
//    //临时目录
//    static let kTempPath = NSTemporaryDirectory()
//    // MARK:- 判断文件目录是否存在
//    static func fileExists(filePath : String) -> Bool {
//        
//        if (filePath.count == 0) {
//            return false
//        }
//        return FileManager.default.fileExists(atPath: filePath)
//    }
//   
//    // MARK:- 获取文件的大小
//    static func  fileSize(_ filePath : String) ->CLongLong{
//    
//        if !self.fileExists(filePath: filePath) {
//            return 0
//        }
//        
//        let fileInfo = try! FileManager.default.attributesOfItem(atPath: filePath)
//        
//        return fileInfo[FileAttributeKey.size] as! CLongLong
//        
//    }
//    
//    // MARK:- 移动文件
//    static func moveFile(_ fromPath : String , _ toPath : String){
//        if self.fileSize(fromPath)  == 0 {
//            return
//        }
////        guard fileExists(filePath: toPath) else {
////            return
////        }
//        if fileExists(filePath: toPath) {
//            removeFile(toPath)
//        }
//        try! FileManager.default.moveItem(atPath: fromPath, toPath: toPath)
//    }
//    
//    /// 删除文件
//    static func removeFile(_ filePath : String){
//        do {
//            try FileManager.default.removeItem(atPath: filePath)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//}

extension String{
    
    ///加密 AES:加密模式:CBC 填充：PKCS7Padding ，数据块： 128  base64 utf-8：
    var aesEncryption: String{
        do {
            if let base64 = self.data(using: .utf8){
                let aes = try AES(key: "1234567887654321", iv: "1234567887654321", padding:.pkcs7)
                let encrypt = try aes.encrypt(base64.bytes)
                return encrypt.toBase64()!
            }
            return ""
        } catch  {
            kLog("加密错误")
            return ""
        }
    }
    ///解密 AES:解密模式:CBC 填充：PKCS7Padding ，数据块： 128  base64 utf-8：
    var aesDecryption: String {
        do {
            if let base64 = Data(base64Encoded: self) {
                let aes = try AES(key: "1234567887654321", iv: "1234567887654321",padding: .pkcs7)
                let decrypted = try aes.decrypt(base64.bytes)
                
                return String(bytes: decrypted, encoding: .utf8)!
            }
            return ""

        } catch {
            kLog("解密错误")
            return ""
        }
    }
}
