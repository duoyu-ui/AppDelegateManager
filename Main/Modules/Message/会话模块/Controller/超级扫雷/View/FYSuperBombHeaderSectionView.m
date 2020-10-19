//
//  FYSuperBombHeaderSectionView.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/11/7.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "FYSuperBombHeaderSectionView.h"
#import "FYSuperBombAttrModel.h"

@interface FYSuperBombHeaderSectionView()<UITextFieldDelegate>
@property (nonatomic , strong) UIView *bgView;
@property (nonatomic, strong) UILabel *unitLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextField *textField;

@end

@implementation FYSuperBombHeaderSectionView

#pragma mark - life cycle

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = HexColor(@"#EDEDED");
//        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self setupSubview];
    }
    return self;
}

- (void)setupSubview {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.textField];
    [self.bgView addSubview:self.unitLabel];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 60, 55));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(12);
        make.centerY.equalTo(self.bgView);
    }];
    
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-12);
        make.centerY.equalTo(self.bgView);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.unitLabel.mas_left).offset(-15);
        make.centerY.equalTo(self.bgView);
        make.width.equalTo(@140);
        make.height.equalTo(@36);
    }];
}

#pragma mark - setter

- (void)setModel:(FYSuperBombAttrModel *)model {
    _model = model;
    
    if (model.minMoney.length && model.maxMoney.length) {
        self.textField.placeholder = [NSString stringWithFormat:@"%@ ~ %@", model.minMoney, model.maxMoney];
    }
}

#pragma mark - getter

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = NSLocalizedString(@"红包金额", nil);
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UILabel *)unitLabel {
    
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.text = NSLocalizedString(@"元", nil);
        _unitLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _unitLabel.font = [UIFont systemFontOfSize:15];
    }
    return _unitLabel;
}

- (UITextField *)textField {
    
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.textColor = [UIColor colorWithHexString:@"#333333"];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(topMoney:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 4;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
    
}
- (void)topMoney:(UITextField *)tf{
    NSString *money;
    if (tf.text == nil || [tf.text isEmpty]) {
        money = @"0";
    }else{
        money = tf.text;
    }
    if (self.didEditChangeBlock != nil) {
        self.didEditChangeBlock(money);
    }
}
#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.didEditBlock) {
        self.didEditBlock(textField.text);
    }
}

@end
