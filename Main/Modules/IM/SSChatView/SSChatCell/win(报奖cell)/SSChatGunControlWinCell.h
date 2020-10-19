//
//  SSChatGunControlWinCell.h
//  ProjectCSHB
//
//  Created by Tom on 2020/6/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYChatBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSChatGunControlWinCell : FYChatBaseCell

@end
@interface FYGunControlWinModel :NSObject
//@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , assign) CGFloat              money;
@property (nonatomic , assign) NSInteger              bombCount;
@property (nonatomic , assign) NSInteger              count;
@property (nonatomic , copy) NSString              * nick;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSArray<NSString *>              * title;
@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , copy) NSString              * date;
@property (nonatomic , copy) NSString              * bomb;
@property (nonatomic , assign) CGFloat              prize;
@property (nonatomic , assign) CGFloat              handicap;

@end

NS_ASSUME_NONNULL_END
