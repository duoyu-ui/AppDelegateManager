//
//  Public.h
//  FreeFare
//
//  Created by wc on 14-4-29.
//  Copyright (c) 2014年 wc All rights reserved.
//

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define INT_TO_STR(x) [NSString stringWithFormat:@"%ld",(long)x]
#define STR_TO_AmountFloatSTR(x) [NSString stringWithFormat:@"%.2f",[x doubleValue]]
#define NUMBER_TO_STR(a) [a isKindOfClass:[NSString class]]?a:[a stringValue]

#define MERGE_String(x,y) [NSString stringWithFormat:@"%@%@",x,y]

#define NOTIF_CENTER [NSNotificationCenter defaultCenter]

#define PROGRESS_HUD_SHOW dispatch_main_async_safe(^{ [JSLProgressHUDUtil show]; });
#define PROGRESS_HUD_SHOW_STATUS(A) dispatch_main_async_safe(^{ [JSLProgressHUDUtil showWithStatus:A]; });
#define PROGRESS_HUD_DISMISS dispatch_main_async_safe(^{ [JSLProgressHUDUtil dismiss]; });

#define WEAK_OBJ(weakObj,obj) __weak __typeof(obj)weakObj = obj;

#define WeakSelf __weak typeof(self) weakSelf = self;

#define IOS10_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define IOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

typedef void (^CallbackBlock)(id object);

#define NOTIF_LOGIN_BACK @"NOTIF_LOGIN_BACK"
#define NOTIF_LOGOUT_BACK @"NOTIF_LOGOUT_BACK"
#define NOTIF_UPDATE_USER_INFO @"NOTIF_UPDATE_USER_INFO"

#pragma mark - *************** 常用枚举 ***************

typedef NS_ENUM(NSUInteger, ResultCode) {
    ResultCodeSuccess = 0,//成功
};

typedef NS_ENUM(NSInteger, GetSmsCodeFromVCType){
    GetSmsCodeFromVCNil,
    GetSmsCodeFromVCRegister ,
    GetSmsCodeFromVCResetPW,
    GetSmsCodeFromVCLoginBySMS,
    GetSmsCodeFromVCPayPW,
    GetSmsCodeBindPhone,
};

typedef NS_ENUM(NSInteger, RewardType){
    RewardType_nil,
    RewardType_bzsz = 6000,//豹子顺子奖励
    RewardType_ztlsyj = 5000,//直推流水佣金
    RewardType_yqhycz = 1110,//邀请好友充值
    RewardType_czjl = 1100,//充值奖励
    RewardType_ecjl = 1200,//二充奖励 未知类处理
    RewardType_fbjl = 3000,//发包奖励
    RewardType_qbjl = 4000,//抢包奖励
    RewardType_jjj = 7000,//救济金
    RewardType_zcdljl = 2100,//注册登录奖励
    RewardType_xydzp = 8000,//幸运大转盘
};

typedef NS_ENUM(NSInteger, GroupTemplateType) {
    /// 福利
    GroupTemplate_N00_FuLi = 0,
    /// 扫雷
    GroupTemplate_N01_Bomb = 1,
    /// 牛牛
    GroupTemplate_N02_NiuNiu = 2,
    /// 禁抢
    GroupTemplate_N03_JingQiang = 3,
    /// 抢庄牛牛
    GroupTemplate_N04_RobNiuNiu = 4,
    /// 二八杠
    GroupTemplate_N05_ErBaGang = 5,
    /// 龙虎斗
    GroupTemplate_N06_LongHuDou = 6,
    /// 接龙
    GroupTemplate_N07_JieLong = 7,
    /// 二人牛牛
    GroupTemplate_N08_ErRenNiuNiu = 8,
    /// 超级扫雷
    GroupTemplate_N09_SuperBobm = 9,
    /// 包包彩
    GroupTemplate_N10_BagLottery = 10,
    /// 包包牛
    GroupTemplate_N11_BagBagCow = 11,
    ///百人牛牛
    GroupTemplate_N14_BestNiuNiu = 14,
    ///极速扫雷
    GroupTemplate_N15_MineClearance = 15,
};

