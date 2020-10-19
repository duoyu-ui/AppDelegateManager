//
//  SSChatRopPromptCell.h
//  ProjectCSHB
//
//  Created by Tom on 2020/6/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYChatBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSChatRopPromptCell : FYChatBaseCell


@end
@interface SSChatRopPromptModel:NSObject
@property (nonatomic , copy) NSArray<NSString *>              * msg;
@property (nonatomic , assign) NSInteger              type;

@end
NS_ASSUME_NONNULL_END
