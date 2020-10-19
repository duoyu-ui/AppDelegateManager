
#import "WXApiManager.h"
#import "RSA.h"

@interface WXApiManager ()

@property (nonatomic, strong) NSString *authState;

@end

@implementation WXApiManager

+ (instancetype)sharedWXApiManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initInPrivate];
    });
    return instance;
}

- (instancetype)initInPrivate {
    self = [super init];
    if (self) {
        _status = NO;
        _delegate = nil;
    }
    return self;
}

- (instancetype)init {
    return nil;
}

- (instancetype)copy {
    return nil;
}


#pragma mark - Public Methods

/**
 * 注册微信
 * @param appId 微信开发者ID
 * @param universalLink 微信开发者 Universal Link
 * @return 成功返回YES，失败返回NO。
 */
+ (BOOL)registerApp:(NSString *)appId universalLink:(NSString *)universalLink
{
#ifdef _PROJECT_WITH_WECHAT_
    if ([WXApiManager sharedWXApiManager].status)
        return YES;
    
    if ([WXApi registerApp:appId]) {
        [WXApiManager sharedWXApiManager].status = YES;
        NSLog(NSLocalizedString(@"微信[WeChatOpenSDK 版本 V%@] => 注册成功！", nil), [WXApi getApiVersion]);
        return YES;
    } else {
        [WXApiManager sharedWXApiManager].status = NO;
        NSLog(NSLocalizedString(@"微信[WeChatOpenSDK 版本 V%@] => 注册失败！", nil), [WXApi getApiVersion]);
        return NO;
    }
#endif
    return NO;
}

/**
 * 发送微信验证请求（SDK V1.7.9）
 * @restrict 该方法支持未安装微信的用户
 * @param viewController 发起验证的视图控制器 VC
 * @param delegate 处理验证结果的代理
 */
- (void)sendAuthRequestWithController:(UIViewController*)viewController
                             delegate:(id<WXAuthDelegate>)delegate
{
    [self sendAuthRequestWithController:viewController delegate:delegate completion:nil];
}

/**
 * 发送微信验证请求（SDK V1.8.6）
 * @restrict 该方法支持未安装微信的用户
 * @param viewController 发起验证的视图控制器 VC
 * @param delegate 处理验证结果的代理
 * @param completion 回调代理
 */
- (void)sendAuthRequestWithController:(UIViewController*)viewController
                             delegate:(id<WXAuthDelegate>)delegate
                           completion:(void (^ __nullable)(BOOL success))completion
{
#ifdef _PROJECT_WITH_WECHAT_
    if (![WXApiManager sharedWXApiManager].status) {
        [viewController alertPromptMessage:NSLocalizedString(@"微信注册失败，请重新打开程序注册。", nil) okActionBlock:nil];
        return;
    }
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    self.authState = req.state = [RSA randomlyGenerated16BitString];
    self.delegate = delegate;
    [WXApi sendAuthReq:req viewController:viewController delegate:self];
#endif
}


#pragma mark - WXApiDelegate

#ifdef _PROJECT_WITH_WECHAT_
-(void)onReq:(BaseReq*)req
{
    // just leave it here, WeChat will not call our app
}

-(void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp* authResp = (SendAuthResp*)resp;
        if (![authResp.state isEqualToString:self.authState]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(wxAuthDenied)]) {
                [self.delegate wxAuthDenied];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWeixinAuthDeny
                                                                object:authResp];
            return;
        }
        
        switch (resp.errCode) {
            case WXSuccess: {
                NSLog(NSLocalizedString(@"微信SDK应答 => [code:%@, state:%@]\n", nil), authResp.code, authResp.state);
                if (self.delegate && [self.delegate respondsToSelector:@selector(wxAuthSucceed:)]) {
                    [self.delegate wxAuthSucceed:authResp.code];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWeixinAuthSuccess
                                                                    object:authResp.code];
                break;
            }
            case WXErrCodeCommon: {
                if (self.delegate && [self.delegate respondsToSelector:@selector(wxAuthCommon)]) {
                    [self.delegate wxAuthCommon];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWeixinAuthCommon
                                                                    object:authResp];
                break;
            }
            case WXErrCodeUserCancel: {
                if (self.delegate && [self.delegate respondsToSelector:@selector(wxAuthCancel)]) {
                    [self.delegate wxAuthCancel];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWeixinAuthCancle
                                                                    object:authResp];
                break;
            }
            case WXErrCodeSentFail: {
                if (self.delegate && [self.delegate respondsToSelector:@selector(wxAuthSentFail)]) {
                    [self.delegate wxAuthSentFail];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWeixinAuthSendFail
                                                                    object:authResp];
                break;
            }
            case WXErrCodeAuthDeny: {
                if (self.delegate && [self.delegate respondsToSelector:@selector(wxAuthDenied)]) {
                    [self.delegate wxAuthDenied];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWeixinAuthDeny
                                                                    object:authResp];
                break;
            }
            case WXErrCodeUnsupport: {
                if (self.delegate && [self.delegate respondsToSelector:@selector(wxAuthUnsupport)]) {
                    [self.delegate wxAuthUnsupport];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWeixinUnsupport
                                                                    object:authResp];
                break;
            }
            default: {
                if (self.delegate && [self.delegate respondsToSelector:@selector(wxAuthUnsupport)]) {
                    [self.delegate wxAuthUnsupport];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWeixinUnsupport
                                                                    object:authResp];
                break;
            }
        }
    }
}
#endif


@end

