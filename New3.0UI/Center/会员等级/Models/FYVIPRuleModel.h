//
//  FYVIPRuleModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/12.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYVIPRuleModel : NSObject

@property (nonatomic, assign) BOOL audio;
@property (nonatomic, assign) BOOL chat;
@property (nonatomic, assign) BOOL picture;
@property (nonatomic, assign) BOOL video;
@property (nonatomic, copy) NSString *recharge;
@property (nonatomic, copy) NSString *capitalFlow;
@property (nonatomic, copy) NSString *reward;
@end

NS_ASSUME_NONNULL_END
