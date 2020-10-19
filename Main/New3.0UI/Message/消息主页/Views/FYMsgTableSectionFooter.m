//
//  FYMsgTableSectionFooter.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/30.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYMsgTableSectionFooter.h"
#import "FYMessageMainViewController.h"
#import "FYContactAddViewController.h"

@interface FYMsgTableSectionFooter ()
// 标题
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSString *title;
// 高度
@property (nonatomic, assign) CGFloat footerHeight;
//
@property (nonatomic, weak) FYMessageMainViewController *parentViewController;

@end


@implementation FYMsgTableSectionFooter

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                 footerHeight:(CGFloat)footerHeight
         parentViewController:(FYMessageMainViewController *)parentViewController
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        _footerHeight = footerHeight;
        _parentViewController = parentViewController;
        [self createView];
        [self setViewAtuoLayout];
    }
    return self;
}

- (void)createView
{
    self.titleLabel = [[UILabel alloc] init];
    [self addSubview:self.titleLabel];
    [self.titleLabel setText:self.title];
    [self.titleLabel setTextColor:COLOR_HEXSTRING(@"#1296DB")];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setFont:FONT_PINGFANG_REGULAR(16)];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressFooterAction:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)setViewAtuoLayout
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).offset(margin);
        make.right.equalTo(self.mas_right).offset(-margin);
    }];
}

- (void)pressFooterAction:(UITapGestureRecognizer *)gesture
{
    if ([[AppModel shareInstance] isGuest]) {
        return;
    }
    
    // 添加朋友
    FYContactAddViewController *VC = [[FYContactAddViewController alloc] init];
    [self.parentViewController.navigationController pushViewController:VC animated:YES];
}


@end

