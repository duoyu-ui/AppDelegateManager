//
//  ImageDetailViewController.m
//  Project
//
//  Created by fy on 2019/1/28.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ImageDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface ImageDetailViewController ()<UIGestureRecognizerDelegate>

//@property (nonatomic, assign) NSInteger showBar; //这边用int 是防止右滑返回的一个bug

@end

@implementation ImageDetailViewController


#pragma mark - life cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if(self.navigationController.navigationBarHidden && self.showBar == 0) {
//        self.showBar = 1;
//    }else {
//        self.showBar = 2;
//    }
//    
//    if(self.hiddenNavBar) {
//        if(self.navigationController.navigationBarHidden == NO)
//            [self.navigationController setNavigationBarHidden:YES animated:YES];
//    }else {
//        if(self.navigationController.navigationBarHidden == YES)
//            [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    if(self.showBar == 2) {
//        if (self.navigationController.navigationBarHidden == YES) {
//            [self.navigationController setNavigationBarHidden:NO animated:YES];
//        }
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    if (self.bgColor == nil) {
        self.bgColor = COLOR_X(228, 32, 52);
    }
    self.view.backgroundColor = self.bgColor;
    
    [self setupSuview];
    [self loadImageUrl];
}

#pragma mark - setup

- (void)setupSuview
{
    if (!self.hiddenNavBar) {
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarHeight);
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.navigationController.navigationBar setTranslucent:NO];
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:self.imageView];
    self.scrollView = scrollView;
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    if (self.hiddenNavBar) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:ICON_NAVIGATION_BAR_BUTTON_BLACK_ARROW] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(self.view).offset(STATUS_BAR_HEIGHT);
            make.width.height.equalTo(@48);
        }];
    }
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadImageUrl {
    if(self.imageUrl) {
        WEAK_OBJ(weakSelf, self);
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [weakSelf restImageScrollLayout:image];
        }];
    }
}


- (void)restImageScrollLayout:(UIImage *)image {
    if (!image) {
        return;
    }
    
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    float rate = image.size.width / image.size.height;
    float x = self.insetsValue;
    float width = SCREEN_WIDTH - x * 2;
    float height = width / rate;
    height += self.insetsValue;
    self.imageView.frame = CGRectMake(x, self.insetsValue, width, height);
    if (height <= self.scrollView.frame.size.height)
        height = self.scrollView.frame.size.height + 1;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, height);
    
    if(!self.top) {
        if(self.imageView.frame.size.height < self.scrollView.frame.size.height - 70){
            CGPoint point = self.imageView.center;
            point.y = (self.scrollView.frame.size.height - 70)/2.0;
            self.imageView.center = point;
        }
    }
    
    [self writeTitle];
}

- (void)writeTitle {
    
}


#pragma mark - Navigation

- (BOOL)prefersNavigationBarHidden
{
    return self.hiddenNavBar;
}


@end
