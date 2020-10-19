//
//  SendRedCheckBalanceHelper.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/4.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SendRedCheckBalanceHelper : NSObject

/// 获取余额
+ (void)checkShowBalanceView:(NSString *)title navigation:(UINavigationController *)navigationController;

@end

NS_ASSUME_NONNULL_END
