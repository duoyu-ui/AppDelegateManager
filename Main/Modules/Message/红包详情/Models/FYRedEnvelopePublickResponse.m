//
//  FYRedEnvelopePublickResponse.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYRedEnvelopePublickResponse.h"

@implementation FYRedEnvelopePubickDetailModel

@end

@implementation FYRedEnvelopePubickGrabModel

@end

@implementation FYRedEnvelopePubickData

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"items" : @"skRedbonusGrabModels"
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"items" : @"FYRedEnvelopePubickGrabModel"
    };
}

@end

@implementation FYRedEnvelopePublickResponse

@end
