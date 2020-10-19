//
//  AppModel.h
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"


typedef enum : NSInteger {
    FYLoginTypeDefault = 0,//验证码登录、手机登录
    FYLoginTypeWeChat = 1,//微信登录
    FYLoginTypeGuest = 2,//游客登录
} FYLoginType;

typedef NS_ENUM(NSInteger, FYGameAppConfigStyle){
    FYGameAppConfigStyleMode1 = 101,
    FYGameAppConfigStyleMode2 = 102,
};

@interface AppModel : NSObject<NSCoding,NSCopying>
/// 本地通知
@property (nonatomic, assign) BOOL granted;
@property (nonatomic ,assign) BOOL turnOnSound;///<声音
@property (nonatomic, assign) BOOL isAppEnterBackground; /// 程序进入后台
/// 系统消息
@property (nonatomic, copy) NSString *lastSysMsgNoticeReadTime;  // 已读的最后一条系统消息时间
/// 用户信息
@property (nonatomic ,strong) UserInfo *userInfo;///<用户信息

@property (nonatomic ,assign) NSInteger unReadCount;  ///< 未读总消息
@property (nonatomic ,assign) NSInteger friendUnReadTotal;  // 好友未读总消息
@property (nonatomic ,strong) NSDictionary *commonInfo;
@property (nonatomic ,copy) NSString *appClientIdInCommonInfo;
@property (nonatomic ,copy) NSString *encRSAPubKey;
@property (nonatomic ,copy) NSString *publicKey;
@property (nonatomic ,copy) NSString *ruleString;
@property (nonatomic ,copy) NSString *randomly16Key;
@property (nonatomic ,strong) NSArray *noticeArray;
@property (nonatomic ,strong) NSMutableAttributedString*  noticeAttributedString;
@property (nonatomic ,copy) NSString *serverUrl;
@property (nonatomic ,copy) NSString *authKey;

/// 用户ID
@property (nonatomic, copy) NSString *accountId;

/// NO:正式版，YES:测试版
@property (nonatomic ,assign) BOOL debugMode;
/// 我加入的群id
@property (nonatomic ,strong) NSArray *myGroupArray;
/// 聊天类型（群聊，单聊）
@property (nonatomic, assign) NSInteger chatType;

/// 群组是否是官方群；yes:官方游戏群，no:自建群
@property (nonatomic, assign) BOOL officeFlag;
/// 游戏类型
@property (nonatomic, assign) NSInteger gameType;
/// 是否是群主
@property (nonatomic, assign) BOOL isGroupOwner;
/// 分享地址
@property (nonatomic, copy) NSString *address;

@property (nonatomic,strong) NSString *wxAppid;
@property (nonatomic,strong) NSString *wxAppSecret;

+ (instancetype)shareInstance;

- (void)saveAppModel;///<登录存档
- (void)logout;///<退出清理
- (UIViewController *)rootVc;
- (void)updateTabBarIndex:(NSInteger)index;

- (void)initSetUp;
- (void)restRootAnimation:(BOOL)animation;
- (void)reSetTabBarAsRootAnimation;
- (NSArray *)ipArray;

- (void)checkGroupId:(NSString *)groupId Completed:(void (^)(BOOL complete))completed;

- (void)updateUserInfo:(NSDictionary *)dict;
- (void)updateCommonInformation:(NSDictionary *)dictionary;
+ (void)debugShowCurrentUrl;

- (FYGameAppConfigStyle)getGameAppConfigStyle;

- (void)loginToUpdateUserInformation:(BOOL)isRefreshRoot;
- (UIViewController *)rootViewController;
- (UIWindow *)appWindow;

- (FYLoginType)loginType;
- (BOOL)isGuest;
- (BOOL)isGuestLogin;
- (BOOL)isShow2Level;
- (void)isShow2LevelSetting:(BOOL)isShow;
- (void)setLoginType:(FYLoginType)type;

/// 根据userid获取备注名,如果没有找到，返回的是空字符串 @""
- (NSString *)getFriendName:(NSString *)userid;
+ (void)alertShowGuestWithResult:(void(^)(UIButton *button))callBack;

@end
