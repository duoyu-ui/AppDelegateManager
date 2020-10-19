//
//  FYBalanceInfoView.h
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/28.
//  Copyright © 2019 CDJay. All rights reserved.
//  抢庄牛牛显示余额,冻结金额

#import <UIKit/UIKit.h>
#import "FYBalanceInfoModel.h"

typedef void (^goBalance)(void);

@interface FYBalanceInfoView : UIView

@property (nonatomic, copy) NSString *title;

+ (void)showTitle:(NSString *)title balanceInfo:(FYBalanceInfoModel *)info block:(goBalance)block;

@end


