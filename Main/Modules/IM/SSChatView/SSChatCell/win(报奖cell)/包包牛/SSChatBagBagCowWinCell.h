//
//  SSChatBagBagCowWinCell.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYChatBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSChatBagBagCowWinCell : FYChatBaseCell

@end
@interface SSChatBagBagCowWinData :NSObject
@property (nonatomic , copy) NSString              * money;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , assign) NSInteger              niu;

@end

@interface SSChatBagBagCowWinModel :NSObject
@property (nonatomic , copy) NSArray<SSChatBagBagCowWinData *>              * data;
@property (nonatomic , copy) NSArray<NSString *>              * msg;
@property (nonatomic , assign) NSInteger              type;
@property (nonatomic , copy) NSString              * gameNumber;

@end

NS_ASSUME_NONNULL_END
