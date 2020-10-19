//
//  FYContactSearchViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCBaseCoreViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FYContactSearchViewControllerDelegate <NSObject>
@optional
- (void)didContactSearchResultAtObjectModel:(id)objModel;
@end


@interface FYContactSearchViewController : CFCBaseCoreViewController

@property (nonatomic, copy) void(^cancleActionBlock)(void);

@property (nonatomic, weak) id<FYContactSearchViewControllerDelegate> delegate;

+ (instancetype)alertSearchController:(NSMutableArray *)dataSource delegate:(id<FYContactSearchViewControllerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
