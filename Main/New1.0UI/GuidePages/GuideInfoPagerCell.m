//
//  GuideInfoPagerCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/12/23.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "GuideInfoPagerCell.h"

@interface GuideInfoPagerCell()

@property (nonatomic, strong) UIImageView *guideImageView;

@end

@implementation GuideInfoPagerCell

- (UIImageView *)guideImageView {
    
    if (!_guideImageView) {
        
        _guideImageView = [[UIImageView alloc] init];
    }
    return _guideImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self setupSubview];
    }
    
    return self;
}


- (void)setupSubview {
    
    [self.contentView addSubview:self.guideImageView];
    [self.guideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (kIs_iPhoneX) {
            make.top.equalTo(self.contentView).offset(SafeAreaTop_Height);
            make.bottom.equalTo(self.contentView).offset(-kBottomSafeHeight);
        }else {
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }
        make.width.equalTo(self.contentView);
    }];
}


#pragma mark - Public setter

- (void)setImage:(NSString *)image {
    _image = image;
    
    self.guideImageView.image = [UIImage imageNamed:image];
}

@end
