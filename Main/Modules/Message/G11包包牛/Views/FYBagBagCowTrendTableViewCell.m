//
//  FYBagBagCowTrendTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagBagCowTrendTableViewCell.h"
#import "FYBagBagCowTrendModel.h"


@interface FYBagBagCowTrendTableViewCell ()
/**
 * 根容器组件
 */
@property (nonatomic, strong) UIView *rootContainerView;
/**
 * 公共容器
 */
@property (nonatomic, strong) UIView *publicContainerView;
/**
 * 期数控件
 */
@property (nonatomic, strong) UILabel *column1Label;
/**
 * 庄控件
 */
@property (nonatomic, strong) UILabel *column2Label;
/**
 * 闲控件
 */
@property (nonatomic, strong) UILabel *column3Label;
/**
 * 输赢控件
 */
@property (nonatomic, strong) UILabel *column4Label;
/**
 * 分割线控件
 */
@property (nonatomic, strong) UIView *separatorLineView;

@end


@implementation FYBagBagCowTrendTableViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

+ (CGFloat)height
{
    return 32.0f;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createViewAtuoLayout];
    }
    return self;
}

#pragma mark - 创建子控件
- (void)createViewAtuoLayout
{
    UIFont *itemFont = FONT_PINGFANG_REGULAR(14);
    UIColor *itemColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    NSArray<NSNumber *> *percents = @[ @(0.25f), @(0.50f), @(0.75f), @(1.0f) ];
    
    // 期数控件
    UILabel *column1Label = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:itemFont];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        CGFloat percent = [percents objectAtIndex:0].floatValue;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).multipliedBy(percent);
            make.left.equalTo(self.contentView.mas_left);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        label;
    });
    self.column1Label = column1Label;
    self.column1Label.mas_key = @"column1Label";
    
    // 庄控件
    UILabel *column2Label = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:itemFont];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        CGFloat percent = [percents objectAtIndex:1].floatValue;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).multipliedBy(percent);
            make.left.equalTo(column1Label.mas_right);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        label;
    });
    self.column2Label = column2Label;
    self.column2Label.mas_key = @"column2Label";
    
    // 闲控件
    UILabel *column3Label = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setFont:FONT_PINGFANG_REGULAR(13)];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentCenter];

        CGFloat percent = [percents objectAtIndex:2].floatValue;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).multipliedBy(percent);
            make.left.equalTo(column2Label.mas_right);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        label;
    });
    self.column3Label = column3Label;
    self.column3Label.mas_key = @"column3Label";
    
    // 输赢控件
    UILabel *column4Label = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:itemFont];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        CGFloat percent = [percents objectAtIndex:3].floatValue;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).multipliedBy(percent);
            make.left.equalTo(column3Label.mas_right);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        label;
    });
    self.column4Label = column4Label;
    self.column4Label.mas_key = @"column4Label";
    
    // 分割线1
    UIView *splitLineViewV1 = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [self.contentView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.centerX.equalTo(self.column1Label.mas_right);
            make.width.mas_equalTo(SEPARATOR_LINE_HEIGHT);
        }];
        
        view;
    });
    splitLineViewV1.mas_key = @"splitLineViewV1";
    
    // 分割线2
    UIView *splitLineViewV2 = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [self.contentView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.centerX.equalTo(self.column2Label.mas_right);
            make.width.mas_equalTo(SEPARATOR_LINE_HEIGHT);
        }];
        
        view;
    });
    splitLineViewV2.mas_key = @"splitLineViewV2";
    
    // 分割线3
    UIView *splitLineViewV3 = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [self.contentView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.centerX.equalTo(self.column3Label.mas_right);
            make.width.mas_equalTo(SEPARATOR_LINE_HEIGHT);
        }];
        
        view;
    });
    splitLineViewV3.mas_key = @"splitLineViewV3";
    
    // 分割线
    UIView *separatorLineView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [self.contentView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(SEPARATOR_LINE_HEIGHT);
        }];
        
        view;
    });
    self.separatorLineView = separatorLineView;
    self.separatorLineView.mas_key = @"separatorLineView";
}

