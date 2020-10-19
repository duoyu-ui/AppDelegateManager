//
//  FYJSSLGameTrendViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCTableRefreshViewController.h"
#import "FYGameJSSLViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYJSSLGameTrendViewController : CFCTableRefreshViewController <FYGameJSSLViewControllerDelegate>

- (instancetype)initWithMessageItem:(MessageItem *)messageItem;

@end

NS_ASSUME_NONNULL_END
