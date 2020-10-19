//
//  SSMenuDataHelper.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/12/9.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSChatMenuConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSMenuDataHelper : NSObject

/// 单利
+ (instancetype)sharedHelper;


/// 获取对应菜单配置
/// @param chatType 聊天类型：1:群聊，0:单聊
/// @param officeFlag 是否是自建群
/// @param gameType 游戏类（0：福利群；1：扫雷群；2：牛牛群；3：禁抢；4：抢庄牛牛群；5：二八杠；6：龙虎斗；7：接龙红包；8：二人牛牛；9:超级扫雷）
- (NSArray <SSChatMenuConfig *>*)loadMenusWithChatType:(NSInteger)chatType
                                            officeFlag:(BOOL)officeFlag 
                                              gameType:(NSInteger)gameType;

@end

NS_ASSUME_NONNULL_END
