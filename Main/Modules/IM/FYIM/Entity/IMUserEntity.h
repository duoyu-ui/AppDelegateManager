//
//  IMUserEntity.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/27.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 通讯录数据类型
typedef NS_ENUM(NSInteger, IMUserEntityFriendType){
    IMUserEntityFriendService = 0,  // 客服
    IMUserEntityFriendSuperior = 1, // 我的上级（邀请我的好友）
    IMUserEntityFriendSubordinate = 2, // 我的下级（我邀请的好友）
    IMUserEntityFriendRegularFriends = 3, // 普通朋友
};

/**
 * 客服和好友实体
 */
@interface IMUserEntity : NSObject

@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *chatId; // 会话sessionid
@property (nonatomic, copy) NSString *personalSignature;
@property (nonatomic, copy) NSString *friendNick;
@property (nonatomic, assign) int status; // 0:离线，1:在线
@property (nonatomic, assign) BOOL isFriend; // YES:朋友 NO:其它

/**
 * 0 == 客服  1 == 好友
 */
@property (nonatomic, assign) int type;

/**
 * 0==我的客服 1 == 我的上级（邀请我的好友）2 == 我的下级（我邀请的好友）3 == 普通朋友
 */
@property (nonatomic, assign) IMUserEntityFriendType friendType;


@end

NS_ASSUME_NONNULL_END
