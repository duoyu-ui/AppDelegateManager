//
//  FYJSSLLeiNumView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYJSSLLeiNumView.h"
@interface FYJSSLLeiNumView()

@end
@implementation FYJSSLLeiNumView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgView];
        [self.imgView addSubview:self.numLab];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.imgView);
            make.centerY.equalTo(self.imgView.mas_centerY).offset(2);
        }];
    }
    return self;
}
- (UILabel *)numLab{
    if (!_numLab) {
        _numLab = [[UILabel alloc]init];
        _numLab.textColor = UIColor.whiteColor;
        _numLab.textAlignment = NSTextAlignmentCenter;
        _numLab.font = FONT_PINGFANG_BOLD(14);
    }
    return _numLab;
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.userInteractionEnabled = YES;
    }
    return _imgView;
}
@end
