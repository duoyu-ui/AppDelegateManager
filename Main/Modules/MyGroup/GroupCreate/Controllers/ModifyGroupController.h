//
//  ModifyGroupController.h
//  ProjectXZHB
//
//  Created by 汤姆 on 2019/7/28.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    ModifyGroupTypeMent,//公告
    ModifyGroupTypeName,//名字
} ModifyGroupType;

typedef void (^ModifyGroupBlock)(NSString *text);

@interface ModifyGroupController : FYBaseCoreViewController

/// 群信息/消息
@property (nonatomic, strong) MessageItem *groupInfo;
/// 文本内容
@property (nonatomic, copy) NSString *content;
/// 群ID
@property (nonatomic, copy) NSString *groupID;
/// 内容修改类型
@property (nonatomic, assign) ModifyGroupType type;
/// 是否是初次设置
@property (nonatomic, assign) BOOL isSetting;

@property (nonatomic, copy) ModifyGroupBlock modifyGroupBlock;

@property (nonatomic, assign) BOOL isGroupOwner;

@end

NS_ASSUME_NONNULL_END
