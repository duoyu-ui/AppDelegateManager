//
//  GroupInfoViewController.h
//  Project
//
//  Created by mini on 2018/8/9.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "FYBaseCoreViewController.h"
@class FYCreateRequest;

typedef void (^GroupInfoBlock)(NSString *text);
typedef void (^GroupInfoChngedBlock)(FYCreateRequest *result);

@interface GroupInfoViewController : FYBaseCoreViewController

@property (nonatomic, copy) GroupInfoBlock block;

/// 群信息修改
@property (nonatomic, copy) GroupInfoChngedBlock changedInfoBlock;

+ (GroupInfoViewController *)groupVc:(MessageItem *)obj;

@end
