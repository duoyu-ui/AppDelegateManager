//
//  FYBillingRecordViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 账单
//

#import "CFCTableRefreshViewController.h"
@class FYBillingProfitLossModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FYBillingRecordViewControllerDelegate <NSObject>
@optional
//
- (void)doRefreshSectionHeaderBillingProfitLossModel:(FYBillingProfitLossModel *)billingProfitLossModel;
- (void)doRefreshSectionHeaderBillingClassButtonTitle:(NSString *)titleString;

@end


@interface FYBillingRecordViewController : CFCTableRefreshViewController

@property (nonatomic, weak) id<FYBillingRecordViewControllerDelegate> delegate_header;

@property (nonatomic, copy) NSString *selectClassId;

@end

NS_ASSUME_NONNULL_END
