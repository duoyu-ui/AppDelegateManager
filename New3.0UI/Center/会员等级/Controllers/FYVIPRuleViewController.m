//
//  FYVIPRuleViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/11.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYVIPRuleViewController.h"
#import "FYVIPRuleModel.h"

@interface FYVIPRuleViewController ()

@property (nonatomic, strong) UIImageView *topVipLogoImageView;
@property (nonatomic, strong) UIImageView *tableTopHeaderImageView;
@property (nonatomic, strong) NSMutableArray<NSMutableArray<UILabel *> *> *arrayOfVIPLabel;
@property (nonatomic , strong) UIScrollView *rootScrollView;
@end

@implementation FYVIPRuleViewController


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self viewDidAddMainView];
//    [self loadRequestDataVIPRules];
    
}
- (void)loadRequestDataVIPRules{
    // 填充VIP规则
    WEAKSELF(weakSelf)
    [self loadRequestDataVIPRulesThen:^(BOOL success, NSMutableArray<FYVIPRuleModel *> *itemNoticeModels) {
        [itemNoticeModels enumerateObjectsUsingBlock:^(FYVIPRuleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx < weakSelf.arrayOfVIPLabel.count) {
                NSMutableArray<UILabel *> *vipLabels = [weakSelf.arrayOfVIPLabel objectAtIndex:idx];
                //
                UILabel *chartLabel = [vipLabels objectAtIndex:0];
                [chartLabel setText:obj.chat?NSLocalizedString(@"有", nil):NSLocalizedString(@"无", nil)];
                //
                UILabel *pictureLabel = [vipLabels objectAtIndex:1];
                [pictureLabel setText:obj.picture?NSLocalizedString(@"有", nil):NSLocalizedString(@"无", nil)];
                //
                UILabel *audioLabel = [vipLabels objectAtIndex:2];
                [audioLabel setText:obj.audio?NSLocalizedString(@"有", nil):NSLocalizedString(@"无", nil)];
                //
                UILabel *videoLabel = [vipLabels objectAtIndex:3];
                [videoLabel setText:obj.video?NSLocalizedString(@"有", nil):NSLocalizedString(@"无", nil)];
                //
                UILabel *rewardLabel = [vipLabels objectAtIndex:4];
                [rewardLabel setText:obj.reward];
                //
                NSString *rechargeString = obj.recharge;
                NSArray<NSString *> *splitRecharge = [obj.recharge componentsSeparatedByString:@"~"];
                if (splitRecharge.count > 1) {
                    rechargeString = [NSString stringWithFormat:@"%@\n~\n%@", splitRecharge.firstObject, splitRecharge.lastObject];
                }
                UILabel *rechargeLabel = [vipLabels objectAtIndex:5];
                [rechargeLabel setText:rechargeString];
                //
               NSString *flowString = obj.capitalFlow;
                NSArray<NSString *> *splitFlow = [obj.capitalFlow componentsSeparatedByString:@"~"];
                if (splitFlow.count > 1) {
                    flowString = [NSString stringWithFormat:@"%@\n~\n%@", splitFlow.firstObject, splitFlow.lastObject];
                }
                UILabel *capitalFlowLabel = [vipLabels objectAtIndex:6];
                [capitalFlowLabel setText:flowString];
            }
        }];
    }];
}

