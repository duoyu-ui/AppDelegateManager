//
//  LWUIImage+Extension.swift
//  FY-IMChat
//
//  Created by Jetter on 2019/2/28.
//  Copyright © 2019 development. All rights reserved.
//

import Foundation

extension UIImage {
 
    /// 颜色转化为图片
    class func imageWithColor(_ color: UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /// 图片去锯齿
    func setAntialiasedImage(_ size: CGSize, _ scale: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(x: 1, y: 1, width: size.width-2, height: size.height-2))
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 图片置灰
    func setAshPlacingImage(_ sourceImage: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: nil , width: Int(self.size.width), height: Int(self.size.height),bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        context?.draw(sourceImage.cgImage!, in: CGRect.init(x: 0, y: 0, width: sourceImage.size.width, height: sourceImage.size.height))
        let cgImage = context!.makeImage()
        let grayImage = UIImage.init(cgImage: cgImage!)
        return grayImage
    }
    
    /// 截屏使用
    func screenShotWithoutMask(shotView: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(shotView.frame.size, true, 0.0)
        let curScreenW = UIScreen.main.bounds.size.width
        let curScreenH = UIScreen.main.bounds.size.width
        shotView.drawHierarchy(in: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: curScreenW, height: curScreenH)), afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
    /// 返回不同颜色的新图片
    func changeColor(color: UIColor) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        
        let context = UIGraphicsGetCurrentContext();
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(.normal)
        
        let rect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context?.clip(to: rect, mask: self.cgImage!)
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage
    }
    
    /// 返回不被拉伸的图片
    class func imageWithRenderingMode(_ named: String) -> UIImage {
        let newImage = UIImage(named: named)
        return (newImage?.withRenderingMode(.alwaysOriginal))!
    }
    
    /**
     生成高清二维码
     */
    class func createQRForString(_ qrString: String, qrScale: CGFloat = 172) -> UIImage {
        if qrString.isEmpty == true{
            return UIImage()
        }
        // 将字符串转换为二进制
        let data = qrString.data(using: String.Encoding.utf8, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        let qrCIImage = filter.outputImage
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(qrCIImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        
        let outImage = colorFilter.outputImage
        let scale = qrScale / outImage!.extent.size.width;
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let transformImage = colorFilter.outputImage!.transformed(by: transform)
        let image = UIImage(ciImage: transformImage)
        
        return image
    }
    
    /// 拉伸按钮背景图片
    class func resizableImage(_ image: UIImage) -> UIImage {
        let w: CGFloat = image.size.width * 0.5
        let h: CGFloat = image.size.height * 0.5
        return image.resizableImage(withCapInsets: UIEdgeInsets(top: w, left: h, bottom: w, right: h))
    }
}

// 扩展 UIImage 的 init 方法，获得渐变效果
public extension UIImage {
    
    convenience init?(gradientColors:[UIColor], size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = gradientColors.map {(color: UIColor) -> AnyObject? in return color.cgColor as AnyObject } as NSArray
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)
        // 第二个参数是起始位置，第三个参数是终止位置
        context!.drawLinearGradient(gradient!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: size.width, y: 0), options: CGGradientDrawingOptions(rawValue: 0))
        self.init(cgImage: (UIGraphicsGetImageFromCurrentImageContext()?.cgImage)!)
        UIGraphicsEndImageContext()
    }
}
