//
//  FYSettingRedPaperHeader1.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/20.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "FYSettingRedPaperHeader1.h"


@implementation FYSettingRedPaperHeader1


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.subtitleLab];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(12);
        }];
        
        [self.subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(4);
        }];
    }
    return self;
}

#pragma mark - Setter public

- (void)setModel:(FYCreateGroupModel *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    self.subtitleLab.text = model.subtitle;
}

#pragma mark - Getter private

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"-";
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLab {
    
    if (!_subtitleLab) {
        _subtitleLab = [[UILabel alloc] init];
        _subtitleLab.text = @"-";
        _subtitleLab.font = [UIFont systemFontOfSize:11];
        _subtitleLab.textColor = [UIColor colorWithHexString:@"#808080"];
    }
    return _subtitleLab;
}


@end
