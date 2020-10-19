//
//  Constants.h
//  Project
//
//  Created by Mike on 2019/1/5.
//  Copyright © 2019 CDJay. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

//static NSString* const WXShareDescription  = NSLocalizedString(@"下载抢红包,每天签到领红包最高88.88，诚招代理0成本0门槛代理每天拉群抢最高8888元", nil);
//static NSString* const WXShareTitle  = NSLocalizedString(@"下载抢红包,每天签到领红包最高88.88，诚招代理0成本0门槛代理每天拉群抢最高8888元", nil);

//static NSString * const kMessRefundMessage = NSLocalizedString(@"未领取的红包，将于5分钟后发起退款", nil);

//static NSString * const kMessCowRefundMessage = NSLocalizedString(@"牛牛红包不结算红包金额，只结算输赢金额", nil);

//static NSString * const kRedpackedGongXiFaCaiMessage = NSLocalizedString(@"恭喜发财，大吉大利", nil);

//static NSString * const kRedpackedExpiredMessage = NSLocalizedString(@"该红包已超过5分钟，如已领取，可在<账单>中查询", nil);

//static NSString * const kGrabpackageNoMoneyMessage = NSLocalizedString(@"金额不足，无法抢包", nil);

//static NSString * const kLookLuckDetailsMessage = NSLocalizedString(@"看看大家的手气>", nil);

//static NSString * const kNoMoreRedpackedMessage = NSLocalizedString(@"红包已抢完", nil);

//static NSString * const kSystemBusyMessage = NSLocalizedString(@"系统繁忙，请稍后再试", nil);

//static NSString * const kOtherDevicesLoginMessage = NSLocalizedString(@"您的账号在别的设备上登录，您被迫下线！", nil);

//static NSString * const kNetworkConnectionNotAvailableMessage = NSLocalizedString(@"网络连接不可用，请稍后重试", nil);

//static NSString * const kAccountOrPasswordErrorMessage = NSLocalizedString(@"账号或密码错误，请重新填写", nil);


// 自定义红包 特殊字符判断  踩雷
//static NSString * const RedPacketString = @"~!@#$%^&*()";
// 牛牛
//static NSString * const CowCowMessageString = @"~!@#$niuniuPrize%^&*()";
// 消息类型
static NSString * const kRCNotificationMessage = @"RC:NotiMessage";
// 密码请求token Key
static NSString * const kAccountPasswordKey = @"1234567887654321";



#pragma mark - ************************ NSUserDefaults Key ************************
static NSString *const kUserDefaultsStandardKeyOpenInstallCode = @"kUserDefaultsStandardKeyOpenInstallCode";


#pragma mark - ************************ 消息通知相关 ************************

/// 需要刷新token通知
static NSString * const kOnConnectSocketNotification = @"kOnConnectSocketNotification";
/// token 失效通知
static NSString * const kTokenInvalidNotification = @"kTokenInvalidNotification";

///试玩房间3分钟后关闭
static NSString * const kGameCloseAtThreeMinLater = @"kGameCloseAtThreeMinLater";
/// 刷新群信息通知
static NSString * const kReloadMyMessageGroupList = @"kReloadMyMessageGroupList";

/// 退出群
static NSString * const kUserExitGroupNotification = @"kUserExitGroupNotification";

/// 已登录IM
static NSString * const kLoggedSuccessNotification = @"kLoggedSuccessNotification";

/// 无网络通知
static NSString * const kNoNetworkNotification = @"kNoNetworkNotification";
/// 有网络通知
static NSString * const kYesNetworkNotification = @"kYesNetworkNotification";
/// 控制器已显示通知
//static NSString * const kMessageViewControllerDisplayNotification = @"kMessageViewControllerDisplayNotification";

#endif /* Constants_h */
