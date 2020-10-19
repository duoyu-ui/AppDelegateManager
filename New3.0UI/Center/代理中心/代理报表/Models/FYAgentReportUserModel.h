//
//  FYAgentReportUserModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/7.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYAgentReportUserItemModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@end

@interface FYAgentReportUserModel : NSObject

@property (nonatomic, strong) NSNumber *backWater;
@property (nonatomic, strong) NSNumber *banlance;
@property (nonatomic, strong) NSNumber *bett;
@property (nonatomic, strong) NSNumber *isNewReg;
@property (nonatomic, strong) NSNumber *profitLoss;
@property (nonatomic, strong) NSNumber *proxy;
@property (nonatomic, strong) NSNumber *shrink;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) NSNumber *isLookSubUser;
@property (nonatomic, strong) NSArray<FYAgentReportUserItemModel *> *subitems;

+ (NSMutableArray<FYAgentReportUserModel *> *)buildingDataModles:(NSDictionary *)dictionary code:(NSString *)code;

@end

NS_ASSUME_NONNULL_END
