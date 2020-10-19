//
//  NetResponseManager.m
//  XM_12580
//
//  Created by mac on 12-7-10.
//  Copyright (c) 2012年 Neptune. All rights reserved.
//

#import "NetResponseManager.h"
#import "NetRequestManager.h"
#import "GTMBase64.h"
#import "NSData+AES.h"
#import "SAMKeychain.h"
#import "RSA.h"
@implementation NetResponseManager

+ (NetResponseManager *)sharedInstance {
    static NetResponseManager *instance = nil;
    static dispatch_once_t onceNetRes;
    dispatch_once(&onceNetRes, ^{
        if(instance == nil)
            instance = [[NetResponseManager alloc] init];
    });
    return instance;
}
                  
- (instancetype)init {
    if(self == [super init]){
    }
    return self;
}

- (void)responseWithHttpManager:(AFHTTPSessionManager2 *)httpManager responseData:(id)data
{
    if ([data isKindOfClass:[NSError class]]) {
        NSError *error = (NSError *)data;
        if(httpManager.failBlock) {
            NSString *url = [NetRequestManager getRequestUrl:httpManager.act];
            FYLog(NSLocalizedString(@"\n🔴🔴🔴🔴🔴🔴 请求地址 => %@  \n🔴🔴🔴🔴🔴🔴 请求参数 Param => %@", nil), url, httpManager.requestParameters);
            httpManager.failBlock(error);
        }
    }
    else if ([data isKindOfClass:[NSData class]]) {
        NSDictionary *dict = [data mj_JSONObject];
        ResultCode code = [[dict objectForKey:@"code"] integerValue];
        if([dict objectForKey:@"code"] == nil) {
            code = -1;
        }
        if(httpManager.act == ActRequestUserInfo){
            if(code == ResultCodeSuccess){
                [self updateUserInfo:dict[@"data"]];
            }
        }
        if(code == ResultCodeSuccess){
            if(httpManager.successBlock)
                httpManager.successBlock(data);
        }else{
            if(httpManager.failBlock)
                httpManager.failBlock(data);
        }
    }
    else if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)data;
        ResultCode code = [[dict objectForKey:@"code"] integerValue];
        if([dict objectForKey:@"code"] == nil) {
            code = -1;
        }
        
        if(httpManager.act == ActRequestToken
           || httpManager.act == ActRequestTokenBySMS
           || httpManager.act == Act2020AuthLoginToken
           || httpManager.act == Act2020ThirdpartRegister
           || httpManager.act == Act2020NewRegister
           || httpManager.act == Act2020ToGuestLogin) {
            NSString *refreshToken = [dict objectForKey:@"refresh_token"];
            if(refreshToken.length > 10) {
                code = ResultCodeSuccess;
            }
            if(code == ResultCodeSuccess){
                [self getTokenBack:dict[@"data"]];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kOnConnectSocketNotification object: nil];
        } else if (httpManager.act == Act2020ThirdpartyCheck) {
            if(code == ResultCodeSuccess){
                NSInteger check = [[dict valueForKeyPath:@"data.is_exist"] integerValue];
                if (check == 1) {
                    [self getTokenBack:dict[@"data"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kOnConnectSocketNotification object: nil];
                }
            }
        } else if(httpManager.act == ActRequestIMToken) {
            if(code == ResultCodeSuccess){
                [[AppModel shareInstance] saveAppModel];
            }
        } else if(httpManager.act == ActRequestUserInfo) {
            if(code == ResultCodeSuccess){
                [self updateUserInfo:dict[@"data"]];
            }
        }
        else if (httpManager.act == ActRequestSystemNotice) {
            if(code == ResultCodeSuccess){
                [self getSystemNoticeBack:dict[@"data"]];
            }
        }
        
        if (code == ResultCodeSuccess) {
            if(httpManager.successBlock)
                httpManager.successBlock(data);
        } else {
            if(httpManager.failBlock)
                httpManager.failBlock(data);
        }
    }
}

