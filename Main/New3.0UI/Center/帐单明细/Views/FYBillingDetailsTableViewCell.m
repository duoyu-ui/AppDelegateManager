//
//  FYBillingDetailsTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 账单详情
//

#import "FYBillingDetailsTableViewCell.h"
#import "FYBillingDetailsModel.h"


@interface FYBillingDetailsTableViewCell ()
/**
 * 根容器
 */
@property (nonnull, nonatomic, strong) UIView *rootContainerView;
/**
 * 公共容器
 */
@property (nonnull, nonatomic, strong) UIView *publicContainerView;


/**
 * 图片控件
 */
@property (nonatomic, strong) UIImageView *recordImageView;
/**
 * 交易标题
 */
@property (nonatomic, strong) UILabel *recordTitleLabel;
/**
 * 交易金额
 */
@property (nonnull, nonatomic, strong) UILabel *recordMoneyLabel;


/**
 * 账单容器
 */
@property (nonnull, nonatomic, strong) UIView *recordContainerView;
/**
 * 账单说明
 */
@property (nonnull, nonatomic, strong) UILabel *recordIntroLabel;
/**
 * 账单时间
 */
@property (nonnull, nonatomic, strong) UILabel *recordCreateTimeLabel;
/**
 * 账单编号
 */
@property (nonnull, nonatomic, strong) UILabel *recordSerialNumberLabel;
/**
 * 账单分类
 */
@property (nonnull, nonatomic, strong) UILabel *recordCategoryLabel;


/**
 * 详情容器
 */
@property (nonnull, nonatomic, strong) UIView *gameInfoContainerView;
@property (nonnull, nonatomic, strong) NSMutableArray<NSString *> *gameInfoTitles;
@property (nonnull, nonatomic, strong) NSMutableArray<UILabel *> *gameContentLabels;

@end


@implementation FYBillingDetailsTableViewCell


+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _gameInfoTitles = @[
            NSLocalizedString(@"游戏", nil), NSLocalizedString(@"期数", nil), NSLocalizedString(@"您的投注", nil), NSLocalizedString(@"比分结果", nil), NSLocalizedString(@"投注", nil), NSLocalizedString(@"中奖", nil), NSLocalizedString(@"赔付", nil)
        ].mutableCopy;
        _gameContentLabels = @[].mutableCopy;
        //
        [self createViewAtuoLayout];
    }
    return self;
}


