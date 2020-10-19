//
//  FYActivityModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYActivityModel : NSObject

@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, strong) NSNumber *hide;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *delFlag;

@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *bodyImg;
@property (nonatomic, copy) NSString *mainTitle;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *beginDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *lastUpdateTime;
@property (nonatomic , copy) NSString *linkUrl;
@end

NS_ASSUME_NONNULL_END
