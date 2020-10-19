//
//  ChatViewController.m
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "ChatViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "EnvelopeMessage.h"
#import "SendRedEnvelopeController.h"
#import "MessageItem.h"
#import "GroupInfoViewController.h"
#import "WebViewController.h"
#import "IQKeyboardManager.h"
#import "EnvelopeNet.h"
#import "SqliteManage.h"
#import "SSChatVoiceCell.h"
#import "RedEnvelopeAnimationView.h"
#import "FYRedEnvelopePublicViewController.h"
#import "FYBagBagCowRedGrapViewController.h"
#import "FYBagLotteryRedGrapController.h"
#import "CowCowVSMessageCell.h"
#import "ImageDetailViewController.h"
#import "NotificationMessageModel.h"
#import "NotificationMessageCell.h"
#import "ShareViewController.h"
#import "FYRobNNQiSController.h"
#import "FYRobTouZhuJLController.h"
#import "AlertViewCus.h"
#import "HelpCenterWebController.h"
#import "CustomerServiceAlertView.h"
#import "FYAgentCenterViewController.h"
#import "WebViewController.h"
#import "ShareDetailViewController.h"
#import "FYContacts.h"
#import "FriendChatInfoController.h"
#import "PersonalSignatureVC.h"
#import "FYCreateRequest.h"
#import "LaunchFristPageVC.h"
#import "FYSuperBombSendPacketVC.h"
#import "FYTransferMoneyViewController.h"
#import "FYYEBViewController.h"
#import "FYUserQRCodeViewController.h"
#import "FYActivityMainViewController.h"
#import "NoRobSendRPController.h"
#import "FYWithdrawMoneyViewController.h"
#import "FYAddBankcardViewController.h"
#import "FYBagBagCowTrendViewController.h"
#import "FYBagBagCowRecordViewController.h"
#import "FYBagLotteryRecordController.h"
#import "FYBagLotteryTrendController.h"
#import "FYBaiRenNNTrendViewController.h"
#import "FYBaiRenNNRecordViewController.h"
#import "NSBundle+FYUtils.h"//多语言

/// 悬浮按钮 TAG
NSInteger const FLOAT_BUTTON_TAG_UUID_ACTIVITY = 10000;
NSInteger const FLOAT_BUTTON_TAG_UUID_TREND = 10001;
NSInteger const FLOAT_BUTTON_TAG_UUID_RECORD = 10002;


@interface ChatViewController ()<FYSystemBaseCellDelegate>

/// 红包详情模型
@property (nonatomic,strong) EnvelopeNet *enveModel;
/// 抢红包视图
@property (nonatomic,strong) RedEnvelopeAnimationView *redpView;
/// 红包动画是否结束
@property (nonatomic,assign) BOOL isAnimationEnd;
/// 抢红包结果数据
@property (nonatomic,strong) id response;
/// 消息ID
@property (nonatomic, copy) NSString *messageId;
/// 定时器
@property (nonatomic,strong) NSTimer *timerView;
/// 聊天定时器
@property (nonatomic,strong) NSTimer *chatTimer;

@property (nonatomic,assign) BOOL isChatTimer;

@property (nonatomic,assign) BOOL isCreateRpView;
@property (nonatomic,assign) BOOL isVSViewClick;

@property (nonatomic,copy) NSString *bankerId;

@property (nonatomic, strong) FYCreateRequest *groupConfig;

// 播放音乐
@property (nonatomic,strong) AVAudioPlayer *player;

/// 导航栏右边的菜单
@property (nonatomic, strong) UIView *rightItem;
/// 群聊 - 联系客服按钮
@property (nonatomic, strong) UIButton *navCustomer;
/// 群聊 - 群组成员按钮
@property (nonatomic, strong) UIButton *navGroupInfo;
/// 单聊 - 聊天详情按钮
@property (nonatomic, strong) UIButton *navUserChatDetailInfo;
/// 聊天 - 右侧悬浮按钮
@property (nonatomic, strong) NSMutableArray<UIButton *> *floatButtons;
@property (nonatomic, strong) UIView *floatButtonContainer;

@end


// 群组类
@implementation ChatViewController

static ChatViewController *_chatVC;

// 群聊 
+ (ChatViewController *)groupChatWithObj:(MessageItem *)obj
{
    if (obj.userId == [AppModel shareInstance].userInfo.userId) {
        [AppModel shareInstance].isGroupOwner = YES;
    } else {
        [AppModel shareInstance].isGroupOwner = NO;
    }
    
    _chatVC = [[ChatViewController alloc] initWithConversationType:FYConversationType_GROUP
                                                          targetId:obj.groupId];
    // 设置会话的类型，如单聊、群聊、聊天室、客服、公众服务会话等
    _chatVC.messageItem = obj;
    
    // 设置聊天会话界面要显示的标题
    NSString *title = obj.chatgName;
    NSRange range = [title rangeOfString:@"("];
    if(range.length == 0)
        range = [title rangeOfString:@"（"];
    if(range.length > 0)
        title = [title substringToIndex:range.location];
    if(title.length == 0)
        title = NSLocalizedString(@"群组", nil);
    if (title.length > 12) {
        _chatVC.title = [NSString stringWithFormat:@"%@...", [title substringToIndex:12]];
    } else {
        _chatVC.title = title;
    }
    return _chatVC;
}

// 单聊
+ (ChatViewController *)privateChatWithModel:(FYContacts *)model
{
    if (model.userId == [AppModel shareInstance].userInfo.userId) {
        [AppModel shareInstance].isGroupOwner = YES;
    } else {
        [AppModel shareInstance].isGroupOwner = NO;
    }
    
    _chatVC = [[ChatViewController alloc] initWithConversationType:FYConversationType_PRIVATE
                                                          targetId:model.sessionId];
    //设置聊天会话界面要显示的标题
    NSString *title = model.nick.length > 0 ? model.nick : model.name;
    if (![NSString isBlankString:model.friendNick]) {
        title = model.friendNick;
    }
    NSRange range = [title rangeOfString:@"("];
    if(range.length == 0)
        range = [title rangeOfString:@"（"];
    if(range.length > 0)
        title = [title substringToIndex:range.location];
    if(title.length == 0)
        title = @"";
    if (title.length > 12) {
        _chatVC.title = [NSString stringWithFormat:@"%@...", [title substringToIndex:12]];
    }else {
        _chatVC.title = title;
    }
    
    return _chatVC;
}

