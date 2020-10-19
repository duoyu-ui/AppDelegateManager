//
//  FYJSSLMachineSelecteView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/8/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYJSSLMachineSelecteView.h"
@interface FYJSSLMachineSelecteView ()
@property (nonatomic , strong) NSMutableArray <UIButton*>*btnArr;
@property (nonatomic , strong) NSMutableArray <UILabel*>*labArr;
@end
@implementation FYJSSLMachineSelecteView
- (void)setModel:(FYJSSLSelecteModel *)model{
    _model = model;
    [self.btnArr enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        [btn setBackgroundImage:[UIImage imageNamed:model.images[idx]] forState:UIControlStateNormal];
        self.labArr[idx].text = model.titles[idx];
    }];
}
+ (CGFloat)headerViewHeight
{
    return [self heightOfButton] * 3;
}
+ (CGFloat)heightOfButton
{
    return 70;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}
-(void)initSubView{
    for (int i = 0; i< 3; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = i;
        [self addSubview:btn];
        [btn addTarget:self action:@selector(randomSelection:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(self.mas_width).multipliedBy(0.6f);
            make.top.equalTo(self.mas_top).offset(i * [[self class] heightOfButton]);
            make.centerX.equalTo(self);
        }];
        //
        UILabel *lab = [[UILabel alloc]init];
        [self addSubview:lab];
        lab.font = FONT_PINGFANG_REGULAR(14);
        lab.textColor = HexColor(@"#1A1A1A");
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(btn.mas_bottom).offset(3);
        }];
        [self.btnArr addObj:btn];
        [self.labArr addObj:lab];
    }
}
- (void)randomSelection:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(gameJSSLMachineSelecteWithView:row:)]) {
        [self.delegate gameJSSLMachineSelecteWithView:self row:sender.tag];
    }
}
- (NSMutableArray<UIButton *> *)btnArr{
    if (!_btnArr) {
        _btnArr = [NSMutableArray<UIButton*> array];
    }
    return _btnArr;
}
- (NSMutableArray<UILabel *> *)labArr{
    if (!_labArr) {
        _labArr = [NSMutableArray<UILabel*> array];
    }
    return _labArr;
}
@end
@implementation FYJSSLSelecteModel

+ (FYJSSLSelecteModel *)setMachineSelecte{
    FYJSSLSelecteModel *model = [[FYJSSLSelecteModel alloc]init];
    model.titles = @[
    NSLocalizedString(@"机选3x1", nil),
    NSLocalizedString(@"机选1x3", nil),
    NSLocalizedString(@"机选5x1", nil)];
    model.images = @[
        @"jssl_san_yi_Selete_icon",
        @"jssl_yi_san_Selete_icon",
        @"jssl_wuSelete_icon"
    ];
    return model;
}
+ (FYJSSLSelecteModel *)setGamedataModel{
    FYJSSLSelecteModel *model = [[FYJSSLSelecteModel alloc]init];
    model.titles = @[
        NSLocalizedString(@"活动", nil),
        NSLocalizedString(@"走势", nil),
        NSLocalizedString(@"记录", nil)];
    model.images = @[
        @"jssl_huodong_icon",
        @"jssl_zoushi_icon",
        @"jssl_jilu_icon"
    ];
    return model;
}
@end
