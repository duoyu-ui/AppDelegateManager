//
//  FYGamesMode1ClassMaxCollectionCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesMode1ClassMaxCollectionCell.h"
#import "FYGamesMode1ClassModel.h"

@interface FYGamesMode1ClassMaxCollectionCell ()
@property (nonnull, nonatomic, strong) UIImageView *iconImageView;
@end

@implementation FYGamesMode1ClassMaxCollectionCell

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
    UIImageView *iconImageView = ({
        UIImageView *imageView = [UIImageView new];
        [self.contentView addSubview:imageView];
        [imageView addCornerRadius:self.height*0.1f];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        imageView;
    });
    self.iconImageView = iconImageView;
    self.iconImageView.mas_key = [NSString stringWithFormat:@"iconImageView"];
}

- (void)setModel:(FYGamesMode1ClassModel *)model
{
    if (![model isKindOfClass:[FYGamesMode1ClassModel class]]) {
        return;
    }
    
    _model = (FYGamesMode1ClassModel *)model;
    
    if ([CFCSysUtil validateStringUrl:model.maxIcon]) {
        __block UIActivityIndicatorView *activityIndicator = nil;
        UIImage *placeholderImage = [UIImage imageNamed:ICON_GAMES_CENTER_CONTENT_MAX_PLACEHOLDER];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.maxIcon] placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
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
    } else if (!VALIDATE_STRING_EMPTY(model.maxIcon) && [UIImage imageNamed:model.maxIcon]) {
        [self.iconImageView setImage:[UIImage imageNamed:model.maxIcon]];
    } else {
        [self.iconImageView setImage:[UIImage imageNamed:ICON_GAMES_CENTER_CONTENT_MAX_PLACEHOLDER]];
    }
}


@end

