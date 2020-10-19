//
//  FYGamesClassMenuTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/16.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesClassMenuTableViewCell.h"
#import "FYGamesClassMenuModel.h"

#define COLOR_GAME_CLASS_MENU_BACKGROUND  COLOR_HEXSTRING(@"#F8F8F8")

// Cell Identifier
NSString * const CELL_IDENTIFIER_GAMES_CLASS_MENU = @"FYGamesClassMenuTableViewCellIdentifier";

@interface FYGamesClassMenuTableViewCell ()
// 标识
@property (nonatomic, strong) UILabel *markLabel;
// 标题
@property (nonatomic, strong) UILabel *titleLabel;
// 分割线
@property (nonatomic, strong) UIView *separatorLineView;

@end

@implementation FYGamesClassMenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createViewAtuoLayout];
    }
    return self;
}

- (void)createViewAtuoLayout
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressContentView:)];
    [self.contentView addGestureRecognizer:tapGesture];
    [self.contentView setBackgroundColor:COLOR_GAME_CLASS_MENU_BACKGROUND];
    
    UILabel *markLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setBackgroundColor:COLOR_GAME_CLASS_MENU_BACKGROUND];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(margin*0.5f);
            make.height.equalTo(self.contentView.mas_height).multipliedBy(0.5f);
            make.centerY.equalTo(self.contentView.mas_centerY);
            // make.width.mas_equalTo(margin*0.25f);
            make.width.mas_equalTo(0.0f);
        }];
        
        label;
    });
    self.markLabel = markLabel;
    self.markLabel.mas_key = @"markLabel";
    
    UILabel *titleLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:FONT_PINGFANG_REGULAR(16)];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(markLabel.mas_right).offset(margin*0.5f);
            make.right.equalTo(self.contentView.mas_right).offset(-margin*0.5f);
            
        }];
        
        label;
    });
    self.titleLabel = titleLabel;
    self.titleLabel.mas_key = @"titleLabel";
    
    UIView *separatorLineView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_GAME_MENU_SEPARATOR_LINE];
        [self.contentView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_bottom).offset(-HEIGHT_GAME_MENU_SEPARATOR_LINE);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(HEIGHT_GAME_MENU_SEPARATOR_LINE);
        }];
        
        view;
    });
    self.separatorLineView = separatorLineView;
    self.separatorLineView.mas_key = @"separatorLineView";
}

- (void)setModel:(FYGamesClassMenuModel *)model
{
    if (![model isKindOfClass:[FYGamesClassMenuModel class]]) {
        return;
    }
    
    _model = model;

    [self.titleLabel setText:model.showName];
    
    if (!model.isSelected) {
        if (self.model.isHotGame) {
            [self.titleLabel setTextColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
        } else {
            [self.titleLabel setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        }
        [self.titleLabel setFont:FONT_PINGFANG_REGULAR(16)];
        [self.markLabel setBackgroundColor:COLOR_GAME_CLASS_MENU_BACKGROUND];
    } else {
        [self.titleLabel setFont:FONT_PINGFANG_SEMI_BOLD(16)];
        [self.titleLabel setTextColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
        [self.markLabel setBackgroundColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
    }
}

- (void)pressContentView:(UITapGestureRecognizer *)gesture
{
    if (self.model.isSelected) {
        return;
    }
    
    [self.titleLabel setFont:FONT_PINGFANG_SEMI_BOLD(16)];
    [self.titleLabel setTextColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
    [self.markLabel setBackgroundColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtGamesClassMenuModel:indexPath:)]) {
        [self.delegate didSelectRowAtGamesClassMenuModel:self.model indexPath:self.indexPath];
    }
}


@end