- (void)viewDidAddMainView
{
    CGFloat itemTableSplineSize = 1.0f;
    //
    CGFloat itemTableHeaderWidth = SCREEN_MIN_LENGTH / 6.0f;
    CGFloat itemTableHeaderHeight = itemTableHeaderWidth * 2.0f * 0.472222f; // 根据图片比例计算
    UIFont *itemFontTableTitle = FONT_PINGFANG_SEMI_BOLD(14);
    UIColor *itemColorTableTitle = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    UIColor *itemColorTableTitleBackgroundH = COLOR_HEXSTRING(@"#FBD6D6");
    UIColor *itemColorTableTitleBackgroundV = COLOR_HEXSTRING(@"#FFF3F3");
    UIColor *itemColorTableHSplitLine = COLOR_HEXSTRING(@"#F9D0D0");
    UIColor *itemColorTableVSplitLine = COLOR_HEXSTRING(@"#FEEBEB");
    //
    CGFloat itemTableContentWidth = itemTableHeaderWidth;
    CGFloat itemTableContentHeight = itemTableContentWidth * 1.1f;
    UIFont *itemFontTableContent = FONT_PINGFANG_REGULAR(14);
    UIColor *itemColorTableContent = COLOR_HEXSTRING(@"#6B6B6B");
    UIColor *itemColorTableContentBackground = COLOR_HEXSTRING(@"#FFFFF");
    UIColor *itemColorTableContentSplitLine = COLOR_HEXSTRING(@"#FFF4F4");
    //
    UIColor *itemColorTableContentMark = itemColorTableContent;
    UIColor *itemColorTableContentMarkBackground = COLOR_HEXSTRING(@"#FFFCF8");
    
    UIScrollView *rootScrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
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
    rootScrollView.mas_key = @"rootScrollView";
    self.rootScrollView  =rootScrollView;
    UIView *containerView = ({
        UIView *view = [[UIView alloc] init];
        [rootScrollView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(rootScrollView);
            make.width.equalTo(rootScrollView);
            if (CFC_IS_IPHONE_X_OR_GREATER) {
                make.height.mas_greaterThanOrEqualTo(SCREEN_HEIGHT-STATUS_NAVIGATION_BAR_HEIGHT-TAB_BAR_DANGER_HEIGHT+1.0);
            } else {
                make.height.mas_greaterThanOrEqualTo(SCREEN_HEIGHT-STATUS_NAVIGATION_BAR_HEIGHT+1.0);
            }
        }];
        view;
    });
    containerView.mas_key = @"containerView";
    
    // LOGO
    [containerView addSubview:self.topVipLogoImageView];
    [self.topVipLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(containerView);
        make.height.mas_equalTo(SCREEN_MIN_LENGTH*0.177777778f);
    }];
    
    // 表格头（会员等级/等级特权）
    {
        // 表格头
        [containerView addSubview:self.tableTopHeaderImageView];
        [self.tableTopHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(containerView);
            make.top.equalTo(self.topVipLogoImageView.mas_bottom);
            make.width.mas_equalTo(itemTableHeaderWidth*2.0f);
            make.height.mas_equalTo(itemTableHeaderHeight);
        }];
        
        // 会员等级
        UILabel *vipGradeTitleLabel = ({
            UILabel *label = [UILabel new];
            [self.tableTopHeaderImageView addSubview:label];
            [label setText:NSLocalizedString(@"会员等级", nil)];
            [label setFont:itemFontTableTitle];
            [label setTextColor:itemColorTableTitle];
            [label setTextAlignment:NSTextAlignmentCenter];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.tableTopHeaderImageView.mas_right).multipliedBy(0.7f);
                make.centerY.equalTo(self.tableTopHeaderImageView.mas_bottom).multipliedBy(0.27f);
            }];
            
            label;
        });
        vipGradeTitleLabel.mas_key = @"vipGradeTitleLabel";
        
        // 等级特权
        UILabel *vipPrivilegeTitleLabel = ({
            UILabel *label = [UILabel new];
            [self.tableTopHeaderImageView addSubview:label];
            [label setText:NSLocalizedString(@"等级特权", nil)];
            [label setFont:itemFontTableTitle];
            [label setTextColor:itemColorTableTitle];
            [label setTextAlignment:NSTextAlignmentCenter];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.tableTopHeaderImageView.mas_right).multipliedBy(0.3f);
                make.centerY.equalTo(self.tableTopHeaderImageView.mas_bottom).multipliedBy(0.73f);
            }];
            
            label;
        });
        vipPrivilegeTitleLabel.mas_key = @"vipPrivilegeTitleLabel";
    }
    
    // 会员等级
    {
        UILabel *lastItemTableTitleGradeLabel = nil;
        NSArray<NSString *> *VIPGradeTitleArr = @[ @"VIP1", @"VIP2", @"VIP3", @"VIP4" ];
        for (NSInteger index = 0; index < VIPGradeTitleArr.count; index ++) {
            NSString *title = [VIPGradeTitleArr objectAtIndex:index];
            UILabel *tableTitleLabel = ({
                // 标题
                UILabel *label = [UILabel new];
                [containerView addSubview:label];
                [label setText:title];
                [label setFont:itemFontTableTitle];
                [label setTextColor:itemColorTableTitle];
                [label setTextAlignment:NSTextAlignmentCenter];
                [label setBackgroundColor:itemColorTableTitleBackgroundH];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(itemTableHeaderWidth);
                    make.height.mas_equalTo(itemTableHeaderHeight);
                    if (!lastItemTableTitleGradeLabel) {
                       make.top.equalTo(self.topVipLogoImageView.mas_bottom);
                       make.left.equalTo(self.tableTopHeaderImageView.mas_right);
                    } else {
                        make.top.equalTo(lastItemTableTitleGradeLabel.mas_top);
                        make.left.equalTo(lastItemTableTitleGradeLabel.mas_right);
                    }
                }];
                
                label;
            });
            tableTitleLabel.mas_key = @"tableTitleLabel";
            
            // 分割线
            UILabel *splineLabel = [UILabel new];
            [containerView addSubview:splineLabel];
            [splineLabel setBackgroundColor:itemColorTableHSplitLine];
            [splineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(itemTableSplineSize);
                make.height.mas_equalTo(itemTableHeaderHeight);
                make.centerY.equalTo(tableTitleLabel.mas_centerY);
                make.left.equalTo(tableTitleLabel.mas_left).offset(-itemTableSplineSize*0.5f);
            }];
            
            lastItemTableTitleGradeLabel = tableTitleLabel;
        }
    }
    
    // 等级特权
    {
        // 等级特权 - 1
        UILabel *lastItemTableTitlePrivilege1Label = nil;
        NSArray<NSString *> *VIPPrivilegeTitleArr1 = @[ NSLocalizedString(@"功能\n特权", nil), NSLocalizedString(@"福利\n权益", nil), NSLocalizedString(@"开通\n条件", nil) ];
        NSArray<NSNumber *> *VIPPrivilegeTitleHeightArr1 = @[ @(itemTableContentHeight*4.0f), @(itemTableContentHeight), @(itemTableContentHeight*2.0f) ];
        for (NSInteger index = 0; index < VIPPrivilegeTitleArr1.count; index ++) {
            NSString *title = [VIPPrivilegeTitleArr1 objectAtIndex:index];
            NSNumber *height = [VIPPrivilegeTitleHeightArr1 objectAtIndex:index];
            UILabel *tableTitleLabel = ({
                // 标题
                UILabel *label = [UILabel new];
                [containerView addSubview:label];
                [label setText:title];
                [label setNumberOfLines:0];
                [label setFont:itemFontTableTitle];
                [label setTextColor:itemColorTableTitle];
                [label setTextAlignment:NSTextAlignmentCenter];
                [label setBackgroundColor:itemColorTableTitleBackgroundV];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(itemTableContentWidth);
                    make.height.mas_equalTo(height.floatValue);
                    if (!lastItemTableTitlePrivilege1Label) {
                       make.top.equalTo(self.tableTopHeaderImageView.mas_bottom);
                       make.left.equalTo(self.tableTopHeaderImageView.mas_left);
                    } else {
                        make.top.equalTo(lastItemTableTitlePrivilege1Label.mas_bottom);
                        make.left.equalTo(lastItemTableTitlePrivilege1Label.mas_left);
                    }
                }];
                
                label;
            });
            tableTitleLabel.mas_key = @"tableTitleLabel";
            
            // 分割线
            UILabel *splineLabel = [UILabel new];
            [containerView addSubview:splineLabel];
            [splineLabel setBackgroundColor:itemColorTableVSplitLine];
            [splineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(itemTableContentWidth);
                make.height.mas_equalTo(itemTableSplineSize);
                make.centerX.equalTo(tableTitleLabel.mas_centerX);
                make.top.equalTo(tableTitleLabel.mas_bottom).offset(-itemTableSplineSize*0.5f);
            }];
            
            lastItemTableTitlePrivilege1Label = tableTitleLabel;
        }
        
        // 等级特权 - 2
        UILabel *lastItemTableTitlePrivilege2Label = nil;
        NSArray<NSString *> *VIPPrivilegeTitleArr2 = @[ NSLocalizedString(@"聊天", nil), NSLocalizedString(@"发图", nil), NSLocalizedString(@"语音", nil), NSLocalizedString(@"视频", nil), NSLocalizedString(@"奖金", nil), NSLocalizedString(@"充值", nil), NSLocalizedString(@"流水", nil) ];
        for (NSInteger index = 0; index < VIPPrivilegeTitleArr2.count; index ++) {
            NSString *title = [VIPPrivilegeTitleArr2 objectAtIndex:index];
            UILabel *tableTitleLabel = ({
                // 标题
                UILabel *label = [UILabel new];
                [containerView addSubview:label];
                [label setText:title];
                [label setFont:itemFontTableTitle];
                [label setTextColor:itemColorTableTitle];
                [label setTextAlignment:NSTextAlignmentCenter];
                [label setBackgroundColor:itemColorTableTitleBackgroundV];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(itemTableContentWidth);
                    make.height.mas_equalTo(itemTableContentHeight);
                    if (!lastItemTableTitlePrivilege2Label) {
                       make.top.equalTo(self.tableTopHeaderImageView.mas_bottom);
                       make.left.equalTo(lastItemTableTitlePrivilege1Label.mas_right);
                    } else {
                        make.top.equalTo(lastItemTableTitlePrivilege2Label.mas_bottom);
                        make.left.equalTo(lastItemTableTitlePrivilege2Label.mas_left);
                    }
                }];
                
                label;
            });
            tableTitleLabel.mas_key = @"tableTitleLabel";
            
            // 分割线
            UILabel *splineLabel = [UILabel new];
            [containerView addSubview:splineLabel];
            [splineLabel setBackgroundColor:itemColorTableVSplitLine];
            [splineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(itemTableContentWidth);
                make.height.mas_equalTo(itemTableSplineSize);
                make.centerX.equalTo(tableTitleLabel.mas_centerX);
                make.top.equalTo(tableTitleLabel.mas_bottom).offset(-itemTableSplineSize*0.5f);
            }];
            
            lastItemTableTitlePrivilege2Label = tableTitleLabel;
        }
        
        // 等级特权 - 分割线 1|2
        UILabel *titleSplineLineVLabel = [UILabel new];
        [containerView addSubview:titleSplineLineVLabel];
        [titleSplineLineVLabel setBackgroundColor:itemColorTableVSplitLine];
        [titleSplineLineVLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(itemTableSplineSize);
            make.top.equalTo(self.tableTopHeaderImageView.mas_bottom);
            make.bottom.equalTo(lastItemTableTitlePrivilege2Label.mas_bottom);
            make.centerX.equalTo(lastItemTableTitlePrivilege2Label.mas_left).offset(-itemTableSplineSize*0.5f);
        }];
    }
    
    // 规则内容
    UILabel *lastItemTableContentLabel = nil;
    for (NSInteger col = 0; col < 4; col ++) {
        NSMutableArray<UILabel *> *itemVIPLabels = [NSMutableArray  array];
        for (NSInteger row = 0; row < 7; row ++) {
            UIColor *textColor = 2==col ? itemColorTableContentMark : itemColorTableContent;
            UIColor *backgroundColor = 5==row ? itemColorTableContentMarkBackground : itemColorTableContentBackground;
            
            UILabel *tableContentLabel = ({
                // 标题
                UILabel *label = [UILabel new];
                [containerView addSubview:label];
                [label setText:STR_APP_TEXT_PLACEHOLDER];
                [label setNumberOfLines:0];
                [label setFont:itemFontTableContent];
                [label setTextColor:textColor];
                [label setBackgroundColor:backgroundColor];
                [label setTextAlignment:NSTextAlignmentCenter];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(itemTableContentWidth);
                    make.height.mas_equalTo(itemTableContentHeight);
                    if (0 == row) {
                        make.top.equalTo(self.tableTopHeaderImageView.mas_bottom);
                        if (!lastItemTableContentLabel) {
                           make.left.equalTo(self.tableTopHeaderImageView.mas_right);
                        } else {
                            make.left.equalTo(lastItemTableContentLabel.mas_right);
                        }
                    } else {
                        make.top.equalTo(lastItemTableContentLabel.mas_bottom);
                        make.left.equalTo(lastItemTableContentLabel.mas_left);
                    }
                }];
                
                label;
            });
            tableContentLabel.mas_key = @"tableTitleLabel";
            
            // 分割线 - 水平
            UILabel *splineHLabel = [UILabel new];
            [containerView addSubview:splineHLabel];
            [splineHLabel setBackgroundColor:itemColorTableContentSplitLine];
            [splineHLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(itemTableContentWidth);
                make.height.mas_equalTo(itemTableSplineSize);
                make.centerX.equalTo(tableContentLabel.mas_centerX);
                make.top.equalTo(tableContentLabel.mas_bottom).offset(-itemTableSplineSize*0.5f);
            }];
            
            // 分割线 - 垂直
            UILabel *splineVLabel = [UILabel new];
            [containerView addSubview:splineVLabel];
            [splineVLabel setBackgroundColor:itemColorTableContentSplitLine];
            [splineVLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(itemTableSplineSize);
                make.height.mas_equalTo(itemTableContentHeight);
                make.centerY.equalTo(tableContentLabel.mas_centerY);
                make.centerX.equalTo(tableContentLabel.mas_left).offset(-itemTableSplineSize*0.5f);
            }];
            
            [itemVIPLabels addObj:tableContentLabel];
            lastItemTableContentLabel = tableContentLabel;
        }
        [self.arrayOfVIPLabel addObj:itemVIPLabels];
    }
    
    // 提示信息
    UILabel *tipInfoLabel = ({
        NSString *content =  NSLocalizedString(@"注：\n充值、流水需同时满足后自动提升为对应的VIP等级；\n升级后奖金将自动发放您的主账户；", nil);
        //
        UILabel *label = [UILabel new];
        [containerView addSubview:label];
        [label setText:content];
        [label setNumberOfLines:0];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
        [label setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(13)]];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastItemTableContentLabel.mas_bottom).offset(10.0f);
            make.left.equalTo(containerView.mas_left).offset(15.0f);
            make.right.equalTo(containerView.mas_right).with.offset(-15.0f);
        }];
        
        label;
    });
    tipInfoLabel.mas_key = @"tipInfoLabel";
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.greaterThanOrEqualTo(tipInfoLabel.mas_bottom).offset(10).priority(749);
    }];
    MJWeakSelf
    rootScrollView.mj_header = [CFCRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf loadRequestDataVIPRules];
    }];
    [rootScrollView.mj_header beginRefreshing];
}



