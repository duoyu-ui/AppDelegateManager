//
//  FYAgentRuleSub1ViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYAgentRuleViewController.h"
#import "FYAgentRuleSub1ViewController.h"

@interface FYAgentRuleSub1ViewController () <UIScrollViewDelegate> 
@property(nonatomic, strong) UIScrollView *rootScrollView;
@end

@implementation FYAgentRuleSub1ViewController

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
        [titleLabel setText:NSLocalizedString(@"1.如何成为代理？", nil)];
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
        [contentLabel setText:NSLocalizedString(@"普通会员名下，邀请3个会员下级，合计有1000以上流水，即可申请成为代理。", nil)];
        [contentLabel setFont:contentFont];
        [contentLabel setTextColor:contentColor];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(title_contgent_gap_v);
            make.left.equalTo(titleLabel.mas_left).offset(title_contgent_gap_h);
            make.right.equalTo(containerView.mas_right).offset(-left_right_gap);
        }];
        contentLabel.mas_key = @"contentLabel";
    }
    
    // 标题2
    {
        UILabel *titleLabel = [UILabel new];
        [containerView addSubview:titleLabel];
        [titleLabel setNumberOfLines:0];
        [titleLabel setText:NSLocalizedString(@"2.代理有什么特权？", nil)];
        [titleLabel setFont:titleFont];
        [titleLabel setTextColor:titleColor];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastItemView.mas_bottom).offset(top_bottom_gap);
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
        NSArray<NSString *> *stringArray = @[ NSLocalizedString(@"成为代理后名下如有代理，可开启裂变模式享有6级返水，", nil), NSLocalizedString(@"普通会员的返水仅来自于直属下级", nil), @"。" ];
        NSArray *attributeArray = @[ attriText, attriMark, attriText ];
        NSAttributedString *attr = [CFCSysUtil attributedString:stringArray attributeArray:attributeArray];
        [contentLabel setAttributedText:attr];
    }
    
    // 标题3
    {
        UILabel *titleLabel = [UILabel new];
        [containerView addSubview:titleLabel];
        [titleLabel setNumberOfLines:0];
        [titleLabel setText:NSLocalizedString(@"3.如何保持代理资格？", nil)];
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
        [contentLabel setText:NSLocalizedString(@"为保护代理权益利益，禁止用户设置小号脱离上级代理，如有违反将取消代理资格。", nil)];
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
        [contentLabel1 setText:NSLocalizedString(@"申请代理成功后需保持活跃度，七天内必须有新注册会员且其下产生1000的流水。非活跃的代理将被取消资格。", nil)];
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
        [contentLabel2 setText:NSLocalizedString(@"代理资格取消后，其下级将自动对接到您的上级。", nil)];
        [contentLabel2 setFont:contentFont];
        [contentLabel2 setTextColor:contentColor];
        [contentLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel1.mas_bottom).offset(title_contgent_gap_v);
            make.left.equalTo(titleLabel.mas_left).offset(title_contgent_gap_h);
            make.right.equalTo(containerView.mas_right).offset(-left_right_gap);
        }];
        contentLabel2.mas_key = @"contentLabel2";
        
        UILabel *contentLabel3 = [UILabel new];
        lastItemView = contentLabel3;
        [containerView addSubview:contentLabel3];
        [contentLabel3 setNumberOfLines:0];
        [contentLabel3 setText:NSLocalizedString(@"失去代理资格后，满足条件将可以再次申请，并保留下级。", nil)];
        [contentLabel3 setFont:contentFont];
        [contentLabel3 setTextColor:contentColor];
        [contentLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel2.mas_bottom).offset(title_contgent_gap_v);
            make.left.equalTo(titleLabel.mas_left).offset(title_contgent_gap_h);
            make.right.equalTo(containerView.mas_right).offset(-left_right_gap);
        }];
        contentLabel3.mas_key = @"contentLabel3";
    }

    // 标题4
    {
        UILabel *titleLabel = [UILabel new];
        [containerView addSubview:titleLabel];
        [titleLabel setNumberOfLines:0];
        [titleLabel setText:NSLocalizedString(@"4.如何计算代理返水金额？", nil)];
        [titleLabel setFont:titleFont];
        [titleLabel setTextColor:titleColor];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastItemView.mas_bottom).offset(top_bottom_gap);
            make.left.equalTo(containerView.mas_left).offset(left_right_gap);
            make.right.equalTo(containerView.mas_right).offset(-left_right_gap);
        }];
        titleLabel.mas_key = @"titleLabel";
        
        UIImageView *imageView = [[UIImageView alloc] init];
        lastItemView = imageView;
        [containerView addSubview:imageView];
        [imageView setImage:[UIImage imageNamed:@"icon_agent_rule_info"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(title_contgent_gap_v);
            make.left.equalTo(titleLabel.mas_left).offset(title_contgent_gap_h);
            make.right.equalTo(containerView.mas_right).offset(-left_right_gap-title_contgent_gap_h);
            make.height.equalTo(imageView.mas_width).multipliedBy(490.0f/940.0f);
        }];
        imageView.mas_key = @"imageView";
    }
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.greaterThanOrEqualTo(lastItemView.mas_bottom).offset(top_bottom_gap+TAB_BAR_DANGER_HEIGHT).priority(749);
    }];
}


@end

