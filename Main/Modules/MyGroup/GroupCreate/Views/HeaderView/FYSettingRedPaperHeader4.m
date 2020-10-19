//
//  FYSettingRedPaperHeader4.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/21.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "FYSettingRedPaperHeader4.h"

@implementation FYSettingRedPaperHeader4

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12);
            make.centerY.equalTo(self);
        }];
    }
    
    return self;
}


#pragma mark - Getter private

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = NSLocalizedString(@"发包金额范围", nil);
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _titleLabel;
}

@end
