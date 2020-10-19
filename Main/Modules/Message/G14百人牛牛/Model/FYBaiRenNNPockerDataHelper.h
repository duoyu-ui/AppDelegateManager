//
//  FYBaiRenNNPockerDataHelper.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FYBestWinsLossesFlopResult;

NS_ASSUME_NONNULL_BEGIN

#define POCKER_DATA_HELPER [FYBaiRenNNPockerDataHelper sharedInstance]

@interface FYBaiRenNNPockerDataHelper : NSObject

@property (nonatomic, strong) FYBestWinsLossesFlopResult * flopResult;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
