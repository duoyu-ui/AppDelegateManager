//
//  FYPayModeModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/18.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYPayBankModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;
@end

@interface FYPayModeTypeModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *sort;
@property (nonatomic, strong) NSNumber *value;
@end

@interface FYPayModeModel : NSObject

@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, strong) NSNumber *chanelId;
@property (nonatomic, strong) NSNumber *chanelType; // 1官方 2VIP 3三方
@property (nonatomic, strong) NSNumber *chanelTypeId;
@property (nonatomic, strong) NSNumber *adviceFlag;
@property (nonatomic, strong) NSNumber *maxAmount;
@property (nonatomic, strong) NSNumber *minAmount;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *bankNum;
@property (nonatomic, copy) NSString *bankAddress;
@property (nonatomic, copy) NSString *chanelRemarks;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *payeeName;
@property (nonatomic, copy) NSString *payeeAccount;
@property (nonatomic, copy) NSString *allocationAmount;
@property (nonatomic, copy) NSString *levelId;
@property (nonatomic, strong) FYPayBankModel *bank;
@property (nonatomic, strong) FYPayModeTypeModel *type;

+ (NSMutableArray<FYPayModeModel *> *) buildingDataModles:(NSMutableArray<FYPayModeModel *> *)itemModels;

+ (NSMutableArray<FYPayModeModel *> *) buildingDataModles1;

+ (NSMutableArray<FYPayModeModel *> *) buildingDataModles2;

@end

NS_ASSUME_NONNULL_END
