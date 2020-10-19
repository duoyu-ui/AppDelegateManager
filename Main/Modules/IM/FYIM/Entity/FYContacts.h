//
//  Contacts.h
//  Project
//
//  Created by Mike on 2019/6/20.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FYStatusDefine.h"

/**
 * 会话entity
 */
@interface FYContacts : NSObject <NSCoding>

/// 群组ID  或  用户ID
@property (nonatomic, copy) NSString     *id;
@property (nonatomic, copy) NSString     *sessionId;
@property (nonatomic, copy) NSString     *userId;
@property (nonatomic, copy) NSString     *nick;
@property (nonatomic, copy) NSString     *avatar;
@property (nonatomic, copy) NSString     *name;
@property (nonatomic, copy) NSString     *remarkName;
@property (nonatomic, copy) NSString     *friendNick;
@property (nonatomic, assign) BOOL isFriend;

/// 用户userId
@property (nonatomic, copy) NSString  *accountUserId;

/// 会话状态 ：0 == 离线  1 == 在线
@property (nonatomic, assign) int status;

/// 扩展消息类型  ：1-官方群，2-自建群，3-客服，4-好友
@property (nonatomic, assign) FYMessageExtype messageType;

/// 会话类型
@property (nonatomic, assign) FYChatConversationType sessionType;

/// 未读消息数
@property (nonatomic, assign) NSInteger unReadMsgCount;

@property (nonatomic, assign) NSInteger sectionNumber;
@property (nonatomic, assign) BOOL    isTopChat; // 是否顶置聊天
@property (nonatomic, strong) NSDate  *isTopTime; // 顶置聊天操作时间

@property (nonatomic, assign) NSTimeInterval lastTimestamp; // 最后一条消息发送时间
@property (nonatomic, strong) NSDate    *lastCreate_time;
@property (nonatomic, copy) NSString    *lastMessageId;
@property (nonatomic, copy) NSString    *lastMessage;

/// 备用字段1
@property (nonatomic, copy)  NSString *FieldOne;

/// 备用字段2
@property (nonatomic, copy)  NSString *FieldTwo;


- (id)initWithPropertiesDictionary:(NSDictionary *)dict;

@end

