//
//  FYRobNiuNIuPromptView.m
//  ProjectXZHB
//
//  Created by 汤姆 on 2019/9/27.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FYRobNiuNIuPromptView.h"
#import "NSString+Size.h"
@interface FYRobNiuNIuPromptView ()

@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic, strong) UILabel *msgLab;
@end
@implementation FYRobNiuNIuPromptView
+ (void)robNiuNIuPromptView:(UIView*)view msg:(NSArray <NSString *>*)msg{
    FYRobNiuNIuPromptView *pView = [[FYRobNiuNIuPromptView alloc]init];
    pView.hidden = !(msg.count > 0);
    [view addSubview:pView];
    NSString *m = [msg componentsJoinedByString:@" "];
    CGFloat w = [m widthWithFont:[UIFont systemFontOfSize:22] constrainedToHeight:22];
    [pView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(w + 30);
    }];
    pView.msgLab.text = m;
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgImage];
        [self.bgImage addSubview:self.msgLab];
        [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.msgLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(-5);
        }];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:2.5];
    }
    return self;
}
- (UIImageView *)bgImage{
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc]init];
        _bgImage.image = [UIImage imageNamed:@"niuNIuPromptIcon"];
    }
    return _bgImage;
}
- (UILabel *)msgLab{
    if (!_msgLab) {
        _msgLab = [[UILabel alloc]init];
        _msgLab.font = [UIFont boldSystemFontOfSize:20];
        _msgLab.textColor = UIColor.whiteColor;
    }
    return _msgLab;
}
- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgImage.alpha = 0.0;
        self.transform = CGAffineTransformMakeScale(0.001,0.001);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