- (void)getTokenBack:(NSDictionary *)responseDic
{
    [AppModel shareInstance].userInfo.userId = responseDic[@"userId"];
    [AppModel shareInstance].userInfo.token = responseDic[@"access_token"];
    [AppModel shareInstance].userInfo.fullToken = [NSString stringWithFormat:@"%@",[AppModel shareInstance].userInfo.token];
    if (![FunctionManager isEmpty:responseDic[@"public_key"]]) {
        NSString *key =
        [RSA randomlyGenerated16BitString];
        [AppModel shareInstance].randomly16Key = key;
        
        NSString *RSApublicKey =
        responseDic[@"public_key"];
        [AppModel shareInstance].publicKey = RSApublicKey;
        
        NSString *ruleString = [NSString stringWithFormat:@"%@dist/#/mainRules?tenant=%@", [AppModel shareInstance].address, kNewTenant];
        [AppModel shareInstance].ruleString = ruleString;
        
        NSString *encRSAPubKey =
        [RSA encryptString:key publicKey:RSApublicKey];
        
        [AppModel shareInstance].encRSAPubKey = encRSAPubKey;
    }


}

- (void)updateUserInfo:(NSDictionary *)dict
{
    [[AppModel shareInstance] updateUserInfo:dict];
}


/**
 获取配置

 @param dict dict
 */
- (void)getCommonInfoBack:(NSDictionary *)dict
{
    if([dict isKindOfClass:[NSString class]]){
        NSString *s = (NSString *)dict;
        NSData *data = [GTMBase64 decodeString:s];
        data = [data AES128DecryptWithKey:kAccountPasswordKey gIv:kAccountPasswordKey];
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        dict = [json mj_JSONObject];
    }
    [AppModel shareInstance].commonInfo = dict;
    NSString *authKey = [AppModel shareInstance].commonInfo[@"app_client_id"];
    
    if(authKey){
        [AppModel shareInstance].appClientIdInCommonInfo = authKey;
        [AppModel shareInstance].authKey = [NSString stringWithFormat:@"%@",authKey];
    }
}

-(void)getSystemNoticeBack:(NSDictionary *)dict
{
    [AppModel shareInstance].noticeArray = [dict arrayForKey:@"records"];
    
    if ([dict arrayForKey:@"records"] == nil) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"records"]) {
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"records"];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:dict[@"records"] forKey:@"records"];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[AppModel shareInstance] saveAppModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateScrollBarView" object:nil];
    
    [self handleNoticeArray];
}

-(void)handleNoticeArray
{
    [AppModel shareInstance].noticeAttributedString = [[NSMutableAttributedString alloc] init];
    if([AppModel shareInstance].noticeArray.count > 0){
        NSMutableArray *arr = [[NSMutableArray alloc] init];
//        NSInteger nu = 0;
        for (NSDictionary *dic in [AppModel shareInstance].noticeArray) {
            NSString *title = dic[@"title"];
//            NSString *content = dic[@"content"];
            NSMutableString *s = [[NSMutableString alloc] initWithString:@""];
            if(title.length > 0)
                [s appendString:title];
//            if(content.length > 0){
//                if(s.length > 0)
//                    [s appendString:@"："];
//                [s appendString:content];
//            }
            [arr addObject:s];
//            nu += 1;
//            if(nu == 2)
//                break;
        }
        
        NSMutableString *s = [[NSMutableString alloc] initWithString:@""];
        for (NSString *txt in arr) {
            if(s.length > 0)
                [s appendString:@"\n"];
            [s appendString:txt];
        }
        [AppModel shareInstance].noticeAttributedString = [[NSMutableAttributedString alloc] initWithString:s];
        NSInteger i = 0;
        for (NSString *txt in arr) {
            UIColor *color = nil;
            if(i%2 == 0)
                color = COLOR_X(100, 100, 100);
            else
                color = Color_3;
            NSRange range = [s rangeOfString:txt];
            [[AppModel shareInstance].noticeAttributedString addAttributes:@{NSForegroundColorAttributeName:color,
                                        NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                range:range];
            i += 1;
        }
    }
    
}
@end
