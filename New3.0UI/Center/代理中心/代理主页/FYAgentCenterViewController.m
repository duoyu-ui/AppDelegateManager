//
//  FYAgentCenterViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYAgentCenterViewController.h"
#import "FYMultiRowLabel.h"
//
#import "CopyViewController.h"
#import "BecomeAgentViewController.h"
#import "ReportFormsViewController.h"
#import "RecommendedViewController.h"
#import "FYAgentReferralsViewController.h" // 我的下线
#import "FYAgentReportViewController.h" // 代理报表

@interface FYAgentCenterViewController ()
@property (nonatomic, strong) FYMultiRowLabel *todayRegisterLabel;
@property (nonatomic, strong) FYMultiRowLabel *todayRechargeLabel;
@property (nonatomic, strong) FYMultiRowLabel *todayCommissionLabel;
@property (nonatomic, strong) UILabel *agentItemLabel;
@property (nonatomic, strong) UIButton *buttonOfCopyUrl;
@property (nonatomic, strong) UILabel *shareLinkUrlLabel;
@property (nonatomic, copy) NSString *shareLinkUrl;
@end

@implementation FYAgentCenterViewController

#pragma mark - Actions

- (void)pressNavigationBarRightButtonItem:(id)sender
{
    NSString *urlString = [AppModel shareInstance].commonInfo[@"pop"];
    FYWebViewController *viewController = [[FYWebViewController alloc] initWithUrl:urlString];
    [viewController setTitle:NSLocalizedString(@"在线客服", nil)];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pressShareLinkUrlLabel
{
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.shareLinkUrl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.shareLinkUrl]];
    }
}

- (void)pressCopyUrlButtonAction
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.shareLinkUrl;
    ALTER_INFO_MESSAGE(NSLocalizedString(@"复制链接成功", nil))
}

