//
//  StateView.m
//  Project
//
//  Created by mac on 2018/8/27.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "StateView.h"

@interface StateView()

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, copy) CDStateHandleBlock handle;
/// 占位视图点击
@property (nonatomic, copy) CDStateTapHandleBlock tapBlock;

@end


@implementation StateView


+ (instancetype)StateViewWithHandle:(CDStateHandleBlock)handle{
    StateView *view = [StateView new];
    view.handle = handle;
    return view;
}

+ (instancetype)stateWithTapHandle:(CDStateTapHandleBlock)block {
    StateView *view = [StateView new];
    view.stateLabel.userInteractionEnabled = YES;
    view.tapBlock = block;
    return view;
}

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupSubview];
        [self makeLayout];
    }
    return self;
}

- (void)setupSubview {
    
    self.imageView = [UIImageView new];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
    
    self.stateLabel = [UILabel new];
    self.stateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.stateLabel];
    self.stateLabel.font = [UIFont systemFontOfSize2:14];
    self.stateLabel.textColor = [UIColor lightGrayColor];
    self.clipsToBounds = YES;
    
    // 添加可点击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.stateLabel addGestureRecognizer:tap];
}

- (void)makeLayout {
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-100);
        make.width.height.equalTo(@150);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom);
        make.centerX.equalTo(self);
        make.height.equalTo(@40);
    }];
}


- (void)hidState {
    [UIView animateWithDuration:0.15 animations:^{
        self.hidden = YES;
    }];
}

- (void)showNetError {
    [self showImage:[UIImage imageNamed:@"state_netError"] title:NSLocalizedString(@"网络开小差了，请检查网络", nil)];
}

- (void)showNetError:(NSString *)errmsg {
    [self showImage:[UIImage imageNamed:@"state_netError"] title:errmsg];
}

- (void)showEmpty {
    [self showImage:[UIImage imageNamed:@"state_empty"] title:NSLocalizedString(@"暂无内容", nil)];
}

- (void)showEmpty:(NSString *)title {
    [self showImage:[UIImage imageNamed:@"state_empty"] title:title];
}

- (void)showImage:(UIImage *)image title:(NSString *)title {
    CGRect frame = self.superview.bounds;
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scroll = (UIScrollView *)self.superview;
        frame = CGRectMake(frame.origin.x, frame.origin.y+scroll.contentSize.height + 64, frame.size.width, frame.size.height-scroll.contentSize.height - 64);
    }
    self.frame = frame;
    [self makeLayout];
    self.imageView.image = image;
    self.stateLabel.text = title;
    self.hidden = NO;
}

#pragma mark - Action

- (void)tapAction {
    if (self.tapBlock) {
        self.tapBlock();
    }
}


@end
