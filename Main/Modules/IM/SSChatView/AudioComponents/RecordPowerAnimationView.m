//
//  RecordPowerAnimationView.m
//  AudioModel
//
//  Created by Tom on 2020/7/6.
//  Copyright © 2020 Tom. All rights reserved.
//

#import "RecordPowerAnimationView.h"
@interface RecordPowerAnimationView()
@property (nonatomic, strong) UIImageView *imgContent;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@end
@implementation RecordPowerAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.imgContent = [[UIImageView alloc] init];
        self.imgContent.image = [UIImage imageNamed:@"ic_record_ripple"];
        [self addSubview:self.imgContent];
        
        self.maskLayer = [[CAShapeLayer alloc] init];
        self.maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.imgContent.frame = self.bounds;
}
- (void)updateWithPower:(float)power{
    int viewCount = ceil(fabs(power) * 10);
    if (viewCount == 0) {
        viewCount++;
    }
    if (viewCount >= 9) {
        viewCount = 9;
    }
    CGFloat itemHeight = 5.5;
    CGFloat maskPadding = itemHeight * viewCount;
    //从下面往上画线
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, self.imgContent.frame.size.height, self.imgContent.frame.size.width, -maskPadding)];
    self.maskLayer.path = path.CGPath;
    self.imgContent.layer.mask = self.maskLayer;
}
@end
