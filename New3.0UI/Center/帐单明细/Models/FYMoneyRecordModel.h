//
//  FYMoneyRecordModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYMoneyRecordModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *category;

+ (NSMutableArray<FYMoneyRecordModel *> *) buildingDataModles;

@end

NS_ASSUME_NONNULL_END
