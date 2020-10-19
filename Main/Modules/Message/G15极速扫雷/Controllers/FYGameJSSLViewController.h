//
//  FYGameJSSLViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGameBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FYGameJSSLViewControllerDelegate <NSObject>
- (void)didUpdateJSSLGameGroupInfoModel:(RobNiuNiuQunModel *)groupInfoModel;
@end

@interface FYGameJSSLViewController : FYGameBaseViewController

@property (nonatomic, weak) id<FYGameJSSLViewControllerDelegate> delegate_jsslgame;

@end

NS_ASSUME_NONNULL_END
