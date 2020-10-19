//
//  FYSettingRedPaperHeader2.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/20.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "FYSettingRedPaperHeader2.h"

@interface FYSettingRedPaperHeader2()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subtitleLab;

@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation FYSettingRedPaperHeader2


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.subtitleLab];
        [self addSubview:self.rightLabel];
        [self addSubview:self.lineView];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(12);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.right.equalTo(self);
            make.height.equalTo(@0.7);
        }];
        
        [self.subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lineView.mas_bottom).offset(12);
            make.left.equalTo(self.titleLabel);
        }];
        
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel);
            make.right.equalTo(self).offset(-12);
        }];
    }
    return self;
}

#pragma mark - Setter public

- (void)setPacketNum:(NSString *)packetNum {
    _packetNum = packetNum;
    
    _rightLabel.text = packetNum;
}

#pragma mark - Getter private

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = NSLocalizedString(@"发包数量", nil);
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLab {
    
    if (!_subtitleLab) {
        _subtitleLab = [[UILabel alloc] init];
        _subtitleLab.text = NSLocalizedString(@"发包金额范围", nil);
        _subtitleLab.font = [UIFont systemFontOfSize:15];
        _subtitleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _subtitleLab;
}

- (UILabel *)rightLabel {
    
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.text = @"-";
        _rightLabel.font = [UIFont systemFontOfSize:15];
        _rightLabel.textColor = [UIColor colorWithHexString:@"#808080"];
    }
    return _rightLabel;
}

- (UIView *)lineView {
    
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#ebebeb"];
    }
    return _lineView;
}

@end
