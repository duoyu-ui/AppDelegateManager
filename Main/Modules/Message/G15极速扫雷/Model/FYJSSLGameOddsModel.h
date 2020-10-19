//
//  FYJSSLGameOddsModel.h
//  ProjectCSHB
//
//  Created by Tom on 2020/8/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface FYJSSLGameOddsData :NSObject
@property (nonatomic , assign) NSInteger              oddVersion;
///参数
@property (nonatomic , copy) NSArray<NSNumber *>              * parameterList;
///基数
@property (nonatomic , copy) NSArray<NSNumber *>              * baseList;
///快捷输入金额
@property (nonatomic , copy) NSString *betList;
@end
///极速扫雷赔率模型
@interface FYJSSLGameOddsModel : NSObject
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , strong) FYJSSLGameOddsData              * data;
@property (nonatomic , assign) NSInteger              code;
@end


NS_ASSUME_NONNULL_END
