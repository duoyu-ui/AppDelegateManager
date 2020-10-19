//
//  MessageItem.h
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FYGroupStatus.h"
#import "FYRobNiuniu.h"

@interface MessageItem : NSObject

/// 入群发包流水
@property (nonatomic, strong) NSNumber *waterBill;
/// 群主ID
@property (nonatomic, copy) NSString *userId;
/// 是否禁言
@property (nonatomic, assign) BOOL shutupFlag;
/// 是否禁图
@property (nonatomic, assign) BOOL shutPicFlag;
/// 头像&群头像图片
@property (nonatomic, copy) NSString *avatar;
/// 群规则
@property (nonatomic, copy) NSString *rule;
/// 群规则图片
@property (nonatomic, copy) NSString *ruleImg;
/// 排序号
@property (nonatomic, copy) NSString *orderNum;
/// 群公告
@property (nonatomic, copy) NSString *notice;
/// 群主昵称
@property (nonatomic, copy) NSString *nick;
/// 群须知
@property (nonatomic, copy) NSString *know;
/// 入群金额
@property (nonatomic, copy) NSString *joinMoney;
/// 入群抢红包个数
@property (nonatomic, copy) NSString *grabCount;
/// 群ID
@property (nonatomic, copy) NSString *groupId;
/// 是否删除
@property (nonatomic, assign) NSInteger isDel;
/// 是否正常
@property (nonatomic, assign) NSInteger isActive;

@property (nonatomic, copy) NSString *delFlag;
/// 创建时间
@property (nonatomic, copy) NSString *createTime;
/// 群类型ID
@property (nonatomic, copy) NSString *chatgId;
/// 群组名称
@property (nonatomic, copy) NSString *chatgName;
/// 群图片
@property (nonatomic, copy) NSString *img;
/// 说话时间
@property (nonatomic, assign) NSInteger talkTime;
/// 加群密码
@property (nonatomic, copy) NSString *password;
/// 玩法
@property (nonatomic, copy) NSString *howplay;
/// 玩法图片
@property (nonatomic, copy) NSString *howplayImg;
/// 成员数量基数
@property (nonatomic, assign) NSInteger groupNum;

/// 是否是自建群（NO是自建群）
@property (nonatomic, assign) BOOL officeFlag;
/// 红包过期时间
@property (nonatomic, copy) NSString *rpOverdueTime;
/// 普通红包最大包数
@property (nonatomic, copy) NSString *simpMaxCount;
/// 普通红包最小包数
@property (nonatomic, copy) NSString *simpMinCount;
/// 普通红包最大金额
@property (nonatomic, copy) NSString *simpMaxMoney;
/// 普通红包最小金额
@property (nonatomic, copy) NSString *simpMinMoney;

/// 最大包数
@property (nonatomic, copy) NSString *maxCount;
/// 最大金额
@property (nonatomic, copy) NSString *maxMoney;
/// 最小包数
@property (nonatomic, copy) NSString *minCount;
/// 最小金额
@property (nonatomic, copy) NSString *minMoney;

@property (nonatomic, strong) NSString *attr;
/// 超级扫雷群类型（1：单雷，2：多雷，3：混合雷）
@property (nonatomic, assign) NSInteger bombType;

/// 最后更新人
@property (nonatomic, copy) NSString *lastUpdateBy;
/// 最后更新时间
@property (nonatomic, copy) NSString *lastUpdateTime;

/// 群类型（0：福利群；1：扫雷群；2：牛牛群；3：禁抢；4：抢庄牛牛群；5：二八杠；6：龙虎斗；7：接龙红包；8：二人牛牛；9:超级扫雷）
@property (nonatomic, assign) NSInteger type;  // GroupTemplateType -> Public.h

@property (nonatomic, assign) BOOL isMyJoined;

@property (nonatomic, copy) NSString *localImg;

@property (nonatomic, copy) NSData *localImgData;

@property (nonatomic, strong) FYRobNiuniu *robNiuniu;
/// 群维护状态
@property (nonatomic, strong) FYGroupStatus *statusData;


/**
* 用于区分表所属用户（实际上是当前的用户id）
*/
@property (nonatomic, copy) NSString *tableOwnerId;
@property (nonatomic, assign) BOOL tryPlayFlag; // 试玩用户群

/**
 * 为了在swift中能够生成模型
 */
+ (instancetype)initWithDict:(NSDictionary *)dict;

@end
