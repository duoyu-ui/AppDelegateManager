//
//  MsgHeaderView.m
//  Project
//
//  Created by Aalto on 2019/4/29.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "MsgHeaderView.h"
#import "PreLoginBannerCell.h"

@interface MsgHeaderView ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>
@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) TYPageControl *pageControl;

@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong)id requestParams;
@property (nonatomic, strong) NSArray *imagesModels;
@property (nonatomic ,strong)NSMutableArray *imageURLStrings;
@end
@implementation MsgHeaderView


- (void)actionBlock:(DataBlock)block{
    self.block = block;
}


- (instancetype)initWithFrame:(CGRect)frame WithLaunchAndLoginModel:(id)requestParams WithOccurBannerAdsType:(OccurBannerAdsType)occurBannerAdsType{
    self = [super initWithFrame:frame];
    if (self) {
        _requestParams = requestParams;
        [self publicScrollPartView:frame WithOccurBannerAdsType:occurBannerAdsType];
        
    }
    return self;
}

- (void)publicScrollPartView:(CGRect)frame WithOccurBannerAdsType:(OccurBannerAdsType)occurBannerAdsType{
    UIView * topline = [[UIView alloc]init];
    topline.backgroundColor = HexColor(@"#f6f5fa");
    [self addSubview:topline];
    [topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(3);
        make.left.right.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self);
    }];
    
    [self layoutIfNeeded];
    
    self.pagerView = [[TYCyclePagerView alloc]initWithFrame:CGRectMake( 0,0, frame.size.width, frame.size.height)];
    self.pagerView.layer.borderWidth = 1;
    self.pagerView.dataSource = self;
    self.pagerView.delegate = self;
    // registerClass or registerNib
    [self.pagerView registerClass:[PreLoginBannerCell class] forCellWithReuseIdentifier:@"PreLoginBannerCellid"];
    [self addSubview:self.pagerView];
    
      [self  addPageControl];
    self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.pagerView.frame) - 26, CGRectGetWidth(self.pagerView.frame), 26);
  
       [self richElemenstsInView:_requestParams];
}


/// 指示器
- (void)addPageControl {
    self.pageControl = [[TYPageControl alloc]init];
    self.pageControl.currentPageIndicatorSize = CGSizeMake(6, 6);
    self.pageControl.pageIndicatorSize = CGSizeMake(6, 6);
    self.pageControl.currentPageIndicatorTintColor = HexColor(@"#ffffff");
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self.pagerView addSubview:self.pageControl];
}


-(void)richElemenstsInView:(id)requestParams{
    BannerData* data = requestParams;
    _pagerView.autoScrollInterval = [data.carouselTime intValue];
   self.imagesModels = data.skAdvDetailList;
    
   
    if (self.imagesModels.count>0) {
        for (int i=0; i<self.imagesModels.count; i++) {
            BannerItem *bData = self.imagesModels[i];
            [self.imageURLStrings addObject:[NSString stringWithFormat:@"%@",bData.advPicUrl]];
        }
    }
    if (self.imagesModels.count==1) {
         _pagerView.isInfiniteLoop = NO;
    }else{
          _pagerView.isInfiniteLoop = YES;
    }
    self.pageControl.numberOfPages = self.imagesModels.count;
    [self.pagerView reloadData];
}

#pragma mark - TYCyclePagerViewDataSource

 -(NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.imageURLStrings.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    PreLoginBannerCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"PreLoginBannerCellid" forIndex:index];
//    cell.backgroundColor = _datas[index];
//    cell.label.text = [NSString stringWithFormat:@"index->%ld",index];
    cell.imageUrl = self.imageURLStrings[index];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame), CGRectGetHeight(pageView.frame));
    layout.itemSpacing = 15;
    //layout.minimumAlpha = 0.3;
//    layout.itemHorizontalCenter = _horCenterSwitch.isOn;
    return layout;
}

#pragma mark - TYCyclePagerViewDelegate
-(void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    _pageControl.currentPage = toIndex;
}

-(void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndexSection:(TYIndexSection)indexSection{
     BannerItem *item = self.imagesModels[indexSection.index];
    if (self.block) {
        self.block(item);
    }
}

-(NSMutableArray *)imageURLStrings{
    if (_imageURLStrings == nil) {
        _imageURLStrings = [[NSMutableArray alloc] init];
    }
    return _imageURLStrings;
}
-(NSArray *)imagesModels{
    if (_imagesModels == nil) {
        _imagesModels = [[NSArray alloc] init];
    }
    return _imagesModels;
}
@end
