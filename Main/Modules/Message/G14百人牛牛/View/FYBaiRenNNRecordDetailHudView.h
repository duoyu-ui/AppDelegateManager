//
//  FYBaiRenNNRecordDetailHudView.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYBaiRenNNRecordModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYBaiRenNNRecordDetailHudView : UIView

+ (void)showRecordDetailHudView:(FYBaiRenNNRecordModel *)recordModel params:(NSDictionary *)parameters;

@end

NS_ASSUME_NONNULL_END
