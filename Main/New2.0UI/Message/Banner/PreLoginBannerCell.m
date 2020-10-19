//
//  PreLoginBannerCell.m
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/11/29.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "PreLoginBannerCell.h"
#import <SDWebImage.h>


@interface PreLoginBannerCell()

@property (nonatomic, strong) UIImageView *preloginImageView;

@end

@implementation PreLoginBannerCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addImageView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.backgroundColor = [UIColor clearColor];
        [self addImageView];
    }
    return self;
}

- (void)addImageView {
    self.preloginImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.preloginImageView];
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    
    [self.preloginImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                           placeholderImage:[UIImage imageNamed:@"icon_loading_1010_260"]];
}

@end