- (void)pressFuctionButtonItemView:(UITapGestureRecognizer *)gesture
{
    UIView *itemView = (UIView*)gesture.view;
    
    NSUInteger index = itemView.tag - 8000;
    
    if (0 == index) { // 申请代理
        if (1 == APPINFORMATION.userInfo.agentFlag) {
            AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
            [view showWithText:NSLocalizedString(@"您已经是代理", nil) button:NSLocalizedString(@"好的", nil) callBack:nil];
            return;
        }
        
        WEAKSELF(weakSelf)
        AccountDeleteTipPopUpView* popupView = [[AccountDeleteTipPopUpView alloc]init];
        [popupView showInApplicationKeyWindow];
        [popupView richElementsInViewWithModel:NSLocalizedString(@"是否提交申请？", nil)];
        [popupView actionBlock:^(id data) {
            [weakSelf applyToBeAgent];
        }];
    } else if (1 == index) { // 分享赚钱
        ShareDetailViewController *VC = [[ShareDetailViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (2 == index) { // 下级玩家
#if 0
        RecommendedViewController *VC = [[RecommendedViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
#else
        NSString *currentUserId = [NSString stringWithFormat:@"%@", APPINFORMATION.userInfo.userId];
        FYAgentReferralsViewController *VC = [[FYAgentReferralsViewController alloc] initWithSearchMemberKey:currentUserId isFromMineCenter:YES];
        [self.navigationController pushViewController:VC animated:YES];
#endif
    } else if (3 == index) { // 推广文案
        CopyViewController *VC = [[CopyViewController alloc] init];
        [VC setTitle:NSLocalizedString(@"推广文案", nil)];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (4 == index) { // 代理规则
        BecomeAgentViewController *VC = [[BecomeAgentViewController alloc] init];
        [VC setHiddenNavBar:YES];
        [VC setImageUrl:APPINFORMATION.commonInfo[@"agent_rule"]];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (5 == index) { // 我的报表
#if 0
        ReportFormsViewController *viewController = [[ReportFormsViewController alloc] init];
        [viewController setUserId:APPINFORMATION.userInfo.userId];
        [self.navigationController pushViewController:viewController animated:YES];
#else
        NSString *currentUserId = [NSString stringWithFormat:@"%@", APPINFORMATION.userInfo.userId];
        FYAgentReportViewController *VC = [[FYAgentReportViewController alloc] initWithSearchMemberKey:currentUserId isFromMineCenter:YES];
        [self.navigationController pushViewController:VC animated:YES];
#endif
    }
}


#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _shareLinkUrl = [NSString stringWithFormat:@"%@?code=%@",APPINFORMATION.address,APPINFORMATION.userInfo.invitecode];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createMainUIView];
    
    WEAKSELF(weakSelf)
    [self loadRequestAgentDataThen:^(NSString *todayRegister, NSString *todayRecharge, NSString *todayCommission) {
        dispatch_main_async_safe(^{
            [weakSelf.todayRegisterLabel setTitle:todayRegister];
            [weakSelf.todayRechargeLabel setTitle:todayRecharge];
            [weakSelf.todayCommissionLabel setTitle:todayCommission];
        });
        if(0 == APPINFORMATION.userInfo.agentFlag){
            [self performSelector:@selector(verifyIsAgentOrBecomeAgent) withObject:nil afterDelay:0.5];
        }
    }];
}

- (void)createMainUIView
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);

    UIScrollView *rootScrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
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
    rootScrollView.mas_key = @"rootScrollView";
    
    UIView *containerView = ({
        UIView *view = [[UIView alloc] init];
        [rootScrollView addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(rootScrollView);
            make.width.equalTo(rootScrollView);
            if (IS_IPHONE_X) {
                make.height.mas_greaterThanOrEqualTo(SCREEN_HEIGHT-STATUS_NAVIGATION_BAR_HEIGHT-TAB_BAR_DANGER_HEIGHT+1.0);
            } else {
                make.height.mas_greaterThanOrEqualTo(SCREEN_HEIGHT-STATUS_NAVIGATION_BAR_HEIGHT+1.0);
            }
        }];
        view;
    });
    containerView.mas_key = @"containerView";
   
    // 头部容器
    UIView *todayHeaderContainer = ({
        UIView *view = [[UIView alloc] init];
        [containerView addSubview:view];
        [view setBackgroundColor:[UIColor whiteColor]];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(containerView);
        }];
    
        view;
    });
    todayHeaderContainer.mas_key = @"todayHeaderContainer";
    
    // 今日数据
    {
        CGFloat todayLabelWidth = (SCREEN_MIN_LENGTH - margin*2.0) * 0.333333f;
        CGFloat todayLabelHeight = todayLabelWidth * 0.5f;
        
        [self setTodayRegisterLabel:[self creatAgentMultiRowLabel:NSLocalizedString(@"今日注册人数", nil)]];
        [containerView addSubview:self.todayRegisterLabel];
        [self.todayRegisterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(containerView.mas_top).offset(margin*1.0f);
            make.left.equalTo(containerView.mas_left).offset(margin*1.0f);
            make.size.mas_equalTo(CGSizeMake(todayLabelWidth, todayLabelHeight));
        }];
        
        [self setTodayRechargeLabel:[self creatAgentMultiRowLabel:NSLocalizedString(@"今日充值总额", nil)]];
        [containerView addSubview:self.todayRechargeLabel];
        [self.todayRechargeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.todayRegisterLabel.mas_top);
            make.left.equalTo(self.todayRegisterLabel.mas_right);
            make.size.mas_equalTo(CGSizeMake(todayLabelWidth, todayLabelHeight));
        }];
        
        [self setTodayCommissionLabel:[self creatAgentMultiRowLabel:NSLocalizedString(@"今日佣金分成", nil)]];
        [containerView addSubview:self.todayCommissionLabel];
        [self.todayCommissionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.todayRechargeLabel.mas_top);
            make.left.equalTo(self.todayRechargeLabel.mas_right);
            make.size.mas_equalTo(CGSizeMake(todayLabelWidth, todayLabelHeight));
        }];
    }
    
    // 代理推广链接
    {
        // 图标
        UIImageView *iconImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            [containerView addSubview:imageView];
            [imageView setImage:[UIImage imageNamed:@"icon_agency_link"]];
            [imageView setContentMode:UIViewContentModeScaleAspectFill];

            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                CGFloat imageSize = CFC_AUTOSIZING_WIDTH(45.0f);
                make.top.equalTo(self.todayCommissionLabel.mas_bottom).offset(margin*2.0f);
                make.left.equalTo(containerView.mas_left).offset(margin*1.5f);
                make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
            }];
            
            imageView;
        });
        iconImageView.mas_key = @"iconImageView";
        
        // 复制链接
        UIButton *buttonOfCopyUrl = ({
            UIFont *titleFont = [UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(12.0f)];
            CGFloat width = [NSLocalizedString(@"复制链接", nil) widthWithFont:titleFont constrainedToHeight:CGFLOAT_MAX]+margin*2.0f;
            CGFloat height = width * 0.33f;
            //
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [containerView addSubview:button];
            [button defaultStyleButton];
            [button addCornerRadius:height*0.5f];
            [button.titleLabel setFont:titleFont];
            [button setTitle:NSLocalizedString(@"复制链接", nil) forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(pressCopyUrlButtonAction) forControlEvents:UIControlEventTouchUpInside];
            //
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(iconImageView.mas_centerY);
                make.right.equalTo(containerView.mas_right).offset(-margin*1.5f);
                make.size.mas_equalTo(CGSizeMake(width, height));
            }];
            
            button;
        });
        self.buttonOfCopyUrl = buttonOfCopyUrl;
        self.buttonOfCopyUrl.mas_key = @"buttonOfCopyUrl";
        
        UILabel *titleLabel = ({
            UILabel *titleLabel = [UILabel new];
            [containerView addSubview:titleLabel];
            [titleLabel setText:NSLocalizedString(@"代理推广链接", nil)];
            [titleLabel setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(16.0f)]];
            [titleLabel setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(iconImageView.mas_right).offset(margin*0.5f);
                make.right.equalTo(buttonOfCopyUrl.mas_left).offset(-margin*1.0f);
                make.bottom.equalTo(iconImageView.mas_centerY);
            }];
            
            titleLabel;
        });
        titleLabel.mas_key = @"titleLabel";
        
        UILabel *shareLinkUrlLabel = ({
            UILabel *shareLinkUrlLabel = [UILabel new];
            [containerView addSubview:shareLinkUrlLabel];
            [shareLinkUrlLabel setText:self.shareLinkUrl];
            [shareLinkUrlLabel setUserInteractionEnabled:YES];
            [shareLinkUrlLabel setFont:[UIFont systemFontOfSize:14.0f]];
            [shareLinkUrlLabel setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressShareLinkUrlLabel)];
            [shareLinkUrlLabel addGestureRecognizer:tapGesture];
            
            [shareLinkUrlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(titleLabel.mas_left);
                make.right.equalTo(titleLabel.mas_right);
                make.top.equalTo(titleLabel.mas_bottom).offset(margin*0.25f);
            }];
            
            shareLinkUrlLabel;
        });
        self.shareLinkUrlLabel = shareLinkUrlLabel;
        self.shareLinkUrlLabel.mas_key = @"shareLinkUrlLabel";
        
        [todayHeaderContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.greaterThanOrEqualTo(iconImageView.mas_bottom).offset(margin*1.0f);
        }];
    }
    
    // 按钮区域
    UIView *footerButtonContainer = ({
        CGFloat buttonWidth = (SCREEN_MIN_LENGTH - margin*2.0) * 0.333333f;
        CGFloat buttonHeight = buttonWidth * 0.78f;
        
        UIView *view = [[UIView alloc] init];
        [containerView addSubview:view];
        [view addCornerRadius:margin*0.5f];
        [view setBackgroundColor:[UIColor whiteColor]];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(todayHeaderContainer.mas_bottom).offset(margin);
            make.left.equalTo(containerView.mas_left).offset(margin);
            make.right.equalTo(containerView.mas_right).offset(-margin);
            make.height.mas_equalTo(buttonHeight*2.0f);
        }];
        
        [self createMainUIViewOfFooterButtons:view buttonWidth:buttonWidth buttonHeight:buttonHeight];
        
        view;
    });
    footerButtonContainer.mas_key = @"footerButtonContainer";
    
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.greaterThanOrEqualTo(footerButtonContainer.mas_bottom).offset(margin*5.0f).priority(749);
    }];
}

