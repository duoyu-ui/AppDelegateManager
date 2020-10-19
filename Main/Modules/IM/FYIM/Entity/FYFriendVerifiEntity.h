//
//  FYFriendVerifiEntity.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/10.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 command:49
 code:10042
 msg
 data={
     userId   发起邀请的用户id
     avatar   发起邀请的用户头像
     nick     发起邀请的用户昵称
     opFlag   0发起邀请，1同意邀请 2删除
     message  申请信息
     remarks  好友备注信息
 }
 */

@interface FYFriendVerifiEntity : NSObject <NSCoding>

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, strong) NSNumber *opFlag;

+ (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
