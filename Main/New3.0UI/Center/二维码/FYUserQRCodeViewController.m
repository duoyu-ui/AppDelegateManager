//
//  FYUserQRCodeViewController.m
//  ProjectCSHB
//
//  Created by Tom on 2020/5/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYUserQRCodeViewController.h"
#import <Photos/Photos.h>

@interface FYUserQRCodeViewController ()
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *imageAvatar;
@property (nonatomic, strong) UIImageView *imageQRCode;
@property (nonatomic, strong) UILabel *labelName;
@property (nonatomic, strong) UILabel *labelID;
@property (nonatomic, strong) UILabel *labelIntroduction;
@property (nonatomic, strong) UILabel *labelTips;
@property (nonatomic, strong) UIButton *buttonRefresh;
@end

@implementation FYUserQRCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"我的二维码", nil);
    self.view.backgroundColor = COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT;
    
    [self mainView];
    
    UIImage *placeholderImage = [UIImage imageNamed:ICON_COMMON_PLACEHOLDER];
    if ([CFCSysUtil validateStringUrl:APPINFORMATION.userInfo.avatar]) {
        __block UIActivityIndicatorView *activityIndicator = nil;
        [self.imageAvatar sd_setImageWithURL:[NSURL URLWithString:APPINFORMATION.userInfo.avatar] placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (!activityIndicator) {
                    [self.imageAvatar addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]];
                    [activityIndicator setColor:COLOR_ACTIVITY_INDICATOR_BACKGROUND];
                    [activityIndicator setCenter:self.imageAvatar.center];
                    [activityIndicator startAnimating];
                    [activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.imageAvatar.mas_centerX);
                        make.centerY.equalTo(self.imageAvatar.mas_centerY);
                    }];
                }
            }];
        } completed:^(UIImage *insertImage, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
        }];
    } else {
        [self.imageAvatar setImage:placeholderImage];
    }
    
    self.labelName.text = [AppModel shareInstance].userInfo.nick;
    self.labelID.text = [NSString stringWithFormat:NSLocalizedString(@"用户ID: %@", nil),[AppModel shareInstance].userInfo.userId];
    self.imageQRCode.image = [UIImage imageNamed:@"icon_game_content_temp"];
    self.labelIntroduction.text = NSLocalizedString(@"出示该二维码,快速添加好友", nil);
    self.labelTips.text = NSLocalizedString(@"为防止诈骗,请勿发送给他人", nil);
    [self.buttonRefresh addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

    {
        UIButton *button = [self createButtonWithImage:@"icon_more_square_black"
                                                target:self
                                                action:@selector(buttonAction:)
                                            offsetType:CFCNavBarButtonOffsetTypeRight
                                             imageSize:NAVIGATION_BAR_BUTTON_IMAGE_SIZE*0.8f];
        [button setTag:2];
        UIBarButtonItem *rightNavItem=[[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = rightNavItem;
    }
    
    [self HTTPGetShareQRCodeInfoThen:^(NSString *shareUrl) {
        
    }];
}

- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag == 1) {
        [self HTTPGetShareQRCodeInfoThen:^(NSString *shareUrl) {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"刷新成功", nil))
        }];
    } else if (sender.tag == 2) {
       WEAKSELF(weakSelf)
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"保存图片", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf  saveQRCodeImage];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)saveQRCodeImage
{
    UIImage *tempImage = self.imageQRCode.image;
    if (tempImage) {
        NSError *error;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            [PHAssetChangeRequest creationRequestForAssetFromImage:tempImage];
        } error:&error];
        
        if (error) {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"保存图片失败", nil))
        } else {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"保存图片成功", nil))
        }
    } else {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"保存图片失败", nil))
    }
}

-(UIView *)mainView{
    if (!_mainView) {
        _mainView=[UIView new];
        _mainView.backgroundColor = [UIColor whiteColor];
        _mainView.layer.cornerRadius = 5;
        [self.view addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.top.mas_equalTo(30);
            make.right.mas_equalTo(-30);
        }];
    }
    return _mainView;
}

-(UIImageView *)imageAvatar{
    if (!_imageAvatar) {
        _imageAvatar=[UIImageView new];
        _imageAvatar.layer.cornerRadius = 23;
        _imageAvatar.clipsToBounds = YES;
        [self.mainView addSubview:_imageAvatar];
        [_imageAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.top.mas_equalTo(30);
            make.size.mas_equalTo(CGSizeMake(46, 46));
        }];
    }
    return _imageAvatar;
}

-(UIImageView *)imageQRCode{
    if (!_imageQRCode) {
        _imageQRCode=[UIImageView new];
        [self.mainView addSubview:_imageQRCode];
        [_imageQRCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.imageAvatar.mas_bottom).mas_offset(20);
            CGFloat width = SCREEN_WIDTH - 110;
            make.size.mas_equalTo(CGSizeMake(width, width));
        }];
    }
    return _imageQRCode;
}

