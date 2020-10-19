//
//  FYContactsModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "IMUserEntity.h"

NS_ASSUME_NONNULL_BEGIN

// 通讯录本地类型
typedef NS_ENUM(NSInteger, FYContactsLocalType){
    FYContactsLocalTypeServices = 0, // 在线客服
    FYContactsLocalTypeMyNewFriends = 1, // 新的朋友
    FYContactsLocalTypeMyJoinGroups = 2, // 我的群组
    FYContactsLocalTypeSystemMessage = 3 // 系统消息
};

@interface FYContactsModel : IMUserEntity

@property (nonatomic, assign) BOOL isLocal; // YES:本地，NO:远程
@property (nonatomic, assign) FYContactsLocalType localType; // 通讯录本地类型

/// 本地客服
+ (FYContactsModel *) buildingDataModleForCustomerService;

/// 系统消息
+ (FYContactsModel *) buildingDataModleForSystemMessage;
+ (FYContactsModel *) buildingDataModleForSystemMessageWithSession:(FYContacts *)session;

@end

NS_ASSUME_NONNULL_END