#pragma mark - 设置数据模型
- (void)setModel:(FYBagBagCowTrendModel *)model
{
    if (![model isKindOfClass:[FYBagBagCowTrendModel class]]) {
        return;
    }
    
    _model = model;

    // 期数
    [self.column1Label setText:[NSString stringWithFormat:@"%@", self.model.gameNumber]];
    
    // 庄
    NSString *bankerString = self.model.isIssuePlaying ? @"?" : [self getTrendTitle:self.model.bankerNumber];
    [self.column2Label setText:bankerString];
    
    // 闲
    NSString *playerString = self.model.isIssuePlaying ? @"?" : [self getTrendTitle:self.model.playerNumber];
    [self.column3Label setText:playerString];
    
    // 输赢
    if (self.model.isIssuePlaying) {
        [self.column4Label setText:@"?"];
    } else {
        if (0 == self.model.winner.integerValue) { // 庄赢
            NSDictionary *attrPref = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT};
            NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
            NSAttributedString *attrString = [CFCSysUtil attributedString:@[NSLocalizedString(@"庄", nil),NSLocalizedString(@"赢", nil)] attributeArray:@[attrPref,attrText]];
            [self.column4Label setAttributedText:attrString];
        } else if (1 == self.model.winner.integerValue) { // 闲赢
            NSDictionary *attrPref = @{ NSForegroundColorAttributeName:COLOR_HEXSTRING(@"#3875F6")};
            NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
            NSAttributedString *attrString = [CFCSysUtil attributedString:@[NSLocalizedString(@"闲", nil),NSLocalizedString(@"赢", nil)] attributeArray:@[attrPref,attrText]];
            [self.column4Label setAttributedText:attrString];
        } else if (2 == self.model.winner.integerValue) { // 和赢
            NSDictionary *attrPref = @{ NSForegroundColorAttributeName:COLOR_HEXSTRING(@"#00C52E")};
            NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
            NSAttributedString *attrString = [CFCSysUtil attributedString:@[NSLocalizedString(@"和", nil),NSLocalizedString(@"赢", nil)] attributeArray:@[attrPref,attrText]];
            [self.column4Label setAttributedText:attrString];
        }
    }
}

- (NSString *)getTrendTitle:(NSString *)number
{
    NSString *result = STR_APP_TEXT_PLACEHOLDER;
    if (1 == number.integerValue) {
        result = NSLocalizedString(@"牛一", nil);
    } else if (2 == number.integerValue) {
        result = NSLocalizedString(@"牛二", nil);
    } else if (3 == number.integerValue) {
        result = NSLocalizedString(@"牛三", nil);
    } else if (4 == number.integerValue) {
        result = NSLocalizedString(@"牛四", nil);
    } else if (5 == number.integerValue) {
        result = NSLocalizedString(@"牛五", nil);
    } else if (6 == number.integerValue) {
        result = NSLocalizedString(@"牛六", nil);
    } else if (7 == number.integerValue) {
        result = NSLocalizedString(@"牛七", nil);
    } else if (8 == number.integerValue) {
        result = NSLocalizedString(@"牛八", nil);
    } else if (9 == number.integerValue) {
        result = NSLocalizedString(@"牛九", nil);
    } else if (10 == number.integerValue) {
        result = NSLocalizedString(@"牛牛", nil);
    } else if (11 == number.integerValue) {
        result = NSLocalizedString(@"金牛", nil);
    } else if (12 == number.integerValue) {
        result = NSLocalizedString(@"对子", nil);
    } else if (13 == number.integerValue) {
        result = NSLocalizedString(@"正顺", nil);
    } else if (14 == number.integerValue) {
        result = NSLocalizedString(@"倒顺", nil);
    } else if (15 == number.integerValue) {
        result = NSLocalizedString(@"豹子", nil);
    }
    return result;
}


@end

