//
//  FYLaunchristPageFooterView.h
//  ProjectCSHB
//
//  Created by Tom on 2020/1/14.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYTextLineView;
NS_ASSUME_NONNULL_BEGIN
@protocol FYLaunchristPageLoginDelegate <NSObject>

- (void)didSeledWihtIndx:(NSInteger)index;

@end
@interface FYLaunchristPageFooterView : UIView
@property (nonatomic ,assign)id<FYLaunchristPageLoginDelegate> delegate;

@property (nonatomic, strong) FYTextLineView *textView;

-(void)updateBottomWeiXingLoginButton;
-(void)updateBottomTouristsLoginButton;

@end

@interface FYTextLineView : UIView
@property (nonatomic, strong) UILabel *label;
@end

NS_ASSUME_NONNULL_END
