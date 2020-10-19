//
//  SSChatKeyBordFunctionView.m
//  SSChatView
//
//  Created by soldoros on 2018/9/25.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import "SSChatKeyBordFunctionView.h"
#import "SSMenuDataHelper.h"

@interface SSChatKeyBordFunctionView()

@property (nonatomic, assign) NSInteger numberPage;

@property (nonatomic, strong) UIPageControl *pageControll;

@property (nonatomic, strong) NSArray <SSChatMenuConfig *>*dataSource;

@property (nonatomic, assign) NSInteger count;

@end


@implementation SSChatKeyBordFunctionView

#pragma mark - getter

- (NSArray<SSChatMenuConfig *> *)dataSource {
    
    if (!_dataSource) {
        _dataSource = [[SSMenuDataHelper sharedHelper] loadMenusWithChatType:[AppModel shareInstance].chatType
                                                                  officeFlag:[AppModel shareInstance].officeFlag
                                                                    gameType:[AppModel shareInstance].gameType];
    }
    return _dataSource;
}


#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.count = 8;
        self.backgroundColor = SSChatCellColor;
        if (self.dataSource.count == 0) {
            NSLog(NSLocalizedString(@"数据源不能为空", nil));
        }

        NSInteger number = self.dataSource.count / self.count + (self.dataSource.count % self.count == 0 ? 0 : 1);
        
        _mScrollView = [UIScrollView new];
        _mScrollView.frame = self.bounds;
        _mScrollView.centerY = self.height * 0.5;
        _mScrollView.backgroundColor = SSChatCellColor;
        _mScrollView.pagingEnabled = YES;
        _mScrollView.delegate = self;
        [self addSubview:_mScrollView];
        _mScrollView.maximumZoomScale = 2.0;
        _mScrollView.minimumZoomScale = 0.5;
        _mScrollView.canCancelContentTouches = NO;
        _mScrollView.delaysContentTouches = YES;
        _mScrollView.showsVerticalScrollIndicator = FALSE;
        _mScrollView.showsHorizontalScrollIndicator = FALSE;
        _mScrollView.backgroundColor = [UIColor clearColor];
        _mScrollView.contentSize = CGSizeMake(FYSCREEN_Width *number, self.height);
        
        // 开始布局
        for(NSInteger i = 0; i < number; ++i) {
            UIView *backView = [UIView new];
            backView.bounds = CGRectMake(0, 0, self.width-40, self.height-55);
            backView.centerX = self.width*0.5 + i*self.width;
            backView.top = 20;
            [_mScrollView addSubview:backView];

            for(NSInteger j = (i * self.count); j < (i+1) * self.count; ++j) {
                
                UIView *btnView = [UIView new];
                btnView.bounds = CGRectMake(0, 0, backView.width/4, backView.height*0.5);
                btnView.left = j%4 * btnView.width;
                btnView.top = (j/4)%2*btnView.height;
                [backView addSubview:btnView];
                btnView.backgroundColor = SSChatCellColor;
                
                if (j < self.dataSource.count) {
                    SSChatMenuConfig *model = self.dataSource[j];
                    
                    btnView.tag = model.tag;
                    
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.bounds = CGRectMake(0, 0, 55, 55);
                    btn.top = 10;
                    btn.titleLabel.font = [UIFont systemFontOfSize:14];
                    btn.centerX = btnView.width*0.5;
                    [btnView addSubview:btn];
                    
                    [btn setBackgroundImage:[UIImage imageNamed:model.image] forState:UIControlStateNormal];
                    btn.userInteractionEnabled = YES;
                    
                    UILabel *lab = [UILabel new];
                    lab.bounds = CGRectMake(0, 0, 80, 20);
                    lab.text = model.title;
                    lab.font = [UIFont systemFontOfSize:12];
                    lab.textColor = [UIColor grayColor];
                    lab.textAlignment = NSTextAlignmentCenter;
                    [lab sizeToFit];
                    lab.centerX = btnView.width * 0.5;
                    lab.top = btn.bottom + 10;
                    [btnView addSubview:lab];
                    lab.userInteractionEnabled = YES;
                
                }
                
                UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerGestureClick:)];
                [btnView addGestureRecognizer:gesture];
                
            }
        }
        
        CGFloat pagerH = 10;
        _pageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.width, pagerH)];
        _pageControll.numberOfPages = number;
        _pageControll.currentPage = 0;
        [_pageControll setCurrentPageIndicatorTintColor:[UIColor grayColor]];
        [_pageControll setPageIndicatorTintColor:makeColorRgb(200, 200, 200)];
        _pageControll.hidden = self.dataSource.count <= 8;
        [self addSubview:_pageControll];
        [_pageControll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.size.mas_equalTo(CGSizeMake(self.width, pagerH));
        }];
        
    }
    
    return self;
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.mScrollView) {
        if (scrollView.contentOffset.x >= FYSCREEN_Width * self.numberPage){
            self.numberPage = 1;
        } else {
            self.numberPage = 0;
        }
        
        self.pageControll.currentPage = (self.mScrollView.contentOffset.x / FYSCREEN_Width);
    }
}


#pragma mark - Action

-(void)footerGestureClick:(UITapGestureRecognizer *)sender {
    
    if(_delegate && [_delegate respondsToSelector:@selector(SSChatKeyBordFunctionViewBtnClick:)]){
        
        [_delegate SSChatKeyBordFunctionViewBtnClick:sender.view.tag];
    }
}


@end
