
#import "WXApiNetManager.h"
#import <AFNetworking/AFNetworking.h>

@implementation WXApiNetManager

+ (void)getAccessTokenWithRespCode: (NSString*)respCode callback: (void(^)(BOOL requestStatus, NSDictionary *response))callback
{
    AFHTTPSessionManager* manager = [[AFHTTPSessionManager alloc] init];
    AFHTTPResponseSerializer* responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/json", @"text/plain", @"text/html"]];
    manager.responseSerializer = responseSerializer;
    
    NSString *appid = [AppModel shareInstance].wxAppid;
    NSString *appsecret = [AppModel shareInstance].wxAppSecret;
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",appid,appsecret,respCode];
    
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError* error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&error];
        if (error) {
            callback(NO, jsonDict);
            return ;
        } else {
            callback(YES, jsonDict);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO, nil);
    }];
}

+ (void)getUserInfoWithToken:(NSString *)token openid:(NSString *)openid callback: (void(^)(BOOL requestStatus, NSDictionary *response))callback
{
    AFHTTPSessionManager* manager = [[AFHTTPSessionManager alloc] init];
    AFHTTPResponseSerializer* responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/json", @"text/plain", @"text/html"]];
    manager.responseSerializer = responseSerializer;
    
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openid];
    
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * task, id responseObject) {
        NSError* error;
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&error];
        if (error) {
            callback(NO, jsonDict);
            return ;
        } else {
            callback(YES, jsonDict);
        }
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        callback(NO, nil);
    }];
}


@end