// 三方游戏类型
typedef NS_ENUM(NSInteger, FYWebGameType){
    FYWebGameSelfDianZiType = 0,  // 自己游戏（QG电子）
    FYWebGameWangZeQiPaiType = 1,  // 王者棋牌
    FYWebGameXingYunQiPaiType = 2, // 幸运棋牌
    FYWebGameQGQiPaiType = 3, // QG棋牌
    FYWebGameKaiYuanQiPaiType = 4, // 开元棋牌
    FYWebGameShuangYingCaiPiaoType = 5, // 双赢彩票
    FYWebGameIMElectronicSportsType = 6, // IM电竞
    FYWebGameIMSportsType = 7, // IM体育
    FYWebGameAGMortalPeopleType = 8, // AG真人
    FYWebGameAGElectronicType = 9, // AG电子
    FYWebGameAGCatchFishType = 10, // AG捕鱼
    FYWebGameKGElectronicType = 11, // KG电子
    FYWebGameAGSportsType = 12, // AG体育
    FYWebGameIMElectronicCityType = 13, // IM电玩城
};


#define WXShareDescription [NSString stringWithFormat:NSLocalizedString(@"我的邀请码是%@", nil),[AppModel shareInstance].userInfo.invitecode]

#define PUSH_C(viewController,targetViewController,animation) targetViewController *vc = [[targetViewController alloc] init]; vc.hidesBottomBarWhenPushed = YES; [viewController.navigationController pushViewController:vc animated:animation];

#pragma mark - *********** 颜色相关 ***********

#define HEXCOLOR(hexValue)  [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1]

///<页面背景色
#define BaseColor HexColor(@"#F6F6F6")
///<导航栏背景色
#define Color_3 HexColor(@"#333333")
///<tab选项栏选中颜色
#define TABSelectColor HexColor(@"#a971fb")
///<分割线颜色
#define TBSeparaColor HexColor(@"#EBEBEB")
///<提交按钮颜色（ff3833，a971fb）
#define MBTNColor HexColor(@"#FE3962")

#define MBTAColor(a) ApHexColor(@"#a971fb",a)
#define SexBack HexColor(@"#6cd1f1")

// 黑色
#define Color_0 HexColor(@"#1E1E1E")
#define Color_3 HexColor(@"#333333")
#define Color_6 HexColor(@"#666666")
#define Color_9 HexColor(@"#999999")
// 白色
#define Color_F HexColor(@"#FFFFFF")

#define kGETVALUE_HEIGHT(width,height,limit_width) ((limit_width)*(height)/(width))

// 背景灰色
#define kBackgroundGrayColor [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0]

#define COLOR_X(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]


#pragma mark - ********** 偏好设置存储相关 **********

#define SetUserDefaultKeyWithObject(key,object) [[NSUserDefaults standardUserDefaults] setObject:object forKey:key]
#define SetUserBoolKeyWithObject(key,object) [[NSUserDefaults standardUserDefaults] setBool:object forKey:key]

#define GetUserDefaultWithKey(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define GetUserDefaultBoolWithKey(key) [[NSUserDefaults standardUserDefaults] boolForKey:key]

#define DeleUserDefaultWithKey(key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]
#define UserDefaultSynchronize  [[NSUserDefaults standardUserDefaults] synchronize]

#pragma mark - ********** 路径相关 **********

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


#pragma mark - ********** iPhoneX适配等 **********

#define kSendRPTitleCellWidth 80

#define kIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kIs_iPhoneX kScreenWidth >=375.0f && kScreenHeight >=812.0f&& kIs_iphone