#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return NSLocalizedString(@"VIP会员", nil);
}

- (CGFloat)prefersNavigationBarHairlineHeight
{
    return NAVIGATION_BAR_HAIR_LINE_HEIGHT_ZERO;
}


#pragma mark - Getter/Setter

- (UIView *)topVipLogoImageView
{
    if(!_topVipLogoImageView) {
        _topVipLogoImageView = [[UIImageView alloc] init];
        [_topVipLogoImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_topVipLogoImageView setImage:[UIImage imageNamed:@"icon_vip_topheader"]];
    }
    return _topVipLogoImageView;
}

- (UIView *)tableTopHeaderImageView
{
    if(!_tableTopHeaderImageView) {
        _tableTopHeaderImageView = [[UIImageView alloc] init];
        [_tableTopHeaderImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_tableTopHeaderImageView setImage:[UIImage imageNamed:@"icon_vip_table_header"]];
    }
    return _tableTopHeaderImageView;
}

- (NSMutableArray<NSMutableArray<UILabel *> *> *)arrayOfVIPLabel
{
    if(!_arrayOfVIPLabel) {
        _arrayOfVIPLabel = [[NSMutableArray<NSMutableArray<UILabel *> *> alloc] init];
    }
    return _arrayOfVIPLabel;
}


#pragma mark - Private

- (void)loadRequestDataVIPRulesThen:(void (^)(BOOL success, NSMutableArray<FYVIPRuleModel *> *itemNoticeModels))then
{
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requestWithAct:ActRequesCenterUserVIPRule parameters:@{ } success:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"VIP规则 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
           !then ?: then(NO,nil);
        } else {
            NSArray<NSDictionary *> *arrayOfDicts = NET_REQUEST_DATA(response);
            NSMutableArray<FYVIPRuleModel *> *itemVIPRuleModels = [FYVIPRuleModel mj_objectArrayWithKeyValuesArray:arrayOfDicts];
            !then ?: then(YES,itemVIPRuleModels);
        }
        [self.rootScrollView.mj_header endRefreshing];
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        !then ?: then(NO,nil);
        [self.rootScrollView.mj_header endRefreshing];
        FYLog(NSLocalizedString(@"获取VIP规则出错 => \n%@", nil), error);
    }];
}


@end