-(UILabel *)labelName{
    if (!_labelName) {
        _labelName=[UILabel new];
        _labelName.font = FONT_PINGFANG_SEMI_BOLD(16);
        _labelName.textColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
        [self.mainView addSubview:_labelName];
        [_labelName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageAvatar.mas_right).offset(10);
            make.bottom.equalTo(self.imageAvatar.mas_centerY);
            make.right.mas_equalTo(-30);
        }];
    }
    return _labelName;
}

-(UILabel *)labelID{
    if (!_labelID) {
        _labelID=[UILabel new];
        _labelID.font = FONT_PINGFANG_REGULAR(14);
        _labelID.textColor = COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT;
        [self.mainView addSubview:_labelID];
        [_labelID mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageAvatar.mas_right).offset(10);
            make.top.equalTo(self.labelName.mas_bottom).offset(2.5f);
            make.right.mas_equalTo(-30);
        }];
    }
    return _labelID;
}

- (UILabel *)labelIntroduction{
    if (!_labelIntroduction) {
        _labelIntroduction=[UILabel new];
        _labelIntroduction.font=FONT_PINGFANG_SEMI_BOLD(14);
        _labelIntroduction.textColor=COLOR_SYSTEM_MAIN_FONT_DEFAULT;
        [self.mainView addSubview:_labelIntroduction];
        [_labelIntroduction mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageQRCode.mas_left);
            make.top.mas_equalTo(self.imageQRCode.mas_bottom).mas_offset(15);
            make.height.mas_equalTo(20);
        }];
    }
    return _labelIntroduction;
}

-(UILabel *)labelTips{
    if (!_labelTips) {
        _labelTips=[UILabel new];
        _labelTips.font=FONT_PINGFANG_REGULAR(12);
        _labelTips.textColor=COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT;
        [self.mainView addSubview:_labelTips];
        [_labelTips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.labelIntroduction.mas_left);
            make.height.mas_equalTo(15);
            make.top.mas_equalTo(self.labelIntroduction.mas_bottom).mas_offset(5);
        }];
    }
    return _labelTips;
}

-(UIButton *)buttonRefresh{
    if (!_buttonRefresh) {
        _buttonRefresh=[UIButton new];
        _buttonRefresh.tag = 1;
        UIImage *image = [[UIImage imageNamed:@"icon_code_refresh"] imageByScalingProportionallyToSize:CGSizeMake(25, 25)];
        [_buttonRefresh setImage:image forState:UIControlStateNormal];
        [_buttonRefresh setTitle:NSLocalizedString(@"刷新", nil) forState:UIControlStateNormal];
        [_buttonRefresh setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _buttonRefresh.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.mainView addSubview:_buttonRefresh];
        [_buttonRefresh mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(60);
            make.top.mas_equalTo(self.labelTips.mas_bottom);
            make.left.right.bottom.mas_equalTo(self.mainView);
        }];
    }
    return _buttonRefresh;
}

- (void)HTTPGetShareQRCodeInfoThen:(void (^)(NSString *shareUrl))then
{
    WEAKSELF(weakSelf)
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER getShareUrlWithCode:@"1" success:^(id object) {
        PROGRESS_HUD_DISMISS
        NSInteger code=[[object valueForKey:@"code"] integerValue];
        if (code == 0) {
            NSString *baseUrl = [object valueForKey:@"data"];
            NSString *qrCode = [AppModel shareInstance].userInfo.invitecode;
            NSString *shareUrl = [NSString stringWithFormat:@"%@%@", baseUrl, qrCode];
            CGFloat qrSize = SCREEN_WIDTH - 120;
            [weakSelf createQRCodeImage:shareUrl qrSize:qrSize then:^(UIImage *qrImage) {
                weakSelf.imageQRCode.image = qrImage;
            }];
            !then ?: then(shareUrl);
        }
    } fail:^(id object) {
        PROGRESS_HUD_DISMISS
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

- (void)createQRCodeImage:(NSString *)qrCodeUrl qrSize:(CGFloat)qrSize then:(void (^)(UIImage *qrImage))then
{
    CGFloat radius = 5.0f;
    CGFloat insertImageSize = qrSize*0.2f;
    NSString *insertImageUrl = @"icon_avatar_default";
    if ([CFCSysUtil validateStringUrl:APPINFORMATION.userInfo.avatar]) {
        UIImage *placeholderImage = [UIImage imageNamed:ICON_COMMON_PLACEHOLDER];
        NSURL *imageUrl = [NSURL URLWithString:APPINFORMATION.userInfo.avatar];
        [self.imageQRCode sd_setImageWithURL:imageUrl placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

        } completed:^(UIImage *insertImage, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            UIImage * qrImage = [UIImage imageOfQRFromString:qrCodeUrl codeSize:qrSize insertImage:insertImage insertSize:insertImageSize roundRadius:radius];
            !then ?: then(qrImage);
        }];
    } else {
        UIImage *insertImage = [UIImage imageNamed:insertImageUrl];
        UIImage * qrImage = [UIImage imageOfQRFromString:qrCodeUrl codeSize:qrSize insertImage:insertImage insertSize:insertImageSize roundRadius:radius];
        !then ?: then(qrImage);
    }
}


@end

