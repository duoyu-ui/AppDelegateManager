//
//  AddGroupContactController.h
//  ProjectXZHB
//
//  Created by 汤姆 on 2019/7/30.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    /// 添加群成员
    ControllerType_add,
    /// 删除群成员
    ControllerType_delete
}ControllerType;

/**
 添加或者删除自建群的成员
 */
@interface AddGroupContactController : FYBaseCoreViewController

/**
 群id
 */
@property (nonatomic, copy) NSString *groupId;

/**
 群成员操作类型（添加、删除）
*/
@property (nonatomic, assign) ControllerType type;

@end


