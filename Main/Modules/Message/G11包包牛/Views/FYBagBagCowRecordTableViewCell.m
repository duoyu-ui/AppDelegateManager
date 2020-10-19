//
//  FYBagBagCowRecordTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagBagCowRecordTableViewCell.h"
#import "FYBagBagCowRecordModel.h"


@interface FYBagBagCowRecordTableViewCell ()
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
@property (nonatomic, strong) UILabel *issueLabel;
/**
 * 输赢控件
 */
@property (nonatomic, strong) UILabel *winnerLabel;
/**
 * 盈亏控件
 */
@property (nonatomic, strong) UILabel *profitLossLabel;
/**
 * 时间控件
 */
@property (nonatomic, strong) UILabel *datetimeLabel;
/**
 * 箭头控件
 */
@property (nonatomic, strong) UIImageView *arrowImageView;
/**
 * 分割线控件
 */
@property (nonatomic, strong) UIView *separatorLineView;

@end


@implementation FYBagBagCowRecordTableViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
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
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    UIFont *itemFont = FONT_PINGFANG_REGULAR(14);
    UIColor *itemColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    NSArray<NSNumber *> *percents = @[ @(0.23f), @(0.33f), @(0.60f), @(0.93f), @(1.0f) ];
    
    // 根容器
    UIView *rootContainerView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:[UIColor whiteColor]];
        [self.contentView insertSubview:view atIndex:0];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0.0f);
            make.top.equalTo(@0.0f);
            make.right.equalTo(@0.0f);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
        view;
    });
    self.rootContainerView = rootContainerView;
    self.rootContainerView.mas_key = @"rootContainerView";
    
    // 公共容器
    UIView *publicContainerView = ({
        UIView *view = [[UIView alloc] init];
        [view.layer setMasksToBounds:YES];
        [rootContainerView addSubview:view];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressPublicItemView:)];
        [view addGestureRecognizer:tapGesture];
        
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
    
    // 期数控件
    UILabel *issueLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:itemFont];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        CGFloat percent = [percents objectAtIndex:0].floatValue;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(publicContainerView.mas_right).multipliedBy(percent);
            make.left.equalTo(publicContainerView.mas_left);
            make.centerY.equalTo(publicContainerView.mas_centerY);
        }];
        
        label;
    });
    self.issueLabel = issueLabel;
    self.issueLabel.mas_key = @"issueLabel";
    
    // 输赢控件
    UILabel *winnerLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:itemFont];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        CGFloat percent = [percents objectAtIndex:1].floatValue;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(publicContainerView.mas_right).multipliedBy(percent);
            make.left.equalTo(issueLabel.mas_right);
            make.centerY.equalTo(publicContainerView.mas_centerY);
        }];
        
        label;
    });
    self.winnerLabel = winnerLabel;
    self.winnerLabel.mas_key = @"winnerLabel";
    
    // 盈亏控件
    UILabel *profitLossLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:itemFont];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        CGFloat percent = [percents objectAtIndex:2].floatValue;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(publicContainerView.mas_right).multipliedBy(percent);
            make.left.equalTo(winnerLabel.mas_right);
            make.centerY.equalTo(publicContainerView.mas_centerY);
        }];
        
        label;
    });
    self.profitLossLabel = profitLossLabel;
    self.profitLossLabel.mas_key = @"profitLossLabel";
    
    // 时间控件
    UILabel *datetimeLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setFont:FONT_PINGFANG_REGULAR(13)];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentCenter];

        CGFloat percent = [percents objectAtIndex:3].floatValue;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(publicContainerView.mas_right).multipliedBy(percent);
            make.left.equalTo(profitLossLabel.mas_right);
            make.centerY.equalTo(publicContainerView.mas_centerY);
        }];
        
        label;
    });
    self.datetimeLabel = datetimeLabel;
    self.datetimeLabel.mas_key = @"datetimeLabel";
    
    // 箭头控件
    UIImageView *arrowImageView = ({
        CGSize imageSize = CGSizeMake(CFC_AUTOSIZING_WIDTH(20.0f), CFC_AUTOSIZING_WIDTH(20.0f));
        UIImageView *imageView = [[UIImageView alloc] init];
        [publicContainerView addSubview:imageView];
        [imageView.layer setMasksToBounds:YES];
        [imageView setUserInteractionEnabled:YES];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setImage:[[UIImage imageNamed:ICON_TABLEVIEW_CELL_ARROW] imageByScalingProportionallyToSize:imageSize]];

        CGFloat percent = [percents objectAtIndex:3].floatValue;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(publicContainerView.mas_centerY);
            make.left.equalTo(publicContainerView.mas_right).multipliedBy(percent);
            make.size.mas_equalTo(imageSize);
        }];
        
        imageView;
    });
    self.arrowImageView = arrowImageView;
    self.arrowImageView.mas_key = @"arrowImageView";
    
    // 分割线
    UIView *separatorLineView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [publicContainerView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(issueLabel.mas_bottom).offset(margin*1.5f);
            make.left.equalTo(publicContainerView.mas_left);
            make.right.equalTo(publicContainerView.mas_right);
            make.height.mas_equalTo(SEPARATOR_LINE_HEIGHT);
        }];
        
        view;
    });
    self.separatorLineView = separatorLineView;
    self.separatorLineView.mas_key = @"separatorLineView";
    
    // 约束的完整性
    [publicContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(separatorLineView.mas_bottom).priority(749);
    }];
}

