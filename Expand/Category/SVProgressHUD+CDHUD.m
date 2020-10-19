//
//  SVProgressHUD+CDHUD.m
//  Project
//
//  Created by mini on 2018/8/3.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "SVProgressHUD+CDHUD.h"

@implementation SVProgressHUD (CDHUD)

+ (void)showError:(NSError *)error {
    NSDictionary *dic = error.userInfo;
    NSString *msg = NSLocalizedString(@"服务器连接失败,请稍后再试", nil);
    if ([dic objectForKey:@"msg"]) {
        msg = [dic objectForKey:@"msg"];
    }
    else if ([dic objectForKey:@"NSLocalizedDescriptionKey"]){
        msg = [dic objectForKey:@"NSLocalizedDescriptionKey"];
    }
    else if ([dic objectForKey:@"NSErrorUserInfoKey"]){
        msg = [dic objectForKey:@"NSErrorUserInfoKey"];
    }
    
    
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSLog(NSLocalizedString(@"请求地址:%@", nil), dic[@"NSErrorFailingURLKey"]);
        NSLog(NSLocalizedString(@"错误原因:%@", nil), dic[@"NSLocalizedDescription"]);
        msg = [dic objectForKey:@"NSLocalizedDescription"] == nil ? msg : [dic objectForKey:@"NSLocalizedDescription"];
        
        if ([dic[@"com.alamofire.serialization.response.error.response"] isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *http = (NSHTTPURLResponse *)dic[@"com.alamofire.serialization.response.error.response"];
            NSInteger code = http.statusCode;
            NSLog(NSLocalizedString(@"错误状态:%zd", nil), code);

            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: dic[@"com.alamofire.serialization.response.error.data"] options:kNilOptions error:nil];
            
            if([serializedData isKindOfClass:[NSDictionary class]]){
                if (code == 401 && [[serializedData objectForKey:@"error"] isEqualToString:@"invalid_token"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kTokenInvalidNotification object:nil];
                    return;
                } else if (code == 403 && [[serializedData objectForKey:@"code"] integerValue] == 1) {
                    msg = [serializedData objectForKey:@"msg"];
                } else if (code == 500 || code == 501) {
                    msg = NSLocalizedString(@"内部服务器错误，请联系在线客服", nil);
                } else if (code == 478) {
                    msg = [serializedData objectForKey:@"msg"];
                }
                
                
                if ([[serializedData objectForKey:@"error"] isEqualToString:@"unauthorized"]) {
//                    SVP_ERROR_STATUS(NSLocalizedString(@"用户信息已失效，请重新登录", nil));
                    [[NSNotificationCenter defaultCenter] postNotificationName:kTokenInvalidNotification object:nil];
                    return;
                } else if ([[serializedData objectForKey:@"error"] isEqualToString:@"Unauthorized"]) {
//                    SVP_ERROR_STATUS(NSLocalizedString(@"用户信息已失效，请重新登录", nil));
                    [[NSNotificationCenter defaultCenter] postNotificationName:kTokenInvalidNotification object:nil];
                    return;
                } else if ([[serializedData objectForKey:@"error"] isEqualToString:@"invalid_grant"]) {
                    
                    if([[serializedData objectForKey:@"error_description"] isEqualToString:@"Bad credentials"]){
                        // 密码错误
//                        SVP_ERROR_STATUS(NSLocalizedString(@"用户信息已失效，请重新登录", nil));
                        [[NSNotificationCenter defaultCenter] postNotificationName:kTokenInvalidNotification object:nil];
                        return;
                    }else if([[serializedData objectForKey:@"error_description"] isEqualToString:@"User account is locked"]){
                        // 封号
//                        SVP_ERROR_STATUS(NSLocalizedString(@"此账号已被封禁，请联系客服", nil));
                        [[NSNotificationCenter defaultCenter] postNotificationName:kTokenInvalidNotification object:nil];
                        return;
                    }
                }

            }
            
        }
    }
    
    [SVProgressHUD showErrorWithStatus:msg];
}


@end
