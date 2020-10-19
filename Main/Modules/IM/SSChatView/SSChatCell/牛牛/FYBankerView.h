//
//  FYBankerView.h
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/2.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYBankerModel.h"
//放弃还是继续坐庄 money : 0:放弃 大于0:继续
typedef void(^giveUpContinueBlock)(NSInteger money);
/**
 连续上庄页面
 */
@interface FYBankerView : UIView
+ (void)showBankerModel:(FYBankerModel*)model view:(UIView*)view block:(giveUpContinueBlock)block;
+ (void)bankDismiss;
@end

