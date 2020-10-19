//
//  FYIndexViewHeaderView.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYIndexViewHeaderView.h"


@interface FYIndexViewHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation FYIndexViewHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.frame = CGRectMake(15, 0, UIScreen.mainScreen.bounds.size.width - 15 * 2, 30);
    }
    return self;
}

+ (CGFloat)headerViewHeight
{
    return 30;
}

+ (NSString *)reuseID
{
    return NSStringFromClass(self);
}

- (void)configWithTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_PINGFANG_REGULAR(14);
        _titleLabel.textColor = COLOR_HEXSTRING(@"#9A9A9A");
    }
    return _titleLabel;
}

@end
