//
//  FYAgentRuleTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYAgentRuleTableViewCell.h"
#import "FYAgentRuleModel.h"

@interface FYAgentRuleTableViewCell ()
@property (nonatomic, strong) UILabel *column1TitleLabel;
@property (nonatomic, strong) UILabel *column1ContentLabel;
@property (nonatomic, strong) UILabel *column2TitleLabel;
@property (nonatomic, strong) UILabel *column2ContentLabel;
@property (nonatomic, strong) UILabel *column3TitleLabel;
@property (nonatomic, strong) UILabel *column3ContentLabel;
@end

@implementation FYAgentRuleTableViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

+ (CGFloat)height
{
    return CFC_AUTOSIZING_WIDTH(75.0f);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createViewAtuoLayout];
    }
    return self;
}

- (void)createViewAtuoLayout
{
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    
    UIFont *titleFont = FONT_PINGFANG_REGULAR(13);
    UIColor *titleColor = COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT;
    UIFont *contentFont = FONT_PINGFANG_REGULAR(13);
    UIColor *contentColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    
    {
        UILabel *column1TitleLabel = ({
            UILabel *label = [UILabel new];
            [self.contentView addSubview:label];
            [label setText:NSLocalizedString(@"游戏/平台", nil)];
            [label setFont:titleFont];
            [label setTextColor:titleColor];
            [label setTextAlignment:NSTextAlignmentLeft];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView.mas_bottom).multipliedBy(0.35f);
                make.left.equalTo(self.contentView.mas_right).multipliedBy(0.05f);
                make.width.equalTo(self.contentView.mas_width).multipliedBy(0.20f);
            }];
            
            label;
        });
        self.column1TitleLabel = column1TitleLabel;
        self.column1TitleLabel.mas_key = @"column1TitleLabel";
        
        UILabel *column1ContentLabel = ({
            UILabel *label = [UILabel new];
            [self.contentView addSubview:label];
            [label setNumberOfLines:0];
            [label setFont:contentFont];
            [label setTextColor:contentColor];
            [label setTextAlignment:NSTextAlignmentLeft];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_bottom).multipliedBy(0.40f);
                make.left.equalTo(column1TitleLabel.mas_left);
                make.right.equalTo(column1TitleLabel.mas_right);
            }];
            
            label;
        });
        self.column1ContentLabel = column1ContentLabel;
        self.column1ContentLabel.mas_key = @"column1ContentLabel";
    }
    
    {
        UILabel *column2TitleLabel = ({
            UILabel *label = [UILabel new];
            [self.contentView addSubview:label];
            [label setText:NSLocalizedString(@"结算方式", nil)];
            [label setFont:titleFont];
            [label setTextColor:titleColor];
            [label setTextAlignment:NSTextAlignmentLeft];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView.mas_bottom).multipliedBy(0.35f);
                make.left.equalTo(self.contentView.mas_right).multipliedBy(0.30f);
                make.right.equalTo(self.contentView.mas_right).multipliedBy(0.45f);
            }];
            
            label;
        });
        self.column2TitleLabel = column2TitleLabel;
        self.column2TitleLabel.mas_key = @"column2TitleLabel";
        
        UILabel *column2ContentLabel = ({
            UILabel *label = [UILabel new];
            [self.contentView addSubview:label];
            [label setNumberOfLines:0];
            [label setFont:contentFont];
            [label setTextColor:contentColor];
            [label setTextAlignment:NSTextAlignmentLeft];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_bottom).multipliedBy(0.40f);
                make.left.equalTo(column2TitleLabel.mas_left);
                make.right.equalTo(column2TitleLabel.mas_right);
            }];
            
            label;
        });
        self.column2ContentLabel = column2ContentLabel;
        self.column2ContentLabel.mas_key = @"column2ContentLabel";
    }
    
    {
        UILabel *column3TitleLabel = ({
            UILabel *label = [UILabel new];
            [self.contentView addSubview:label];
            [label setText:NSLocalizedString(@"返水比例(1~6)", nil)];
            [label setFont:titleFont];
            [label setTextColor:titleColor];
            [label setTextAlignment:NSTextAlignmentLeft];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView.mas_bottom).multipliedBy(0.35f);
                make.left.equalTo(self.contentView.mas_right).multipliedBy(0.55f);
                make.right.equalTo(self.contentView.mas_right).multipliedBy(0.95f);
            }];
            
            label;
        });
        self.column3TitleLabel = column3TitleLabel;
        self.column3TitleLabel.mas_key = @"column3TitleLabel";
        
        UILabel *column3ContentLabel = ({
            UILabel *label = [UILabel new];
            [self.contentView addSubview:label];
            [label setNumberOfLines:0];
            [label setFont:contentFont];
            [label setTextColor:contentColor];
            [label setTextAlignment:NSTextAlignmentLeft];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_bottom).multipliedBy(0.40f);
                make.left.equalTo(column3TitleLabel.mas_left);
                make.right.equalTo(column3TitleLabel.mas_right);
                make.bottom.equalTo(self.contentView.mas_bottom);
            }];
            
            label;
        });
        self.column3ContentLabel = column3ContentLabel;
        self.column3ContentLabel.mas_key = @"column3ContentLabel";
    }
    
    {
        UIView *splitLineV1 = ({
            UIView *view = [[UIView alloc] init];
            [view setBackgroundColor:COLOR_GAME_CONTENT_SEPARATOR_LINE];
            [self.contentView addSubview:view];
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.contentView);
                make.width.mas_equalTo(SEPARATOR_LINE_HEIGHT);
                make.centerX.equalTo(self.contentView.mas_right).multipliedBy(0.25f);
            }];
            
            view;
        });
        splitLineV1.mas_key = @"splitLineV1";
        
        UIView *splitLineV2 = ({
            UIView *view = [[UIView alloc] init];
            [view setBackgroundColor:COLOR_GAME_CONTENT_SEPARATOR_LINE];
            [self.contentView addSubview:view];
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.contentView);
                make.width.mas_equalTo(SEPARATOR_LINE_HEIGHT);
                make.centerX.equalTo(self.contentView.mas_right).multipliedBy(0.50f);
            }];
            
            view;
        });
        splitLineV2.mas_key = @"splitLineV2";
        
        UIView *splitLineH = ({
            UIView *view = [[UIView alloc] init];
            [view setBackgroundColor:COLOR_GAME_CONTENT_SEPARATOR_LINE];
            [self.contentView addSubview:view];
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.contentView);
                make.height.mas_equalTo(SEPARATOR_LINE_HEIGHT);
            }];
            
            view;
        });
        splitLineH.mas_key = @"splitLineH";
    }
    
}

- (void)setModel:(FYAgentRuleModel *)model
{
    if (![model isKindOfClass:[FYAgentRuleModel class]]) {
        return;
    }
    
    _model = model;

    [self.column1ContentLabel setText:self.model.name];
    [self.column2ContentLabel setText:self.model.options];
//    [self.column3ContentLabel setText:self.model.level];
    NSMutableAttributedString *abs = [[NSMutableAttributedString alloc]initWithString:model.level];
    [abs addAttribute:NSFontAttributeName value:FONT_PINGFANG_REGULAR(12) range:NSMakeRange(0, model.level.length)];
    self.column3ContentLabel.attributedText = abs;
}

@end

