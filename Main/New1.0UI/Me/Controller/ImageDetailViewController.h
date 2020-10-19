//
//  ImageDetailViewController.h
//  Project
//
//  Created by fy on 2019/1/28.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "SuperViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageDetailViewController : SuperViewController
/// 图片url
@property (nonatomic, strong) NSString *imageUrl;
/// 背景色
@property (nonatomic, strong) UIColor *bgColor;
/// 距离屏幕边框的距离
@property (nonatomic, assign) NSInteger insetsValue;

@property (nonatomic, assign) BOOL hiddenNavBar;

@property (nonatomic, assign) BOOL top;//是否置顶

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIScrollView *scrollView;

- (void)loadImageUrl;
- (void)writeTitle;

@end

NS_ASSUME_NONNULL_END
