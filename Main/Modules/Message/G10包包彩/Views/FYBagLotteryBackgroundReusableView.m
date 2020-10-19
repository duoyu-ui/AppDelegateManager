//
//  FYBagLotteryBackgroundReusableView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/18.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagLotteryBackgroundReusableView.h"
@interface FYBagLotteryBackgroundReusableView()
@property (nonatomic , strong) UIView *bgView;
@end
@implementation FYBagLotteryBackgroundReusableView
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    [super applyLayoutAttributes:layoutAttributes];
    if ([layoutAttributes isKindOfClass:[UICollectionViewLayoutAttributes class]]) {
        [self addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(2);
            make.bottom.mas_equalTo(-2);
            make.right.mas_equalTo(self.mas_right);

        }];
    }
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = HexColor(@"#F8F8F8");
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 8;
    }
    return _bgView;
}
@end