#pragma mark - 创建子控件
- (void)createViewAtuoLayout
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat container_left_right_gap = margin * 1.5f;
    CGFloat content_left_right_gap = margin * 1.5f;
    CGFloat textHeight = CFC_AUTOSIZING_WIDTH(35);
    UIFont *titleFont = FONT_PINGFANG_REGULAR(14);
    UIFont *contentFont = FONT_PINGFANG_REGULAR(14);
    UIColor *titleColor = COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT;
    UIColor *contentColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    
    // 根容器组件
    UIView *rootContainerView = ({
        UIView *view = [[UIView alloc] init];
        [self.contentView addSubview:view];
        [view setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0.0f);
            make.top.equalTo(@0.0f);
            make.right.equalTo(@0.0f);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
        }];
        
        view;
    });
    self.rootContainerView = rootContainerView;
    self.rootContainerView.mas_key = @"rootContainerView";
    
    // 公共容器组件
    UIView *publicContainerView = ({
        UIView *view = [[UIView alloc] init];
        [rootContainerView addSubview:view];
        [view.layer setMasksToBounds:YES];
        [view setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rootContainerView.mas_left);
            make.top.equalTo(rootContainerView.mas_top);
            make.right.equalTo(rootContainerView.mas_right);
            make.bottom.equalTo(rootContainerView.mas_bottom);
        }];
        
        view;
    });
    self.publicContainerView = publicContainerView;
    self.publicContainerView.mas_key = @"publicContainerView";
    
    // 图标控件
    UIImageView *recordImageView = ({
        CGFloat imageSize = CFC_AUTOSIZING_WIDTH(35.0f);
        UIImageView *imageView = [[UIImageView alloc] init];
        [publicContainerView addSubview:imageView];
        [imageView addCornerRadius:imageSize*0.5f];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(publicContainerView.mas_top).offset(margin*3.0f);
            make.centerX.equalTo(publicContainerView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
        }];
        
        imageView;
    });
    self.recordImageView = recordImageView;
    self.recordImageView.mas_key = @"recordImageView";
    
    // 标题控件
    UILabel *recordTitleLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:FONT_PINGFANG_REGULAR(16)];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(recordImageView.mas_bottom).offset(margin*0.5f);
            make.left.right.equalTo(publicContainerView);
        }];
        
        label;
    });
    self.recordTitleLabel = recordTitleLabel;
    self.recordTitleLabel.mas_key = @"recordTitleLabel";
    
    // 交易金额
    UILabel *recordMoneyLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:FONT_PINGFANG_SEMI_BOLD(18)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(recordTitleLabel.mas_bottom).offset(margin*0.5f);
            make.centerX.equalTo(publicContainerView.mas_centerX);
        }];
        
        label;
    });
    self.recordMoneyLabel = recordMoneyLabel;
    self.recordMoneyLabel.mas_key = @"recordMoneyLabel";
    
    // 账单区域
    {
        // 账单容器
        UIView *recordContainerView = ({
            UIView *view = [[UIView alloc] init];
            [publicContainerView addSubview:view];
            [view.layer setMasksToBounds:YES];
            [view setBackgroundColor:[UIColor whiteColor]];
            [view addCornerRadius:margin];

            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(recordMoneyLabel.mas_bottom).offset(margin*1.5f);
                make.left.equalTo(publicContainerView.mas_left).offset(container_left_right_gap);
                make.right.equalTo(publicContainerView.mas_right).offset(-container_left_right_gap);
            }];
            
            view;
        });
        self.recordContainerView = recordContainerView;
        self.recordContainerView.mas_key = @"recordContainerView";
        
        // 账单说明
        UILabel *recordIntroLabel = ({
            // 标题
            UILabel *titleLable = [UILabel new];
            [recordContainerView addSubview:titleLable];
            [titleLable setText:NSLocalizedString(@"账单说明", nil)];
            [titleLable setTextAlignment:NSTextAlignmentLeft];
            [titleLable setFont:titleFont];
            [titleLable setTextColor:titleColor];
            [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(recordContainerView.mas_top).offset(margin*1.5f);
                make.left.equalTo(recordContainerView.mas_left).offset(content_left_right_gap);
                make.height.mas_equalTo(textHeight);
            }];
            
            // 内容
            UILabel *contentLabel = [UILabel new];
            [recordContainerView addSubview:contentLabel];
            [contentLabel setText:STR_APP_TEXT_PLACEHOLDER];
            [contentLabel setTextAlignment:NSTextAlignmentRight];
            [contentLabel setFont:contentFont];
            [contentLabel setTextColor:contentColor];
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(titleLable.mas_centerY);
                make.left.equalTo(titleLable.mas_right);
                make.right.equalTo(recordContainerView.mas_right).offset(-content_left_right_gap);
                make.height.mas_equalTo(textHeight);
            }];
            
            contentLabel;
        });
        self.recordIntroLabel = recordIntroLabel;
        self.recordIntroLabel.mas_key = @"recordIntroLabel";
        
        // 创建时间
        UILabel *recordCreateTimeLabel = ({
            // 标题
            UILabel *titleLable = [UILabel new];
            [recordContainerView addSubview:titleLable];
            [titleLable setText:NSLocalizedString(@"创建时间", nil)];
            [titleLable setTextAlignment:NSTextAlignmentLeft];
            [titleLable setFont:titleFont];
            [titleLable setTextColor:titleColor];
            [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(recordIntroLabel.mas_bottom);
                make.left.equalTo(recordContainerView.mas_left).offset(content_left_right_gap);
                make.height.mas_equalTo(textHeight);
            }];
            
            // 内容
            UILabel *contentLabel = [UILabel new];
            [recordContainerView addSubview:contentLabel];
            [contentLabel setText:STR_APP_TEXT_PLACEHOLDER];
            [contentLabel setTextAlignment:NSTextAlignmentRight];
            [contentLabel setFont:contentFont];
            [contentLabel setTextColor:contentColor];
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(titleLable.mas_centerY);
                make.left.equalTo(titleLable.mas_right);
                make.right.equalTo(recordContainerView.mas_right).offset(-content_left_right_gap);
                make.height.mas_equalTo(textHeight);
            }];
            
            contentLabel;
        });
        self.recordCreateTimeLabel = recordCreateTimeLabel;
        self.recordCreateTimeLabel.mas_key = @"recordCreateTimeLabel";
        
        // 账单单号
        UILabel *recordSerialNumberLabel = ({
            // 标题
            UILabel *titleLable = [UILabel new];
            [recordContainerView addSubview:titleLable];
            [titleLable setText:NSLocalizedString(@"账单单号", nil)];
            [titleLable setTextAlignment:NSTextAlignmentLeft];
            [titleLable setFont:titleFont];
            [titleLable setTextColor:titleColor];
            [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(recordCreateTimeLabel.mas_bottom);
                make.left.equalTo(recordContainerView.mas_left).offset(content_left_right_gap);
                make.height.mas_equalTo(textHeight);
            }];
            
            // 内容
            UILabel *contentLabel = [UILabel new];
            [recordContainerView addSubview:contentLabel];
            [contentLabel setText:STR_APP_TEXT_PLACEHOLDER];
            [contentLabel setTextAlignment:NSTextAlignmentRight];
            [contentLabel setFont:contentFont];
            [contentLabel setTextColor:contentColor];
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(titleLable.mas_centerY);
                make.left.equalTo(titleLable.mas_right);
                make.right.equalTo(recordContainerView.mas_right).offset(-content_left_right_gap);
                make.height.mas_equalTo(textHeight);
            }];
            
            contentLabel;
        });
        self.recordSerialNumberLabel = recordSerialNumberLabel;
        self.recordSerialNumberLabel.mas_key = @"recordSerialNumberLabel";
        
        // 账单分类
        UILabel *recordCategoryLabel = ({
            // 标题
            UILabel *titleLable = [UILabel new];
            [recordContainerView addSubview:titleLable];
            [titleLable setText:NSLocalizedString(@"账单分类", nil)];
            [titleLable setTextAlignment:NSTextAlignmentLeft];
            [titleLable setFont:titleFont];
            [titleLable setTextColor:titleColor];
            [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(recordSerialNumberLabel.mas_bottom);
                make.left.equalTo(recordContainerView.mas_left).offset(content_left_right_gap);
                make.height.mas_equalTo(textHeight);
            }];
            
            // 内容
            UILabel *contentLabel = [UILabel new];
            [recordContainerView addSubview:contentLabel];
            [contentLabel setText:STR_APP_TEXT_PLACEHOLDER];
            [contentLabel setTextAlignment:NSTextAlignmentRight];
            [contentLabel setFont:contentFont];
            [contentLabel setTextColor:contentColor];
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(titleLable.mas_centerY);
                make.left.equalTo(titleLable.mas_right);
                make.right.equalTo(recordContainerView.mas_right).offset(-content_left_right_gap);
                make.height.mas_equalTo(textHeight);
            }];
            
            contentLabel;
        });
        self.recordCategoryLabel = recordCategoryLabel;
        self.recordCategoryLabel.mas_key = @"recordCategoryLabel";
        
        [self.recordContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(recordCategoryLabel.mas_bottom).offset(margin);
        }];
    }
    
    
    // 游戏详情
    {
        UIView *gameInfoContainerView = ({
            UIView *view = [[UIView alloc] init];
            [publicContainerView addSubview:view];
            [view.layer setMasksToBounds:YES];
            [view setBackgroundColor:[UIColor whiteColor]];
            [view addCornerRadius:margin];

            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.recordContainerView.mas_bottom).offset(margin);
                make.left.equalTo(publicContainerView.mas_left).offset(container_left_right_gap);
                make.right.equalTo(publicContainerView.mas_right).offset(-container_left_right_gap);
            }];
            
            view;
        });
        self.gameInfoContainerView = gameInfoContainerView;
        self.gameInfoContainerView.mas_key = @"bottomContainerView";
        
        UILabel *lastItelLabel = nil;
        self.gameContentLabels = @[].mutableCopy;
        for (NSInteger idx = 0; idx < self.gameInfoTitles.count; idx ++) {
            // 标题
            UILabel *titleLable = [UILabel new];
            [gameInfoContainerView addSubview:titleLable];
            [titleLable setText:[self.gameInfoTitles objectAtIndex:idx]];
            [titleLable setTextAlignment:NSTextAlignmentLeft];
            [titleLable setFont:titleFont];
            [titleLable setTextColor:titleColor];
            [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(textHeight);
                if (!lastItelLabel) {
                    make.top.equalTo(gameInfoContainerView.mas_top).offset(margin*1.5f);
                    make.left.equalTo(gameInfoContainerView.mas_left).offset(content_left_right_gap);
                } else {
                    make.top.equalTo(lastItelLabel.mas_bottom);
                    make.left.equalTo(lastItelLabel.mas_left);
                }
            }];
            titleLable.mas_key = [NSString stringWithFormat:@"gameTitleLable%ld", idx];
            
            // 内容
            UILabel *contentLabel = [UILabel new];
            [gameInfoContainerView addSubview:contentLabel];
            [contentLabel setText:STR_APP_TEXT_PLACEHOLDER];
            [contentLabel setTextAlignment:NSTextAlignmentRight];
            [contentLabel setFont:contentFont];
            [contentLabel setTextColor:contentColor];
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(titleLable.mas_centerY);
                make.left.equalTo(titleLable.mas_right);
                make.right.equalTo(gameInfoContainerView.mas_right).offset(-content_left_right_gap);
                make.height.mas_equalTo(textHeight);
            }];
            contentLabel.mas_key = [NSString stringWithFormat:@"gameContentLabel%ld", idx];
            [self.gameContentLabels addObj:contentLabel];
            
            lastItelLabel = titleLable;
        }

        [self.gameInfoContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastItelLabel.mas_bottom).offset(margin);
        }];
    }
    
    // 约束的完整性
    [self.publicContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.gameInfoContainerView.mas_bottom).priority(749);
    }];
}

