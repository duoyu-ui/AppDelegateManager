//
//  LaunchFristPageVC.h
//  Project
//
//  Created by Aalto on 2019/4/30.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "SuperViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LaunchFristPageVC : BaseVC
+(BaseNewNavViewController *)noLoginView;
//- (void)actionBlock:(ActionBlock)block;

@end

@interface FYAlertToRegister : UIView
@property(nonatomic,copy) void(^buttonCallBack)(UIButton *button);
+(void)alertShowWithResult:(void(^)(UIButton *button))callBack;
@end

@interface FYTwoButtonView : UIView
@property(nonatomic, strong) UIButton *buttonLeft;
@property(nonatomic, strong) UIButton *buttonRight;
@end

@interface FYAlertWechatBindCodeView : UIView
@property (nonatomic, strong) FYTwoButtonView *buttonView;
@property (nonatomic, strong) UITextField *textField;
@property(nonatomic,copy) void(^buttonCallBack)(UIButton *button,NSString *code);
@end

@interface FYAlertCloseTipsView : UIView
@property (nonatomic,strong) UILabel *message;
@property(nonatomic,copy) void(^buttonCallBack)(UIButton *button);
@property (nonatomic, strong) FYTwoButtonView *buttonView;
+ (void)alertShowFromVC:(UIViewController *)vc result:(void (^)(UIButton * _Nonnull))callBack;
@end

@interface FYAlertDangerView : UIView
+ (void)alertShowFromVC:(UIViewController *)vc result:(void (^)(UIButton * _Nonnull))callBack;
@end

@interface FYAlertBindPhoneView : UIView

@end



NS_ASSUME_NONNULL_END
