//
//  FYFriendName.m
//  ProjectCSHB
//
//  Created by FangYuan on 2020/3/4.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYFriendName.h"

@interface FYFriendName ()
@property (nonatomic,strong) NSMutableDictionary *friendNames;
@end

@implementation FYFriendName

+ (instancetype)shareInstance
{
    static FYFriendName *tempStore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tempStore=[[[self class] alloc] init];
    });
    return tempStore;
}

+ (void)setName:(NSString *)name userID:(NSString *)userid
{
    [[FYFriendName shareInstance].friendNames setObject:name forKey:userid];
    [[FYFriendName shareInstance] saveFriends];
}

+ (NSString *)getName:(NSString *)userId
{
    if (userId == nil) {
        return @"";
    }
    
    NSString *key=userId;
    if (![key isKindOfClass:[NSString class]]) {
        key=[NSString stringWithFormat:@"%@",userId];
    }
    NSString *name=[[FYFriendName shareInstance].friendNames objectForKey:key];
    if (name) {
        return name;
    }
    return @"";
}

+ (void)addNames:(NSArray *)array
{
    for (NSDictionary *user in array) {
        if ([user isKindOfClass:[NSDictionary class]]) {
            NSString *key = [user stringForKey:@"targetId"];
            if (key == nil) {
                continue;
            }
            
            NSString *remark = [user stringForKey:@"remarkNick"];
            if (remark == nil) {
                continue;
            }
            
            NSString *nick = [user stringForKey:@"nick"];
            FYLog(NSLocalizedString(@"好友备注 => [%@]=[%@]=[%@]", nil), key, nick, remark);
            [FYFriendName setName:remark userID:key];
        }
    }
    
    /*
     {
       "createTime":"2020-03-03 19:30:55",
       "id":5,
       "remarkNick":"峰9527",
       "targetId":14102,
       "updateTime":"2020-03-03 19:30:55",
       "userId":6023
     }
     */
}

- (void)saveFriends
{
    if ([AppModel shareInstance].userInfo.isLogined) {
        NSString *userID = [AppModel shareInstance].userInfo.userId;
        NSUserDefaults *defaultData = [NSUserDefaults standardUserDefaults];
        NSString *key = [NSString stringWithFormat:@"nickfriends%@", userID];
        [defaultData setObject:self.friendNames forKey:key];
        [defaultData synchronize];
    }
}

- (NSMutableDictionary *)friendNames
{
    if (!_friendNames) {
        NSString *userID = [AppModel shareInstance].userInfo.userId;
        if (userID != nil) {
            NSUserDefaults *defaultData = [NSUserDefaults standardUserDefaults];
            NSString *key = [NSString stringWithFormat:@"nickfriends%@",userID];
            NSDictionary *tempDict = [defaultData objectForKey:key];
            if (tempDict == nil) {
                _friendNames = [NSMutableDictionary new];
            } else {
                _friendNames = [NSMutableDictionary dictionaryWithDictionary:tempDict];
            }
        } else {
            _friendNames = [NSMutableDictionary new];
        }
    }
    return _friendNames;
}

+ (void)httpGetFriends
{
    if ([AppModel shareInstance].userInfo.isLogined) {
        [FYFriendName clearData]; //缓存清空
        [[FYFriendName shareInstance] friendNames]; //缓存初始化
        // 获取所有的好友备信息
        [NET_REQUEST_MANAGER selectInternalNick:@{} successBlock:^(id response) {
            FYLog(NSLocalizedString(@"获取好友备注 %@", nil), response);
            if (NET_REQUEST_SUCCESS(response)) {
                NSObject *data = NET_REQUEST_DATA(response);
                if ([data isKindOfClass:[NSArray class]]) {
                    NSArray *userArr = (NSArray *)data;
                    if (userArr && userArr.count > 0) {
                        [FYFriendName addNames:userArr];
                    }
                }
            } else {
                FYLog(NSLocalizedString(@"🔴🔴🔴🔴🔴🔴 获取所有的好友备注信息失败！", nil));
            }
        } failureBlock:^(id error) {
            FYLog(NSLocalizedString(@"🔴🔴🔴🔴🔴🔴 获取所有的好友备注信息异常！", nil));
        }];
    } else {
        [[FYFriendName shareInstance].friendNames removeAllObjects];;
    }
}

+ (void)clearData
{
    [FYFriendName shareInstance].friendNames = nil;
}


@end

