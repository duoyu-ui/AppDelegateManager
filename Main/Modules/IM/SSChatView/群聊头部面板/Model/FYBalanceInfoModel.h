//
//  FYBalanceInfoModel.h
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/1.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYBalanceInfoModel : NSObject
//@property (nonatomic , assign) NSInteger              id;
//冻结金额
@property (nonatomic , assign) CGFloat              frozenMoney;
@property (nonatomic , assign) NSInteger              userId;
//余额
@property (nonatomic , assign) CGFloat              balance;
@property (nonatomic , assign) NSInteger              version;

@end

NS_ASSUME_NONNULL_END
