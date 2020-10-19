//
//  FYShareDataImageView.m
//  ProjectCSHB
//
//  Created by Tom on 2019/10/20.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "FYShareDataImageView.h"
#import "UIImageView+WebCache.h"
@interface FYShareDataImageView ()
//邀请码
@property (nonatomic ,strong)UILabel *invitationCodeLab;
//二维码
@property (nonatomic ,strong)UIImageView *qrImageView;
@property (nonatomic ,strong)UILabel *titleLab;

@end
@implementation FYShareDataImageView
- (void)setModel:(FYShareDetailModel *)model{
    _model = model;
    
    WeakSelf
    [self.shareImageView sd_setImageWithURL:[NSURL URLWithString:_model.firstAvatar] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        CGSize size = image.size;
        CGFloat imageW = size.width;
        CGFloat imageH = size.height;
        CGFloat scale = imageH / imageW;

        weakSelf.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * scale);
        weakSelf.shareImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, weakSelf.contentSize.height);
        [weakSelf.qrImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCREEN_WIDTH * scale * 0.45);
        }];
    }];
    self.qrImageView.image = CD_QrImg([NSString stringWithFormat:@"%@%@",_model.url,[AppModel shareInstance].userInfo.invitecode], 100);
    self.invitationCodeLab.text = [AppModel shareInstance].userInfo.invitecode;
    [self.copyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
         make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.shareImageView];
        [self.shareImageView addSubview:self.invitationCodeLab];
        [self.shareImageView addSubview:self.qrImageView];
        [self.shareImageView addSubview:self.invitationCodeLab];
        [self.shareImageView addSubview:self.titleLab];
        [self.shareImageView addSubview:self.copyBtn];
        [self.qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.height.mas_equalTo(100);
            make.top.mas_equalTo(200);
        }];
        [self.invitationCodeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.shareImageView);
            make.top.equalTo(self.qrImageView.mas_bottom).offset(15);
        }];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.invitationCodeLab.mas_centerY);
            make.right.mas_equalTo(self.invitationCodeLab.mas_left).offset(-20);
        }];
        [self.copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.invitationCodeLab.mas_right).offset(20);
            make.centerY.equalTo(self.invitationCodeLab.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
    }
    return self;
}
- (UIImageView *)shareImageView{
    if (!_shareImageView) {
        _shareImageView = [[UIImageView alloc]init];
        _shareImageView.userInteractionEnabled = YES;
    }
    return _shareImageView;
}
- (UILabel *)invitationCodeLab{
    if (!_invitationCodeLab) {
        _invitationCodeLab = [[UILabel alloc]init];
        _invitationCodeLab.font = [UIFont systemFontOfSize:23];
        _invitationCodeLab.textColor = UIColor.whiteColor;
    }
    return _invitationCodeLab;
}
- (UIImageView *)qrImageView{
    if (!_qrImageView) {
        _qrImageView = [[UIImageView alloc]init];
    }
    return _qrImageView;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.font = [UIFont systemFontOfSize:23];
        _titleLab.textColor = UIColor.whiteColor;
        _titleLab.text = NSLocalizedString(@"邀请码", nil);
    }
    return _titleLab;
}
- (UIButton *)copyBtn{
    if (!_copyBtn) {
        _copyBtn = [[UIButton alloc]init];
        [_copyBtn setBackgroundImage:[UIImage imageNamed:@"copyBtn"] forState:UIControlStateNormal];
    }
    return _copyBtn;
}
@end