- (void)createMainUIViewOfFooterButtons:(UIView *)container buttonWidth:(CGFloat)width buttonHeight:(CGFloat)height
{
    int colum = 3;
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat imageSize = height * 0.47f;
    CGFloat autoNameFontSize = CFC_AUTOSIZING_FONT(15.0f);
    
    NSString *agentTitle = 1==APPINFORMATION.userInfo.agentFlag ? NSLocalizedString(@"您已是代理", nil) : STR_AGENT_CENTER_MENU_ITEM_SHENQINGDAILI;
    NSArray<NSString *> *btnTitleArray = @[ agentTitle,
                                            STR_AGENT_CENTER_MENU_ITEM_FENXIANGZHUANQINA,
                                            STR_AGENT_CENTER_MENU_ITEM_XIAJIWANJIA,
                                            STR_AGENT_CENTER_MENU_ITEM_TUIGUANGWENAN,
                                            STR_AGENT_CENTER_MENU_ITEM_DAILIGUIZE,
                                            STR_AGENT_CENTER_MENU_ITEM_WODEBAOBIAO ].mutableCopy;
    NSArray<NSString *> *btnImageArray = @[ @"icon_agency_apply",
                                            @"icon_agency_share",
                                            @"icon_agency_junior",
                                            @"icon_agency_treatment",
                                            @"icon_agency_rule",
                                            @"icon_agency_forms" ];
    
    UIView *lastItemView = nil;
    for (int i = 0; i < 6; i ++) {
        // 容器
        UIView *itemView = ({
            UIView *itemContainerView = [[UIView alloc] init];
            [itemContainerView setTag:8000+i];
            [container addSubview:itemContainerView];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressFuctionButtonItemView:)];
            [itemContainerView addGestureRecognizer:tapGesture];
            [itemContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(width));
                make.height.equalTo(@(height));
                
                if (!lastItemView) {
                    make.top.equalTo(container.mas_top);
                    make.left.equalTo(container.mas_left);
                } else {
                    if (i % colum == 0) {
                        make.top.equalTo(lastItemView.mas_bottom);
                        make.left.equalTo(container.mas_left);
                    } else {
                        make.left.equalTo(lastItemView.mas_right);
                        make.top.equalTo(lastItemView.mas_top);
                    }
                }
            }];
            itemContainerView.mas_key = [NSString stringWithFormat:@"itemContainerView%d",i];
            
            // 图片
            UIImageView *iconImageView = ({
                UIImageView *imageView = [UIImageView new];
                [itemContainerView addSubview:imageView];
                [imageView setUserInteractionEnabled:YES];
                [imageView setContentMode:UIViewContentModeScaleAspectFill];
                [imageView setImage:[UIImage imageNamed:btnImageArray[i]]];
                
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(itemContainerView.mas_centerX);
                    make.centerY.equalTo(itemContainerView.mas_bottom).multipliedBy(0.35f);
                    make.height.equalTo(@(imageSize));
                    make.width.equalTo(@(imageSize));
                }];
                
                imageView;
            });
            iconImageView.mas_key = [NSString stringWithFormat:@"iconImageView%d",i];
            
            // 标题
            UILabel *titleLabel = ({
                UILabel *label = [UILabel new];
                [itemContainerView addSubview:label];
                [label setText:btnTitleArray[i]];
                [label setFont:[UIFont boldSystemFontOfSize:autoNameFontSize]];
                [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
                [label setTextAlignment:NSTextAlignmentCenter];
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(itemContainerView.mas_left).offset(margin*0.5f);
                    make.right.equalTo(itemContainerView.mas_right).offset(-margin*0.5f);
                    make.top.equalTo(iconImageView.mas_bottom).offset(margin*0.5f);
                }];
                
                label;
            });
            titleLabel.mas_key = [NSString stringWithFormat:@"titleLabel%d",i];
            
            // 申请代理
            if (0 == i) {
                self.agentItemLabel = titleLabel;
            }
            
            itemContainerView;
        });
        
        lastItemView = itemView;
    }
}



