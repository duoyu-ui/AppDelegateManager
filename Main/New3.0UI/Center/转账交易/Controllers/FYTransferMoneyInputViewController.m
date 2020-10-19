//
//  FYTransferMoneyInputViewController.m
//  ProjectCSHB
//
//  Created by Tom on 2020/5/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYTransferMoneyInputViewController.h"
#import "FYHTTPResponseModel.h"

@interface FYTransferMoneyInputViewController ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *grayLine;
@property (nonatomic, strong) UIImageView *imageAvatar;
@property (nonatomic, strong) UILabel *labelTo;
@property (nonatomic, strong) UILabel *labelNickname;
@property (nonatomic, strong) UILabel *labelID;

@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UILabel *labelToMoney;
@property (nonatomic, strong) UILabel *labelMoneyType;
@property (nonatomic, strong) UILabel *labelTips;
@property (nonatomic, strong) UITextField *fieldMoney;

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation FYTransferMoneyInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"填写转账金额", nil);
    self.view.backgroundColor = COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT;
    self.labelTo.text=NSLocalizedString(@"转账给", nil);
    self.labelNickname.text = APP_USER_REMARK_NAME(self.toUser.userId);
    self.labelID.text = [NSString stringWithFormat:@"ID:%@",self.toUser.userId];
    [self.imageAvatar sd_setImageWithURL:[NSURL URLWithString:self.toUser.avatar]];
    self.labelToMoney.text=NSLocalizedString(@"转账金额", nil);
    self.labelMoneyType.text=@"￥";
    NSString *tips=[NSString stringWithFormat:NSLocalizedString(@"单笔限额 %ld~%ld元，每天最多转账%ld次", nil),self.minMoney,self.maxMoney,self.maxCount];
    self.labelTips.text=tips;
    self.fieldMoney.placeholder=NSLocalizedString(@"请输入转账金额", nil);
    [self bottomView];
}

-(void)buttonTransferAction:(UIButton *)sender{
    NSLog(NSLocalizedString(@"你点击了转账", nil));
    [self HTTPTransferToOtherUser];
}


-(UIView *)topView{
    if (!_topView) {
        _topView=[UIView new];
        _topView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(self.view);
            make.height.mas_equalTo(100);
        }];
    }
    return _topView;
}

-(UIView *)grayLine{
    if (!_grayLine) {
        _grayLine=[UIView new];
        _grayLine.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self.topView addSubview:_grayLine];
        [_grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(38);
            make.height.mas_equalTo(1);
            make.right.mas_equalTo(0);
        }];
    }
    return _grayLine;
}

-(UIImageView *)imageAvatar{
    if (!_imageAvatar) {
        _imageAvatar=[UIImageView new];
        [self.topView addSubview:_imageAvatar];
        [_imageAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(self.grayLine.mas_bottom).mas_offset(10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }
    return _imageAvatar;
}

-(UILabel *)labelTo{
    if (!_labelTo) {
        _labelTo=[UILabel new];
        _labelTo.font = [UIFont boldSystemFontOfSize:14];
        _labelTo.textColor=[UIColor blackColor];
        [self.topView addSubview:_labelTo];
        [_labelTo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(20);
        }];
    }
    return _labelTo;
}

-(UILabel *)labelNickname{
    if (!_labelNickname) {
        _labelNickname=[UILabel new];
        _labelNickname.font = [UIFont systemFontOfSize:14];
        _labelNickname.textColor = [UIColor blackColor];
        [self.topView addSubview:_labelNickname];
        [_labelNickname mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageAvatar.mas_right).mas_offset(10);
            make.bottom.equalTo(self.imageAvatar.mas_centerY).offset(-0.25f);
        }];
    }
    return _labelNickname;
}

-(UILabel *)labelID{
    if (!_labelID) {
        _labelID=[UILabel new];
        _labelID.font = [UIFont systemFontOfSize:12];
        _labelID.textColor = [UIColor grayColor];
        [self.topView addSubview:_labelID];
        [_labelID mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.labelNickname.mas_left);
            make.top.mas_equalTo(self.labelNickname.mas_bottom).offset(5.0f);
        }];
    }
    return _labelID;
}