#pragma mark - 设置数据模型
- (void)setModel:(FYBagBagCowRecordModel *)model
{
    if (![model isKindOfClass:[FYBagBagCowRecordModel class]]) {
        return;
    }
    
    _model = model;

    // 期数
    [self.issueLabel setText:[NSString stringWithFormat:@"%@", self.model.gameNumber]];
    
    // 输赢
    if (0 == self.model.winner.integerValue) { // 庄赢
        NSDictionary *attrPref = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT};
        NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
        NSAttributedString *attrString = [CFCSysUtil attributedString:@[NSLocalizedString(@"庄", nil),NSLocalizedString(@"赢", nil)] attributeArray:@[attrPref,attrText]];
        [self.winnerLabel setAttributedText:attrString];
    } else if (1 == self.model.winner.integerValue) { // 闲赢
        NSDictionary *attrPref = @{ NSForegroundColorAttributeName:COLOR_HEXSTRING(@"#3875F6")};
        NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
        NSAttributedString *attrString = [CFCSysUtil attributedString:@[NSLocalizedString(@"闲", nil),NSLocalizedString(@"赢", nil)] attributeArray:@[attrPref,attrText]];
        [self.winnerLabel setAttributedText:attrString];
    } else if (2 == self.model.winner.integerValue) { // 和赢
        NSDictionary *attrPref = @{ NSForegroundColorAttributeName:COLOR_HEXSTRING(@"#00C52E")};
        NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
        NSAttributedString *attrString = [CFCSysUtil attributedString:@[NSLocalizedString(@"和", nil),NSLocalizedString(@"赢", nil)] attributeArray:@[attrPref,attrText]];
        [self.winnerLabel setAttributedText:attrString];
    }
    
    // 盈亏
    if (model.money.floatValue == 0) {
        NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
        NSString *content = [NSString stringWithFormat:@"%.2f", fabs(self.model.money.floatValue)];
        NSAttributedString *attrString = [CFCSysUtil attributedString:@[content] attributeArray:@[attrText]];
        [self.profitLossLabel setAttributedText:attrString];
    } else if (model.money.floatValue < 0) {
        NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
        NSString *content = [NSString stringWithFormat:@"- %.2f", fabs(self.model.money.floatValue)];
        NSAttributedString *attrString = [CFCSysUtil attributedString:@[content] attributeArray:@[attrText]];
        [self.profitLossLabel setAttributedText:attrString];
    } else {
        NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT};
        NSString *content = [NSString stringWithFormat:@"+ %.2f", fabs(self.model.money.floatValue)];
        NSAttributedString *attrString = [CFCSysUtil attributedString:@[content] attributeArray:@[attrText]];
        [self.profitLossLabel setAttributedText:attrString];
    }
    
    // 时间
    [self.datetimeLabel setText:[FYDateUtil dateFormattingWithDateString:model.createTime dateFormate:kFYDatePickerFormatDateFull toFormate:kFYDatePickerFormatDateFull]];
}


#pragma mark - 触发操作事件
- (void)pressPublicItemView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtBagBagCowRecordModel:indexPath:)]) {
        [self.delegate didSelectRowAtBagBagCowRecordModel:self.model indexPath:self.indexPath];
    }
}


@end

