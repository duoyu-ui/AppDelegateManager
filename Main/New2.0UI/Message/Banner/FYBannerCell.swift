//
//  FYBannerCell.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/14.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit
import Kingfisher

class FYBannerCell: UICollectionViewCell {
    
    var imageURL: String? {
        didSet {
            guard let url = imageURL else {
                return
            }
            
            bannerView.setImageWithURL(url, placeholder: "common_placeholder")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(bannerView)
        bannerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.top.left.equalTo(5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var bannerView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.baseBackgroundColor
        imageView.addRound(8)
        return imageView
    }()
}
