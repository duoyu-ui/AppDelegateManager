//
//  FYBannerView.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/13.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

private let kBannerIdentifier = "kBannerIdentifier"

@objc protocol CycleBannerDelegate: AnyObject{
    /// 点击轮播图
    func didSelectedLine(index: Int)
    /// 点击跑马灯
    func didSelectedMarquee()
}

@objcMembers
class FYBannerView: UIView {
    
   open var bannerImages = [String]() {
        didSet {
            pageControl.isHidden = bannerImages.count > 0 ? false : true
            cyclePagerView.isHidden = bannerImages.count > 0 ? false : true
            
            pageControl.numberOfPages = bannerImages.count
            cyclePagerView.reloadData()
            
            self.needsUpdateConstraints()
        }
    }
    
    var marqueeList = [String]() {
        didSet {
            guard marqueeList.count != 0 else { return }
            self.labelMarquee.textStringGroup = marqueeList
        }
    }

    ///点击轮播图代理
    weak var delegate: CycleBannerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        cyclePagerView.addSubview(pageControl)
        addSubview(cyclePagerView)
        
        marqueeView.addSubview(labelMarquee)
        addSubview(marqueeView)
        
        marqueeView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(35)
        }
        
        cyclePagerView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(marqueeView.snp.top)
            make.top.left.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(cyclePagerView.snp.bottom).offset(-5)
            make.height.equalTo(20)
        }
        
        labelMarquee.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///轮播图
    lazy var cyclePagerView: TYCyclePagerView = {
        let cyclePagerView = TYCyclePagerView()
        cyclePagerView.isInfiniteLoop = true
        cyclePagerView.delegate = self
        cyclePagerView.isHidden = true
        cyclePagerView.dataSource = self
        cyclePagerView.register(FYBannerCell.classForCoder(), forCellWithReuseIdentifier: kBannerIdentifier)
        return cyclePagerView
    }()
    
    lazy var pageControl: TYPageControl = {
        let pageControl = TYPageControl()
        pageControl.currentPageIndicatorSize = CGSize(width: 8, height: 8)
        pageControl.isHidden = true
        return pageControl
    }()

    ///文字跑马灯
    lazy var labelMarquee: AutoHorizontalMarquee = {
        let frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 35)
        let autoLabelView = AutoHorizontalMarquee(frame: frame)
        autoLabelView.autoBackColor = .white
        autoLabelView.textFont = UIFont.systemFont(ofSize: 14)
        autoLabelView.textColor = UIColor.kTextColor
        autoLabelView.delegate = self
        return autoLabelView
    }()
    
    ///跑马灯背景view
    lazy var marqueeView: UIView = {
        let view = UIView()
        return view
    }()
}

extension FYBannerView {
    
    @objc private func marqueeAction() {
        self.delegate?.didSelectedMarquee()
    }
}

// MARK: - AutoMarqueeDelegate

extension FYBannerView: AutoMarqueeDelegate {
    
    func autoDidSelectIndex(_ marquee: AutoHorizontalMarquee, index: Int) {
        
        self.marqueeAction()
    }
}

// MARK: - TYCyclePagerViewDelegate

extension FYBannerView: TYCyclePagerViewDelegate {
    
    func pagerView(_ pageView: TYCyclePagerView, didScrollFrom fromIndex: Int, to toIndex: Int) {
        pageControl.currentPage = toIndex
    }
    
    func pagerView(_ pageView: TYCyclePagerView, didSelectedItemCell cell: UICollectionViewCell, at indexSection: TYIndexSection) {
        self.delegate?.didSelectedLine(index: indexSection.index)
    }
}

// MARK: - TYCyclePagerViewDataSource

extension FYBannerView: TYCyclePagerViewDataSource {
    
    func numberOfItems(in pageView: TYCyclePagerView) -> Int {
        return bannerImages.count
    }
    
    func layout(for pageView: TYCyclePagerView) -> TYCyclePagerViewLayout {
        let layout = TYCyclePagerViewLayout()
        layout.itemSize = CGSize(width: cyclePagerView.frame.width, height: cyclePagerView.frame.height)
        layout.itemSpacing = 15
        layout.itemHorizontalCenter = true
        return layout
    }
    
    func pagerView(_ pagerView: TYCyclePagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = cyclePagerView.dequeueReusableCell(withReuseIdentifier: kBannerIdentifier, for: index) as! FYBannerCell
        cell.imageURL = bannerImages[safe: index]
        return cell
    }
    
}
