//
//  FYAgentReferralsSectionHeader.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 我的下线 - 搜索会员 + 时间选择
//

#import <UIKit/UIKit.h>
#import "FYDatePickerHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FYAgentReferralsSectionHeaderDelegate <FYDatePickerHeaderViewDelegate>
@optional
/// 协议
@end

@interface FYAgentReferralsSectionHeader : FYDatePickerHeaderView

@end

NS_ASSUME_NONNULL_END

