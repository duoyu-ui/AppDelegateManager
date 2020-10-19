//
//  FYAgentReportMenuModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/1.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYAgentReportMenuModel : NSObject

@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *name;

+ (NSMutableArray<FYAgentReportMenuModel *> *) buildingDataModles:(NSArray<NSDictionary *> *)arrayOfDicts;

@end

NS_ASSUME_NONNULL_END
