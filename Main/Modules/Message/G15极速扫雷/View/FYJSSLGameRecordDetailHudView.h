//
//  FYJSSLGameRecordDetailHudView.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYJSSLGameRecordModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYJSSLGameRecordDetailHudView : UIView

+ (void)showRecordDetailHudView:(FYJSSLGameRecordModel *)recordModel params:(NSDictionary *)parameters;

@end

NS_ASSUME_NONNULL_END
