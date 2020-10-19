//
//  FYBillingRecordModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/20.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYBillingRecordModel : NSObject

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *title; // 筛选类型
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *linkUrl;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *levelList;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *infoId;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *billtId;

+ (NSMutableArray<FYBillingRecordModel *> *) buildingDataModles;

@end

NS_ASSUME_NONNULL_END