#pragma mark - 设置数据模型
- (void)setModel:(FYBillingDetailsModel *)model
{
    // 类型安全检查
    if (![model isKindOfClass:[FYBillingDetailsModel class]]) {
        return;
    }
    
    // 数据赋值
    _model = model;
    
    // 标题
    [self.recordTitleLabel setText:NSLocalizedString(@"扫雷赔付到账 发包1", nil)];
    // 图标
    [self.recordImageView setImage:[UIImage imageNamed:@"icon_game_fl"]];
    // 交易金额
    {
        NSString *symbol = @"+ ";
        UIColor *foregroundColorAttribute = COLOR_HEXSTRING(@"#0E7E12");
        NSString *originString = @"1.11";
        if ( arc4random_uniform(10) > 5) {
            symbol = @"- ";
            foregroundColorAttribute = COLOR_HEXSTRING(@"#D42540");
        }
        NSDictionary *attributesExtra = @{ NSFontAttributeName:FONT_PINGFANG_REGULAR(13.0f),
                                           NSForegroundColorAttributeName:foregroundColorAttribute};
        NSDictionary *attributesPrice = @{ NSFontAttributeName:FONT_PINGFANG_REGULAR(30.0f),
                                           NSForegroundColorAttributeName:foregroundColorAttribute};
        NSAttributedString *attributedString = [CFCSysUtil attributedString:@[ symbol, originString, @"" ]
                                                             attributeArray:@[ attributesPrice, attributesPrice, attributesExtra]];
        [self.recordMoneyLabel setAttributedText:attributedString];
    }
    
    // 账单区域
    {
        // 账单说明
        [self.recordIntroLabel setText:NSLocalizedString(@"龙虎斗结算", nil)];
        
        // 创建时间
        [self.recordCreateTimeLabel setText:@"2017-05-12 08:00"];
        
        // 账单编号
        [self.recordSerialNumberLabel setText:@"3243536456745734524"];
        
        // 账单分类
        [self.recordCategoryLabel setText:NSLocalizedString(@"游戏盈亏", nil)];
    }

    // 游戏详情
    NSMutableArray<NSString *> *gameInfoContents = @[
        NSLocalizedString(@"龙虎斗", nil), @"232441", NSLocalizedString(@"龙", nil), NSLocalizedString(@"龙", nil), @"-1.00", @"2.00", @"1.00"
    ].mutableCopy;
    for (NSInteger idx = 0; idx < self.gameContentLabels.count && idx < gameInfoContents.count; idx ++) {
        UILabel *itemLabel = [self.gameContentLabels objectAtIndex:idx];
        [itemLabel setText:[gameInfoContents objectAtIndex:idx]];
    }
    
}


@end

