//
//  FYGameBaseViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGameBaseViewController.h"
#import "GroupInfoViewController.h"


@interface FYGameBaseViewController ()

@property (nonatomic, strong) FYCreateRequest *groupConfig;

/// 导航栏右边的菜单
@property (nonatomic, strong) UIView *rightItem;
/// 群聊 - 联系客服按钮
@property (nonatomic, strong) UIButton *navCustomer;
/// 群聊 - 群组成员按钮
@property (nonatomic, strong) UIButton *navGroupInfo;

@end


@implementation FYGameBaseViewController

+ (FYGameBaseViewController *)createGameVCByMsgItem:(MessageItem *)msgItem
{
    NSString *classNameString = [[self class] getGameVCClassStringByMsgItem:msgItem];
    FYGameBaseViewController *groupGameVC = [[NSClassFromString(classNameString) alloc] init];
    if (![groupGameVC isKindOfClass:[FYGameBaseViewController class]]) {
        NSAssert(NO, @"游戏页面的基类必须是[FYGameBaseViewController]类，请进行修改。");
    }

    // 设置群组游戏 IM 消息数据
    groupGameVC.messageItem = msgItem;
    
    // 设置聊天会话界面要显示的标题
    NSString *title = msgItem.chatgName;
    NSRange range = [title rangeOfString:@"("];
    if(range.length == 0)
        range = [title rangeOfString:@"（"];
    if(range.length > 0)
        title = [title substringToIndex:range.location];
    if(title.length == 0)
        title = NSLocalizedString(@"群组", nil);
    if (title.length > 12) {
        groupGameVC.title = [NSString stringWithFormat:@"%@...", [title substringToIndex:12]];
    } else {
        groupGameVC.title = title;
    }
    
    return groupGameVC;
}

+ (NSString *)getGameVCClassStringByMsgItem:(MessageItem *)msgItem
{
    NSString *classNameString = @"FYGameBaseViewController";

    // 极速扫雷
    if (GroupTemplate_N15_MineClearance == msgItem.type) {
        classNameString = @"FYGameJSSLViewController";
    }
    // 极速扫雷
    else if (GroupTemplate_N15_MineClearance == msgItem.type) {
        classNameString = @"FYGameJSSLViewController";
    }
    
    return classNameString;
}


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [AppModel shareInstance].chatType = FYConversationType_GROUP;
    
    // 必须禁用侧滑返回，返回前需要做相关操作（请求退群等操作）
    [self setFd_interactivePopDisabled:YES];
    [self setFd_interactivePopMaxAllowedInitialDistanceToLeftEdge:FULLSCREEN_POP_GESTURE_MAX_DISTANCE_TO_LEFT_EDGE];
    
    [self setUIOfNavigation];
    
}

- (void)setUIOfNavigation
{
    // 群聊
    UIBarButtonItem *infoItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightItem];
    self.navigationItem.rightBarButtonItem = infoItem;

}


#pragma mark - 导航条按钮事件

/// 用户退出当前页面
- (void)pressNavigationBarLeftButtonItem:(id)sender
{
    [super pressNavigationBarLeftButtonItem:sender];
    
    if (self.messageItem.officeFlag) {
        // 退出官方群请求
        [FYAPP_PRECISION_MANAGER doTryToQuitGroupOfficeYes:self.messageItem
                                            isBackToRootVC:NO
                                                      from:self.navigationController];
    }
}

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


@end

