//
//  FYGamesClassContent2QPTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/20.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesClassContent2QPTableViewCell.h"
#import "FYGamesClassContent2QPModel.h"

// Cell Identifier
NSString * const CELL_IDENTIFIER_GAMES_CLASS_CONTENT_2_QIPAI = @"FYGamesClassContent2QPTableViewCellIdentifier";

@interface FYGamesClassContent2QPTableViewCell ()
// 图片
@property (nonatomic, strong) UIImageView *iconImageView;
// 标题
@property (nonatomic, strong) UILabel *titleLabel;
// 内容
@property (nonatomic, strong) UILabel *contentLabel;
// 进入
@property (nonatomic, strong) UILabel *detailBtnLabel;
// 分割线
@property (nonatomic, strong) UIView *separatorLineView;

@end

@implementation FYGamesClassContent2QPTableViewCell

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
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *iconImageView = ({
        CGFloat imageSize = GAMES_MALL_CONTENT_CELL_HEIGHT * 0.7;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageSize, imageSize)];
        [self.contentView addSubview:imageView];
        [imageView addCornerRadius:imageSize*0.1f];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];

        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(margin*1.75f);
            make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
        }];
        
        imageView;
    });
    self.iconImageView = iconImageView;
    self.iconImageView.mas_key = @"iconImageView";
    
    UILabel *detailBtnLabel = ({
        NSString *text = NSLocalizedString(@"进入", nil);
        UIFont *font = FONT_PINGFANG_SEMI_BOLD(16);
        CGFloat height = [text heightWithFont:font constrainedToWidth:CGFLOAT_MAX]+margin*0.7f;
        CGFloat width = height*2.6f;
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setText:text];
        [label addCornerRadius:height*0.5f];
        [label setFont:font];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:COLOR_HEXSTRING(@"#F6F6F6")];
        [label addBorderWithColor:COLOR_HEXSTRING(@"#DDDDDD") cornerRadius:height*0.5f andWidth:0.5f];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-margin*1.0f);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
        
        label;
    });
    self.detailBtnLabel = detailBtnLabel;
    self.detailBtnLabel.mas_key = @"detailBtnLabel";
    
    UILabel *titleLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:FONT_PINGFANG_REGULAR(16)];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(iconImageView.mas_centerY);
            make.left.equalTo(iconImageView.mas_right).offset(margin*0.6f);
            make.right.equalTo(detailBtnLabel.mas_left).offset(-margin*0.8f);
        }];
        
        label;
    });
    self.titleLabel = titleLabel;
    self.titleLabel.mas_key = @"titleLabel";
    
    UILabel *contentLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:FONT_PINGFANG_LIGHT(13)];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
        [label setTextAlignment:NSTextAlignmentLeft];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(margin*0.5f);
            make.left.equalTo(titleLabel.mas_left);
            make.right.equalTo(titleLabel.mas_right);
        }];
        
        label;
    });
    self.contentLabel = contentLabel;
    self.contentLabel.mas_key = @"contentLabel";
    
    UIView *separatorLineView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_GAME_CONTENT_SEPARATOR_LINE];
        [self.contentView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_bottom).offset(-HEIGHT_GAME_CONTENT_SEPARATOR_LINE);
            make.left.equalTo(titleLabel.mas_left);
            make.right.equalTo(detailBtnLabel.mas_right);
            make.height.mas_equalTo(HEIGHT_GAME_CONTENT_SEPARATOR_LINE);
        }];
        
        view;
    });
    self.separatorLineView = separatorLineView;
    self.separatorLineView.mas_key = @"separatorLineView";
}

- (void)setModel:(FYGamesClassContent2QPModel *)model
{
    if (![model isKindOfClass:[FYGamesClassContent2QPModel class]]) {
        return;
    }
    
    _model = model;

    [self.titleLabel setText:model.gameName];
    [self.contentLabel setText:model.descriptionMsg];
    
    // 1显示 2隐藏 3维护
    if (3 == model.menuGameFlag.integerValue) {
        [self.detailBtnLabel setText:NSLocalizedString(@"维护", nil)];
        [self.detailBtnLabel setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
    } else {
        [self.detailBtnLabel setText:NSLocalizedString(@"进入", nil)];
        [self.detailBtnLabel setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
    }
    
    if ([CFCSysUtil validateStringUrl:model.imageUrl]) {
        __block UIActivityIndicatorView *activityIndicator = nil;
        UIImage *placeholderImage = [UIImage imageNamed:ICON_GAMES_CENTER_CONTENT_PLACEHOLDER];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (!activityIndicator) {
                    [self.iconImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]];
                    [activityIndicator setColor:COLOR_ACTIVITY_INDICATOR_BACKGROUND];
                    [activityIndicator setCenter:self.iconImageView.center];
                    [activityIndicator startAnimating];
                    [activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.iconImageView.mas_centerX);
                        make.centerY.equalTo(self.iconImageView.mas_centerY);
                    }];
                }
            }];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
        }];
    } else if (!VALIDATE_STRING_EMPTY(model.imageUrl) && [UIImage imageNamed:model.imageUrl]) {
        [self.iconImageView setImage:[UIImage imageNamed:model.imageUrl]];
    } else {
        [self.iconImageView setImage:[UIImage imageNamed:ICON_GAMES_CENTER_CONTENT_PLACEHOLDER]];
    }
}

- (void)pressContentView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtGamesClassContent2QPModel:indexPath:)]) {
        [self.delegate didSelectRowAtGamesClassContent2QPModel:self.model indexPath:self.indexPath];
    }
}


@end

