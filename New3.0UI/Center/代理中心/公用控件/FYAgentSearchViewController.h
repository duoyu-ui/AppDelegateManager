//
//  FYAgentSearchViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCBaseCoreViewController.h"
#import "FYAgentSearchHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYAgentSearchViewController : CFCBaseCoreViewController
//
@property (nonatomic, strong) FYAgentSearchHeaderView *searchHeaderView; // 搜索控件
@property (nonatomic, copy) NSString *searchMemberKey; // 搜索会员ID
@property (nonatomic, copy) NSString *searchTextPlaceHolder; // 搜索空白占位符

- (instancetype)initWithSearchMemberKey:(NSString *)searchMemberKey isInitSearchText:(BOOL)isInitSearchText;

@end

NS_ASSUME_NONNULL_END