+ (ChatViewController *)currentChat {
    return _chatVC;
}


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUIOfNavigation];
    
    [self setUIOfFloatButtons];
    
    self.enveModel = [EnvelopeNet shareInstance];
    
    [self updateUnreadMessage];
    
    self.isCreateRpView = NO;
    self.isVSViewClick = NO;
    
    // 通知 - 监听消息
    {
        // 试玩3分钟
        if ([APPINFORMATION isGuestLogin]) {
            [NOTIF_CENTER addObserver:self
                             selector:@selector(showGameCloseAtThreeMinLater:)
                                 name:kGameCloseAtThreeMinLater
                               object:nil];
        }
    
        // 被踢出群
        if (FYConversationType_GROUP == self.chatType) {
            [NOTIF_CENTER addObserver:self
                             selector:@selector(kAddOrDeleteDidUserGroup:)
                                 name:kNotificationJoinOrDeletedDidUserGroup
                               object:nil];
        }
    }

    // 新好友加入
    if (self.isNewMember) {
        [self sendWelcomeMessage:self.sessionId];
    }
    
    // 自建群进入（提醒）
    if (!self.messageItem.officeFlag && FYConversationType_GROUP == self.chatType) {
        [NET_REQUEST_MANAGER requestJoinChatGroupSelfNoticeWithGroupId:self.messageItem.groupId success:^(id response) {

        } failure:^(id error) {
            
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    self.extendedLayoutIncludesOpaqueBars = YES;  // 防止导航栏下移64
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    // 隐藏导航栏底线
    if (FYConversationType_GROUP == self.chatType) {
        [self.navigationBarHairlineImageView setHidden:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //[IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [[IQKeyboardManager sharedManager]setEnable:YES];
    self.isCreateRpView = NO;
    self.isVSViewClick = NO;
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)setUIOfNavigation
{
    if (FYConversationType_GROUP == self.chatType) {
        // 群聊
        UIBarButtonItem *infoItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightItem];
        self.navigationItem.rightBarButtonItem = infoItem;
    } else {
        // 单聊
        if (FYConversationType_CUSTOMERSERVICE != self.chatType) {
            UIBarButtonItem *rightNavItem=[[UIBarButtonItem alloc] initWithCustomView:self.navUserChatDetailInfo];
            self.navigationItem.rightBarButtonItem = rightNavItem;
        }
    }
    
    if (self.messageItem.officeFlag && self.chatType == FYConversationType_GROUP) {

        UIImageView *back = [[UIImageView alloc]initWithImage:[UIImage imageNamed:ICON_NAVIGATION_BAR_BUTTON_BLACK_ARROW]];
        back.userInteractionEnabled = YES;
        back.frame = CGRectMake(0, 11, 20, 20);
        //
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressNavActionLeftBackGroupOfficeYes)];
        [backView addSubview:back];
        [backView addGestureRecognizer:tap];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backView];

        self.navigationItem.leftBarButtonItem = item;

    } else if (self.messageItem.officeFlag == NO && self.chatType == FYConversationType_GROUP) {
        
        UIImageView *back = [[UIImageView alloc]initWithImage:[UIImage imageNamed:ICON_NAVIGATION_BAR_BUTTON_BLACK_ARROW]];
        back.userInteractionEnabled = YES;
        back.frame = CGRectMake(0, 11, 20, 18);
        //
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressNavActionBackGroupOfficeNo)];
        [backView addSubview:back];
        [backView addGestureRecognizer:tap];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backView];

        self.navigationItem.leftBarButtonItem = item;
    }
}

- (void)setUIOfFloatButtons
{
    // 群聊才有
    if (self.chatType != FYConversationType_GROUP) {
        return;
    }

    // 头部区域
    UIView *topHeaderView = self.groupHearderView;
    if (GroupTemplate_N10_BagLottery == self.messageItem.type
        || GroupTemplate_N11_BagBagCow == self.messageItem.type) {
        topHeaderView = self.nperHaederView;
    } else if (GroupTemplate_N14_BestNiuNiu == self.messageItem.type){
        topHeaderView = self.wlHaederView;
    }
    
    // 悬浮按钮
    {
        // 容器
        [self.view addSubview:self.floatButtonContainer];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onFloatButtonPangesture:)];
        [self.floatButtonContainer addGestureRecognizer:panGesture];
        [self.floatButtonContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topHeaderView.mas_bottom);
            make.right.equalTo(self.view.mas_right);
        }];
        
        // 活动、走势、记录
        NSArray<NSString *> *titleStrArr = @[ NSLocalizedString(@"活动", nil) ];
        NSArray<NSString *> *imageUrlArr = @[ @"icon_game_award" ];
        NSArray<NSNumber *> *tagValueArr = @[ [NSNumber numberWithInteger:FLOAT_BUTTON_TAG_UUID_ACTIVITY] ];
        if (GroupTemplate_N10_BagLottery == self.messageItem.type
            || GroupTemplate_N11_BagBagCow == self.messageItem.type
            || GroupTemplate_N14_BestNiuNiu == self.messageItem.type) {
            titleStrArr = @[ NSLocalizedString(@"活动", nil), NSLocalizedString(@"走势", nil), NSLocalizedString(@"记录", nil) ];
            imageUrlArr = @[ @"icon_game_award", @"icon_game_trend", @"icon_game_record" ];
            tagValueArr = @[ [NSNumber numberWithInteger:FLOAT_BUTTON_TAG_UUID_ACTIVITY],
                             [NSNumber numberWithInteger:FLOAT_BUTTON_TAG_UUID_TREND],
                             [NSNumber numberWithInteger:FLOAT_BUTTON_TAG_UUID_RECORD] ];
        }
        UIView *lastItemButton = nil;
        for (NSInteger index = 0; index < titleStrArr.count && index < imageUrlArr.count && index < tagValueArr.count; index ++) {
            lastItemButton = [self createUIOfFloatButtonIcon:imageUrlArr[index] title:titleStrArr[index] tag:tagValueArr[index].integerValue lastItemView:lastItemButton];
            [self.floatButtons addObj:lastItemButton];
        }
        
        // 容器
        CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
        [self.floatButtonContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastItemButton.mas_left);
            make.bottom.equalTo(lastItemButton.mas_bottom).offset(margin*0.5f);
        }];
    }
    
    // 群聊倒计时控件
    [self.view addSubview:self.countdownView];
    [self.countdownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.height.centerY.equalTo(self.floatButtons.firstObject);
        make.right.equalTo(self.floatButtons.firstObject.mas_left);
    }];
}

