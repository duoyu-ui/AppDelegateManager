//
//  FYContactsModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYContactsModel.h"

@implementation FYContactsModel

+ (FYContactsModel *) buildingDataModleForCustomerService
{
    FYContactsModel *model = [[FYContactsModel alloc] init];
    [model setNick:NSLocalizedString(@"在线客服", nil)];
    [model setFriendNick:NSLocalizedString(@"在线客服", nil)];
    [model setAvatar:@"onlineServiceMsgicon"];
    [model setPersonalSignature:NSLocalizedString(@"有问题 找客服", nil)];
    [model setType:0]; // 0:客服，1:好友
    [model setIsFriend:NO];
    [model setFriendType:IMUserEntityFriendService];
    //
    [model setIsLocal:YES]; // YES:本地，NO:远程
    [model setLocalType:FYContactsLocalTypeServices];
    
    return model;
}

+ (FYContactsModel *) buildingDataModleForSystemMessage
{
    FYContactsModel *model = [[FYContactsModel alloc] init];
    [model setNick:NSLocalizedString(@"系统消息", nil)];
    [model setFriendNick:NSLocalizedString(@"系统消息", nil)];
    [model setAvatar:@"systemMessageIcon"];
    [model setPersonalSignature:NSLocalizedString(@"暂无消息", nil)];
    [model setType:0]; // 0:客服，1:好友
    [model setIsFriend:NO];
    [model setFriendType:IMUserEntityFriendService];
    //
    [model setUserId:[AppModel shareInstance].userInfo.userId];
    [model setChatId:[FYSysMsgNoticeEntity reuseChatSysMsgNoticeSessionId]];  // 会话 sessionid
    //
    [model setIsLocal:YES]; // YES:本地，NO:远程
    [model setLocalType:FYContactsLocalTypeSystemMessage];
    
    return model;
}

+ (FYContactsModel *) buildingDataModleForSystemMessageWithSession:(FYContacts *)session
{
    FYContactsModel *model = [[self class] buildingDataModleForSystemMessage];
    if (session) {
        [model setPersonalSignature:session.lastMessage];
    }
    return model;
}


@end

