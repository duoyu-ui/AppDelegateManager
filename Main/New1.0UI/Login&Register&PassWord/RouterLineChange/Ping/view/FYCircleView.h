//
//  FYCircleView.h
//  FY_OC
//
//  Created by FangYuan on 2020/2/2.
//  Copyright © 2020 FangYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYCircleView : UIView
@property (nonatomic, strong) CAShapeLayer *outerCircle;
@property (nonatomic, strong) CAShapeLayer *smallCircle;
@property (nonatomic, strong) CAShapeLayer *smallCircleRight;
@property (nonatomic, strong) CAShapeLayer *signalLayer;
@property (nonatomic, strong) CAShapeLayer *signalLayerShadow;
@property (nonatomic, strong) UILabel *label;

-(void)updateSignal:(NSInteger)countLine;
-(void)setCircleColor:(UIColor *)color selected:(BOOL)flag;

@end

NS_ASSUME_NONNULL_END
