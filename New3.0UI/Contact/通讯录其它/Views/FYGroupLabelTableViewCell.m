//
//  FYGroupLabelTableViewCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/5/20.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGroupLabelTableViewCell.h"

@interface FYGroupLabelTableViewCell ()

@property (nonatomic, strong) UIButton *buttonTips;

@end


@implementation FYGroupLabelTableViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.buttonTips setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    }
    return self;
}

- (void)updateLabel:(NSString *)title
{
    [self.buttonTips setTitle:title forState:UIControlStateNormal];
    
    if ([title isEqualToString:NSLocalizedString(@"官方", nil)]) {
        self.buttonTips.layer.backgroundColor = COLOR_HEXSTRING(@"#1296DB").CGColor;
    } else if ([title isEqualToString:NSLocalizedString(@"自建", nil)]){
        self.buttonTips.layer.backgroundColor = COLOR_HEXSTRING(@"#15CD79").CGColor;
    }
}

- (UIButton *)buttonTips
{
    if (!_buttonTips) {
        _buttonTips=[UIButton new];
        _buttonTips.titleLabel.font = [UIFont systemFontOfSize:11];
        _buttonTips.layer.backgroundColor = [UIColor redColor].CGColor;
        [_buttonTips setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buttonTips.layer.cornerRadius = 2;
        [self.contentView addSubview:_buttonTips];
        [_buttonTips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.labelName.mas_right).mas_offset(5);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(18);
        }];
    }
    return _buttonTips;
}

@end