-(UIView *)centerView{
    if (!_centerView) {
        _centerView=[UIView new];
        _centerView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_centerView];
        [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.equalTo(self.topView.mas_bottom).mas_offset(10);
            make.height.mas_equalTo(160);
        }];
    }
    return _centerView;
}

-(UILabel *)labelToMoney{
    if (!_labelToMoney) {
        _labelToMoney=[UILabel new];
        _labelToMoney.font = [UIFont boldSystemFontOfSize:18];
        _labelToMoney.textColor = [UIColor blackColor];
        [self.centerView addSubview:_labelToMoney];
        [_labelToMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.height.mas_offset(40);
            make.top.mas_offset(10);
        }];
    }
    return _labelToMoney;
}

-(UILabel *)labelMoneyType{
    if (!_labelMoneyType) {
        _labelMoneyType = [UILabel new];
        _labelMoneyType.font=[UIFont boldSystemFontOfSize:20];
        _labelMoneyType.textColor =[UIColor blackColor];
        [self.centerView addSubview:_labelMoneyType];
        [_labelMoneyType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.bottom.mas_equalTo(self.fieldMoney.mas_bottom).mas_offset(-3);
            make.width.mas_equalTo(22);
        }];
    }
    return _labelMoneyType;
}

-(UILabel *)labelTips{
    if (!_labelTips) {
        _labelTips=[UILabel new];
        _labelTips.font = [UIFont systemFontOfSize:12];
        _labelTips.textColor =[UIColor grayColor];
        _labelTips.adjustsFontSizeToFitWidth = YES;
        [self.centerView addSubview:_labelTips];
        [_labelTips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.bottom.mas_equalTo(-11);
        }];
    }
    return _labelTips;
}

-(UITextField *)fieldMoney{
    if (!_fieldMoney) {
        _fieldMoney=[UITextField new];
        _fieldMoney.keyboardType = UIKeyboardTypeDecimalPad;
        _fieldMoney.font = [UIFont boldSystemFontOfSize:26];
        _fieldMoney.textColor = [UIColor blackColor];
        _fieldMoney.textAlignment =NSTextAlignmentLeft;
        [self.centerView addSubview:_fieldMoney];
        [_fieldMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.labelMoneyType.mas_right).mas_offset(10);
            make.height.mas_equalTo(33);
            make.top.equalTo(self.labelToMoney.mas_bottom).mas_offset(10);
            make.right.mas_equalTo(-20);
        }];
    }
    return _fieldMoney;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView=[UIView new];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bottomView];
        UIButton *button=[UIButton new];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT;
        [button addRound:3];
        [button setTitle:NSLocalizedString(@"转账", nil) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [_bottomView addSubview:button];
        [button addTarget:self action:@selector(buttonTransferAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.equalTo(self.centerView.mas_bottom);
            make.height.mas_equalTo(120);
        }];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_bottomView);
            make.centerX.mas_equalTo(0);
            make.left.mas_equalTo(20);
            make.height.mas_equalTo(SYSTEM_GLOBAL_BUTTON_HEIGHT);
        }];
    }
    return _bottomView;
}


- (void)HTTPTransferToOtherUser
{
    if (self.fieldMoney.text.length < 1) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"请输入转账金额", nil))
        return;
    }
    
    NSInteger accountMoney=[self.fieldMoney.text integerValue];
    if (accountMoney < self.minMoney) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"金额设置过小", nil))
        return;
    } else if (accountMoney > self.maxMoney) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"金额设置过大", nil))
        return;
    }
    
    NSString *amount = [NSString stringWithFormat:@"%ld", accountMoney];
    NSDictionary *parameters = @{ @"userId":self.toUser.userId, @"amount":amount };
    
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requestWithAct:ActRequesTransferMoneyToUser parameters:parameters success:^(id object) {
        PROGRESS_HUD_DISMISS
        FYHTTPResponseModel *response=[FYHTTPResponseModel mj_objectWithKeyValues:object];
        if (response.code == 0) {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"转账成功", nil))
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            ALTER_HTTP_MESSAGE(response.alterMsg)
        }
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
    }];
}

@end
