//
//  AllUserViewController.h
//  Project
//
//  Created by mini on 2018/8/16.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "FYBaseCoreViewController.h"

// 群成员控制器
@interface AllUserViewController : FYBaseCoreViewController

// 群ID
@property (nonatomic,copy) NSString *groupId;
@property (nonatomic,assign) BOOL isDelete;

+ (AllUserViewController *)allUser:(id)obj;

@end
