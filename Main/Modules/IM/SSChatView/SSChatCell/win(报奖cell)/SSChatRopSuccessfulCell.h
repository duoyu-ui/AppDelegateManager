//
//  SSChatRopSuccessfulCell.h
//  ProjectCSHB
//
//  Created by Tom on 2020/6/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYChatBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSChatRopSuccessfulCell : FYChatBaseCell

@end
@interface SSChatRopSuccessfulModel : NSObject
@property (nonatomic , copy) NSArray<NSString *>              * msg;
@property (nonatomic , assign) NSInteger              type;

@end
NS_ASSUME_NONNULL_END
