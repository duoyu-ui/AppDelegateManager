//
//  FYSystemMessageController.h
//  ProjectCSHB
//
//  Created by Tom on 2020/6/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCBaseCoreViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYSystemNewMessageController : CFCBaseCoreViewController

/* 会话ID */
@property(nonatomic, copy) NSString *sessionId;

- (id)initWithSessionId:(NSString *)sessionId;

@end

NS_ASSUME_NONNULL_END
