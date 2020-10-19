//
//  FYBaseCoreViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBaseCoreViewController.h"
#import "FYWithdrawMoneyViewController.h"
#import "FYAddBankcardViewController.h"
#import "ActivityDetail1ViewController.h"
#import "ActivityDetail2ViewController.h"
#import "ChatViewController.h"
#import "WebViewController.h"
#import "EnterPwdBoxView.h"
#import "MessageItem.h"


@interface FYBaseCoreViewController ()

@property(nonatomic,strong) EnterPwdBoxView *entPwdView;

@end


@implementation FYBaseCoreViewController

#pragma mark - Life Cycle

- (void)fromBannerPushToVCWithBannerItem:(BannerItem*)item isFromLaunchBanner:(BOOL)isFromLaunchBanner
{
    if (![FunctionManager isEmpty:item.advLinkUrl]) {
        [NET_REQUEST_MANAGER requestClickBannerWithAdvSpaceId:item.advSpaceId Id:item.ID success:^(id object) {
            
        } fail:^(id object) {
            
        }];
    }
    
    WEAK_OBJ(weakSelf, self);
    NSInteger linktype = [item.linkType integerValue];
    switch (linktype) {
        case 1:
        {
            if (![FunctionManager isEmpty:item.advLinkUrl]) {
                FYWebViewController *webViewController = [[FYWebViewController alloc] initWithUrl:item.advLinkUrl];
                [webViewController setTitle:item.name];
                [self.navigationController pushViewController:webViewController animated:YES];
                if (isFromLaunchBanner) {
                    [webViewController actionBlock:^(id data) {
                        [[AppModel shareInstance] reSetTabBarAsRootAnimation];
                    }];
                }
            }
        }
            break;
        case 2:
        {
            if (![FunctionManager isEmpty:item.advLinkUrl]) {
                for (NSDictionary *dict in [AppModel shareInstance].myGroupArray) {
                    MessageItem *data = [MessageItem mj_objectWithKeyValues:dict];
                    if ([item.advLinkUrl isEqualToString: data.groupId]) {
                        [weakSelf chatProcessing:data];
                    }
                }
            }
        }
            break;
        case 3:
        {
            if (![FunctionManager isEmpty:item.advLinkUrl]) {
                
                [NET_REQUEST_MANAGER getActivityListWithSuccess:^(id object) {
                    NSDictionary * dict = object;
                    NSArray* dataArray = dict[@"data"][@"records"];
                    if(dataArray==nil || dataArray.count == 0){
                        [weakSelf setTabBarSelectedIndex:TABBAR_INDEX_GAMEHALL];
                    }else{
                        [weakSelf pushToActivityVC:dataArray onType:[item.advLinkUrl integerValue]];
                    }
                } fail:^(id object) {
                    [[FunctionManager sharedInstance] handleFailResponse:object];
                }];
                
            }else{
                [weakSelf setTabBarSelectedIndex:TABBAR_INDEX_GAMEHALL];
            }
        }
            break;
        case 4:
        {
            if (![FunctionManager isEmpty:item.advLinkUrl]) {
                NSInteger index = [item.advLinkUrl integerValue];
                if (index==1 || index==2) {
                    NSString *urlHead = @"";
                    NSString *urlTitle = @"";
                    if (index==1) {
                        urlHead = [AppModel shareInstance].commonInfo[@"big.wheel.lottery.url"];
                        urlTitle = NSLocalizedString(@"幸运大转盘", nil);
                    } else if (index==2){
                        urlHead = [AppModel shareInstance].commonInfo[@"fruit.slot.url"];
                        urlTitle = NSLocalizedString(@"水果游戏机", nil);
                    }
                    if (urlHead.length > 0) {
                        NSString *url = [NSString stringWithFormat:@"%@?token=%@&publickey=%@&userAccount=%@&tenant=%@",urlHead,[AppModel shareInstance].userInfo.token,[AppModel shareInstance].publicKey,GetUserDefaultWithKey(@"mobile"),kNewTenant];
                        
                        FYWebViewController *webViewController = [[FYWebViewController alloc] initWithUrl:url gameType:FYWebGameSelfDianZiType];
                        [webViewController setUserid:APPINFORMATION.userInfo.userId];
                        [webViewController setTitle:urlTitle];
                        [self.navigationController pushViewController:webViewController animated:YES];
                    } else {
                        [weakSelf setTabBarSelectedIndex:TABBAR_INDEX_RECHARGE];
                    }
                } else {
                    [weakSelf setTabBarSelectedIndex:TABBAR_INDEX_RECHARGE];
                }
            } else {
                [weakSelf setTabBarSelectedIndex:TABBAR_INDEX_RECHARGE];
            }
        }
            break;
        case 5:
        {
            if (![FunctionManager isEmpty:item.advLinkUrl]) {
                ImageDetailViewController *vc = [[ImageDetailViewController alloc] init];
                vc.imageUrl = item.advLinkUrl;
                vc.hiddenNavBar = YES;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 7://充值
        {
            if (![FunctionManager isEmpty:item.advLinkUrl]) {
                if ([FunctionManager isPureInt:item.advLinkUrl]) {
                    [weakSelf setTabBarSelectedIndex:[item.advLinkUrl integerValue]];
                } else {
                    FYRechargeMainViewController *VC = [[FYRechargeMainViewController alloc] initWithIsPush:YES];
                    [weakSelf.navigationController pushViewController:VC animated:YES];
                }
            }
        }
            break;
            
        case 6://代理
        {
            if (![FunctionManager isEmpty:item.advLinkUrl]) {
                if ([FunctionManager isPureInt:item.advLinkUrl]) {
                    [weakSelf setTabBarSelectedIndex:[item.advLinkUrl integerValue]];
                } else {
                    UIViewController *vc =[[NSClassFromString([NSString stringWithFormat:@"%@",item.advLinkUrl]) alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }
        }
            break;
        case 8://提现
        {
            if (![FunctionManager isEmpty:item.advLinkUrl]) {
                if ([FunctionManager isPureInt:item.advLinkUrl]) {
                    [weakSelf setTabBarSelectedIndex:[item.advLinkUrl integerValue]];
                } else {
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
                }
            }
        }
            break;
        case 12:
        {
            // 创建自建群
            [NET_REQUEST_MANAGER isDisplayCreateGroup:@{} successBlock:^(NSDictionary *success) {
                if ([success isKindOfClass:[NSDictionary class]]) {
                    NSInteger code = [[success valueForKey:@"code"] integerValue];
                    if (code == 0) {
                        [SVProgressHUD dismiss];
                        Class cls = NSClassFromString(@"FYCreateGroupViewController");
                        UIViewController *VC = [[cls alloc] init];
                        [weakSelf.navigationController pushViewController:VC animated:YES];
                        return;
                    }
                }
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"游戏暂未开放，敬请期待", nil)];
            } failureBlock:^(NSError *failure) {
                [[FunctionManager sharedInstance] handleFailResponse:failure];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)chatProcessing:(MessageItem*)item
{
    __weak __typeof(self)weakSelf = self;
    [[AppModel shareInstance] checkGroupId:item.groupId Completed:^(BOOL complete) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (complete) {
            [strongSelf groupChat:item isNew:NO];
        } else {
            if (item.password != nil && item.password.length > 0) {
                [strongSelf passwordBoxView:item];
            } else {
                [strongSelf joinGroup:item password:nil];
            }
        }
    }];
}

- (void)joinGroup:(MessageItem *)item password:(NSString *)password
{
    // 加入群组
    SVP_SHOW;
    __weak __typeof(self)weakSelf = self;
    [[NetRequestManager sharedInstance] getChatGroupJoinWithGroupId:item.groupId pwd:password success:^(id object) {
        SVP_DISMISS;
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([[object objectForKey:@"code"] integerValue] == 0) {
            [strongSelf groupChat:item isNew:YES];
        } else {
            if ([[object objectForKey:@"errorcode"] integerValue] == 19) {
                NSString *msg = [NSString stringWithFormat:@"%@",[object objectForKey:@"alterMsg"]];
                SVP_ERROR_STATUS(msg);
                [strongSelf groupChat:item isNew:YES];
            }else{
                [[FunctionManager sharedInstance] handleFailResponse:object];
            }
            
        }
    } fail:^(id object) {
        
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}


#pragma mark - 输入密码框

- (void)passwordBoxView:(MessageItem *)item
{
    EnterPwdBoxView *entPwdView = [[EnterPwdBoxView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _entPwdView = entPwdView;
    [_entPwdView showInView:self.view];
    __weak __typeof(self)weakSelf = self;
    
    // 查看详情
    _entPwdView.joinGroupBtnBlock = ^(NSString *password){
        [weakSelf enterPwdView:item password:password];
    };
}

- (void)enterPwdView:(MessageItem *)item password:(NSString *)password
{
    if (password.length == 0) {
        SVP_ERROR_STATUS(NSLocalizedString(@"请输入密码", nil));
        return;
    }
    [self.entPwdView disMissView];
    [self joinGroup:item password:password];
}


- (void)groupChat:(id)obj isNew:(BOOL)isNew
{
    ChatViewController *vc = [ChatViewController groupChatWithObj:obj];
    vc.isNewMember = isNew;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)pushToActivityVC:(NSArray*) dataArray onType:(NSInteger)type
{
    for (NSDictionary *dic in dataArray) {
        NSInteger index = [dic[@"type"] integerValue];
        if (type == index) {
            
            if(type == RewardType_bzsz || type == RewardType_ztlsyj || type == RewardType_yqhycz || type == RewardType_czjl || type == RewardType_zcdljl){//6000豹子顺子奖励 5000直推流水佣金 1110邀请好友充值 1100充值奖励 2100注册登录奖励
                ActivityDetail1ViewController *vc = [[ActivityDetail1ViewController alloc] init];
                vc.infoDic = dic;
                vc.imageUrl = dic[@"bodyImg"];
                vc.title = dic[@"mainTitle"];
                vc.hiddenNavBar = YES;
                vc.top = YES;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if(type == RewardType_fbjl
                     ||type == RewardType_qbjl
                     ||type == RewardType_jjj){// 3000发包奖励 4000抢包奖励
                ActivityDetail2ViewController *vc = [[ActivityDetail2ViewController alloc] init];
                vc.infoDic = dic;
                vc.title = dic[@"mainTitle"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self setTabBarSelectedIndex:TABBAR_INDEX_GAMEHALL];
            }
            
        }
    }
}

- (void)setTabBarSelectedIndex:(NSInteger)index
{
    if (self.navigationController.tabBarController.selectedIndex == index) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        self.navigationController.tabBarController.hidesBottomBarWhenPushed=NO;
        UITabBarController *rootVC = (UITabBarController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
        [rootVC setSelectedIndex:index];
        [self.navigationController.tabBarController setSelectedIndex:index];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


@end


