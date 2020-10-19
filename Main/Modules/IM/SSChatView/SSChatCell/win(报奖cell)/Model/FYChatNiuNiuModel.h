//
//  FYChatNiuNiuModel.h
//  ProjectCSHB
//
//  Created by Tom on 2020/6/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface FYChatNiuNiuData :NSObject
@property (nonatomic , copy) NSString              * money;
@property (nonatomic , copy) NSString              * handicap;
@property (nonatomic , assign) NSInteger              bank;
@property (nonatomic , copy) NSString              * bet;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * str;

@end
@interface FYChatNiuNiuModel : NSObject
@property (nonatomic , copy) NSArray<NSString *>              * msg;
@property (nonatomic , copy) NSArray<FYChatNiuNiuData *>              * data;
@property (nonatomic , assign) NSInteger              type;

@end

NS_ASSUME_NONNULL_END
