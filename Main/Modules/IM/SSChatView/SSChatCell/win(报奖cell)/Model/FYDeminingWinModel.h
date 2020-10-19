//
//  FYDeminingWinModel.h
//  ProjectCSHB
//
//  Created by Tom on 2020/6/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface SSChatDeminingWinGrabList :NSObject
@property (nonatomic , assign) BOOL              bombFlag;
@property (nonatomic , assign) CGFloat              money;
@property (nonatomic , copy) NSString              * nick;
@property (nonatomic , copy) NSString              * moneyGet;

@end
@interface FYDeminingWinModel : NSObject
@property (nonatomic , copy) NSString              * bombCountExplode;
@property (nonatomic , assign) CGFloat              money;
///总包数
@property (nonatomic , assign) NSInteger              bombCount;
@property (nonatomic , copy) NSString              * nick;
@property (nonatomic , copy) NSArray<NSString *>              * title;
@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , copy) NSString              * date;
///过期时间
@property (nonatomic , copy) NSString              * leftTime;
///剩余红包金额
@property (nonatomic , copy) NSString              * left;
@property (nonatomic , assign) NSInteger              createTime;
///庄家赔付
@property (nonatomic , assign) CGFloat              moneyPaid;
@property (nonatomic , assign) CGFloat              handicap;
@property (nonatomic , copy) NSArray<SSChatDeminingWinGrabList *>              * grabList;
@end

NS_ASSUME_NONNULL_END
