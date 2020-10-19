//
//  FYCircleView.m
//  FY_OC
//
//  Created by FangYuan on 2020/2/2.
//  Copyright © 2020 FangYuan. All rights reserved.
//

#import "FYCircleView.h"

@implementation FYCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        NSLog(@"circle frame:%@",NSStringFromCGRect(frame));
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGPoint ppCenter=CGPointMake(frame.size.width * 0.5, frame.size.height *0.5);
        [path addArcWithCenter:ppCenter radius:ppCenter.x startAngle:M_PI_4+0.3 endAngle:M_PI_4 - 0.3 clockwise:YES];
        self.outerCircle.path = path.CGPath;
        CGPoint endpppA=[path currentPoint];
        UIBezierPath *path2=[UIBezierPath bezierPath];
        [path2 addArcWithCenter:ppCenter radius:ppCenter.x startAngle:M_PI_4-0.3 endAngle:M_PI_4 clockwise:YES];
        CGPoint endpppB=[path2 currentPoint];
        CGFloat length = sqrt(pow((endpppA.x - endpppB.x), 2) + pow((endpppA.y -endpppB.y), 2));
        length -= 5;
        
        UIBezierPath *path333= [UIBezierPath bezierPath];
        [path333 addArcWithCenter:endpppB radius:length startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        self.smallCircle.path = path333.CGPath;
        UIBezierPath *pathRigth = [UIBezierPath bezierPath];
        [pathRigth moveToPoint:CGPointMake(endpppB.x - 7, endpppB.y)];
        [pathRigth addLineToPoint:CGPointMake(endpppB.x - 2, endpppB.y + 5)];
        [pathRigth addLineToPoint:CGPointMake(endpppB.x + 7, endpppB.y - 5)];
//        [pathRigth stroke];
        self.signalLayer.bounds = CGRectMake(0, 0, frame.size.width / 2, frame.size.height / 3);
        self.signalLayer.position = CGPointMake(frame.size.width * 0.5, frame.size.height / 3);
        self.signalLayerShadow.bounds = CGRectMake(0, 0, frame.size.width / 2, frame.size.height / 3);
        self.signalLayerShadow.position = CGPointMake(frame.size.width * 0.5, frame.size.height / 3);
        self.label.frame = CGRectMake(0, frame.size.height *0.6, frame.size.width, 30);
        self.smallCircleRight.path = pathRigth.CGPath;
    }
    return self;
}

-(void)updateSignal:(NSInteger)countLine{
    CGFloat maxLength = self.signalLayer.bounds.size.width;
    CGFloat maxHeight = self.signalLayer.bounds.size.height;
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    CGFloat steperLength = maxLength / 5;
    CGFloat steperHeight = maxHeight / 4;
    for (int i = 1; i<5; i++) {
        CGPoint currentPoint = CGPointMake(i*steperLength, maxHeight - steperHeight * i);
        if (countLine < i) {
            [path2 moveToPoint:CGPointMake(i*steperLength , maxHeight - 3)];
            [path2 addLineToPoint:currentPoint];
        }else{
            [path moveToPoint:CGPointMake(i*steperLength, maxHeight - 3)];
            [path addLineToPoint:currentPoint];
        }
    }
    self.signalLayer.path = path.CGPath;
    self.signalLayerShadow.path = path2.CGPath;
}

-(void)setCircleColor:(UIColor *)color selected:(BOOL)flag{
    UIColor *white=[UIColor whiteColor];
    if (flag) {
        self.smallCircle.strokeColor = white.CGColor;
//        self.smallCircleRight.strokeColor = white.CGColor;
//        self.smallCircleRight.fillColor = white.CGColor;
        self.outerCircle.strokeColor = white.CGColor;
        self.signalLayer.strokeColor = white.CGColor;
        self.signalLayerShadow.strokeColor = white.CGColor;
        self.label.textColor = white;
        self.smallCircle.fillColor = color.CGColor;
        self.outerCircle.fillColor = color.CGColor;
        self.signalLayer.fillColor = color.CGColor;
        self.signalLayerShadow.fillColor = color.CGColor;
    }else{
        self.smallCircle.strokeColor = color.CGColor;
//        self.smallCircleRight.strokeColor = color.CGColor;
        self.outerCircle.strokeColor = color.CGColor;
        self.signalLayer.strokeColor = color.CGColor;
        self.signalLayerShadow.strokeColor = color.CGColor;
        self.label.textColor = color;
        self.smallCircle.fillColor = white.CGColor;
        
        self.outerCircle.fillColor = white.CGColor;
        self.signalLayer.fillColor = white.CGColor;
        self.signalLayerShadow.fillColor = white.CGColor;
        
//        self.smallCircleRight.fillColor = color.CGColor;
    }
    
}

- (UILabel *)label{
    if (!_label) {
        _label=[UILabel new];
        _label.font = [UIFont systemFontOfSize:16];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return _label;
}

- (CAShapeLayer *)signalLayer{
    if (!_signalLayer) {
        _signalLayer=[CAShapeLayer layer];
        _signalLayer.lineWidth = 5;
        _signalLayer.lineCap=kCALineCapRound;
        _signalLayer.fillColor = [UIColor redColor].CGColor;
        [self.layer addSublayer:_signalLayer];
    }
    return _signalLayer;
}

- (CAShapeLayer *)signalLayerShadow{
    if (!_signalLayerShadow) {
        _signalLayerShadow=[CAShapeLayer layer];
        _signalLayerShadow.lineWidth = 5;
        _signalLayerShadow.lineCap=kCALineCapRound;
        _signalLayerShadow.fillColor = [UIColor redColor].CGColor;
        _signalLayerShadow.opacity = 0.1;
        [self.layer addSublayer:_signalLayerShadow];
    }
    return _signalLayerShadow;
}

- (CAShapeLayer *)smallCircle{
    if (!_smallCircle) {
        _smallCircle=[CAShapeLayer layer];
        _smallCircle.lineWidth = 2;
        _smallCircle.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:_smallCircle];
    }
    return _smallCircle;
}

- (CAShapeLayer *)smallCircleRight{
    if (!_smallCircleRight) {
        _smallCircleRight=[CAShapeLayer layer];
        _smallCircleRight.lineWidth = 2;
        _smallCircleRight.strokeColor = UIColor.whiteColor.CGColor;
        _smallCircleRight.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:_smallCircleRight];
    }
    return _smallCircleRight;
}

- (CAShapeLayer *)outerCircle{
    if (!_outerCircle) {
        _outerCircle=[CAShapeLayer layer];
        _outerCircle.lineWidth = 2;
        _outerCircle.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:_outerCircle];
    }
    return _outerCircle;
}

@end
