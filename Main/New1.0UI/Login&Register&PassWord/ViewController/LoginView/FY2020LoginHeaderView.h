//
//  FY2020LoginHeaderView.h
//  FY_OC
//
//  Created by FangYuan on 2020/1/30.
//  Copyright © 2020 FangYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FY2020LoginHeaderView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *buttonLeft;
@property (nonatomic, strong) UIButton *buttonRight;
@property (nonatomic, strong) UIView *redIndicator;
@property (nonatomic, strong) NSLayoutConstraint *redCenter;
@property (nonatomic, strong) UIButton *currentButton;
@property (nonatomic, copy) void(^buttonCallBack)(UIButton *btn);

-(void)buttonAction:(UIButton *)sender;
-(void)updateIndicator;
@end

NS_ASSUME_NONNULL_END
