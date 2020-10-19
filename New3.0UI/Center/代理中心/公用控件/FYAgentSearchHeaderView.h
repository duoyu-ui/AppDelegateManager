//
//  FYAgentSearchHeaderView.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FYAgentSearchHeaderViewDelegate <NSObject>
@optional
- (void)didAgentHeaderSearchByKeyword:(NSString *)keyword isSearch:(BOOL)isSeach;
- (void)didAgentHeaderSearchUserHeaderPicture;
@end

@interface FYAgentSearchHeaderView : UIView

@property (nonatomic, weak) id<FYAgentSearchHeaderViewDelegate> delegate;

+ (CGFloat)headerViewHeight;

- (instancetype)initWithFrame:(CGRect)frame searchMemberKey:(NSString *)searchMemberKey delegate:(id<FYAgentSearchHeaderViewDelegate>)delegate;

- (void)createViewAtuoLayout;

- (void)createViewSearchAtuoLayout;

- (void)endEditing;

- (void)doRefreshSearchKey:(NSString *)userId userName:(NSString *)username usertype:(NSNumber *)usertype headIcon:(NSString *)headIcon searchText:(NSString *)searchText;

@end

NS_ASSUME_NONNULL_END