/*状态栏高度*/
#define kStatusBarHeight (CGFloat)(kIs_iPhoneX?(44.0):(20.0))
/*导航栏高度*/
#define kNavBarHeight (44)
/*状态栏和导航栏总高度*/
#define kNavBarAndStatusBarHeight (CGFloat)(kIs_iPhoneX?(88.0):(64.0))
/*TabBar高度*/
#define kTabBarHeight (CGFloat)(kIs_iPhoneX?(49.0 + 34.0):(49.0))
/*顶部安全区域远离高度*/
#define kTopBarSafeHeight (CGFloat)(kIs_iPhoneX?(44.0):(0))
/*底部安全区域远离高度*/
#define kBottomSafeHeight (CGFloat)(kIs_iPhoneX?(34.0):(0))
/*iPhoneX的状态栏高度差值*/
#define kTopBarDifHeight (CGFloat)(kIs_iPhoneX?(24.0):(0))
/*导航条和Tabbar总高度*/
#define kNavAndTabHeight (kNavBarAndStatusBarHeight + kTabBarHeight)
///全局线的高度
#define kLineHeight 0.7
///全局线的距离上面控件的间距
#define kLineSpacing 9
///新cell字体size
#define kCellFont 15
///国际化
//#define a) NSLocalizedString(a, nil)
#ifdef DEBUG
#define NSLog(format, ...) printf("[%s][DEBUG]%s [第%d行] => %s \n", [[CFCSysUtil getCurrentTimeStamp] UTF8String], __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String])
#else
#define NSLog(__FORMAT__, ...)
#endif


#pragma mark - ********* 引用类 *********

#import "AABlock.h"
#import "FLAnimatedImage.h"
#import "NSObject+CDCategory.h"
//#import "NSObject+CDExtension.h"
#import "CDProtocol.h"
#import "UIView+CDSDImage.h"
#import "CDFunction.h"
#import "UIButton+Ani.h"
#import "UIButton+Helper.h"
#import "Masonry.h"

#import "CDTableModel.h"
#import "MJRefresh.h"
#import "MJExtension.h"

#import "NetRequestManager.h"
#import "FunctionManager.h"

#import "Macros.h"
#import "VVAdaptUI.h"
#import "Constants.h"
#import "FYNotificationConst.h"

#import "SuperViewController.h"

#import "AppModel.h"
//#import "UserModel.h"
#import "UserInfo.h"


#import "SVProgressHUD+CDHUD.h"

#import "UIView+AZGradient.h"
#import "AlertViewCus.h"
#import "FYSDK.h"

#import "YBNotificationManager.h"
#import "BannerModel.h"
//#import "UIView+SDExtension.h"
//#import "SDCycleScrollView.h"
#import "AlertTipPopUpView.h"
#import "BaseVC.h"
#import "UITableView+YBGeneral.h"

#import "UIViewController+AlterMessage.h"
#import "NetworkConfig.h"

#import <ReactiveObjC.h>
#import <MBProgressHUD/MBProgressHUD.h>



// 三方扩展库 - CocoaPods
#import "UINavigationSXFixSpace.h"
#import "DZNEmptyDataSet/UIScrollView+EmptyDataSet.h"
// 三方扩展库 - 手动导入库
#import "Reachability.h"
#import "JSLProgressHUDUtil.h"
#import "JSLProgressAlertUtil.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
// 自定义头文件 - Core
#import "CFCSysCore.h"
#import "CFCSysConst.h"
// 自定义头文件 - Utils
#import "FYDateUtil.h"
#import "CFCSysUtil.h"
#import "CFCAutosizingUtil.h"
#import "CFCStringMathsUtil.h"
#import "CFCNavSXFixSpaceUitl.h"
#import "CFCNetworkReachabilityUtil.h"
// 自定义头文件 - Macros
#import "CFCStringMacro.h"
#import "CFCAssetsMacro.h"
#import "CFCSysLogMacro.h"
#import "CFCSysCoreMacro.h"
// 自定义头文件 - UIKit
#import "CFCRefreshHeader.h"
#import "CFCRefreshFooter.h"
#import "CFCTabBarController.h"
#import "CFCTabBarController+InterfaceOrientation.h"
#import "CFCNavigationController.h"
#import "CFCNavigationController+InterfaceOrientation.h"
#import "CFCNavBarViewController.h"
#import "CFCNetworkViewController.h"
#import "CFCDirectionViewController.h"
#import "CFCBaseCoreViewController.h"
// 自定义头文件 - Categories
#import "CFCCategories.h"

// 公共头文件
#import "FYRechargeMainViewController.h"
#import "FYPresentAlertViewController.h"
#import "FYRootUI4TabBarController.h"
#import "FYWebViewController.h"
#import "FYApplicationManager.h"
#import "FYPrecisionManager.h"
#import "FYCountDownObject.h"



