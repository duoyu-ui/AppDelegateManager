//
//  SSChatBastNiuNiuWinCell.h
//  ProjectCSHB
//
//  Created by Tom on 2020/8/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYChatBaseCell.h"


NS_ASSUME_NONNULL_BEGIN
///百人牛牛报奖
@interface SSChatBastNiuNiuWinCell : FYChatBaseCell

@end
@interface SSChatBastNiuNiuWinModel :NSObject
@property (nonatomic , copy) NSArray<NSString *>              * msg;
@property (nonatomic , assign) NSInteger              type;
@end
NS_ASSUME_NONNULL_END