/// 悬浮按钮事件
- (void)pressActionOfFloatBtn:(UIButton *)sender
{
    // 活动
    if (FLOAT_BUTTON_TAG_UUID_ACTIVITY == sender.tag) {
        FYActivityMainViewController *viewController = [[FYActivityMainViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    // 走势
    else if (FLOAT_BUTTON_TAG_UUID_TREND == sender.tag) {
        if (GroupTemplate_N10_BagLottery == self.messageItem.type) {
            FYBagLotteryTrendController *VC = [[FYBagLotteryTrendController alloc] initWithMessageItem:self.messageItem];
            [self setDelegate_lottery:VC];
            [self.navigationController pushViewController:VC animated:YES];
        } else if (GroupTemplate_N11_BagBagCow == self.messageItem.type) {
            FYBagBagCowTrendViewController *VC = [[FYBagBagCowTrendViewController alloc] initWithMessageItem:self.messageItem];
            [self setDelegate_lottery:VC];
            [self.navigationController pushViewController:VC animated:YES];
        } else if (GroupTemplate_N14_BestNiuNiu == self.messageItem.type) {
            FYBaiRenNNTrendViewController *VC = [[FYBaiRenNNTrendViewController alloc] initWithMessageItem:self.messageItem];
            [self setDelegate_lottery:VC];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    // 记录
    else if (FLOAT_BUTTON_TAG_UUID_RECORD == sender.tag) {
        if (GroupTemplate_N10_BagLottery == self.messageItem.type) {
            FYBagLotteryRecordController *VC = [[FYBagLotteryRecordController alloc] initWithMessageItem:self.messageItem];
            [self.navigationController pushViewController:VC animated:YES];
        } else if (GroupTemplate_N11_BagBagCow == self.messageItem.type) {
            FYBagBagCowRecordViewController *VC = [[FYBagBagCowRecordViewController alloc] initWithMessageItem:self.messageItem];
            [self.navigationController pushViewController:VC animated:YES];
        } else if (GroupTemplate_N14_BestNiuNiu == self.messageItem.type) {
            FYBaiRenNNRecordViewController *VC = [[FYBaiRenNNRecordViewController alloc] initWithMessageItem:self.messageItem];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}

/// 非群组退出按钮
- (void)pressNavigationBarLeftButtonItem:(id)sender
{
    [super pressNavigationBarLeftButtonItem:sender];
 
    // 退出必须设置为空
    _chatVC = nil;
    
    if (self.chatType != FYConversationType_GROUP) {
        if (self.isBackToRootVC) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

/// 官方群组退出按钮
- (void)pressNavActionLeftBackGroupOfficeYes
{
    [self pressNavigationBarLeftButtonItem:nil];
    
    // 退出必须设置为空
    _chatVC = nil;
    
    // 退出官方群请求
    [FYAPP_PRECISION_MANAGER doTryToQuitGroupOfficeYes:self.messageItem
                                        isBackToRootVC:self.isBackToRootVC
                                                  from:self.navigationController];
    
    if (self.bankerId != nil) {
        [[IMGroupModule sharedInstance] removeGroupEntityWithGroupId:self.bankerId];
    }
    
    if (self.sessionId != nil) {
        [[IMSessionModule sharedInstance] removeSession:self.sessionId];
    }
}


/// 自建群组退出按钮
- (void)pressNavActionBackGroupOfficeNo
{
    [self pressNavigationBarLeftButtonItem:nil];
    
    // 退出必须设置为空
    _chatVC = nil;
    
    if (self.isBackToRootVC) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 删除好友
- (void)kAddOrDeleteDidUserGroup:(NSNotification *)not
{
    NSDictionary *dict = not.object;
    NSString *msg = [NSString stringWithFormat:@"%@",dict[@"msg"]];
    NSInteger command = [dict[@"command"] integerValue];

    if (command == 33 ){
        SVP_ERROR_STATUS(msg);
        [self performSelectorOnMainThread:@selector(deleteFromUserGroupChat) withObject:nil waitUntilDone:YES];
    }
}

- (void)deleteFromUserGroupChat
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 试玩退出
- (void)showGameCloseAtThreeMinLater:(NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    NSString *message=[NSString stringWithFormat:@"%@", dict[@"context"]];
    NSInteger time = [dict[@"time"] integerValue];
    if (time < 1) {
        WEAKSELF(weakSelf)
        dispatch_main_async_safe(^{
            if (weakSelf.isBackToRootVC) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        });
        return;
    }
    
    UIViewController *controller=[UIViewController new];
    controller.view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    FYAlertCloseTipsView *centerView=[[FYAlertCloseTipsView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - SCREEN_WIDTH) * 0.5, SCREEN_WIDTH, SCREEN_WIDTH)];
    [centerView.buttonView.buttonLeft setTitle:[NSString stringWithFormat:NSLocalizedString(@"再玩%ld分钟", nil),time] forState:UIControlStateNormal];
    [centerView.buttonView.buttonRight setTitle:NSLocalizedString(@"立即退出", nil) forState:UIControlStateNormal];
    centerView.message.text = message;
    __weak typeof(self) tempVC = self;
    centerView.buttonCallBack = ^(UIButton * _Nonnull button) {
        [controller dismissViewControllerAnimated:YES completion:nil];
        if ([button.currentTitle isEqualToString:NSLocalizedString(@"立即退出", nil)]) {
            [tempVC.navigationController popViewControllerAnimated:YES];
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * 60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (tempVC != nil) {
                    [tempVC pressNavActionBackGroupOfficeNo];
                }
            });
        }
    };
    [controller.view addSubview:centerView];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)dealloc
{
    _chatVC = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - VS 视图查看详情

/// 点击VS牛牛Cell消息背景视图
- (void)didTapVSCowcowCell:(FYMessage *)model
{
    if (self.isVSViewClick) {
        return;
    }
    self.isVSViewClick = YES;
    
    self.bankerId = [[model.cowcowRewardInfoDict objectForKey:@"userId"] stringValue];
    //    [self vsViewGetRedPacketDetailsData:[model.cowcowRewardInfoDict objectForKey:@"id"]];
    NSString *redId = [[model.cowcowRewardInfoDict objectForKey:@"id"] stringValue];
    [self goto_RedPackedDetail:redId isCowCow:YES];
}


#pragma mark - 聊天功能扩展拦

// 多功能视图点击回调  图片10  视频11  位置12
-(void)fyChatFunctionBoardClickedItemWithTag:(NSInteger)tag
{
    [self setSSChatKeyBoardInputViewEndEditing];

    [self.view endEditing:YES];
    
    if (KEYBOARD_FUNCTION_UUID_FULI == tag) { // 福利
        [self sendFuLiPacket];
    } else if (KEYBOARD_FUNCTION_UUID_JIAMENG == tag) { // 加盟
        if ([[AppModel shareInstance] isGuest]) {
            return;
        }
        FYAgentCenterViewController *VC = [[FYAgentCenterViewController alloc] init];
        [VC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (KEYBOARD_FUNCTION_UUID_REDPACKET == tag) {  // 红包
        if (GroupTemplate_N00_FuLi == self.messageItem.type || !self.messageItem.type) {
            [self sendFuLiPacket];
            return;
        } else if (GroupTemplate_N03_JingQiang == self.messageItem.type) {
            NoRobSendRPController *VC = [[NoRobSendRPController alloc] init];
            VC.CDParam = self.messageItem;
            [self.navigationController pushViewController:VC animated:YES];
        } else if (GroupTemplate_N09_SuperBobm == self.messageItem.type) { // 超级扫雷
            FYSuperBombSendPacketVC *sendVC = [[FYSuperBombSendPacketVC alloc] init];
            sendVC.messageItem = self.messageItem;
            [self.navigationController pushViewController:sendVC animated:YES];
        } else {
            SendRedEnvelopeController *VC = [[SendRedEnvelopeController alloc] init];
            VC.CDParam = self.messageItem;
            [self.navigationController pushViewController:VC animated:YES];
        }
    } else if (KEYBOARD_FUNCTION_UUID_RECHARGE == tag) { // 充值
        FYRechargeMainViewController *VC = [[FYRechargeMainViewController alloc] initWithIsPush:YES];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (KEYBOARD_FUNCTION_UUID_PALY_RULE == tag) { // 玩法
        WebViewController *VC = [[WebViewController alloc] initWithUrl:[AppModel shareInstance].ruleString];
        VC.navigationItem.title = NSLocalizedString(@"玩法规则", nil);
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
    } else if (KEYBOARD_FUNCTION_UUID_GROUP_RULE == tag) { // 群规
        [self groupRuleView];
    } else if (KEYBOARD_FUNCTION_UUID_HELPER == tag) {  // 帮助
        HelpCenterWebController *vc = [[HelpCenterWebController alloc] initWithUrl:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (KEYBOARD_FUNCTION_UUID_CUSTOMER == tag) {  // 客服
        [self openWebCustomerService];
    } else if (KEYBOARD_FUNCTION_UUID_PHOTO == tag) { // 照片
        [super fyChatFunctionBoardClickedItemWithTag:10];
    } else if (KEYBOARD_FUNCTION_UUID_CARAMER == tag) { // 拍照
        [super fyChatFunctionBoardClickedItemWithTag:11];
    } else if(KEYBOARD_FUNCTION_UUID_ERANMONEY == tag) {  // 赚钱
        if ([[AppModel shareInstance] isGuest]) {
            return;
        }
        PUSH_C(self, ShareDetailViewController, YES);
    } else if (KEYBOARD_FUNCTION_UUID_ISSUE_RECORDS == tag) { // 期数记录
        FYRobNNQiSController *VC = [[FYRobNNQiSController alloc]init];
        VC.chatId = self.messageItem.groupId;
        VC.type = self.messageItem.type;
        [self.navigationController pushViewController:VC animated:YES];
    } else if (KEYBOARD_FUNCTION_UUID_BETTING_RECORDS == tag) { // 投注记录
        FYRobTouZhuJLController *VC = [[FYRobTouZhuJLController alloc]init];
        VC.chatId = self.messageItem.groupId;
        VC.type = self.messageItem.type;
        [self.navigationController pushViewController:VC animated:YES];
    } else if(KEYBOARD_FUNCTION_UUID_TRANSFER_MONEY == tag) { // 转账
        if ([[AppModel shareInstance] isGuest]) {
            return;
        }
        FYTransferMoneyViewController *VC = [[FYTransferMoneyViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    } else if(KEYBOARD_FUNCTION_UUID_DRAW_MONEY == tag) { // 提款
        if ([[AppModel shareInstance] isGuest]) {
            return;
        }
        if (!APPINFORMATION.userInfo.isBindMobile) {
            [self doToShowBindPhoneViewController];
            return;
        }
        if (APPINFORMATION.userInfo.isTiedCard) {
            FYWithdrawMoneyViewController *viewController = [[FYWithdrawMoneyViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            FYAddBankcardViewController *VC = [[FYAddBankcardViewController alloc] init];
            [VC setFinishAddBankItemModelBlock:^FYAddBankCardResType(FYBankItemModel * _Nullable bankCardModel) {
                [APPINFORMATION.userInfo setIsTiedCard:YES];
                return FYAddBankCardResMyCenterToWithdraw; // 个人中心 -> 添加银行卡 -> 提现
            }];
            [self.navigationController pushViewController:VC animated:YES];
        }
    } else if(KEYBOARD_FUNCTION_UUID_YUEBAO == tag) { // 余额宝
        if ([[AppModel shareInstance] isGuest]) {
            return;
        }
        FYYEBViewController *VC = [[FYYEBViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    } else if(KEYBOARD_FUNCTION_UUID_QRCODE == tag) { // 二维码
        if ([[AppModel shareInstance] isGuest]) {
            return;
        }
        FYUserQRCodeViewController *VC = [[FYUserQRCodeViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
// 发送红包
- (void)fyChatKeyBoardClickedCustomButtonRedPacket:(UIButton *)sender
{
    [self goto_sendRedEnvelopeEnt];
}


#pragma mark - FYIMGroupChatHeaderViewDelegate

// 群组头部事件 - 充值操作
- (void)groupHeaderView:(FYIMGroupChatHeaderView *)headerView didActionOfRecharge:(UIButton *)button
{
    FYRechargeMainViewController *VC = [[FYRechargeMainViewController alloc] initWithIsPush:YES];
    [self.navigationController pushViewController:VC animated:YES];
}

// 群组头部事件 - 玩法操作
- (void)groupHeaderView:(FYIMGroupChatHeaderView *)headerView didActionOfPlayRule:(UIButton *)button
{
    NSString *url = [FYLanguageModel palyLanguageConfigType:self.messageItem.type];
    WebViewController *VC = [[WebViewController alloc] initWithUrl:url];
    [VC setTitle:NSLocalizedString(@"玩法规则", nil)];
    [self.navigationController pushViewController:VC animated:YES];
}

// 群组头部事件 - 分享操作
- (void)groupHeaderView:(FYIMGroupChatHeaderView *)headerView didActionOfShare:(UIButton *)button
{
    ShareDetailViewController *viewController = [[ShareDetailViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - 群规
- (void)groupRuleView
{
    ImageDetailViewController *vc = [[ImageDetailViewController alloc] init];
    vc.imageUrl = self.messageItem.ruleImg;
    vc.hiddenNavBar = YES;
    vc.title = NSLocalizedString(@"群规", nil);
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - override Cell点击事件

- (void)didChatVoiceCell:(FYChatBaseCell*)cell model:(FYMessage *)model{
    [super didChatVoiceCell:cell model:model];
    FYMessage *voiceModel = [[IMMessageModule sharedInstance] getMessageWithMessageId:model.messageId];
    SSChatVoiceCell *voiccell = (SSChatVoiceCell*)cell;
    voiccell.dotView.hidden = YES;
    NSDictionary *dict =  [model.text mj_JSONObject];
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionary];
    for (NSString *key in dict.allKeys) {
        if ([key isEqualToString:@"unRead"]) {//点击语音cell,
            [mutDict setObject:@(YES) forKey:key];
        }else{
           [mutDict setObject:dict[key] forKey:key];
        }
    }
    model.text = [mutDict mj_JSONString];
    voiceModel = model;
    [[IMMessageModule sharedInstance] updateMessage:voiceModel];
}
// cell点击事件
- (void)didTapMessageCell:(FYMessage *)model
{
    [super didTapMessageCell:model];
    
    [self.view endEditing:YES];
    
    if (model.messageType == FYMessageTypeRedEnvelope) {
        // 发送者ID
        self.bankerId = model.messageSendId;
            if (self.isCreateRpView) {
                return;
            }
            self.isCreateRpView = YES;
            if (model.redEnvelopeMessage.redpacketId.length != 0 ||model.redEnvelopeMessage.redpacketId != nil ) {
                [self getRedPacketDetailsData:model];
            } else {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"红包ID不能为空!", nil)];
            }
    } else {
        NSDictionary *dict = [model.text mj_JSONObject];
        if ([dict objectForKey:@"redType"] != nil) {
            [self goto_RedPackedDetail:dict[@"id"] isCowCow:YES];
        }
    }
}

#pragma mark - 获取红包详情
/**
 获取红包详情
 
 @param messageModel RCMessageModel
 */
- (void)getRedPacketDetailsData:(FYMessage *)messageModel
{
    if (GroupTemplate_N10_BagLottery == self.messageItem.type) {
        WEAKSELF(weakSelf)
        NSString *redpacketId = messageModel.redEnvelopeMessage.redpacketId;
        [_enveModel getRedPacketDetailBagBagLotteryWithId:redpacketId then:^(BOOL success, NSString *status) {
            if (success) {
                if ([messageModel.redEnvelopeMessage.cellStatus integerValue] == 1) {
                    weakSelf.isCreateRpView = NO;
                    [weakSelf goto_RedPackedDetail:redpacketId isCowCow:YES];
                } else if ([@"2" isEqualToString:status]) {
                    weakSelf.isCreateRpView = NO;
                    [weakSelf updateRedPackedStatus:messageModel.messageId cellStatus:status];
                    [weakSelf goto_RedPackedDetail:redpacketId isCowCow:YES];
                } else {
                    [weakSelf actionShowRedPackedView:messageModel];
                }
            } else {
                weakSelf.isCreateRpView = NO;
            }
        }];
    } else if (GroupTemplate_N11_BagBagCow == self.messageItem.type) {
        WEAKSELF(weakSelf)
        self.isCreateRpView = NO;
        NSString *redpacketId = messageModel.redEnvelopeMessage.redpacketId;
        [_enveModel getRedPacketDetailBagBagCowWithId:redpacketId then:^(BOOL success, NSString *status) {
            if (success) {
                [weakSelf updateRedPackedStatus:messageModel.messageId cellStatus:status];
                //
                FYBagBagCowRedGrapViewController *VC = [[FYBagBagCowRedGrapViewController alloc]init];
                VC.type = weakSelf.messageItem.type;
                VC.packetId = redpacketId;
                [weakSelf.navigationController pushViewController:VC animated:YES];
            } else {
                ALTER_INFO_MESSAGE(NSLocalizedString(@"不可抢包", nil))
            }
        }];
    } else {
        PROGRESS_HUD_SHOW
        __weak __typeof(self)weakSelf = self;
        [_enveModel getRedpDetSendId:messageModel.redEnvelopeMessage.redpacketId successBlock:^(NSDictionary *response) {
            PROGRESS_HUD_DISMISS
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (NET_REQUEST_SUCCESS(response)) {
                if ([messageModel.redEnvelopeMessage.cellStatus integerValue] == 1) {
                    [strongSelf goto_RedPackedDetail:strongSelf.enveModel isCowCow:YES];
                } else {
                    [strongSelf actionShowRedPackedView:messageModel];
                }
            } else {
                strongSelf.isCreateRpView = NO;
                [[FunctionManager sharedInstance] handleFailResponse:response];
            }
        } failureBlock:^(NSError *error) {
            PROGRESS_HUD_DISMISS
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.isCreateRpView = NO;
            [[FunctionManager sharedInstance] handleFailResponse:error];
        }];
    }
}

/**
 抢红包视图
 
 @param messageModel 红包信息
 */
- (void)actionShowRedPackedView:(FYMessage *)messageModel
{
    self.isAnimationEnd = NO;
    RedEnvelopeAnimationView *view = [[RedEnvelopeAnimationView alloc]initWithFrame:self.view.bounds];
    [view updateView:_enveModel.redPackedInfoDetail response:nil rpOverdueTime:self.messageItem.rpOverdueTime];
    self.redpView = view;
    
    __weak __typeof(self)weakSelf = self;
    // 开红包
    view.openBtnBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf action_tapCustom:messageModel];
    };
    // 查看详情
    view.detailBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf goto_RedPackedDetail:strongSelf.enveModel isCowCow:YES];
    };
    // 视图消失
    view.animationBlock = ^{
//        [self updateRedPackedStatus:messageModel.messageId cellStatus:@"1"];
        return ;
    };
    // 动画结束Block
    view.animationEndBlock = ^{
        return ;
    };
    // View消失Block
    view.disMissRedBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.isCreateRpView = NO;
        return ;
    };
    
    // 红包状态 0没有点击(红包没抢)  1已点击(红包已抢)  2已点击(红包已抢完） 3已点击(红包已过期)
    NSInteger status = [[_enveModel.redPackedInfoDetail objectForKey:@"status"] integerValue];
    NSInteger left = [[_enveModel.redPackedInfoDetail objectForKey:@"left"] integerValue];
    
    if (status == 2) {
        [self updateRedPackedStatus:messageModel.messageId cellStatus:@"3"];
    }
    
    if (status == 1 && left == 0) {
        [self updateRedPackedStatus:messageModel.messageId cellStatus:@"2"];
    }
    
    [view showInView:self.view];
}


#pragma mark - 好友聊天信息页

- (void)goto_FriendChatInfo:(FYContacts *)contacts
{
    [self.view endEditing:YES];
    
    [FriendChatInfoController pushFromNavVC:self contacts:contacts success:^(id data) {
        
    }];
}

#pragma mark - 点击头像事件

-(void)didTapCellChatHeaderImg:(FYMessage *)msg
{
    [self.view endEditing:YES];
    
//    if (self.chatType == FYConversationType_PRIVATE ||
//        self.chatType == FYConversationType_CUSTOMERSERVICE) {
//        return;
//    }
    
    if ([msg.user.userId isEqualToString:[AppModel shareInstance].userInfo.userId]) {
        return;
    }
    
    // 点击@用户
//    [self.sessionInputView addMentionedUser:msg.user];
    // 内部号可查看id
//    if ([AppModel shareInstance].userInfo.innerNumFlag) {
//        AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
//        [view showWithText:[NSString stringWithFormat:NSLocalizedString(@"昵称：%@\nID：%@", nil),msg.user.nick, msg.user.userId] button:NSLocalizedString(@"好的", nil) callBack:nil];
//    }
    [PersonalSignatureVC pushFromVC:self requestParams:msg success:^(id data) {
        
    }];
//    [self goto_GroupInfo];
}


#pragma mark - 长按头像

- (void)didLongPressCellChatHeaderImg:(UserInfo *)userInfo
{
    [self.view endEditing:YES];
    
    // 自己
    if ([userInfo.userId isEqualToString:[AppModel shareInstance].userInfo.userId]) {
        return;
    }
    
//    // 内部号可查看id
//    if ([AppModel shareInstance].userInfo.innerNumFlag) {
//        AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
//        [view showWithText:[NSString stringWithFormat:NSLocalizedString(@"昵称：%@\nID：%@", nil),userInfo.nick, userInfo.userId] button:NSLocalizedString(@"好的", nil) callBack:nil];
//    }
    // 点击@用户
    [self.sessionInputView addMentionedUser:userInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 抢红包

- (void)action_tapCustom:(FYMessage *)messageModel
{
    if (GroupTemplate_N10_BagLottery == self.messageItem.type) {

        self.response = [NSDictionary new];
        _timerView = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(uploadTimer:) userInfo:nil repeats:NO];
        
        PROGRESS_HUD_SHOW
         __weak __typeof(self)weakSelf = self;
        NSString *redpacketId = messageModel.redEnvelopeMessage.redpacketId;
        NSString *gameNumber = [NSString stringWithFormat:@"%ld", messageModel.redEnvelopeMessage.num];
        [NET_REQUEST_MANAGER requesGamesBagBagLotteryGrapWithGroupId:self.messageItem.groupId gameNumber:gameNumber redId:redpacketId success:^(id response) {
            PROGRESS_HUD_DISMISS
            FYLog(NSLocalizedString(@"包包彩抢包%@", nil), response);
            
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.response = response;
            strongSelf.messageId = messageModel.messageId;
            [strongSelf redPackedStatusJudgmentResponse:response];

        } failure:^(id error) {
            PROGRESS_HUD_DISMISS
            
            self.isAnimationEnd = YES;
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if ([error isKindOfClass:[NSDictionary class]]) {
                NSString *msg = [(NSDictionary *)error stringForKey:@"alterMsg"];
                if ([msg containsString:NSLocalizedString(@"余额不足", nil)]) {
                    [self checkShowBalanceView:msg];
                } else if ([msg containsString:NSLocalizedString(@"该红包已过期", nil)]) {
                    messageModel.redEnvelopeMessage.cellStatus = @"3";
                    [strongSelf updateRedPackedStatus:messageModel.messageId cellStatus:messageModel.redEnvelopeMessage.cellStatus];
                    [strongSelf.redpView disMissRedView];
                }
            } else {
                [[FunctionManager sharedInstance] handleFailResponse:error];
            }
            
            strongSelf.response = error;
            strongSelf.messageId = messageModel.messageId;
            [strongSelf redPackedStatusJudgmentResponse:error];
            
            [self performSelector:@selector(delayDisMissRedView) withObject:nil afterDelay:1.5];
        }];
    } else {
        NSDictionary *parameters = @{ @"packetId":messageModel.redEnvelopeMessage.redpacketId };
        
        self.response = [NSDictionary new];
        _timerView = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(uploadTimer:) userInfo:nil repeats:NO];
        
        __weak __typeof(self)weakSelf = self;
        __block NSDictionary *dict = [NSDictionary dictionary];
        
        PROGRESS_HUD_SHOW
        [NET_REQUEST_MANAGER redpacketGrab:parameters successBlock:^(NSDictionary *response) {
            PROGRESS_HUD_DISMISS
            
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.response = response;
            strongSelf.messageId = messageModel.messageId;
            dict = response;
            [strongSelf redPackedStatusJudgmentResponse:response];
            
        } failureBlock:^(id error) {
            PROGRESS_HUD_DISMISS
            
            if ([error[@"errorcode"] intValue] == 1) {
                [self.redpView updateView:self->_enveModel.redPackedInfoDetail response:error rpOverdueTime:@""];
            }
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if ([error isKindOfClass:[NSDictionary class]]) {
                NSString *msg = [(NSDictionary *)error stringForKey:@"alterMsg"];
                if ([msg containsString:NSLocalizedString(@"余额不足", nil)]) {
                    [self checkShowBalanceView:msg];
                } else if ([msg containsString:NSLocalizedString(@"该红包已过期", nil)]) {
                    messageModel.redEnvelopeMessage.cellStatus = @"3";
                    [strongSelf updateRedPackedStatus:messageModel.messageId cellStatus:messageModel.redEnvelopeMessage.cellStatus];
                    [strongSelf.redpView disMissRedView];
                }
            } else {
                [[FunctionManager sharedInstance] handleFailResponse:error];
            }
            
            strongSelf.response = error;
            strongSelf.messageId = messageModel.messageId;
            [strongSelf redPackedStatusJudgmentResponse:error];
            //
            [strongSelf uploadTimer:nil];
            
            [self performSelector:@selector(delayDisMissRedView) withObject:nil afterDelay:1.5];
        }];
    }
}

- (void)delayDisMissRedView
{
     [self.redpView disMissRedView];
}

- (AVAudioPlayer *)player
{
    if (!_player) {
        // 1. 创建播放器对象
        // 虽然传递的参数是NSURL地址, 但是只支持播放本地文件, 远程音乐文件路径不支持
        NSURL *url = [[NSBundle mainBundle]URLForResource:@"success.mp3" withExtension:nil];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        
        //允许调整速率,此设置必须在prepareplay 之前
        _player.enableRate = YES;
        // _player.delegate = self;
        
        //指定播放的循环次数、0表示一次
        //任何负数表示无限播放
        [_player setNumberOfLoops:0];
        //准备播放
        [_player prepareToPlay];
        
    }
    return _player;
}


- (void)uploadTimer:(NSTimer *)timer
{
    self.isAnimationEnd = YES;
    
    if (self.response != nil) {
        [self redPackedStatusJudgmentResponse:self.response];
    }
    
    if (_timerView != nil) {
        [_timerView invalidate];
    }
}


#pragma mark -  抢包视图动画结束
/**
 红包动画判断
 */
- (void)redpackedAnimationJudgment
{
    if (self.response != nil) {
        [self redPackedStatusJudgmentResponse:self.response];
    }
}


#pragma mark -  抢包后红包状态判断
- (void)redPackedStatusJudgmentResponse:(id)response
{
    if (self.isAnimationEnd == NO) {
        return;
    }
    
    NSInteger code = [[response objectForKey:@"code"] integerValue];
    if ([response objectForKey:@"code"] && code == 0) {
        // 正常
        [self.redpView disMissRedView];
        [self goto_RedPackedDetail:self.enveModel isCowCow:YES];
        [self updateRedPackedStatus:self.messageId cellStatus:@"1"];
#pragma mark - 声音
        NSString *key = MESSAGE_NOTICE_SWITCH_KEY(APPINFORMATION.userInfo.userId, self.sessionId);
        BOOL isNotDisturbSound = [[NSUserDefaults standardUserDefaults] boolForKey:key];
        if (!isNotDisturbSound && [AppModel shareInstance].turnOnSound) {
#if TARGET_IPHONE_SIMULATOR
            FYLog(NSLocalizedString(@"模拟器：声音提示，你抢到红包了！", nil));
#elif TARGET_OS_IPHONE
            [self.player play];
#endif
        }
    } else {
        NSInteger code = [[response objectForKey:@"errorcode"] integerValue];
        [self.redpView updateView:_enveModel.redPackedInfoDetail response:response rpOverdueTime:self.messageItem.rpOverdueTime];
        if (code == 11) {
            // 红包已抢完
            [self updateRedPackedStatus:self.messageId cellStatus:@"2"];
        } else if (code == 12) {
            // 已抢过红包
            [self updateRedPackedStatus:self.messageId cellStatus:@"1"];
        } else if (code == 13) {
            // 余额不足

        } else if (code == 14) {
            // 通讯异常，请重试
        } else if (code == 15) {
            // 单个红包金额不足0.01
        } else if (code == 16) {
            // 红包已逾期
            [self updateRedPackedStatus:self.messageId cellStatus:@"3"];
        } else if (code == 17) {
            
        } else {
            
        }
    }
}

/**
 更新红包状态
 
 @param messageId 消息ID
 @param cellStatus 红包状态 0 没有点击(红包没抢)  1 已点击(红包已抢)  2 已点击(红包已抢完） 3 已点击(红包已过期)
 */
- (void)updateRedPackedStatus:(NSString *)messageId cellStatus:(NSString *)cellStatus
{
    [self.dataSource enumerateObjectsUsingBlock:^(FYMessagelLayoutModel *modelLayout, NSUInteger idx, BOOL * _Nonnull stop) {
        if (messageId == modelLayout.message.messageId) {
             modelLayout.message.redEnvelopeMessage.cellStatus = cellStatus;
            [self setRedEnvelopeMessage:messageId redEnvelopeMessage:modelLayout.message.redEnvelopeMessage];
            self.dataSource[idx].message.redEnvelopeMessage.cellStatus = cellStatus;
            NSIndexPath *indexPth = [NSIndexPath indexPathForRow:idx inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPth] withRowAnimation:UITableViewRowAnimationNone];
            return;
        }
    }];
}


#pragma mark - 更新红包信息
/**
 * 更新红包信息
 * @param messageId 消息ID
 * @param redEnvelopeMessage 更改后的红包模型
*/
- (void)setRedEnvelopeMessage:(NSString *)messageId redEnvelopeMessage:(EnvelopeMessage *)redEnvelopeMessage
{
    FYMessage *fyMessage = [[IMMessageModule sharedInstance] getMessageWithMessageId:messageId];
    fyMessage.redEnvelopeMessage = redEnvelopeMessage;
    [[IMMessageModule sharedInstance] updateMessage:fyMessage];
}


#pragma mark - 查看红包详情

- (void)goto_RedPackedDetail:(id)obj isCowCow:(BOOL)isCowCow
{
    if (GroupTemplate_N10_BagLottery == self.messageItem.type) {
        [self.view endEditing:YES];
        self.isVSViewClick = NO;
        NSString *redPackedId;
        if ([obj isKindOfClass:[EnvelopeNet class]]) {
            EnvelopeNet *model = (EnvelopeNet *)obj;
            redPackedId = [model.redPackedInfoDetail[@"id"] stringValue];
        } else {
            redPackedId = (NSString *)obj;
        }
        //
        FYBagLotteryRedGrapController *VC = [[FYBagLotteryRedGrapController alloc]init];
        VC.type = self.messageItem.type;
        VC.packetId = redPackedId;
        [self.navigationController pushViewController:VC animated:YES];
    } else {
        [self.view endEditing:YES];
        self.isVSViewClick = NO;
        NSString *redPackedId;
        if ([obj isKindOfClass:[EnvelopeNet class]]) {
            EnvelopeNet *model = (EnvelopeNet *)obj;
            redPackedId = [model.redPackedInfoDetail[@"id"] stringValue];
        } else {
            redPackedId = (NSString *)obj;
        }
        
        FYRedEnvelopePublicViewController *VC = [[FYRedEnvelopePublicViewController alloc]init];
        VC.type = self.messageItem.type;
        VC.packetId = redPackedId;
        [self.navigationController pushViewController:VC animated:YES];
    }
}


#pragma mark 去发红包入口

/// 发红包入口
- (void)goto_sendRedEnvelopeEnt
{
    [self.view endEditing:YES];
    
    // 群类型（0：福利群；1：扫雷群；2：牛牛群；3：禁抢；4：抢庄牛牛群；5：二八杠；6：龙虎斗；7：接龙红包；8：二人牛牛；9:超级扫雷）
    if (GroupTemplate_N00_FuLi == self.messageItem.type) {
        [self sendFuLiPacket];
        return;
    } else if (GroupTemplate_N03_JingQiang == self.messageItem.type) {
        NoRobSendRPController *VC = [[NoRobSendRPController alloc] init];
        VC.CDParam = self.messageItem;
        [self.navigationController pushViewController:VC animated:YES];
    } else if (GroupTemplate_N09_SuperBobm == self.messageItem.type) {
        FYSuperBombSendPacketVC *sendVC = [[FYSuperBombSendPacketVC alloc] init];
        sendVC.messageItem = self.messageItem;
        [self.navigationController pushViewController:sendVC animated:YES];
    } else {
        SendRedEnvelopeController *VC = [[SendRedEnvelopeController alloc] init];
        VC.CDParam = self.messageItem;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (void)sendFuLiPacket
{
    if (self.messageItem.officeFlag) { // 官方群
        SendRedEnvelopeController *VC = [[SendRedEnvelopeController alloc] init];
        VC.isFu = YES;
        VC.CDParam = self.messageItem;
        [self.navigationController pushViewController:VC animated:YES];
    } else { // 自建群
        if ([self isGroupOwner]) {
            SendRedEnvelopeController *VC = [[SendRedEnvelopeController alloc] init];
            VC.isFu = YES;
            VC.CDParam = self.messageItem;
            [self.navigationController pushViewController:VC animated:YES];
        } else {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"暂未开放", nil))
        }
    }
}


#pragma mark - 导航条按钮事件

/// 群信息（群聊）
- (void)pressNavActionGroupDetailInfo
{
    [self.view endEditing:YES];
    
    WeakSelf
    GroupInfoViewController *vc = [GroupInfoViewController groupVc:self.messageItem];
    vc.block = ^(NSString *text) {
        weakSelf.navigationItem.title = text;
    };
    vc.changedInfoBlock = ^(FYCreateRequest *result) {
        weakSelf.groupConfig = result;
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 在线客服（群聊）
- (void)pressNavActionCustomerService:(id)sender
{
    [self.view endEditing:YES];
    
    NSString *urlString = [AppModel shareInstance].commonInfo[@"pop"];
    FYWebViewController *viewController = [[FYWebViewController alloc] initWithUrl:urlString];
    [viewController setTitle:NSLocalizedString(@"在线客服", nil)];
    [self.navigationController pushViewController:viewController animated:YES];
}

/// 聊天详情（单聊）
- (void)pressNavActionUserChatDetailInfo:(id)sender
{
    [self.view endEditing:YES];
    
    [self goto_FriendChatInfo:self.toContactsModel];
}

- (void)didMoveToParentViewController:(UIViewController*)parent
{
    [super didMoveToParentViewController:parent];
    
    if(!parent){
        _chatVC = nil;
    }
}


#pragma mark - 即将发送消息
- (FYMessage *)willSendMessage:(FYMessage *)message
{
    return message;
}

- (void)chatTimerStop
{
    if (_chatTimer!=nil) {
        [_chatTimer invalidate];
        self.isChatTimer = NO;
    }
}

- (void)chatTimer:(NSTimer*)timer
{
    // NSLog(@"test......name=%@",timer.userInfo);
    [self chatTimerStop];
}

- (void)openWebCustomerService
{
    FYWebViewController *VC = [[FYWebViewController alloc] initWithUrl:[AppModel shareInstance].commonInfo[@"pop"]];
    [VC setTitle:NSLocalizedString(@"在线客服", nil)];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)sendWelcomeMessage:(NSString *)groupId
{
    NSString *content = [NSString stringWithFormat:NSLocalizedString(@"大家好，我是%@", nil), [AppModel shareInstance].userInfo.nick];
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
    [userDict setObject:[AppModel shareInstance].userInfo.userId forKey:@"userId"];  // 用户ID
    [userDict setObject:[AppModel shareInstance].userInfo.nick forKey:@"nick"];   // 用户昵称
    [userDict setObject:[AppModel shareInstance].userInfo.avatar forKey:@"avatar"];  // 用户头像
    
    NSDictionary *parameters = @{
                                 @"user":userDict,  // 发送者用户信息
                                 @"from":[AppModel shareInstance].userInfo.userId,      // 发送者ID
                                 @"cmd":@"11",      // 聊天命令
                                 @"chatId":groupId,   // 群ID
                                 @"chatType":@(FYConversationType_GROUP),  // 1 群聊   2  p2p
                                 @"msgType":@(FYMessageTypeText),   // 0 文本 6 红包  7 报奖信息
                                 @"content":content // 消息内容
                                 };
    [[FYIMMessageManager shareInstance] sendMessageServer:parameters];
}


#pragma mark - 懒加载

- (UIView *)rightItem
{
    if (!_rightItem) {
        _rightItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, NAVIGATION_BAR_HEIGHT)];
        [_rightItem addSubview:self.navCustomer];
        [_rightItem addSubview:self.navGroupInfo];
    }
    return _rightItem;
}

- (UIButton *)navGroupInfo
{
    if (!_navGroupInfo) {
        CGFloat iconSize = 26.0f;
        _navGroupInfo =  [[UIButton alloc] initWithFrame:CGRectMake(40, (NAVIGATION_BAR_HEIGHT-iconSize)*0.5f, iconSize, iconSize)];
        [_navGroupInfo setImage:[[UIImage imageNamed:@"group-info"] imageByScalingProportionallyToSize:CGSizeMake(iconSize, iconSize)]
        forState:UIControlStateNormal];
        [_navGroupInfo addTarget:self action:@selector(pressNavActionGroupDetailInfo) forControlEvents:UIControlEventTouchUpInside];
        [_navGroupInfo setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }
    return _navGroupInfo;
}

- (UIButton *)navCustomer
{
    if (!_navCustomer) {
        CGFloat iconSize = 24.0f;
        _navCustomer = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, NAVIGATION_BAR_HEIGHT)];
        [_navCustomer setImage:[[UIImage imageNamed:ICON_NAV_BAR_BUTTON_CUSTOMER_SERVICE] imageByScalingProportionallyToSize:CGSizeMake(iconSize, iconSize)]
        forState:UIControlStateNormal];
        [_navCustomer setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_navCustomer addTarget:self action:@selector(pressNavActionCustomerService:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navCustomer;
}

- (UIButton *)navUserChatDetailInfo
{
    if (!_navUserChatDetailInfo) {
        _navUserChatDetailInfo = [self createButtonWithImage:@"icon_more_square_black"
                                                target:self
                                                action:@selector(pressNavActionUserChatDetailInfo:)
                                            offsetType:CFCNavBarButtonOffsetTypeRight
                                             imageSize:NAVIGATION_BAR_BUTTON_IMAGE_SIZE*0.8f];
    }
    return _navUserChatDetailInfo;
}

- (UIView *)floatButtonContainer
{
    if (!_floatButtonContainer) {
        _floatButtonContainer = [[UIView alloc] init];
    }
    return _floatButtonContainer;
}

- (NSMutableArray<UIButton *> *)floatButtons
{
    if (!_floatButtons) {
        _floatButtons = [NSMutableArray array];
    }
    return _floatButtons;
}


#pragma mark - Navigation

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (CGFloat)prefersNavigationBarHairlineHeight
{
    if (FYConversationType_GROUP == self.chatType) {
        return NAVIGATION_BAR_HAIR_LINE_HEIGHT_ZERO;
    }
    return NAVIGATION_BAR_HAIR_LINE_HEIGHT_DEFAULT;
}



#pragma mark - Private

/// 判断是否是群主,是否自建群
- (BOOL)isGroupOwner {
    if (self.messageItem.userId == [AppModel shareInstance].userInfo.userId) {
        return YES;
    }
    return NO;
}

/// 判断用户是否绑定了手机号
- (void)doToShowBindPhoneViewController
{
    FYPresentAlertViewController *alterVC = [FYPresentAlertViewController alertControllerWithContent:NSLocalizedString(@"请先绑定手机号", nil)];
    [alterVC setAlertTextAlignment:FYPresentAlertTextAlignmentCenter];
    [alterVC setConfirmActionBlock:^{
        FY2020ForgetController *viewController = [[FY2020ForgetController alloc] init];
        [viewController setTitle:NSLocalizedString(@"绑定手机", nil)];
        [viewController setIsNeedChangeNavigation:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    [[FunctionManager getAppRootViewController] presentViewController:alterVC animated:YES completion:nil];
}

/// 创建悬浮按钮
- (UIButton *)createUIOfFloatButtonIcon:(NSString *)imageUrl title:(NSString *)titleString tag:(NSInteger)tag lastItemView:(UIView *)lastItemView
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat floatBtnWidth = CHAT_MESSAGE_FLOAT_BUTTON_WIDTH;
    CGFloat floatBtnHeight = CHAT_MESSAGE_FLOAT_BUTTON_HEIGHT;
    CGFloat cornerRadius = floatBtnHeight*0.5f;
    CGRect frame = CGRectMake(0, 0, floatBtnWidth, floatBtnHeight);
    
    UIButton *floatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [floatButton setTag:tag];
    [floatButton setFrame:frame];
    [floatButton setBackgroundColor:[UIColor whiteColor]];
    [floatButton addTarget:self action:@selector(pressActionOfFloatBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.floatButtonContainer addSubview:floatButton];
    //
    [floatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(floatBtnWidth, floatBtnHeight));
        make.right.equalTo(self.floatButtonContainer.mas_right);
        if (!lastItemView) {
            make.top.equalTo(self.floatButtonContainer.mas_top).offset(margin*0.5f);
        } else {
            make.top.equalTo(lastItemView.mas_bottom).offset(margin*0.5f);
        }
    }];
    
    //
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(cornerRadius,cornerRadius)];
    CAShapeLayer *mask = [[CAShapeLayer alloc] init];
    mask.frame = frame;
    mask.path = path.CGPath;
    floatButton.layer.mask = mask;
    
    // 图片
    UIImageView *iconImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [floatButton addSubview:imageView];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setImage:[UIImage imageNamed:imageUrl]];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(floatButton.mas_centerY);
            make.left.equalTo(floatButton.mas_left).offset(cornerRadius*0.7f);
            make.width.height.equalTo(floatButton.mas_height).multipliedBy(0.5f);
        }];
        
        imageView;
    });
    iconImageView.mas_key = @"iconImageView";
    
    // 标题
    UILabel *titleLabel = ({
        UILabel *label = [UILabel new];
        [floatButton addSubview:label];
        [label setNumberOfLines:1];
        [label setText:titleString];
        [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(14)]];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(floatButton.mas_centerY);
            make.right.equalTo(floatButton.mas_right).offset(-margin*0.5f);
            make.left.equalTo(iconImageView.mas_right);
        }];
        
        label;
    });
    titleLabel.mas_key = @"titleLabel";
    
    return floatButton;
}

/// 悬浮按钮 - 标题隐藏与显示
- (void)onFloatButtonPangesture:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:pan.view];
    if(pan.state== UIGestureRecognizerStateEnded) {
        if (translation.x > 0) {
            CGPoint center = CGPointMake(SCREEN_MIN_LENGTH, self.floatButtonContainer.center.y);
            [self.floatButtonContainer setCenter:center];
            [self.floatButtonContainer mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.view.mas_right).offset(CHAT_MESSAGE_FLOAT_BUTTON_WIDTH*0.55f);
            }];
        } else {
            CGPoint center = CGPointMake(SCREEN_MIN_LENGTH-CHAT_MESSAGE_FLOAT_BUTTON_WIDTH*0.5f, self.floatButtonContainer.center.y);
            [self.floatButtonContainer setCenter:center];
            [self.floatButtonContainer mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.view.mas_right);
            }];
        }
    }
}


@end


