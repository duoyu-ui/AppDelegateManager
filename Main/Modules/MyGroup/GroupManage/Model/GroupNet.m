//
//  GroupNet.m
//  Project
//
//  Created by mini on 2018/8/16.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "GroupNet.h"
//#import "BANetManager_OC.h"

@implementation GroupNet

-(instancetype)init {
    self = [super init];
    if (self) {
        _dataList = [[NSMutableArray alloc]init];
        _page = 1;
        _pageSize = 15;
        _isMost = NO;
        _isEmpty = NO;
    }
    return self;
}

/// 群组禁言
/// @param groupId 群ID
/// @param successBlock 成功block
/// @param failureBlock 失败block
- (void)stopSpeakGroupUserGroupId:(NSString *)groupId
                     successBlock:(void (^)(NSDictionary *))successBlock
                     failureBlock:(void (^)(NSError *))failureBlock {
    
    NSMutableDictionary *queryParamDict = [[NSMutableDictionary alloc] init];
    if (groupId.length == 0) {
        groupId = @"";
    }
    [queryParamDict setObject:groupId forKey:@"groupId"];
    
    __weak __typeof(self)weakSelf = self;
    [NET_REQUEST_MANAGER skChatGroupStop:queryParamDict successBlock:^(NSDictionary *response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf processingData:response];
        successBlock(response);
    } failureBlock:^(NSError *error) {
        failureBlock(error);
    }];
}


/// 群组禁图
/// @param groupId 群ID
/// @param successBlock 成功block
/// @param failureBlock 失败block
- (void)stopPicGroupUserGroupId:(NSString *)groupId
                   successBlock:(void (^)(NSDictionary *))successBlock
                   failureBlock:(void (^)(NSError *))failureBlock {
    
    NSMutableDictionary *queryParamDict = [[NSMutableDictionary alloc] init];
    if (groupId.length == 0) {
        groupId = @"";
    }
    
    [queryParamDict setObject:groupId forKey:@"id"];

    __weak __typeof(self)weakSelf = self;
    [NET_REQUEST_MANAGER groupStopPic:queryParamDict successBlock:^(NSDictionary *response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf processingData:response];
        successBlock(response);
    } failureBlock:^(NSError *error) {
        failureBlock(error);
    }];
}

/**
 查询群成员
 
 @param groupId 群ID
 @param successBlock 成功block
 @param failureBlock 失败block
 */
- (void)queryGroupUserGroupId:(NSString *)groupId
                 successBlock:(void (^)(NSDictionary *))successBlock
                 failureBlock:(void (^)(NSError *))failureBlock {
    
    NSMutableDictionary *queryParamDict = [[NSMutableDictionary alloc] init];
    if (groupId.length == 0) {
        groupId = @"";
    }
    [queryParamDict setObject:groupId forKey:@"id"];  
    
    NSDictionary *parameters = @{
                                 @"size":@(self.pageSize),
                                 @"sort":@"id",
                                 @"isAsc":@"true",
                                 @"current":@(self.page),
                                 @"queryParam":queryParamDict
                                 };
    
    __weak __typeof(self)weakSelf = self;
    [NET_REQUEST_MANAGER searchGroupUsers:parameters successBlock:^(NSDictionary *response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf processingData:response];
        successBlock(response);
    } failureBlock:^(NSError *error) {
        failureBlock(error);
    }];
}

- (void)dissolveGroupWithID:(NSString *)groupId isOfficeFlag:(BOOL)isOfficeFlag isGroupManager:(BOOL)isGroupManager successBlock:(void (^)(NSDictionary *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSDictionary *parameters = nil;
    if (isOfficeFlag) {//退出群,解散群
        [NET_REQUEST_MANAGER getChatGroupQuitWithGroupId:groupId success:^(id response) {
            successBlock(response);
        } fail:^(id error) {
            failureBlock(error);
        }];
        return;
    } else {//自建群
        if (isGroupManager) {//群主解散群
            parameters = @{
                           @"chatGroupId":groupId,
                           @"userId": AppModel.shareInstance.userInfo.userId
                           };
            [NET_REQUEST_MANAGER delGroup:parameters successBlock:^(NSDictionary *response) {
                successBlock(response);
            } failureBlock:^(NSError *error) {
                failureBlock(error);
            }];
        }else {
            [NET_REQUEST_MANAGER getChatGroupQuitWithGroupId:groupId success:^(id response) {
                successBlock(response);
            } fail:^(id error) {
                failureBlock(error);
            }];
        }
    }
}


- (void)getGroupMemberWithUserID:(NSString *)userId groupId:(NSString *)groupId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize successBlock:(void (^)(NSDictionary *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSDictionary *parameters = nil;
    parameters = @{
                   @"queryParam": @{
                           @"id": groupId,
                           @"userIdOrNick": userId
                           },
                   @"current": @(pageIndex),
                   @"size": @(pageSize)
                   };
    
    [NET_REQUEST_MANAGER queryGroupUsers:parameters successBlock:^(NSDictionary *response) {
        
        successBlock(response);
        
    } failureBlock:^(NSError *error) {
        
        failureBlock(error);
    }];
}

- (void)deleteGroupMembersWithGroupId:(NSString *)grupId userIds:(NSArray *)array successBlock:(void (^)(NSDictionary *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSDictionary *parameters = [NSDictionary new];
    parameters = @{
                   @"chatGroupId": grupId,
                   @"userId":array
                   };
    
    [NET_REQUEST_MANAGER delgroupMember:parameters successBlock:^(NSDictionary *response) {
        
        successBlock(response);
        
    } failureBlock:^(NSError *(error)) {
        
        failureBlock(error);
    }];
}

- (void)processingData:(NSDictionary *)response {
    if (CD_Success([response objectForKey:@"code"], 0)) {
        NSDictionary *data = [response objectForKey:@"data"];
        if (data != NULL) {
            if (self.page == 1) {
                [self.dataList removeAllObjects];
            }
            
            self.total = [[data objectForKey:@"total"]integerValue];
            
//            if(self.groupNum > 0) {
//                self.total += self.groupNum;
//            }  
            NSArray *list = [data objectForKey:@"records"];
            for (id obj in list) {
                if([obj isKindOfClass:[NSNull class]]){
                    [self.dataList addObject:@{}];
                }else
                    [self.dataList addObject:obj];
            }
            self.isEmpty = (self.dataList.count == 0)?YES:NO;
            self.isMost = ((self.dataList.count % self.pageSize == 0)&(list.count>0))?NO:YES;
        }
        
    }
}

@end
