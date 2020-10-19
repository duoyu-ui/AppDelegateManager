//
//  FYJSSLGameRecordDetailHudCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYJSSLGameRecordDetailHudCell.h"
#import "FYJSSLGameRecordDetailModel.h"
#import "FYJSSLGameRecordHudModel.h"
#import "FYJSSLGameResultModel.h"

@interface FYJSSLGameRecordDetailHudCell ()
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *betMoneyLabel;
@property (nonatomic, strong) UILabel *oddsLabel;
@property (nonatomic, strong) UILabel *profitLossLabel;
@property (nonatomic, strong) NSMutableArray<UILabel *> *betNumLabels;
@property (nonatomic, strong) NSMutableArray<UILabel *> *resNumLabels;
@end

@implementation FYJSSLGameRecordDetailHudCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

+ (CGFloat)headerViewHeight
{
    return [[self class] heightOfTitle] + [[self class] heightOfContentRow] * 6;
}

+ (CGFloat)heightOfTitle
{
    return CFC_AUTOSIZING_WIDTH(32.0);
}

+ (CGFloat)heightOfContentRow
{
    return CFC_AUTOSIZING_WIDTH(28.0);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.whiteColor;
        [self createViewAtuoLayout];
    }
    return self;
}

#pragma mark - 创建子控件
- (void)createViewAtuoLayout
{
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    
    UIFont *itemFont = FONT_PINGFANG_REGULAR(14);
    UIColor *itemColor = COLOR_HEXSTRING(@"#6D6D6D");
    UIColor *splitLineColor = HexColor(@"#D3D3D3");
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat heightOfContentRow = [[self class] heightOfContentRow];
    CGFloat offsetCenterY = [[self class] heightOfTitle] + heightOfContentRow * 3.5f;
    NSArray<NSNumber *> *percents = @[ @(0.25f), @(0.50f), @(0.75f), @(1.0f) ];
    
    // 第N注
    UILabel *numberLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:itemFont];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(self.contentView.mas_top);
            make.height.mas_equalTo([[self class] heightOfTitle]);
        }];
        
        label;
    });
    self.numberLabel = numberLabel;
    self.numberLabel.mas_key = @"numberLabel";
    
    // 投注金额
    UILabel *betMoneyLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:itemFont];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentRight];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-margin*1.5f);
            make.top.equalTo(self.contentView.mas_top);
            make.height.mas_equalTo([[self class] heightOfTitle]);
        }];
        
        label;
    });
    self.betMoneyLabel = betMoneyLabel;
    self.betMoneyLabel.mas_key = @"betMoneyLabel";
        
    // 表格头
    UILabel *lastTableHeaderLabel = nil;
    {
        NSArray<NSString *> *titles = @[NSLocalizedString(@"位数", nil),
                                        NSLocalizedString(@"投注号码", nil),
                                        NSLocalizedString(@"开奖结果", nil),
                                        NSLocalizedString(@"盈亏", nil)];
        for (NSInteger index = 0; index < titles.count; index ++) {
            lastTableHeaderLabel = ({
                UILabel *label = [UILabel new];
                [self.contentView addSubview:label];
                [label setText:titles[index]];
                [label setFont:itemFont];
                [label setTextColor:[UIColor whiteColor]];
                [label setTextAlignment:NSTextAlignmentCenter];
                [label setBackgroundColor:HexColor(@"#6B6B6B")];
                //
                CGFloat percent = [percents objectAtIndex:index].floatValue;
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.contentView.mas_right).multipliedBy(percent);
                    make.height.equalTo(@(heightOfContentRow));
                    if (!lastTableHeaderLabel) {
                        make.top.equalTo(self.numberLabel.mas_bottom);
                        make.left.equalTo(self.contentView.mas_left);
                    } else {
                        make.top.equalTo(lastTableHeaderLabel.mas_top);
                        make.left.equalTo(lastTableHeaderLabel.mas_right);
                    }
                }];
                
                label;
            });
            lastTableHeaderLabel.mas_key = [NSString stringWithFormat:@"lastTableHeaderLabel%ld", index];
            //
            if (index < titles.count -1) {
                UILabel *splitLineTableHeader = ({
                    UILabel *view = [[UILabel alloc] init];
                    [view setBackgroundColor:splitLineColor];
                    [self.contentView addSubview:view];
                    
                    CGFloat percent = [percents objectAtIndex:index].floatValue;
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.contentView.mas_right).multipliedBy(percent);
                        make.centerY.equalTo(lastTableHeaderLabel.mas_centerY);
                        make.width.mas_equalTo(SEPARATOR_LINE_HEIGHT);
                        make.height.mas_equalTo(heightOfContentRow);
                    }];
                    
                    view;
                });
                splitLineTableHeader.mas_key = @"splitLineTableHeader";
            }
        }
    }
    
    // 万千百十个
    UILabel *lastItemLabel = nil;
    {
        self.betNumLabels = [NSMutableArray<UILabel *> array];
        self.resNumLabels = [NSMutableArray<UILabel *> array];
        //
        NSArray<NSString *> *titles = @[NSLocalizedString(@"万", nil),
                                        NSLocalizedString(@"千", nil),
                                        NSLocalizedString(@"百", nil),
                                        NSLocalizedString(@"十", nil),
                                        NSLocalizedString(@"个", nil)];
        NSInteger column = 3;
        for (NSInteger row = 0; row < titles.count; row ++) {
            for (NSInteger col = 0; col < column; col ++) {
                CGFloat percent = [percents objectAtIndex:col].floatValue;
                //
                lastItemLabel = ({
                    UILabel *label = [UILabel new];
                    [self.contentView addSubview:label];
                    [label setFont:itemFont];
                    [label setTextColor:itemColor];
                    [label setTextAlignment:NSTextAlignmentCenter];
                    //
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(self.contentView.mas_right).multipliedBy(percent);
                        make.height.equalTo(@(heightOfContentRow));
                        if (0 == col) {
                            if (!lastItemLabel) {
                                make.top.equalTo(lastTableHeaderLabel.mas_bottom);
                                make.left.equalTo(self.contentView.mas_left);
                            } else {
                                make.top.equalTo(lastItemLabel.mas_bottom);
                                make.left.equalTo(self.contentView.mas_left);
                            }
                        } else {
                            make.top.equalTo(lastItemLabel.mas_top);
                            make.left.equalTo(lastItemLabel.mas_right);
                        }
                    }];
            
                    label;
                });
                lastItemLabel.mas_key = [NSString stringWithFormat:@"lastItemLabel%ld", column*row+col];
                //
                if (0 == col) {
                    [lastItemLabel setText:titles[row]];
                } else if (1 == col) { // 投注号码
                    [lastItemLabel setText:STR_APP_TEXT_PLACEHOLDER];
                    [self.betNumLabels addObj:lastItemLabel];
                } else if (2 == col) { // 开奖结果
                    // 背景
                    CGFloat draw_size = heightOfContentRow * 0.8f;
                    UIImageView *resultDrawView = [[UIImageView alloc] init];
                    [lastItemLabel addSubview:resultDrawView];
                    [resultDrawView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(draw_size);
                        make.height.mas_equalTo(draw_size);
                        make.centerX.equalTo(lastItemLabel);
                        make.centerY.equalTo(lastItemLabel);
                    }];
                    if (0 == row) {
                        [resultDrawView setImage:[UIImage imageNamed:@"jssl_wan_icon_sel"]];
                    } else if (1 == row) {
                        [resultDrawView setImage:[UIImage imageNamed:@"jssl_qian_icon_sel"]];
                    } else if (2 == row) {
                        [resultDrawView setImage:[UIImage imageNamed:@"jssl_bai_icon_sel"]];
                    } else if (3 == row) {
                        [resultDrawView setImage:[UIImage imageNamed:@"jssl_shi_icon_sel"]];
                    } else if (4 == row) {
                        [resultDrawView setImage:[UIImage imageNamed:@"jssl_ge_icon_sel"]];
                    }
                    // 号码
                    UILabel *resultDrawLabel = ({
                        UILabel *label = [UILabel new];
                        [resultDrawView addSubview:label];
                        [label setText:@"?"];
                        [label setFont:FONT_PINGFANG_BOLD(14)];
                        [label setTextColor:[UIColor whiteColor]];
                        [label setTextAlignment:NSTextAlignmentCenter];
                        
                        [label mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(resultDrawView.mas_centerX);
                            make.centerY.equalTo(resultDrawView.mas_centerY);
                        }];
                        
                        label;
                    });
                    [self.resNumLabels addObj:resultDrawLabel];
                }
                //
                UILabel *splitLineCol = ({
                    UILabel *view = [[UILabel alloc] init];
                    [view setBackgroundColor:splitLineColor];
                    [self.contentView addSubview:view];
                    
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.contentView.mas_right).multipliedBy(percent);
                        make.centerY.equalTo(lastItemLabel.mas_centerY);
                        make.width.mas_equalTo(SEPARATOR_LINE_HEIGHT);
                        make.height.mas_equalTo(heightOfContentRow);
                    }];
                    
                    view;
                });
                splitLineCol.mas_key = @"splitLineCol";
            }
            //
            UILabel *splitLineRow = ({
                UILabel *view = [[UILabel alloc] init];
                [view setBackgroundColor:splitLineColor];
                [self.contentView addSubview:view];

                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(SEPARATOR_LINE_HEIGHT);
                    make.left.equalTo(self.contentView.mas_left);
                    make.right.equalTo(lastItemLabel.mas_right);
                    make.bottom.equalTo(lastItemLabel.mas_bottom);
                }];

                view;
            });
            splitLineRow.mas_key = @"splitLineRow";
        }
    }
    
    // 倍率
    UILabel *oddsLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:itemFont];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentRight];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_top).offset(offsetCenterY);
            make.centerX.equalTo(lastTableHeaderLabel.mas_centerX);
        }];
        
        label;
    });
    self.oddsLabel = oddsLabel;
    self.oddsLabel.mas_key = @"oddsLabel";
    
    // 盈亏
    UILabel *profitLossLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:itemFont];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentRight];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(offsetCenterY);
            make.centerX.equalTo(lastTableHeaderLabel.mas_centerX);
        }];
        
        label;
    });
    self.profitLossLabel = profitLossLabel;
    self.profitLossLabel.mas_key = @"profitLossLabel";
    
    UILabel *separatorLineView = ({
        UILabel *view = [[UILabel alloc] init];
        [view setBackgroundColor:splitLineColor];
        [self.contentView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(SEPARATOR_LINE_HEIGHT);
        }];
        
        view;
    });
    separatorLineView.mas_key = @"separatorLineView";
}

