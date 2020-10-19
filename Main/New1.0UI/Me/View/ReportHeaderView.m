//
//  BillHeadView.m
//  Project
//
//  Created by mini on 2018/8/14.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "ReportHeaderView.h"


#define BClickTAG 1000


@implementation ReportHeaderView

+ (ReportHeaderView *)headView{
    ReportHeaderView *headView = [[ReportHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 75 +8)];
    return headView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initSubviews];
        [self initLayout];
    }
    return self;
}

#pragma mark ----- Data
- (void)initData{
    
}

#pragma mark ----- Layout
- (void)initLayout{
    
}

#pragma mark ----- subView
- (void)initSubviews{
    CGFloat w = (SCREEN_WIDTH)/2;
    CGFloat h = 75;
    NSArray *list = @[@"kaishishijian",@"jieshushijian"];
    NSArray *titles = @[@"",@""];
    for (int i = 0; i<list.count; i++) {
        UIButton *b = [self item:list[i] title:titles[i] frame:CGRectMake((1+w)*(i%2), (1+h)*(i/2), w, h)];//[[UIButton alloc]initWithFrame:];
        b.tag = BClickTAG + i;
        [b addTarget:self action:@selector(handle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:b];
    }
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor =  BaseColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@8);
        make.bottom.equalTo(self);
    }];
    
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor =  BaseColor;
    [self addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.width.equalTo(@0.5);
        make.bottom.equalTo(self).offset(-5);
        make.centerX.equalTo(self);
    }];
}

- (UIButton *)item:(NSString *)img title:(NSString *)title frame:(CGRect)rect{
    UIButton *btn = [[UIButton alloc]initWithFrame:rect];
    btn.backgroundColor = [UIColor whiteColor];
    btn.adjustsImageWhenHighlighted = false;
    [btn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    [btn setTitleColor:Color_3 forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize2:14];
    btn.titleLabel.numberOfLines = 0;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    
    return btn;
}

- (void)handle:(UIButton *)sender{
    if (sender.tag == BClickTAG) {//开始时间
        if (self.beginChange) {
            self.beginChange(nil);
        }
    }
    else if (sender.tag == BClickTAG+1) {//结束时间
        if (self.endChange) {
            self.endChange(nil);
        }
    }
}

- (void)setBeginTime:(NSString *)beginTime{
    _beginTime = beginTime;
    [self update:BClickTAG content:[NSString stringWithFormat:NSLocalizedString(@"开始时间\n%@", nil),beginTime]];
}

- (void)setEndTime:(NSString *)endTime{
    _endTime = endTime;
    [self update:1+BClickTAG content:[NSString stringWithFormat:NSLocalizedString(@"结束时间\n%@", nil),endTime]];
}

- (void)update:(NSInteger)sender content:(NSString *)content{
    UIButton *btn = [self viewWithTag:sender];
    [btn setTitle:content forState:UIControlStateNormal];
}

@end
