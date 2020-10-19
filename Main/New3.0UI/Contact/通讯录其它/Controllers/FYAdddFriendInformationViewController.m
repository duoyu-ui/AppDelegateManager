//
//  FYAdddFriendInformationViewController.m
//  ProjectCSHB
//
//  Created by Tom on 2020/6/1.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYAdddFriendInformationViewController.h"
#import "FYTransferMoneyInputViewController.h"
#import "FYMobileContactInformation.h"
#import "FYHTTPResponseModel.h"

@interface FYAdddFriendInformationViewController ()
@property (nonatomic ,strong)UIImageView *imageAvatar;
@property (nonatomic ,strong)UILabel *labelNick;

@property (nonatomic ,strong)UIView *tempWhiteA;
@property (nonatomic ,strong)UILabel *labelSourceTitle;
@property (nonatomic ,strong)UILabel *labelSourceMessage;

@property (nonatomic ,strong)UIView *tempWhiteB;
@property (nonatomic ,strong)UILabel *labelTips;
@property (nonatomic ,strong)UITextField *fieldTips;
@property (nonatomic ,strong)UILabel *labelInvite;
@property (nonatomic ,strong)UITextView *textView;

@property (nonatomic , strong) UIButton *button;

@end

@implementation FYAdddFriendInformationViewController

- (UIColor *)prefersNavigationBarColor
{
    return [UIColor colorWithWhite:0.95 alpha:1];
}

- (CGFloat)prefersNavigationBarHairlineHeight
{
    return NAVIGATION_BAR_HAIR_LINE_HEIGHT_ZERO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    
    [self.imageAvatar sd_setImageWithURL:[NSURL URLWithString:self.avatarString]];
    self.labelNick.text = self.nickString;
    self.labelSourceTitle.text=NSLocalizedString(@"来源", nil);
    self.labelSourceMessage.text=self.sourceString;
    self.labelTips.text=NSLocalizedString(@"设置备注", nil);
    self.labelInvite.text=NSLocalizedString(@"发送添加朋友申请", nil);
    [self textView];

    [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 隐藏导航栏底线
    [self.navigationBarHairlineImageView setHidden:YES];
}

-(void)buttonAction:(UIButton *)sender{
    [self toAddFriend];
}

-(void)toAddFriend
{
    WEAKSELF(weakSelf)
    NSDictionary *senderDict=@{@"userId":self.userID,
                               @"message":self.textView.text,
                               @"remarks":self.fieldTips.text};
    RequestInfo *info=[[RequestInfo alloc] initWithType:RequestType_post];
    info.act = ActRequestInviteAcceptFriend;
    NSString *urlString=@"social/skUserInviteFriends/invite";
    info.url = [NSString stringWithFormat:@"%@%@", [AppModel shareInstance].serverUrl,urlString];
    
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requestWithData:senderDict requestInfo:info success:^(id object) {
        PROGRESS_HUD_DISMISS
        
        FYHTTPResponseModel *response = [FYHTTPResponseModel mj_objectWithKeyValues:object];
        [SVProgressHUD showInfoWithStatus:response.msg];
        
        NSDictionary *senderDict=@{@"userId":[AppModel shareInstance].userInfo.userId,
                                   @"avatar":[AppModel shareInstance].userInfo.avatar,
                                   @"nick":[AppModel shareInstance].userInfo.nick,
                                   @"opFlag":@"0",
                                   @"message":weakSelf.textView.text,
                                   @"remarks":weakSelf.fieldTips.text};
        [self invitedFriendAction:senderDict];
        
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    } fail:^(id object) {
        PROGRESS_HUD_DISMISS
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

- (void)invitedFriendAction:(NSDictionary *)friendInformation
{
    NSString *jsonString = [friendInformation JSONString];
    NSDictionary *parameters = @{
                                 @"command":@"49",
                                 @"code":@"10042",
                                 @"data":jsonString
                                 };
    NSLog(@"invitedFriendAction IM:%@",parameters);
    [[FYIMMessageManager shareInstance] sendMessageServer:parameters];
}


-(UIImageView *)imageAvatar{
    if (!_imageAvatar) {
        _imageAvatar=[UIImageView new];
        [self.view addSubview:_imageAvatar];
        [_imageAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(53, 53));
        }];
    }
    return _imageAvatar;
}

-(UILabel *)labelNick{
    if (!_labelNick) {
        _labelNick=[UILabel new];
        _labelNick.font=[UIFont boldSystemFontOfSize:16];
        _labelNick.textColor = [UIColor blackColor];
        [self.view addSubview:_labelNick];
        [_labelNick mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageAvatar.mas_right).mas_offset(10);
            make.top.mas_equalTo(self.imageAvatar.mas_top);
            make.height.mas_equalTo(25);
        }];
    }
    return _labelNick;
}

-(UIView *)tempWhiteA{
    if (!_tempWhiteA) {
        _tempWhiteA=[UIView new];
        _tempWhiteA.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tempWhiteA];
        [_tempWhiteA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(self.imageAvatar.mas_bottom).mas_offset(25);
        }];
    }
    return _tempWhiteA;
}

- (UILabel *)labelSourceTitle{
    if (!_labelSourceTitle) {
        _labelSourceTitle=[UILabel new];
        _labelSourceTitle.font = [UIFont systemFontOfSize:14];
        _labelSourceTitle.textColor = [UIColor blackColor];
        [self.tempWhiteA addSubview:_labelSourceTitle];
        [_labelSourceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.mas_equalTo(0);
        }];
    }
    return _labelSourceTitle;
}

