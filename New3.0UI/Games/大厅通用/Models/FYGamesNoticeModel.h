//
//  FYGamesNoticeModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYGamesNoticeModel : NSObject

@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *releaseTime;
@property (nonatomic, copy) NSString *lastUpdateTime;

@property (nonatomic, strong) NSNumber *noticeType;
@property (nonatomic, strong) NSNumber *delFlag;
@property (nonatomic, strong) NSNumber *releaseFlag;
@property (nonatomic, strong) NSNumber *stickFlag;

@property (nonatomic, strong) NSNumber *isLoacl; // 0:远程，1:本地

+ (NSMutableArray<FYGamesNoticeModel *> *) buildingDataModles;

@end

NS_ASSUME_NONNULL_END
