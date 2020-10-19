//
//  CreateGroupInfoCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/19.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYCreateGroupModel.h"

typedef void(^DidSwitchChangedBlock)(void);
typedef void(^DidSwitchChangedIsOnBlock)(BOOL isOn);
typedef void(^DidTextFiledEndBlock)(NSString * _Nonnull text);

NS_ASSUME_NONNULL_BEGIN

@interface CreateGroupInfoCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, copy) DidSwitchChangedBlock switchChangedBlock;
@property (nonatomic, copy) DidSwitchChangedIsOnBlock switchChangedIsOnBlock;
@property (nonatomic, copy) DidTextFiledEndBlock textEditEndBlock;
@property (nonatomic, strong) FYCreateGroupModel *model;
@property (nonatomic, assign) BOOL isRate;

/// 左边标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 右边标题
@property (nonatomic, strong) UILabel *subtitleLab;
/// 右边箭头指示
@property (nonatomic, strong) UIImageView *arrowView;
/// 开关状态
@property (nonatomic, strong) UISwitch *switchView;
/// 输入框
@property (nonatomic, strong) UITextField *textField;

@end

NS_ASSUME_NONNULL_END
