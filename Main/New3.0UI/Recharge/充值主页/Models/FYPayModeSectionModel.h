//
//  FYPayModeSectionModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/18.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FYPayModeModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYPayModeSectionModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray<FYPayModeModel *> *list;

+ (NSMutableArray<FYPayModeSectionModel *> *) buildingDataModles;

@end

NS_ASSUME_NONNULL_END
