//
//  FYMessageSearchViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/30.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 消息搜索
//

#import "CFCBaseCoreViewController.h"


NS_ASSUME_NONNULL_BEGIN

@protocol FYMessageSearchViewControllerDelegate <NSObject>
@optional
- (void)didMessageSearchResultAtObjectModel:(id)objModel;
@end


@interface FYMessageSearchViewController : CFCBaseCoreViewController

@property (nonatomic, copy) void(^cancleActionBlock)(void);

@property (nonatomic, weak) id<FYMessageSearchViewControllerDelegate> delegate;

+ (instancetype)alertSearchController:(NSMutableArray *)dataSource delegate:(id<FYMessageSearchViewControllerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
