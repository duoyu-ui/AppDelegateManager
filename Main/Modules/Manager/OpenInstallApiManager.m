
#import "OpenInstallApiManager.h"

@implementation OpenInstallApiManager

+ (instancetype)sharedOpenInstallApiManager {
    static dispatch_once_t onceToken;
    static OpenInstallApiManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initInPrivate];
    });
    return instance;
}

- (instancetype)initInPrivate {
    self = [super init];
    if (self) {

    }
    return self;
}

- (instancetype)init {
    return nil;
}

- (instancetype)copy {
    return nil;
}


#pragma mark - OpenInstallDelegate

#ifdef _PROJECT_WITH_OPENINSTALL_
// 通过OpenInstall获取已经安装App被唤醒时的参数（如果是通过渠道页面唤醒App时，会返回渠道编号）
- (void)getWakeUpParams:(OpeninstallData *)appData
{
    if (appData.data) {//(动态唤醒参数)
        //e.g.如免填邀请码建立邀请关系、自动加好友、自动进入某个群组或房间等
    }
    if (appData.channelCode) { //(通过渠道链接或二维码唤醒会返回渠道编号)
        //e.g.可自己统计渠道相关数据等
    }
    NSString *codeNumber = VALIDATE_STRING_EMPTY(kOpenInviteCode) ? appData.data[@"code"] : kOpenInviteCode;
    SetUserDefaultKeyWithObject(kUserDefaultsStandardKeyOpenInstallCode, codeNumber);
    NSLog(NSLocalizedString(@"OpenInstallSDK:\n动态参数：%@;\n渠道编号：%@", nil),appData.data,appData.channelCode);
}
#endif


@end
