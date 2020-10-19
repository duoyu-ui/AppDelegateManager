//
//  FYNotificationConst.h
//  Project
//
//  Created by fangyuan on 2020/5/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#ifndef _FY_NOTIFICATION_CONST_MACRO_H_
#define _FY_NOTIFICATION_CONST_MACRO_H_

///获取微信登录返回的code
static NSString *const kNotificationWeixinAuthSuccess = @"kNotificationWeixinAuthSuccess";
static NSString *const kNotificationWeixinAuthCommon = @"kNotificationWeixinAuthCommon";
static NSString *const kNotificationWeixinAuthCancle = @"kNotificationWeixinAuthCancle";
static NSString *const kNotificationWeixinAuthSendFail = @"kNotificationWeixinAuthSendFail";
static NSString *const kNotificationWeixinAuthDeny = @"kNotificationWeixinAuthDeny";
static NSString *const kNotificationWeixinUnsupport = @"kNotificationWeixinUnsupport";


/// 余额实时变动
static NSString * const kNotificationUserInfoBalanceChange = @"kNotificationUserInfoBalanceChange";


/// 通知 -> 清空聊天内容
static NSString * const kNotificationClearChatRecordsContent = @"kNotificationClearChatRecordsContent";
/// 通知 -> 未读消息数有变更
static NSString * const kNotificationMsgUnreadMessageNumberChange = @"kUnreadMessageNumberChange";
/// 通知  -> 好友或客服的离线或上线消息
static NSString * const kNotificationUserOnOffStatusChange = @"kNotificationUserOnOffStatusChange";
/// 通知  -> 新好友申请
static NSString * const kNotificationNewFriendInvitation = @"kNotificationNewFriendInvitation";
/// 通知  -> 添加或删除好友
static NSString * const kNotificationAddOrDeleteFriend = @"kNotificationAddOrDeleteFriend";
/// 通知  -> 修改好友信息
static NSString * const kNotificationModifyFriendInfo = @"kNotificationModifyFriendInfo";
/// 通知 -> 刷新系统消息或通知公告（添加、删除、修改）
static NSString * const kNotificationSysMsgOrPlatformNoticeChange = @"kNotificationSysMsgOrPlatformNoticeChange";


/// 通知  -> 加入群、被踢出、被邀请到自建群
static NSString * const kNotificationJoinOrDeletedDidUserGroup = @"kAddOrDeleteDidUserGroup";
/// 通知  -> 创建或删除自建群
static NSString * const kNotificationCreateOrDeleteSelfGroup = @"kNotificationCreateOrDeleteSelfGroup";
/// 通知  -> 修改自建群信息（标题、公告）
static NSString * const kNotificationModifyUpdateGroupInfo = @"kNotificationModifyUpdateGroupInfo";

/// 通知 -> 游戏大厅显示模式切换
static NSString * const kNotificationAppConfigStyleModeChange = @"kNotificationAppConfigStyleModeChange";
/// 通知 -> 刷新游戏大厅通知
static NSString * const kNotificationReloadGamesMallList = @"kReloadGameMallList";
/// 通知 -> 游戏大厅通知
static NSString * const kNotificationGamesMallSDShowHide = @"sd_show_hide";
/// 通知 -> 牛牛消息
static NSString * const kNotificationGroupOfRobNiuNiuContent = @"robNiuNiuContent";

/// 通知 -> 群状态消息,用于包包彩投注界面倒计时
static NSString * const kNotificationGroupStatusMessage = @"kNotificationGroupStatusMessage";

/// 本地 - 余额宝转账金额变动
static NSString * const kNotificationYuEBaoTransferBalanceChange = @"kNotificationYuEBaoTransferBalanceChange";



#endif /* _FY_NOTIFICATION_CONST_MACRO_H_ */
