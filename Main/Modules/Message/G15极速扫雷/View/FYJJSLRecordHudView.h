//
//  FYJJSLRecordHudView.h
//  ProjectCSHB
//
//  Created by Tom on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYJSSLRecordData.h"
NS_ASSUME_NONNULL_BEGIN
///极速扫雷-历史弹窗
@interface FYJJSLRecordHudView : UIView
+ (void)showJSSLRecordWithData:(NSArray<FYJSSLRecordData*>*)data;

@end

NS_ASSUME_NONNULL_END
