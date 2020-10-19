//
//  SSChatSystemWinCell.h
//  ProjectCSHB
//
//  Created by Tom on 2020/6/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYChatBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSChatSystemWinCell : FYChatBaseCell

@end
@interface SSChatSystemWinModel:NSObject
@property (nonatomic , assign) CGFloat              money;
@property (nonatomic , copy) NSArray<NSString *>              * title;
@property (nonatomic , assign) CGFloat              award;
@property (nonatomic , copy) NSString              * user;
@end
NS_ASSUME_NONNULL_END