#pragma mark - 设置数据模型
- (void)setModel:(FYJSSLGameRecordHudModel *)model
{
    if (![model isKindOfClass:[FYJSSLGameRecordHudModel class]]) {
        return;
    }
    
    _model = model;

    // 第N注
    NSString *zhNum = [NSString stringWithFormat:@"%ld", self.indexPath.row + 1];
    if ([[NSBundle currentLanguage] hasPrefix:@"zh"]) {
        zhNum = [CFCSysUtil translationArabicNum:zhNum.integerValue];
    }
    [self.numberLabel setText:[NSString stringWithFormat:NSLocalizedString(@"第%@注", nil), zhNum]];

    // 投注金额
    [self.betMoneyLabel setText:[NSString stringWithFormat:NSLocalizedString(@"单注金额：%@", nil),self.model.betRecordDTO.betMoney]];
    
    // 倍率
    [self.oddsLabel setText:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"倍率", nil),self.model.betRecordDTO.odds]];
    
    // 盈亏
    if (self.model.betRecordDTO.profitLoss.floatValue == 0) {
        NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
        NSString *content = [NSString stringWithFormat:@"%.2f", fabs(self.model.betRecordDTO.profitLoss.floatValue)];
        NSAttributedString *attrString = [CFCSysUtil attributedString:@[content] attributeArray:@[attrText]];
        [self.profitLossLabel setAttributedText:attrString];
    } else if (self.model.betRecordDTO.profitLoss.floatValue < 0) {
        NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
        NSString *content = [NSString stringWithFormat:@"-%.2f", fabs(self.model.betRecordDTO.profitLoss.floatValue)];
        NSAttributedString *attrString = [CFCSysUtil attributedString:@[content] attributeArray:@[attrText]];
        [self.profitLossLabel setAttributedText:attrString];
    } else {
        NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT};
        NSString *content = [NSString stringWithFormat:@"+%.2f", fabs(self.model.betRecordDTO.profitLoss.floatValue)];
        NSAttributedString *attrString = [CFCSysUtil attributedString:@[content] attributeArray:@[attrText]];
        [self.profitLossLabel setAttributedText:attrString];
    }
    
    // 投注号码、开奖结果
    NSString *joinedSysbol = @",";
    for (NSInteger idx = 0; idx < self.betNumLabels.count && idx < self.resNumLabels.count; idx ++) {
        UILabel *betNumLabel = [self.betNumLabels objectAtIndex:idx];
        UILabel *resNumLabel = [self.resNumLabels objectAtIndex:idx];
        if (0 == idx) {
            [resNumLabel setText:self.model.recordDTO.myriad];
            if (self.model.betRecordDTO.myriadBet.count > 0) {
                NSString *betNumsValue = [self.model.betRecordDTO.myriadBet componentsJoinedByString:joinedSysbol];
                [betNumLabel setText:[NSString stringWithFormat:@"【%@】", betNumsValue]];
            } else {
                [betNumLabel setText:@""];
            }
        } else if (1 == idx) {
            [resNumLabel setText:self.model.recordDTO.thousand];
            if (self.model.betRecordDTO.thousandBet.count > 0) {
                NSString *betNumsValue = [self.model.betRecordDTO.thousandBet componentsJoinedByString:joinedSysbol];
                [betNumLabel setText:[NSString stringWithFormat:@"【%@】", betNumsValue]];
            } else {
                [betNumLabel setText:@""];
            }
        } else if (2 == idx) {
            [resNumLabel setText:self.model.recordDTO.hundred];
            if (self.model.betRecordDTO.hundredBet.count > 0) {
                NSString *betNumsValue = [self.model.betRecordDTO.hundredBet componentsJoinedByString:joinedSysbol];
                [betNumLabel setText:[NSString stringWithFormat:@"【%@】", betNumsValue]];
            } else {
                [betNumLabel setText:@""];
            }
        } else if (3 == idx) {
            [resNumLabel setText:self.model.recordDTO.ten];
            if (self.model.betRecordDTO.tenBet.count > 0) {
                NSString *betNumsValue = [self.model.betRecordDTO.tenBet componentsJoinedByString:joinedSysbol];
                [betNumLabel setText:[NSString stringWithFormat:@"【%@】", betNumsValue]];
            } else {
                [betNumLabel setText:@""];
            }
        } else if (4 == idx) {
            [resNumLabel setText:self.model.recordDTO.individual];
            if (self.model.betRecordDTO.individualBet.count > 0) {
                NSString *betNumsValue = [self.model.betRecordDTO.individualBet componentsJoinedByString:joinedSysbol];
                [betNumLabel setText:[NSString stringWithFormat:@"【%@】", betNumsValue]];
            } else {
                [betNumLabel setText:@""];
            }
        }
    }
    
    
}


@end

