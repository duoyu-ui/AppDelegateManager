
#import <Foundation/Foundation.h>
#ifdef _PROJECT_WITH_WECHAT_
#import "WXApi.h"
#import "WXApiObject.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@protocol WXAuthDelegate <NSObject>

@optional
- (void)wxAuthSucceed:(NSString *)code; /**< 成功    */
- (void)wxAuthCommon; /**< 普通错误类型    */
- (void)wxAuthCancel; /**< 用户点击取消并返回    */
- (void)wxAuthSentFail; /**< 发送失败    */
- (void)wxAuthDenied; /**< 授权失败    */
- (void)wxAuthUnsupport; /**< 微信不支持    */

@end

#ifndef _PROJECT_WITH_WECHAT_
@interface WXApiManager : NSObject
#else
@interface WXApiManager : NSObject <WXApiDelegate>
#endif

@property (nonatomic, assign) BOOL status;

@property (nonatomic, weak) id<WXAuthDelegate, NSObject> delegate;

/**
 *  严格单例
 *  @return 实例对象.
 */
+ (instancetype)sharedWXApiManager;

/**
 * 注册微信
 * @param appId 微信开发者ID
 * @param universalLink 微信开发者 Universal Link
 * @return 成功返回YES，失败返回NO。
 */
+ (BOOL)registerApp:(NSString *)appId universalLink:(NSString *)universalLink;

/**
 * 发送微信验证请求（SDK V1.7.9）
 * @restrict 该方法支持未安装微信的用户
 * @param viewController 发起验证的视图控制器 VC
 * @param delegate 处理验证结果的代理
 */
- (void)sendAuthRequestWithController:(UIViewController*)viewController
                             delegate:(id<WXAuthDelegate>)delegate;

/**
 * 发送微信验证请求（SDK V1.8.6）
 * @restrict 该方法支持未安装微信的用户
 * @param viewController 发起验证的视图控制器 VC
 * @param delegate 处理验证结果的代理
 * @param completion 回调代理
 */
- (void)sendAuthRequestWithController:(UIViewController*)viewController
                             delegate:(id<WXAuthDelegate>)delegate
                           completion:(void (^ __nullable)(BOOL success))completion;

@end


NS_ASSUME_NONNULL_END
