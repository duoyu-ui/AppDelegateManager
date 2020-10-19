//
//  UserInfo.m
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "UserInfo.h"
#import "FunctionManager.h"

@implementation UserInfo

MJCodingImplementation

- (id)copyWithZone:(NSZone *)zone{
    UserInfo *copy = [[self class] allocWithZone: zone];
    copy.isLogined = self.isLogined;
    copy.userId = self.userId;
    copy.avatar = self.avatar;
    copy.email = self.email;
    copy.invitecode = self.invitecode;
    copy.mobile = self.mobile;
    copy.gender = self.gender;
    copy.balance = self.balance;
    copy.createTime = self.createTime;
    copy.jointime = self.jointime;
    copy.token = self.token;
    copy.fullToken = self.fullToken;
    copy.nick = self.nick;
    copy.userSalt = self.userSalt;
    copy.status = self.status;
    copy.recharge = self.recharge;
    copy.profit = self.profit;
    copy.cashDraw = self.cashDraw;
    copy.isBindMobile = self.isBindMobile;
    return copy;
}

@end
