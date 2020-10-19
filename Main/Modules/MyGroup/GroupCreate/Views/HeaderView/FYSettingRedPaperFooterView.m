//
//  FYSettingRedPaperFooterView.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/20.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "FYSettingRedPaperFooterView.h"

@interface FYSettingRedPaperFooterView()

@property (nonatomic, strong) UIButton *doneButton;

@end

@implementation FYSettingRedPaperFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.doneButton];
        [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(42);
            make.right.equalTo(self).offset(-42);
            make.centerY.equalTo(self);
            make.height.equalTo(@42);
        }];
    }
    return self;
}


#pragma mark - Action

- (void)saveAction {
    if (self.didSaveBlock) {
        self.didSaveBlock();
    }
}

#pragma mark - Getter

- (UIButton *)doneButton {
    
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _doneButton.titleLabel.font = [UIFont boldSystemFontOfSize2:15];
        [_doneButton setTitle:NSLocalizedString(@"保存并返回", nil) forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _doneButton.backgroundColor = COLOR_SYSTEM_MAIN_BUTTON_BACKGROUND_SELECT_DEFAULT;
        _doneButton.layer.cornerRadius = 7;
        _doneButton.layer.masksToBounds = YES;
        [_doneButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}


@end
