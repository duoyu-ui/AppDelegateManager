//
//  FYJSSLFooterView.h
//  ProjectCSHB
//
//  Created by Tom on 2020/8/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FYJSSLFooterDelegate <NSObject>

///删除
- (void)jsslBetDelete;

/// 投注
- (void)jsslBetWithMoney:(NSString *)money;
/// 选择money
- (void)jsslBetSeletWithMoney:(NSString *)money;

@end
@interface FYJSSLFooterView : UIView
@property (nonatomic , weak) id<FYJSSLFooterDelegate> delegate;
@property (nonatomic , copy) NSString *singleMoneyTips;
@property (nonatomic , strong) UITextField *tf;
@property (nonatomic , strong) UILabel *moneyLab;
@property (nonatomic , strong) UIButton *betBtn;
@property (nonatomic , copy) NSString *odds;
@end

NS_ASSUME_NONNULL_END
