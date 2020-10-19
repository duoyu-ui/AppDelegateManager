//
//  FYGameReportSectionHeader.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYDatePickerHeaderView.h"
#import "FYGameReportViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FYGameReportSectionHeaderDelegate <FYDatePickerHeaderViewDelegate>
@optional
/// 协议
@end

@interface FYGameReportSectionHeader : FYDatePickerHeaderView <FYGameReportViewControllerDelegate>

@end

NS_ASSUME_NONNULL_END
