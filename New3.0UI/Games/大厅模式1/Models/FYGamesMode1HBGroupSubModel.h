//
//  FYGamesMode1HBGroupSubModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "MessageItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYGamesMode1HBGroupSubModel : MessageItem

@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *imageUrl;

@end

NS_ASSUME_NONNULL_END
