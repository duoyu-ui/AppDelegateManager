//
//  FYBillingQueryModle.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 查询筛选 - 子级
@interface FYBillingQueryFilterSubModle : NSObject

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, strong) NSNumber *idAuto;
@property (nonatomic, strong) NSNumber *delFlag;
@property (nonatomic, strong) NSNumber *value;

@end

// 查询筛选
@interface FYBillingQueryFilterModle : NSObject

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, strong) NSNumber *idAuto;
@property (nonatomic, strong) NSNumber *delFlag;
@property (nonatomic, strong) NSNumber *value;

@property (nonatomic, strong) NSArray<FYBillingQueryFilterSubModle *> *subItems;

@end


// 查询分类
@interface FYBillingQueryClassModle : NSObject

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, strong) NSNumber *idAuto;
@property (nonatomic, strong) NSNumber *delFlag;
@property (nonatomic, strong) NSNumber *value;

@property (nonatomic, strong) NSArray<FYBillingQueryFilterModle *> *filterItems;

@end


// 查询模型
@interface FYBillingQueryModle : NSObject

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *parentId;

@property (nonatomic, strong) NSNumber *idAuto;
@property (nonatomic, strong) NSNumber *delFlag;
@property (nonatomic, strong) NSNumber *value;

@property (nonatomic, strong) NSArray<FYBillingQueryClassModle *> *classItems;

@end

NS_ASSUME_NONNULL_END
