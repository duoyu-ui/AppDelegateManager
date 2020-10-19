//
//  FYBaiRenNNRecordModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBaiRenNNRecordModel.h"

@implementation FYBaiRenNNRecordSubDetailModel

@end

@implementation FYBaiRenNNRecordModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id"
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"result" : @"FYBaiRenNNRecordSubDetailModel"
    };
}

@end

