//
//  FYContactSectionModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYContactSectionModel.h"
#import "FYContactsModel.h"

@implementation FYContactSectionModel


+ (FYContactSectionModel *) buildingDataModleForFunction
{
    NSMutableArray<FYContactsModel *> *contacts = [NSMutableArray array];
    {
        {
            FYContactsModel *model = [[FYContactsModel alloc] init];
            [model setNick:NSLocalizedString(@"新的朋友", nil)];
            [model setFriendNick:NSLocalizedString(@"新的朋友", nil)];
            [model setAvatar:@"icon_new_friends"];
            [model setPersonalSignature:@""];
            [model setType:0]; // 0:客服，1:好友
            [model setIsFriend:NO];
            [model setFriendType:IMUserEntityFriendService];
            //
            [model setIsLocal:YES];
            [model setLocalType:FYContactsLocalTypeMyNewFriends];
            //
            [contacts addObj:model];
        }
        {
            FYContactsModel *model = [[FYContactsModel alloc] init];
            [model setNick:NSLocalizedString(@"我的群组", nil)];
            [model setFriendNick:NSLocalizedString(@"我的群组", nil)];
            [model setAvatar:@"icon_mygroup"];
            [model setPersonalSignature:@""];
            [model setType:0]; // 0:客服，1:好友
            [model setIsFriend:NO];
            [model setFriendType:IMUserEntityFriendService];
            //
            [model setIsLocal:YES];
            [model setLocalType:FYContactsLocalTypeMyJoinGroups];
            //
            [contacts addObj:model];
        }
    }
    
    FYContactSectionModel *sectionModel = [[FYContactSectionModel alloc] init];
    [sectionModel setTitle:NSLocalizedString(@"功能", nil)];
    [sectionModel setContacts:contacts];
    
    return sectionModel;
}

+ (FYContactSectionModel *) buildingDataModleForCustomerService
{
    NSMutableArray<FYContactsModel *> *contacts = [NSMutableArray array];
    
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
        //
        [contacts addObj:model];
    }
    
    {
        NSArray<IMUserEntity *> *allServiceEntities = [[IMContactsModule sharedInstance] getAllServices];
        NSArray<NSDictionary *> *arrayOfDicts = [IMUserEntity mj_keyValuesArrayWithObjectArray:allServiceEntities];
        NSMutableArray<FYContactsModel *> *serviceModels = [FYContactsModel mj_objectArrayWithKeyValuesArray:arrayOfDicts];
        [contacts addObjectsFromArray:serviceModels];
    }
    
    FYContactSectionModel *sectionModel = [[FYContactSectionModel alloc] init];
    [sectionModel setTitle:NSLocalizedString(@"客服", nil)];
    [sectionModel setContacts:contacts];
    
    return sectionModel;
}



@end
