
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXApiNetManager : NSObject

+ (void)getAccessTokenWithRespCode:(NSString*)respCode
                          callback:(void(^)(BOOL requestStatus, NSDictionary *response))callback;

+ (void)getUserInfoWithToken:(NSString *)token
                      openid:(NSString *)openid
                    callback:(void(^)(BOOL requestStatus, NSDictionary *response))callback;

@end

NS_ASSUME_NONNULL_END
