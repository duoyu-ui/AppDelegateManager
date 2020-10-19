//
//  FYGroupVerifiEntity.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/27.
//  Copyright © 2019 CDJay. All rights reserved.
//  群验证消息实体

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYGroupVerifiEntity : NSObject <NSCoding>

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *groupImg;
@property (nonatomic, copy) NSString *groupName;

/**
 * 是否为官方群
 */
@property (nonatomic, assign) BOOL groupOfficeFlag;

/**
* 用户ID
*/
@property (nonatomic, copy) NSString *userId;


+ (instancetype)initWithDict:(NSDictionary *)dict;


@end

NS_ASSUME_NONNULL_END
