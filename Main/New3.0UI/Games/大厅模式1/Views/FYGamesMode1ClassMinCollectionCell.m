//
//  FYGamesMode1ClassMinCollectionCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesMode1ClassMinCollectionCell.h"
#import "FYGamesMode1ClassModel.h"

@interface FYGamesMode1ClassMinCollectionCell ()
@property (nonnull, nonatomic, strong) UIImageView *iconImageView;
@property (nonnull, nonatomic, strong) UILabel *titleLabel;
@end

@implementation FYGamesMode1ClassMinCollectionCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self createViewAtuoLayout];
    }
    return self;
}

- (void) createViewAtuoLayout
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    
    // 图片控件
    UIImageView *iconImageView = ({
        CGFloat imageSize = self.width * 0.7f;
        UIImageView *imageView = [UIImageView new];
        [self.contentView addSubview:imageView];
        [imageView addCornerRadius:imageSize*0.1f];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(imageSize,imageSize));
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.centerY.equalTo(self.contentView.mas_bottom).multipliedBy(0.45f);
        }];
        
        imageView;
    });
    self.iconImageView = iconImageView;
    self.iconImageView.mas_key = [NSString stringWithFormat:@"iconImageView"];
    
    // 标题控件
    UILabel *titleLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:FONT_PINGFANG_REGULAR(14)];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(iconImageView.mas_bottom).offset(margin*0.5f);
        }];
        
        label;
    });
    self.titleLabel = titleLabel;
    self.titleLabel.mas_key = @"titleLabel";
}

- (void)setModel:(FYGamesMode1ClassModel *)model
{
    if (![model isKindOfClass:[FYGamesMode1ClassModel class]]) {
        return;
    }
    
    _model = (FYGamesMode1ClassModel *)model;
    
    [self.titleLabel setText:self.model.showName];

    if ([CFCSysUtil validateStringUrl:model.minIcon]) {
        __block UIActivityIndicatorView *activityIndicator = nil;
        UIImage *placeholderImage = [UIImage imageNamed:ICON_GAMES_CENTER_CONTENT_PLACEHOLDER];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.minIcon] placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
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
    } else if (!VALIDATE_STRING_EMPTY(model.minIcon) && [UIImage imageNamed:model.minIcon]) {
        [self.iconImageView setImage:[UIImage imageNamed:model.minIcon]];
    } else {
        [self.iconImageView setImage:[UIImage imageNamed:ICON_GAMES_CENTER_CONTENT_PLACEHOLDER]];
    }
}


@end

