//
//  FYAgentRuleSub2ViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYAgentRuleViewController.h"
#import "FYAgentRuleSub2ViewController.h"

@interface FYAgentRuleSub2ViewController () <UIScrollViewDelegate> 
@property(nonatomic, strong) UIScrollView *rootScrollView;
@end

@implementation FYAgentRuleSub2ViewController

#pragma mark - Life Cycle

- (void)resetSubScrollViewSize:(CGSize)size
{
    [super resetSubScrollViewSize:size];
    
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    [self.rootScrollView setFrame:frame];
    [self.rootScrollView setContentSize:frame.size];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat top_bottom_gap = margin * 1.5f;
    CGFloat left_right_gap = margin * 1.5f;
    CGFloat title_contgent_gap_v = margin * 0.8f;
    CGFloat title_contgent_gap_h = margin * 1.0f;
    //
    UIFont *titleFont = FONT_PINGFANG_SEMI_BOLD(15.0f);
    UIColor *titleColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    UIFont *contentFont = FONT_PINGFANG_REGULAR(14);
    UIColor *contentColor = COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT;
    //
    NSDictionary *attriText = @{ NSFontAttributeName:contentFont, NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT};
    NSDictionary *attriMark = @{ NSFontAttributeName:contentFont, NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT};
    
    UIScrollView *rootScrollView = ({
        TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.view.bounds];
        [scrollView setBounces:NO];
        [scrollView setDelegate:self];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [self.view addSubview:scrollView];
        
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            if (CFC_IS_IPHONE_X_OR_GREATER) {
                if (@available(iOS 11.0, *)) {
                    make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
                    make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                } else {
                    make.top.equalTo(self.view.mas_top);
                    make.bottom.equalTo(self.view.mas_bottom);
                }
            } else {
                make.top.equalTo(self.view.mas_top);
                make.bottom.equalTo(self.view.mas_bottom);
            }
        }];
        
        scrollView;
    });
    self.rootScrollView = rootScrollView;
    self.rootScrollView.mas_key = @"rootScrollView";
    
    UIView *containerView = ({
        UIView *view = [[UIView alloc] init];
        [rootScrollView addSubview:view];
        
        CGFloat topNoneHeight = STATUS_NAVIGATION_BAR_HEIGHT + [FYAgentRuleViewController heightOfHeaderSegment] + [FYAgentRuleViewController heightOfHeaderSpline] * 2.0f;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(rootScrollView);
            make.width.equalTo(rootScrollView);
            if (CFC_IS_IPHONE_X_OR_GREATER) {
                make.height.mas_greaterThanOrEqualTo(SCREEN_HEIGHT-topNoneHeight-TAB_BAR_DANGER_HEIGHT+1.0);
            } else {
                make.height.mas_greaterThanOrEqualTo(SCREEN_HEIGHT-topNoneHeight+1.0);
            }
        }];
        view;
    });
    containerView.mas_key = @"containerView";
    
    // 标题1
    UIView *lastItemView = nil;
    {
        UILabel *titleLabel = [UILabel new];
        [containerView addSubview:titleLabel];
        [titleLabel setNumberOfLines:0];
        [titleLabel setText:NSLocalizedString(@"1.什么是代理团队？", nil)];
        [titleLabel setFont:titleFont];
        [titleLabel setTextColor:titleColor];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(containerView.mas_top).offset(top_bottom_gap);
            make.left.equalTo(containerView.mas_left).offset(left_right_gap);
            make.right.equalTo(containerView.mas_right).offset(-left_right_gap);
        }];
        titleLabel.mas_key = @"titleLabel";
        
        UILabel *contentLabel = [UILabel new];
        lastItemView = contentLabel;
        [containerView addSubview:contentLabel];
        [contentLabel setNumberOfLines:0];
        [contentLabel setFont:contentFont];
        [contentLabel setTextColor:contentColor];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(title_contgent_gap_v);
            make.left.equalTo(titleLabel.mas_left).offset(title_contgent_gap_h);
            make.right.equalTo(containerView.mas_right).offset(-left_right_gap);
        }];
        contentLabel.mas_key = @"contentLabel";
        //
        NSArray<NSString *> *stringArray = @[ NSLocalizedString(@"代理团队为参与当前层级用户返水计算的下级用户，包含代理、会员和", nil), NSLocalizedString(@"自己", nil), @"。" ];
        NSArray *attributeArray = @[ attriText, attriMark, attriText ];
        NSAttributedString *attr = [CFCSysUtil attributedString:stringArray attributeArray:attributeArray];
        [contentLabel setAttributedText:attr];
    }
    
    // 标题2
    {
        UILabel *titleLabel = [UILabel new];
        [containerView addSubview:titleLabel];
        [titleLabel setNumberOfLines:0];
        [titleLabel setText:NSLocalizedString(@"2.当前层级为代理", nil)];
        [titleLabel setFont:titleFont];
        [titleLabel setTextColor:titleColor];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastItemView.mas_bottom).offset(top_bottom_gap);
            make.left.equalTo(containerView.mas_left).offset(left_right_gap);
            make.right.equalTo(containerView.mas_right).offset(-left_right_gap);
        }];
        titleLabel.mas_key = @"titleLabel";
        
        UILabel *contentLabel = [UILabel new];
        [containerView addSubview:contentLabel];
        [contentLabel setNumberOfLines:0];
        [contentLabel setText:NSLocalizedString(@"如当前层级是代理，可获得下6级的返水，也可逐级查询下6级的用户信息，以下图为例，当前层级的团队数量为12：", nil)];
        [contentLabel setFont:contentFont];
        [contentLabel setTextColor:contentColor];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(title_contgent_gap_v);
            make.left.equalTo(titleLabel.mas_left).offset(title_contgent_gap_h);
            make.right.equalTo(containerView.mas_right).offset(-left_right_gap);
        }];
        contentLabel.mas_key = @"contentLabel";
        
        UILabel *contentLabel1 = [UILabel new];
        [containerView addSubview:contentLabel1];
        [contentLabel1 setNumberOfLines:0];
        [contentLabel1 setText:NSLocalizedString(@"a、当前用户是[代理0]，能拿到下图所有红色块和绿色块用户的返水，但拿不到灰色块用户的返水；", nil)];
        [contentLabel1 setFont:contentFont];
        [contentLabel1 setTextColor:contentColor];
        [contentLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel.mas_bottom).offset(title_contgent_gap_v);
            make.left.equalTo(titleLabel.mas_left).offset(title_contgent_gap_h);
            make.right.equalTo(containerView.mas_right).offset(-left_right_gap);
        }];
        contentLabel1.mas_key = @"contentLabel1";
        
        UILabel *contentLabel2 = [UILabel new];
        [containerView addSubview:contentLabel2];
        [contentLabel2 setNumberOfLines:0];
        [contentLabel2 setText:NSLocalizedString(@"b、若查询[代理A]，可查到[代理B]，并且可以逐级继续向下查，查到第6级[代理F]后将看不到其下级；", nil)];
        [contentLabel2 setFont:contentFont];
        [contentLabel2 setTextColor:contentColor];
        [contentLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel1.mas_bottom).offset(title_contgent_gap_v);
            make.left.equalTo(titleLabel.mas_left).offset(title_contgent_gap_h);
            make.right.equalTo(containerView.mas_right).offset(-left_right_gap);
        }];
        contentLabel2.mas_key = @"contentLabel2";
        
        UILabel *contentLabel3 = [UILabel new];
        [containerView addSubview:contentLabel3];
        [contentLabel3 setNumberOfLines:0];
        [contentLabel3 setText:NSLocalizedString(@"c、如果查询第6级-[代理F]，代理报表相关数据只统计[代理F]个人数据，不含其下级数据。", nil)];
        [contentLabel3 setFont:contentFont];
        [contentLabel3 setTextColor:contentColor];
        [contentLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel2.mas_bottom).offset(title_contgent_gap_v);
            make.left.equalTo(titleLabel.mas_left).offset(title_contgent_gap_h);
            make.right.equalTo(containerView.mas_right).offset(-left_right_gap);
        }];
        contentLabel3.mas_key = @"contentLabel3";

        UIImageView *imageView = [[UIImageView alloc] init];
        lastItemView = imageView;
        [containerView addSubview:imageView];
        [imageView setImage:[UIImage imageNamed:@"icon_agent_rule_level1"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel3.mas_bottom).offset(title_contgent_gap_v);
            make.left.equalTo(containerView.mas_left);
            make.right.equalTo(containerView.mas_right);
            make.height.equalTo(imageView.mas_width).multipliedBy(1800.0/1080.0f);
        }];
        imageView.mas_key = @"imageView";
    }
    
    // 标题3
    {
        UILabel *titleLabel = [UILabel new];
        [containerView addSubview:titleLabel];
        [titleLabel setNumberOfLines:0];
        [titleLabel setText:NSLocalizedString(@"3.当前层级为会员", nil)];
        [titleLabel setFont:titleFont];
        [titleLabel setTextColor:titleColor];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastItemView.mas_bottom).offset(top_bottom_gap);
            make.left.equalTo(containerView.mas_left).offset(left_right_gap);
            make.right.equalTo(containerView.mas_right).offset(-left_right_gap);
        }];
        titleLabel.mas_key = @"titleLabel";
        
        UILabel *contentLabel = [UILabel new];
        [containerView addSubview:contentLabel];
        [contentLabel setNumberOfLines:0];
        [contentLabel setText:NSLocalizedString(@"如当前层级是会员，可获得下1级的返水，可查下1级的用户信息，以下图为例，当前层级的团队数量为3：", nil)];
        [contentLabel setFont:contentFont];
        [contentLabel setTextColor:contentColor];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(title_contgent_gap_v);
            make.left.equalTo(titleLabel.mas_left).offset(title_contgent_gap_h);
            make.right.equalTo(containerView.mas_right).offset(-left_right_gap);
        }];
        contentLabel.mas_key = @"contentLabel";
        
        UILabel *contentLabel1 = [UILabel new];
        [containerView addSubview:contentLabel1];
        [contentLabel1 setNumberOfLines:0];
        [contentLabel1 setText:NSLocalizedString(@"a、当前用户是[会员0]，只能拿到下图所示[代理A]和[会员A]的返水，[代理A]和[会员A]下级的返水[会员0]拿不到；", nil)];
        [contentLabel1 setFont:contentFont];
        [contentLabel1 setTextColor:contentColor];
        [contentLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel.mas_bottom).offset(title_contgent_gap_v);
            make.left.equalTo(titleLabel.mas_left).offset(title_contgent_gap_h);
            make.right.equalTo(containerView.mas_right).offset(-left_right_gap);
        }];
        contentLabel1.mas_key = @"contentLabel1";
        
        UILabel *contentLabel2 = [UILabel new];
        [containerView addSubview:contentLabel2];
        [contentLabel2 setNumberOfLines:0];
        [contentLabel2 setText:NSLocalizedString(@"b、若查询[代理A]或[会员A]，将查不到下级信息；", nil)];
        [contentLabel2 setFont:contentFont];
        [contentLabel2 setTextColor:contentColor];
        [contentLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel1.mas_bottom).offset(title_contgent_gap_v);
            make.left.equalTo(titleLabel.mas_left).offset(title_contgent_gap_h);
            make.right.equalTo(containerView.mas_right).offset(-left_right_gap);
        }];
        contentLabel2.mas_key = @"contentLabel2";
        
        UILabel *contentLabel3 = [UILabel new];
        [containerView addSubview:contentLabel3];
        [contentLabel3 setNumberOfLines:0];
        [contentLabel3 setText:NSLocalizedString(@"c、如果搜索当前用户的下级[代理A]或[会员A]，代理报表相关数据只统计[代理A]或[会员A]个人数据，不含其下级数据。", nil)];
        [contentLabel3 setFont:contentFont];
        [contentLabel3 setTextColor:contentColor];
        [contentLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel2.mas_bottom).offset(title_contgent_gap_v);
            make.left.equalTo(titleLabel.mas_left).offset(title_contgent_gap_h);
            make.right.equalTo(containerView.mas_right).offset(-left_right_gap);
        }];
        contentLabel3.mas_key = @"contentLabel3";

        UIImageView *imageView = [[UIImageView alloc] init];
        lastItemView = imageView;
        [containerView addSubview:imageView];
        [imageView setImage:[UIImage imageNamed:@"icon_agent_rule_level2"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel3.mas_bottom).offset(title_contgent_gap_v);
            make.left.equalTo(containerView.mas_left);
            make.right.equalTo(containerView.mas_right);
            make.height.equalTo(imageView.mas_width).multipliedBy(800.0/1080.0f);
        }];
        imageView.mas_key = @"imageView";
    }
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.greaterThanOrEqualTo(lastItemView.mas_bottom).offset(top_bottom_gap+TAB_BAR_DANGER_HEIGHT).priority(749);
    }];
}


@end

