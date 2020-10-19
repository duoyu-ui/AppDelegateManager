//
//  YEBTransferInVC.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/7/22.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "YEBTransferVC.h"
#import "YEBTransferSuccessVC.h"
#import "YEBAccountInfoModel.h"
#import "YEBPSWView.h"
#import "YEBTransferModel.h"
#import "SetPayPasswordController.h"

@interface YEBTransferVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *residueMoneyLabe;
@property (weak, nonatomic) IBOutlet UITextField *moneyField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstrain;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textMoneyLabe;
@property (weak, nonatomic) IBOutlet UIButton *allMoneyButton;
@end

@implementation YEBTransferVC {
    ///0 == in 1 == out
    int _vcType;
}

+ (instancetype)transferInVC
{
    YEBTransferVC *vc = [YEBTransferVC new];
    vc.title = NSLocalizedString(@"转入余额宝", nil);
    vc->_vcType = 0;
    return vc;
}

+ (instancetype)transferOutVC
{
    YEBTransferVC *vc = [YEBTransferVC new];
    vc.title = NSLocalizedString(@"余额宝转出", nil);
    vc->_vcType = 1;
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_vcType == 1) {
        
        self.titleLabel.text = NSLocalizedString(@"余额宝账户", nil);
        self.residueMoneyLabe.text = [NSString stringWithFormat:@"%.2f %@", self.model.m_totalMoney, NSLocalizedString(@"元", nil)];
        self.textMoneyLabe.text = [NSString stringWithFormat:@"%@(%@)", NSLocalizedString(@"输入金额", nil), NSLocalizedString(@"元", nil)];
        self.moneyField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"本次最多可以转出%.2f元", nil),self.model.m_rollOutMaxMoney];
        [self.allMoneyButton setTitle:NSLocalizedString(@"全部", nil) forState:UIControlStateNormal];
        [self.confirmBtn setTitle:NSLocalizedString(@"确定转出", nil) forState:UIControlStateNormal];
        self.descLabel.text = NSLocalizedString(@"余额宝的资金若需转出至银行卡，请提前转出至红包账户提现，提现将不收取任何费用。", nil);
        
    } else {
        
        self.titleLabel.text = NSLocalizedString(@"红包账户", nil);
        self.residueMoneyLabe.text = [NSString stringWithFormat:@"%.2f %@", AppModel.shareInstance.userInfo.balance.doubleValue, NSLocalizedString(@"元", nil)];
        self.textMoneyLabe.text = [NSString stringWithFormat:@"%@(%@)", NSLocalizedString(@"输入金额", nil), NSLocalizedString(@"元", nil)];
        self.moneyField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"建议至少%.2f元或以上，以便看到效益。", nil),self.model.m_rollInMinMoney];
        [self.allMoneyButton setTitle:NSLocalizedString(@"全部", nil) forState:UIControlStateNormal];
        [self.confirmBtn setTitle:NSLocalizedString(@"确定转入", nil) forState:UIControlStateNormal];
        self.descLabel.text = NSLocalizedString(@"余额宝的资金若需转出至银行卡，请提前转出至红包账户提现，提现将不收取任何费用。", nil);
    }
    
    self.bottomView.hidden = YES;
    self.heightConstrain.constant = 99;
    
    self.moneyField.delegate = self;
    [self.moneyField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        self.confirmBtn.enabled = x.length > 0;
        self.confirmBtn.backgroundColor = x.length > 0 ? kThemeTextColor : [UIColor grayColor];
    }];
}

- (void)update
{
    if (_vcType == 1) {
        self.residueMoneyLabe.text = [NSString stringWithFormat:NSLocalizedString(@"%.2f 元", nil),self.model.m_totalMoney];
    } else {
        
        self.residueMoneyLabe.text = [NSString stringWithFormat:NSLocalizedString(@"%.2f 元", nil),AppModel.shareInstance.userInfo.balance.doubleValue];
    }
}

- (IBAction)allMoneyBtnClick:(id)sender
{
    if (_vcType == 1) {
        if (self.model.m_totalMoney == 0) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"余额宝账户没有可用金额", nil)];
            return;
        }
        self.moneyField.text = [NSString stringWithFormat:@"%.2f",self.model.m_totalMoney];
    } else {
        if (AppModel.shareInstance.userInfo.balance.doubleValue == 0) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"红包账户没有可用金额", nil)];
            return;
        }
        self.moneyField.text = [NSString stringWithFormat:@"%.2f",AppModel.shareInstance.userInfo.balance.doubleValue];
    }
    if (self.moneyField.text.doubleValue > 0) {
        [self.moneyField becomeFirstResponder];
        self.confirmBtn.enabled = YES;
        self.confirmBtn.backgroundColor = kThemeTextColor;
    }
}

