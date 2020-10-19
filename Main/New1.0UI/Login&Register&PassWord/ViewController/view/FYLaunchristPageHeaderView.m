//
//  FYLaunchristPageHeaderView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/1/14.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYLaunchristPageHeaderView.h"
#import <TYCyclePagerView.h>
#import "FYLaunchristPageCell.h"
#import "FYLaunchPageModel.h"
@interface FYLaunchristPageHeaderView()<TYCyclePagerViewDelegate,TYCyclePagerViewDataSource>
@property (nonatomic ,strong)UIView *backView;
@property (nonatomic ,strong)TYCyclePagerView *pageView;
@property (nonatomic ,strong)TYPageControl *pageControl;
@end
@implementation FYLaunchristPageHeaderView


- (void)setModel:(FYLaunchModels *)model{
    _model = model;
    
    self.pageControl.numberOfPages = model.data.skAdvDetailList.count;
    [self.pageView reloadData];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.mas_equalTo(5);
            make.width.mas_equalTo(kScreenWidth - 30);
            make.bottom.mas_equalTo(-20);
        }];
        [self.backView addSubview:self.pageView];
        [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.backView);
            make.top.left.mas_equalTo(4);
        }];
        [self.pageView addSubview:self.pageControl];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.mas_equalTo(self.pageView.mas_bottom).offset(-3);
            make.height.mas_equalTo(10);
            make.width.mas_equalTo(self.pageView.mas_width);
        }];
    }
    return self;
}
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView{
    return self.model.data.skAdvDetailList.count;
}
- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index{
    FYLaunchristPageCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"FYLaunchristPageCell" forIndex:index];
    NSArray *items = [FYLaunchSkAdvDetailList mj_objectArrayWithKeyValuesArray:self.model.data.skAdvDetailList];
    cell.list = items[index];
    return cell;
}
- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView{
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = self.pageView.size;
    return layout;
}
- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
  
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = UIColor.whiteColor;
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 4;
    }
    return _backView;
}
- (TYCyclePagerView *)pageView{
    if (!_pageView) {
        _pageView = [[TYCyclePagerView alloc]init];
        _pageView.isInfiniteLoop = YES;
        _pageView.autoScrollInterval = 3.0;
//        _pageView.layer.borderWidth = 1;
//        _pageView.backgroundColor = UIColor.grayColor;
        _pageView.delegate = self;
        _pageView.dataSource = self;
        [_pageView registerClass:[FYLaunchristPageCell class] forCellWithReuseIdentifier:@"FYLaunchristPageCell"];
        [_pageView addSubview:self.pageControl];
    }
    return _pageView;
}
- (TYPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[TYPageControl alloc]init];
        _pageControl.currentPageIndicatorSize = CGSizeMake(6, 6);
    }
    return _pageControl;
}
@end