-(UILabel *)labelSourceMessage{
    if (!_labelSourceMessage) {
        _labelSourceMessage=[UILabel new];
        _labelSourceMessage.font = [UIFont systemFontOfSize:14];
        _labelSourceMessage.textColor = [UIColor grayColor];
        [self.tempWhiteA addSubview:_labelSourceMessage];
        [_labelSourceMessage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(83);
            make.centerY.mas_equalTo(0);
        }];
    }
    return _labelSourceMessage;
}

- (UIView *)tempWhiteB{
    if (!_tempWhiteB) {
        _tempWhiteB=[UIView new];
        _tempWhiteB.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tempWhiteB];
        [_tempWhiteB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.top.mas_equalTo(self.tempWhiteA.mas_bottom).mas_offset(10);
        }];
    }
    return _tempWhiteB;
}

- (UILabel *)labelTips{
    if (!_labelTips) {
        _labelTips=[UILabel new];
        _labelTips.font = [UIFont systemFontOfSize:12];
        _labelTips.textColor = [UIColor grayColor];
        [self.tempWhiteB addSubview:_labelTips];
        [_labelTips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.height.mas_equalTo(15);
            make.left.mas_equalTo(20);
        }];
    }
    return _labelTips;
}

-(UITextField *)fieldTips{
    if (!_fieldTips) {
        _fieldTips = [UITextField new];
        _fieldTips.placeholder = NSLocalizedString(@"设置用户的备注信息", nil);
        _fieldTips.font = [UIFont systemFontOfSize:14];
        _fieldTips.textColor =[UIColor blackColor];
        _fieldTips.borderStyle = UITextBorderStyleRoundedRect;
        _fieldTips.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self.tempWhiteB addSubview:_fieldTips];
        [_fieldTips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.top.mas_equalTo(self.labelTips.mas_bottom).mas_offset(5);
            make.height.mas_equalTo(35);
            make.right.mas_equalTo(-30);
        }];
    }
    return _fieldTips;
}

- (UILabel *)labelInvite{
    if (!_labelInvite) {
        _labelInvite=[UILabel new];
        _labelInvite.textColor = [UIColor grayColor];
        _labelInvite.font = [UIFont systemFontOfSize:12];
        [self.tempWhiteB addSubview:_labelInvite];
        [_labelInvite mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(self.fieldTips.mas_bottom).mas_offset(10);
            make.height.mas_equalTo(15);
        }];
    }
    return _labelInvite;
}

-(UITextView *)textView{
    if (!_textView) {
        _textView = [UITextView new];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.textColor = [UIColor blackColor];
        _textView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        _textView.layer.cornerRadius = 4;
        _textView.clipsToBounds = YES;
        [self.tempWhiteB addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.top.mas_equalTo(self.labelInvite.mas_bottom).mas_offset(5);
            make.height.mas_equalTo(100);
        }];
    }
    return _textView;
}

-(UIButton *)button{
    if (!_button) {
        _button=[UIButton new];
        [_button setTitle:NSLocalizedString(@"发送并添加到通讯录", nil) forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.backgroundColor = [UIColor colorWithRed:114/255.0 green:187/255.0 blue:115/255.0 alpha:1];
        _button.layer.cornerRadius = 2;
        [self.tempWhiteB addSubview:_button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(SYSTEM_GLOBAL_BUTTON_HEIGHT);
            make.top.mas_equalTo(self.textView.mas_bottom).mas_offset(35);
        }];
    }
    return _button;
}

- (void)doQRCodeResultForTransferMoney:(FYContactSimpleModel *)contactSimpleModel
{
    [self requestDataThen:^(NSInteger maxCount, CGFloat minMoney, CGFloat maxMoney) {
        [self toTransferVCWithMaxCount:maxCount minMoney:minMoney maxMoney:maxMoney user:contactSimpleModel];
    }];
}

- (void)toTransferVCWithMaxCount:(NSInteger)maxCount minMoney:(CGFloat)minMoney maxMoney:(CGFloat)maxMoney user:(FYContactSimpleModel *)toUser
{
    FYTransferMoneyInputViewController *VC=[FYTransferMoneyInputViewController new];
    VC.toUser=toUser;
    VC.maxCount = maxCount;
    VC.maxMoney = maxMoney;
    VC.minMoney = minMoney;
    [self.navigationController pushViewController:VC removeViewController:self];
}

- (void)requestDataThen:(void (^)(NSInteger maxCount, CGFloat minMoney, CGFloat maxMoney))then
{
    PROGRESS_HUD_SHOW
    NSString *userId = APPINFORMATION.userInfo.userId;
    [NET_REQUEST_MANAGER requestWithAct:ActRequestTransferMoneyNearRecord parameters:@{ @"userId":userId } success:^(id object) {
        PROGRESS_HUD_DISMISS
        FYLog(@"Transfer History:%@", object);
        FYHTTPResponseModel *response=[FYHTTPResponseModel mj_objectWithKeyValues:object];
        if (response.data) {
            NSDictionary *ruleDict=[response.data valueForKey:@"transferSettingDTO"];
            if (ruleDict) {
                NSInteger maxCount = [ruleDict integerForKey:@"numberTimes"];
                CGFloat minMoney = [ruleDict floatForKey:@"singleTransferMin"];
                CGFloat maxMoney = [ruleDict floatForKey:@"singleTransferMax"];
                !then?:then(maxCount,minMoney,maxMoney);
            }
        }
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
    }];
}
@end
