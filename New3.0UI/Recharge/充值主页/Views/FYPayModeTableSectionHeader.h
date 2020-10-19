//
//  FYPayModeTableSectionHeader.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/18.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FYPayModeTableSectionHeaderDelegate <NSObject>
@optional
- (void)didSelectAtPayModeTableSecionHeader:(NSInteger)tableSection;
@end


@interface FYPayModeTableSectionHeader : UIView

@property (nonatomic, weak) id<FYPayModeTableSectionHeaderDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title headerViewHeight:(CGFloat)headerViewHeight showMoreButton:(BOOL)isShowMoreButton tableSecion:(NSInteger)tableSection;

@end


NS_ASSUME_NONNULL_END
