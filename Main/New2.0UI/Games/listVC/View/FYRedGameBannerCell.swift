//
//  FYESportsCell.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/19.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit
import Kingfisher


class FYRedGameBannerCell: UITableViewCell {
    
    class func cellHeightWithModel(_ item: Any) -> CGFloat {
        return 112.px
    }
    
    
    var model: GameListData? {
        didSet {
            guard let model = model else {
                return
            }
            guard let imageURL = model.iconSize!.boolValue ? model.maxIcon : model.minIcon else {
                return
            }
            backdropView.setImageWithURL(imageURL, placeholder: "icon_loading_1010_260")
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.colorWithHexStr("FFFFFF")
        self.contentView.backgroundColor = UIColor.colorWithHexStr("FFFFFF")
        
        addSubview(backdropView)
        backdropView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(8)
            make.top.equalTo(5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var backdropView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
}
