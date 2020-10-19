//
//  FYGamesMode1StatusModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYGamesMode1StatusModel : NSObject

@property (nonatomic, strong) NSNumber *accessWay;
@property (nonatomic, strong) NSNumber *displayFlag;
@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, strong) NSNumber *maintainFlag;
@property (nonatomic, strong) NSNumber *maintainLimitTime;
@property (nonatomic, strong) NSNumber *openFlag;
@property (nonatomic, strong) NSNumber *powerFlag;
@property (nonatomic, strong) NSNumber *sort;
@property (nonatomic, strong) NSNumber *type;

@property (nonatomic, copy) NSString *maintTotalTime;
@property (nonatomic, copy) NSString *maintainEnd;
@property (nonatomic, copy) NSString *maintainStart;
@property (nonatomic, copy) NSString *showName;
@property (nonatomic, copy) NSString *linkUrl;

@end

NS_ASSUME_NONNULL_END
