//
//  FYNiuNiuWinModel.h
//  ProjectCSHB
//
//  Created by Tom on 2020/6/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYNiuNiuWinBankerGrab :NSObject
@property (nonatomic , copy) NSString              * score;
@property (nonatomic , copy) NSString              * nick;
@property (nonatomic , copy) NSString              * handicap;
@property (nonatomic , assign) CGFloat              winMoney;
@property (nonatomic , assign) NSInteger              userId;

@end

@interface FYNiuNiuWinGrabList :NSObject
@property (nonatomic , copy) NSString              * score;
@property (nonatomic , copy) NSString              * nick;
@property (nonatomic , copy) NSString              * handicap;
@property (nonatomic , assign) CGFloat              winMoney;
@property (nonatomic , assign) NSInteger              userId;

@end

@interface FYNiuNiuWinModel :NSObject
@property (nonatomic , copy) NSString              * result;
@property (nonatomic , strong) FYNiuNiuWinBankerGrab              * bankerGrab;
@property (nonatomic , copy) NSArray<FYNiuNiuWinGrabList *>              * grabList;

@property (nonatomic , copy) NSArray<NSString *>              * gameOver;
@property (nonatomic , copy) NSArray<NSString *>              * title;
@property (nonatomic , copy) NSString              * date;

@end

NS_ASSUME_NONNULL_END
