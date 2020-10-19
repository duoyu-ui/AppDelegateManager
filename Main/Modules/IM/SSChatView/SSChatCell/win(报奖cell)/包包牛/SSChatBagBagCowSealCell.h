//
//  SSChatBagBagCowSealCell.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYChatBaseCell.h"

NS_ASSUME_NONNULL_BEGIN
///封盘
@interface SSChatBagBagCowSealCell : FYChatBaseCell

@end
@interface SSChatBagBagCowSealModel :NSObject
@property (nonatomic , copy) NSArray<NSString *>              * msg;
@property (nonatomic , assign) NSInteger              type;

@end
NS_ASSUME_NONNULL_END
