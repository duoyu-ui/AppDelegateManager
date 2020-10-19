//
//  UIImageView+Kingfisher.swift
//  MK-MChain
//
//  Created by Jetter on 2019/2/28.
//  Copyright © 2019 miku. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher

enum ImageResult {
    case success(UIImage)
    case failure(String)
}

extension UIImageView {
    
    /// 设置网络图片
    ///
    /// - Parameter url: 网络图片资源url
    func setImageWithURL(_ url: String) {
        guard let imageURL = url.URLValue else {
            return
        }
        
        kf.setImage(with: imageURL)
    }
    
    
    /// 设置网络图片及占位图
    ///
    /// - Parameters:
    ///   - url: 网络图片资源url
    ///   - placeholder: 占位图片
    func setImageWithURL(_ url: String, placeholder: UIImage = UIImage()) {
        guard let imageURL = url.URLValue else {
            return
        }
        
        kf.setImage(with: imageURL, placeholder: placeholder)
    }
    
    
    /// 设置网络图片及占位图
    ///
    /// - Parameters:
    ///   - url: 网络图片资源url
    ///   - placeholder: 占位图片名称
    func setImageWithURL(_ url: String, placeholder: String) {
        guard let imageURL = url.URLValue else {
            return
        }
        
        kf.setImage(with: imageURL, placeholder: UIImage(named: placeholder))
    }
    
    
    /// 设置本地Gif图片
    ///
    /// - Parameters:
    ///   - imageName: 图片名称
    ///   - placeholder: 占位图片
    func setLocalGifWithImage(_ image: String, placeholder: UIImage = UIImage()) {
        let path = Bundle.main.path(forResource: image, ofType: "gif")
        let data = NSData(contentsOfFile: path ?? "") as Data?
        guard data != nil else {
            return
        }
        
        
        self.kf.setImage(with: ImageResource(downloadURL: URL(fileURLWithPath: path!)),
                                placeholder: placeholder)
        //self.contentMode = .scaleAspectFill
    }
    
    /// 下载网络图片资源
    ///
    /// - Parameters:
    ///   - url: 网络图片资源url
    ///   - placeholder: 占位图片名称
    ///   - callback: 下载完成回调
    func downloadImageWithURL(_ url: String,
                              placeholder: UIImage = UIImage(),
                              callback:(@escaping (ImageResult) -> ())) {
        guard let _ = URL(string: url) else {
            return
        }
        
//        kf.setImage(with: imageURL, options: [.memoryCacheExpiration(.expired)]) { result in
//            switch result {
//            case .success(let value):
//                print("Task done for: \(value.source.url?.absoluteString ?? "")")
//                callback(ImageResult.success(try! result.get().image))
//            case .failure(let error):
//                print("Job failed: \(error.localizedDescription)")
//                callback(ImageResult.failure("Job failed: \(error.localizedDescription)"))
//            }
//        }
    }
}