- (IBAction)confirmBtnClick:(id)sender
{
    [self.view endEditing:YES];
    
    double money = self.moneyField.text.doubleValue;
    if (money <= 0) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"请输入正确的金额!", nil)];
        return;
    }
    if (_vcType ==  1) {
        
        if (money > self.model.m_rollOutMaxMoney) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:NSLocalizedString(@"单次最多转出%.2f元", nil),self.model.m_rollInMaxMoney]];
            return;
        }
        if (money < self.model.m_rollOutMinMoney) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:NSLocalizedString(@"单次最少转出%.2f元", nil),self.model.m_rollInMinMoney]];
            return;
        }
        if (self.model.m_totalMoney == 0) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"余额宝账户没有可用金额", nil)];
            return;
        }
    }
    
    if (_vcType == 0) {
        
        if (money > self.model.m_rollInMaxMoney) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:NSLocalizedString(@"单次最多转入%.2f元", nil),self.model.m_rollInMaxMoney]];
            return;
        }
        if (money < self.model.m_rollInMinMoney) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:NSLocalizedString(@"单次最少转入%.2f元", nil),self.model.m_rollInMinMoney]];
            return;
        }
        if (AppModel.shareInstance.userInfo.balance.doubleValue == 0) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"红包账户没有可用金额", nil)];
            return;
        }
    }
    
    NSString *message = NSLocalizedString(@"请输入密码", nil);
    if (self.model.m_payPassword.length == 0) {
        message = NSLocalizedString(@"请设置密码", nil);
    }
    //跳转到支付密码
    kWeakly(self);
    YEBPSWView *view = [YEBPSWView showView:message
                                  completed:^(NSString * _Nonnull pwd) {
        [weakself operation:pwd];
    }];
    
    if (self.model.m_payPassword.length > 0) {
        [view showForgotPSW];
    }
    
    view.forgotBtnClickCallback = ^{
        [weakself.navigationController pushViewController:SetPayPasswordController.new animated:YES];
    };
}

- (void)operation:(NSString *)psw
{
    double money = self.moneyField.text.doubleValue;
    
    [SVProgressHUD show];
    if (self->_vcType == 1) {
        [[NetRequestManager sharedInstance] getOutWithMoney:money password:psw success:^(id object) {
            if ([object[@"code"] integerValue] == 0) {
                [SVProgressHUD dismiss];
                [self sendSuccessNoti];
                self.model.m_totalMoney = self.model.m_totalMoney - money;
                AppModel.shareInstance.userInfo.balance = [NSString stringWithFormat:@"%f", AppModel.shareInstance.userInfo.balance.doubleValue + money];
                [self update];
                YEBTransferSuccessVC *vc = [YEBTransferSuccessVC transferOutSuccessVCWithMoney:self.moneyField.text];
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                
                [SVProgressHUD showErrorWithStatus:object[@"alterMsg"]];
            }
        } fail:^(id object) {
            
            [[FunctionManager sharedInstance] handleFailResponse:object];
        }];

    } else {
        [[NetRequestManager sharedInstance] getInWithMoney:money password:psw success:^(id object) {
            
            if ([object[@"code"] integerValue] == 0) {
                [SVProgressHUD dismiss];
                [self sendSuccessNoti];
                self.model.m_totalMoney = self.model.m_totalMoney + money;
                AppModel.shareInstance.userInfo.balance = [NSString stringWithFormat:@"%f", AppModel.shareInstance.userInfo.balance.doubleValue - money];
                [self update];
                YEBTransferModel *model = [YEBTransferModel mj_objectWithKeyValues:object[@"data"]];
                               YEBTransferSuccessVC *vc = [YEBTransferSuccessVC transferInSuccessVCWithResult:model];
                               [self.navigationController pushViewController:vc animated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:object[@"alterMsg"]];
            }
        } fail:^(id object) {
            
            [[FunctionManager sharedInstance]handleFailResponse:object];
        }];
    }
}


- (void)sendSuccessNoti
{
    // 转入&转出成功
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationYuEBaoTransferBalanceChange object:nil];
}


#pragma mark - <UITextFiledDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    if (range.length >= 1) { // 删除数据, 都允许删除
        return YES;
    }
        if (![self checkDecimal:[textField.text stringByAppendingString:string]]){
          
            if (textField.text.length > 0 && [string isEqualToString:@"."] && ![textField.text containsString:@"."]) {
                return YES;
            }
            
            return NO;
            
        }
    return YES;
}


#pragma mark - 正则表达式

/**
 判断是否是两位小数
 @param str 字符串
 @return yes/no
 */
- (BOOL)checkDecimal:(NSString *)str
{
    NSString *regex = @"^[0-9]+(\\.[0-9]{1,2})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if([pred evaluateWithObject: str])
    {
        return YES;
    }else{
        return NO;
    }
}


@end

