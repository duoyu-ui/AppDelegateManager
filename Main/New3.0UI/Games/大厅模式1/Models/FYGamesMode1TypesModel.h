//
//  FYGamesMode1TypesModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FYGamesMode1ClassModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYGamesMode1TypesModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *showName;

@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, strong) NSNumber *type; // 1:红包 2:棋牌 3:电子 4:彩票
@property (nonatomic, strong) NSNumber *sort;
@property (nonatomic, strong) NSNumber *index;

@property (nonatomic, copy) NSString *count;
@property (nonatomic, strong) NSNumber *openFlag;
@property (nonatomic, strong) NSNumber *iconSize;
@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *lastUpdateTime;
@property (nonatomic, copy) NSString *maintainEnd;
@property (nonatomic, copy) NSString *maintainStart;
@property (nonatomic, strong) NSNumber *maintainFlag;
@property (nonatomic, strong) NSNumber *maintainLimitTime;
@property (nonatomic, strong) NSNumber *timestamp;

@property (nonatomic, strong) NSArray<FYGamesMode1ClassModel *> *list;

@end

NS_ASSUME_NONNULL_END
