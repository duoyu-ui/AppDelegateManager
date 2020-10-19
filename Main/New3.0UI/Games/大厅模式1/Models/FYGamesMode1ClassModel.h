//
//  FYGamesMode1ClassModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYGamesMode1ClassModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *showName;
@property (nonatomic, copy) NSString *minIcon;
@property (nonatomic, copy) NSString *maxIcon;
@property (nonatomic, copy) NSString *maintainStart;
@property (nonatomic, copy) NSString *maintainEnd;
@property (nonatomic, copy) NSString *maintTotalTime;
@property (nonatomic, copy) NSString *lastUpdateTime;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *accessIcon;

@property (nonatomic, copy) NSString *countSum;
@property (nonatomic, copy) NSString *linkUrl;

@property (nonatomic, strong) NSNumber *accessWay;
@property (nonatomic, strong) NSNumber *displayFlag;
@property (nonatomic, strong) NSNumber *iconSize;
@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, strong) NSNumber *lastUpdateBy;
@property (nonatomic, strong) NSNumber *maintainFlag;
@property (nonatomic, strong) NSNumber *maintainLimitTime;
@property (nonatomic, strong) NSNumber *openFlag;
@property (nonatomic, strong) NSNumber *parentId;
@property (nonatomic, strong) NSNumber *powerFlag;
@property (nonatomic, strong) NSNumber *productWallet;
@property (nonatomic, strong) NSNumber *sort;
@property (nonatomic, strong) NSNumber *timestamp;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, strong) NSNumber *closeFlag;

@end


NS_ASSUME_NONNULL_END
