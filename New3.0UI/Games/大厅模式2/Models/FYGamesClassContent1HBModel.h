//
//  FYGamesClassContent1HBModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/16.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYGamesClassContent1HBModel : MessageItem

@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *imageUrl;

// 以下三个字段，从二级菜单取值。（热门分类，则三级数据自己返回，无取从二级取）
@property (nonatomic, strong) NSNumber *menuGameFlag;  // 1显示 2隐藏 3维护
@property (nonatomic, copy) NSString *menuMaintainEnd; // 维护结束时间
@property (nonatomic, copy) NSString *menuMaintainStart; // 维护开始时间

+ (NSMutableArray<FYGamesClassContent1HBModel *> *) buildingDataModles;

@end

NS_ASSUME_NONNULL_END