#pragma mark - Network


- (void)applyToBeAgent
{
    WEAKSELF(weakSelf)
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER askForToBeAgentWithSuccess:^(id response) {
        PROGRESS_HUD_DISMISS
        NSString* alterMsg = [response objectForKey:@"alterMsg"];
        if (![FunctionManager isEmpty:alterMsg]) {
            AccountDeleteTipPopUpView* popupView = [[AccountDeleteTipPopUpView alloc]init];
            [popupView showInApplicationKeyWindow];
            [popupView richElementsInViewWithModel:alterMsg];
            [popupView actionBlock:^(id data) {
                
            }];
        }
        [weakSelf loadRequestUserInfoThen:^{
            if(1 == APPINFORMATION.userInfo.agentFlag) {
                dispatch_main_async_safe(^{
                    [weakSelf.agentItemLabel setText:NSLocalizedString(@"您已经代理", nil)];
                });
            }
        }];
    } fail:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
    }];
}

- (void)loadRequestUserInfoThen:(void (^)(void))then
{
    [NET_REQUEST_MANAGER requestUpdateUserInfoWithSuccess:^(id response) {
        FYLog(NSLocalizedString(@"用户数据 => \n%@", nil), response);
        !then ?: then();
    } failure:^(id error) {
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"获取用户信息异常！ => \n%@", nil), error);
        !then ?: then();
    }];
}

