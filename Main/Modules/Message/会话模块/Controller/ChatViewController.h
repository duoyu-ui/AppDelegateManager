//
//  ChatViewController.h
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "FYIMSessionViewController.h"
#import "FYContacts.h"

@interface ChatViewController : FYIMSessionViewController

/// 群聊
/// @param obj 会话记录
+ (ChatViewController *)groupChatWithObj:(MessageItem *)obj;

/// 单聊
/// @param model 会话记录
+ (ChatViewController *)privateChatWithModel:(FYContacts *)model;

/// 当前聊天
+ (ChatViewController *)currentChat;

/// 是否是新成员
@property (nonatomic,assign) BOOL isNewMember;

/// 是否返回主页
@property (nonatomic,assign) BOOL isBackToRootVC;


@end

