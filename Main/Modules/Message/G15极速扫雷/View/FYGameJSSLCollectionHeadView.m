//
//  FYGameJSSLCollectionHeadView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/8/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGameJSSLCollectionHeadView.h"
@interface FYGameJSSLCollectionHeadView()
@property (nonatomic , strong) UIImageView *imgView;
@end
@implementation FYGameJSSLCollectionHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.top.equalTo(self.mas_top).offset(3);
            make.width.equalTo(self.mas_width).offset(-10);
        }];
        NSArray <NSString *>*titles = @[NSLocalizedString(@"万", nil),
                           NSLocalizedString(@"千", nil),
                           NSLocalizedString(@"百", nil),
                           NSLocalizedString(@"十", nil),
                           NSLocalizedString(@"个", nil)];
        NSMutableArray <UILabel*>*labs = [NSMutableArray array];
        [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *lab = [[UILabel alloc]init];
            [self addSubview:lab];
            lab.text = title;
            lab.font = [UIFont systemFontOfSize:12];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = HexColor(@"#6B6B6B");
            [labs addObj:lab];
        }];
        [labs mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        [labs mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.equalTo(self);
        }];
    }
    return self;
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.image = [UIImage imageNamed:@"jssl_game_title_icon"];
    }
    return _imgView;
}
@end