- (void)loadRequestAgentDataThen:(void (^)(NSString *todayRegister, NSString *todayRecharge, NSString *todayCommission))then
{
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requestAgentDatas:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"代理中心数据 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
           !then ?: then(@"0",@"0",@"0");
        } else {
            NSDictionary *data = NET_REQUEST_DATA(response);
            NSString *todayRegister = [data stringForKey:@"todayRegisterCount"];
            NSString *todayRecharge = [data stringForKey:@"todayRechargeMoney"];
            NSString *todayCommission = [data stringForKey:@"todayCommission"];
            !then ?: then(todayRegister,todayRecharge,todayCommission);
        }
    } fail:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"获取代理中心数据出错 => \n%@", nil), error);
        !then ?: then(@"0",@"0",@"0");
    }];
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_AGENT_CENTER;
}

- (CGFloat)prefersNavigationBarHairlineHeight
{
    return NAVIGATION_BAR_HAIR_LINE_HEIGHT_ZERO;
}

- (CFCNavBarButtonItemType)prefersNavigationBarRightButtonItemType
{
    return CFCNavBarButtonItemTypeCustom;
}

- (NSString *)prefersNavigationBarRightButtonItemImageNormal
{
    return ICON_NAV_BAR_BUTTON_CUSTOMER_SERVICE;
}


#pragma mark - Private

- (FYMultiRowLabel *)creatAgentMultiRowLabel:(NSString *)content
{
    UIColor *titleColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    UIFont *titleFont = [UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(17)];
    UIColor *contentColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    UIFont *contentFont = FONT_COMMON_BUTTON_TITLE;
    
    FYMultiRowLabel *label = [[FYMultiRowLabel alloc] init];
    // 标题
    [label setTitle:@"0"];
    [label setTitleFont:titleFont];
    [label setTitleColor:titleColor];
    [label setTitleTextAlignment:NSTextAlignmentCenter];
    // 金额
    [label setContent:content];
    [label setContentFont:contentFont];
    [label setContentColor:contentColor];
    [label setContentTextAlignment:NSTextAlignmentCenter];
           
    return label;
}

- (void)verifyIsAgentOrBecomeAgent
{
    if (1 == APPINFORMATION.userInfo.agentFlag) {
        return;
    }
    __weak __typeof(self)weakSelf = self;
    AccountDeleteTipPopUpView* popupView = [[AccountDeleteTipPopUpView alloc]init];
    [popupView showInApplicationKeyWindow];
    [popupView richElementsInViewWithModel:NSLocalizedString(@"您还不是代理，是否申请代理？", nil)];
    [popupView actionBlock:^(id data) {
        [weakSelf applyToBeAgent];
    }];
}


@end

