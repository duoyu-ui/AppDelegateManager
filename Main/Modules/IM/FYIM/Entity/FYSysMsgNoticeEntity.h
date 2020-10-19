//
//  FYSysMsgNoticeEntity.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/3.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYSysMsgNoticeEntity : NSObject <NSCoding>

@property (nonatomic, copy) NSString     *sessionId;
@property (nonatomic, copy) NSString     *accountUserId; /// 用户userId
@property (nonatomic, assign) NSInteger  unReadMsgCount; /// 未读消息数

// 会话实体数据模型<这些值设置为本地固定不变的>
@property (nonatomic, copy) NSString     *userId;
@property (nonatomic, copy) NSString     *nick;
@property (nonatomic, copy) NSString     *avatar;
@property (nonatomic, copy) NSString     *remarkName;
@property (nonatomic, copy) NSString     *friendNick;
@property (nonatomic, copy) NSString     *personalSignature;
@property (nonatomic, assign) BOOL       isFriend; // YES:朋友 NO:其它

// 系统消息或新闻公告数据内容
@property (nonatomic, copy) NSString            *title;
@property (nonatomic, copy) NSString            *content;
@property (nonatomic, copy) NSString            *releaseTime;
@property (nonatomic, copy) NSString            *lastUpdateTime;
@property (nonatomic, copy) NSString            *createTime;
@property (nonatomic, assign) NSInteger         Id;
@property (nonatomic, assign) NSInteger         stickFlag;
@property (nonatomic, assign) NSInteger         noticeType; // 0:系统 1:平台
@property (nonatomic, assign) BOOL              delFlag;
@property (nonatomic, assign) BOOL              releaseFlag;

/// 是否已读
@property (nonatomic, assign) BOOL isRead;

+ (NSString *)reuseChatSysMsgNoticeSessionId; /// 系统消息或通知公告唯一标识

+ (NSMutableArray<FYSysMsgNoticeEntity *> *) buildingDataModles:(NSArray<NSDictionary *> *)arrayOfDicts;

@end

NS_ASSUME_NONNULL_END
