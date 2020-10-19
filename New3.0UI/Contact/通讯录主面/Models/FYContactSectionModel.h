//
//  FYContactSectionModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FYContactsModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYContactSectionModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSMutableArray<FYContactsModel *> *contacts;


+ (FYContactSectionModel*) buildingDataModleForFunction;

+ (FYContactSectionModel *) buildingDataModleForCustomerService;


@end

NS_ASSUME_NONNULL_END
