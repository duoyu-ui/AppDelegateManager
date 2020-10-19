//
//  FYPersonStaticSectionHeader.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYDatePickerHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FYPersonStaticSectionHeaderDelegate <FYDatePickerHeaderViewDelegate>
@optional
/// 协议
@end

@interface FYPersonStaticSectionHeader : FYDatePickerHeaderView

@end

NS_ASSUME_NONNULL_END
