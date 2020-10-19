//
//  FYBankSearchViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/9.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCBaseCoreViewController.h"
@class FYBankItemModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FYBankSearchViewControllerDelegate <NSObject>
@optional
- (void)didBankModelSearchResultAtObjectModel:(FYBankItemModel *)objModel;
@end

@interface FYBankSearchViewController : CFCBaseCoreViewController

@property (nonatomic, copy) void(^cancleActionBlock)(void);

@property (nonatomic, weak) id<FYBankSearchViewControllerDelegate> delegate;

+ (instancetype)alertSearchController:(NSMutableArray *)dataSource selected:(FYBankItemModel *)itemModel delegate:(id<FYBankSearchViewControllerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
