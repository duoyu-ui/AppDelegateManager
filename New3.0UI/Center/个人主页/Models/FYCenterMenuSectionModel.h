//
//  FYCenterMenuSectionModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/19.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYCenterMenuItemCategoryModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *value;
@end

@interface FYCenterMenuItemModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *selectedIcon;
@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *sort;
@property (nonatomic, strong) NSNumber *parentId;
@property (nonatomic, strong) NSNumber *openFlag;
@property (nonatomic, strong) NSArray<FYCenterMenuItemCategoryModel *> *category;
+ (NSMutableArray<FYCenterMenuItemModel *> *) buildingDataModlesForMyService;
+ (NSMutableArray<FYCenterMenuItemModel *> *) buildingDataModlesForAgentCenter;
@end

@interface FYCenterMenuReportModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *selectedIcon;
@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *sort;
@property (nonatomic, strong) NSNumber *parentId;
@property (nonatomic, strong) NSNumber *openFlag;
@property (nonatomic, strong) NSArray<FYCenterMenuItemModel *> *childList;
@end


@interface FYCenterMenuSectionModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *list;

+ (FYCenterMenuSectionModel *) buildingDataModlesForMyService;
+ (FYCenterMenuSectionModel *) buildingDataModlesForAgentCenter;
+ (NSMutableArray<FYCenterMenuSectionModel *> *) buildingDataModles;

@end

NS_ASSUME_NONNULL_END
