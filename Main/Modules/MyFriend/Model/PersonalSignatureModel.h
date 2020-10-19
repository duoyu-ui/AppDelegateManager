//
//  MyFriendMessageListModel.h
//  Project
//
//  Created by Mike on 2019/6/27.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonalSignatureItem : NSObject

/// 聊天会话id
@property (nonatomic, copy) NSString     *chatId;
@property (nonatomic, copy) NSString     *avatar;
@property (nonatomic, copy) NSString     *friendNick;
@property (nonatomic, copy) NSString     *nick;
@property (nonatomic, copy) NSString     *userId;
@property (nonatomic, copy) NSString     *mobile;
@property (nonatomic, assign) NSInteger  relation;
@property (nonatomic, assign) BOOL  isFriend;

@end

@interface PersonalSignatureModel : NSObject

@property (nonatomic, strong) PersonalSignatureItem     *data;
@property (nonatomic, copy) NSString     *alterMsg;
@property (nonatomic, copy) NSString     *code;
@property (nonatomic, copy) NSString     *errorcode;
@property (nonatomic, copy) NSString     *msg;
@end

NS_ASSUME_NONNULL_END
