//
//  FYMobileContactInformation.h
//  ProjectCSHB
//
//  Created by Tom on 2020/5/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYMobileContactInformation : NSObject
@property (nonatomic, copy) NSString *familyName;
@property (nonatomic, copy) NSString *givenName;
@property (nonatomic, copy) NSString *phoneNumber;
@end

@interface FYContactMainModel : NSObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *chatId;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *personalSignature;
@property (nonatomic, assign) NSInteger status;//0:离线，1:在线
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) NSInteger type;// 0:客服，1:好友
@property (nonatomic, assign) NSInteger friendType;//0:我邀请的好友，1:邀请我的好友
@property (nonatomic, copy) NSString *friendNick;
@end

@interface FYContactSimpleModel : NSObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *chatId;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *personalSignature;
@property (nonatomic, assign) NSInteger status;//0:离线，1:在线
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) NSInteger type;// 0:客服，1:好友
@property (nonatomic, assign) NSInteger friendType;//0:我邀请的好友，1:邀请我的好友
@property (nonatomic, copy) NSString *friendNick;
@end

@interface FYInviteFriendModel : NSObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *inviteUserId;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) NSInteger opFlag;
/*
 {
     "avatar": "dsasa",
     "createTime": "2020-05-25 10:41:25",
     "id": 1,
     "inviteUserId": 6192,
     "message": "撒大大",
     "nick": "哇大师",
     "opFlag": 0,
     "updateTime": "2020-05-25 10:41:25",
     "userId": 6169
 }
 */
@end

NS_ASSUME_NONNULL_END
