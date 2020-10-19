//
//  FYGamesBannerModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYGamesBannerModel : NSObject

@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, strong) NSNumber *advSpaceId;
@property (nonatomic, strong) NSNumber *linkType;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *advPicUrl;
@property (nonatomic, copy) NSString *advLinkUrl;

+ (NSMutableArray<FYGamesBannerModel *> *) buildingDataModles;

@end

NS_ASSUME_NONNULL_END
