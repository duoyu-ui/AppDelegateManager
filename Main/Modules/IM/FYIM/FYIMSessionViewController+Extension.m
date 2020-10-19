//
//  FYIMSessionViewController+Extension.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYIMSessionViewController+Extension.h"
#import "FYBalanceInfoModel.h"
#import "FYBankerView.h"
#import "FYBagLotteryBetHudView.h"
#import "FYBagLotteryBetHudData.h"
#import "SSChatBagLotteryBetModel.h"
#import "FYBagLotteryBetModel.h"
#import "FYPermutationTool.h"
#import "FYBagBagCowBetHubView.h"
#import "FYBettingDetailsProcessing.h"
@implementation FYIMSessionViewController (Extension)

- (void)UpdateGroupInfo
{
    // 群聊天监听通知
    if (FYConversationType_GROUP == self.chatType) {
        
        [NOTIF_CENTER addObserver:self
                         selector:@selector(didNotificationReloadMyMessageGroupList:)
                             name:kReloadMyMessageGroupList
                           object:nil];
        
        // 抢庄牛牛、二八杠、龙虎斗、接龙红包
        if (GroupTemplate_N04_RobNiuNiu == self.messageItem.type
            || GroupTemplate_N05_ErBaGang == self.messageItem.type
            || GroupTemplate_N06_LongHuDou == self.messageItem.type
            ) { // 抢庄牛牛、二八杠、龙虎斗
            [self robNiuNiuInfo];
            [NOTIF_CENTER addObserver:self
                             selector:@selector(didNotificationRobNiuNiuContent:)
                                 name:kNotificationGroupOfRobNiuNiuContent
                               object:nil];
        } else if (GroupTemplate_N07_JieLong == self.messageItem.type) { // 接龙红包
            [self solitaireInfo];
            [NOTIF_CENTER addObserver:self
                             selector:@selector(didNotificationSolitaireContent:)
                                 name:kNotificationGroupOfRobNiuNiuContent
                               object:nil];
        } else if (GroupTemplate_N10_BagLottery == self.messageItem.type){ // 包包彩
            [self getBegLotteryInfo];
            [NOTIF_CENTER addObserver:self
                             selector:@selector(didNotificationBagLotteryContent:)
                                 name:kNotificationGroupOfRobNiuNiuContent
                               object:nil];
        } else if (GroupTemplate_N11_BagBagCow == self.messageItem.type) { // 包包牛
            [NOTIF_CENTER addObserver:self
                             selector:@selector(didNotificationBagBagCowContent:)
                                 name:kNotificationGroupOfRobNiuNiuContent
                               object:nil];
            [self getBegBagCowInfo];
        } else if (GroupTemplate_N14_BestNiuNiu == self.messageItem.type) { // 百人牛牛
            [NOTIF_CENTER addObserver:self
                             selector:@selector(didNotificationBestNiuNiuContent:)
                                 name:kNotificationGroupOfRobNiuNiuContent
                               object:nil];
            [self getBestNiuNiuInfo];
        }
    }

    [NOTIF_CENTER addObserver:self
                     selector:@selector(reloadGamesMallList:)
                         name:kNotificationReloadGamesMallList
                       object:nil];
}
///游戏维护提示
- (void)reloadGamesMallList:(NSNotification *)notification{
    NSDictionary *object = [NSDictionary dictionaryWithDictionary:notification.object];
    NSDictionary *dict = object[@"data"];
    NSInteger type = [dict[@"type"] integerValue];
    if (type == self.messageItem.type) {
        NSDictionary *data = [[NSString stringWithFormat:@"%@",dict[@"data"]] mj_JSONObject];
        BOOL isMaintenance = [[NSString UUIDTimestamp] integerValue] < [data[@"maintainStart"] integerValue];
        if ([data[@"gameFlag"] integerValue] == 3 && isMaintenance) {
            NSString *start = [NSString timeStampToString:[data[@"maintainStart"] integerValue]];
            NSString *end = [NSString timeStampToString:[data[@"maintainEnd"] integerValue]];
            ///计算维护时间
            NSInteger maintenanceTime = ([data[@"maintainEnd"] integerValue] / 1000 - [data[@"maintainStart"] integerValue] / 1000)/60;
            NSString *maintenanceStr = [NSString string];
            if (maintenanceTime > 60) {//按小时算
                NSInteger hours = maintenanceTime / 60;
                NSInteger minutes = maintenanceTime % 60;
                maintenanceStr = [NSString stringWithFormat:NSLocalizedString(@"%zd小时%zd分钟", nil),hours,minutes];
            }else{
                maintenanceStr = [NSString stringWithFormat:NSLocalizedString(@"%zd分钟", nil),maintenanceTime];
            }
            
            NSString *context = [NSString stringWithFormat:NSLocalizedString(@"我们计划于%@至%@进行一次游戏维护\n维护时间%@", nil),start,end,maintenanceStr];
            NSMutableAttributedString *message = [[NSMutableAttributedString alloc]initWithString:context];
            [message addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12]range:NSMakeRange(0,context.length)];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:context preferredStyle:UIAlertControllerStyleAlert];
                [alerVC setValue:message forKey:@"attributedMessage"];
                [alerVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"请您知晓", nil) style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alerVC animated:YES completion:nil];
            });
        }
    }
}
// 通知处理 - 更新群组信息
- (void)didNotificationReloadMyMessageGroupList:(NSNotification *)notification
{
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:notification.object];
    if ([dict count]) {
        MessageItem *item = [MessageItem mj_objectWithKeyValues:dict[@"data"][@"chatInfo"]];
        // 更新群会话名称
        [self updateGroupInfoWithId:item.groupId name:item.chatgName];
        // 防止crash
        if ([self.messageItem isKindOfClass:[MessageItem class]]) {
            if (self.messageItem.robNiuniu != nil) {
                item.robNiuniu = self.messageItem.robNiuniu;
            }
        }
        
        if (item.groupId == self.messageItem.groupId) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.messageItem = item;
                self.title = self.messageItem.chatgName;
                [self reloadPlayGroupInfo];
                [self.tableView reloadData];
            });
        }
    }
}

- (void)updateGroupInfoWithId:(NSString *)groupId name:(NSString *)name
{
    if (groupId != nil) {
        FYContacts *contacts = [[IMSessionModule sharedInstance] getSessionWithSessionId:groupId];
        if (contacts != nil) {
            contacts.name = name;
            [[IMSessionModule sharedInstance] updateSeesion:contacts];
        }
    }
}
/// 重新获取群配置（加注金额，上庄比例）
- (void)reloadPlayGroupInfo
{
    if (self.messageItem.groupId) {
        
        [[NetRequestManager sharedInstance] getGroupInfoWithGroupId:self.messageItem.groupId success:^(id object) {
            if (object && [object isKindOfClass:[NSDictionary class]]) {
                if ([object[@"code"] integerValue] == 0) {
                    NSDictionary *JSONData = [object[@"data"] mj_JSONObject];
                    MessageItem *model = [MessageItem mj_objectWithKeyValues:JSONData];
                    self.messageItem.robNiuniu = model.robNiuniu;
                    [self updateGroupInfoWithId:self.messageItem.groupId name:model.chatgName];
                }
            }
            
            [self.tableView reloadData];
            
        } fail:^(id object) {
            
            if (object && [object isKindOfClass:[NSDictionary class]]) {
                NSInteger errorCode = [object[@"errorcode"] integerValue];
                if (errorCode == 10000001) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            }
            
            [[FunctionManager sharedInstance] handleFailResponse:object];
        }];
    }
}
#pragma mark -  抢庄牛牛、二八杠、龙虎斗群信息
// 抢庄牛牛群信息
- (void)robNiuNiuInfo{
    NSDictionary *dict = @{@"chatId":self.messageItem.groupId};
    [NET_REQUEST_MANAGER getRobNiuNiuInfoDict:dict success:^(id object) {
        if ([object[@"code"] integerValue] == 0) {
            // 主线程刷新UI
            [self performSelectorOnMainThread:@selector(robNiuNiuQunContent:) withObject:object waitUntilDone:YES];
        }
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
    [self updateBalance];
}
// 抢庄牛牛群信息
- (void)didNotificationRobNiuNiuContent:(NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    NSString *groupId = [NSString stringWithFormat:@"%@",dict[@"data"][@"chatId"]];
    if (![self.messageItem.groupId isEqualToString:groupId]) {
        return;
    }
    
    NSDictionary *dataDict = [dict[@"data"][@"content"] mj_JSONObject];
    if ([dict[@"command"] integerValue] == 36){//牛牛消息
        // 主线程刷新UI
        [self performSelectorOnMainThread:@selector(robNiuNiuQunContent:) withObject:dataDict waitUntilDone:YES];
    }
}

- (void)robNiuNiuQunContent:(NSDictionary *)dict
{
   
    NSInteger type = [dict[@"type"] integerValue];
   
    if (type == 5 || type == 4) {
        // 本期无投注,延迟投注
        return;
    } else if(type == 3 || type == 6) {
        // 更新余额
        [self updateBalance];
        return;
    } else if (type == 2) {
         // 继续坐庄
        MJWeakSelf
        [FYBankerView showBankerModel:[FYBankerModel mj_objectWithKeyValues:dict[@"data"]] view:self.view block:^(NSInteger money) {
            if (money == 0) {
                [weakSelf getNNContinueBankerwhitMoney:@""];
            }else{
                [weakSelf getNNContinueBankerwhitMoney:[NSString stringWithFormat:@"%zd",money]];
            }
        }];
        return;
    } else if (type == 1004) {
        // 群配置信息已更改
        [self reloadPlayGroupInfo];
        return;
    } else if (type == 14){
        return;
    }
    
    if ([dict[@"data"] mj_JSONString].length == 0) {
        return;
    }
    
    RobNiuNiuQunModel *modelOfRobNiuNiu = [RobNiuNiuQunModel mj_objectWithKeyValues:dict[@"data"]];
    if (modelOfRobNiuNiu.status == 3) {
        [self updateBalance];
    }
    // 群类型（0：福利群；1：扫雷群；2：牛牛群；4：抢庄牛牛群；5：二八杠；6：龙虎斗；7：接龙红包；8：二人牛牛；9:超级扫雷）
    if (GroupTemplate_N04_RobNiuNiu == self.messageItem.type
        || GroupTemplate_N05_ErBaGang == self.messageItem.type
        || GroupTemplate_N06_LongHuDou == self.messageItem.type
        ) {
        if (modelOfRobNiuNiu.status != 1) {
            [FYBankerView bankDismiss];
        }
        self.countdownView.modelOfNiuNiu = modelOfRobNiuNiu;
        if(self.delegate_keyboard && [self.delegate_keyboard respondsToSelector:@selector(didUpdateChatKeyboardCustomButtonWithRobNiuNiuQunModel:)]){
            [self.delegate_keyboard didUpdateChatKeyboardCustomButtonWithRobNiuNiuQunModel:modelOfRobNiuNiu];
        }
    }
}
/// 连续上庄&放弃上庄
- (void)getNNContinueBankerwhitMoney:(NSString *)money
{
    [NET_REQUEST_MANAGER robNiuNiuContinueBankerChatId:self.messageItem.groupId money:money success:^(id object) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            if ([object[@"code"] integerValue] != 0) {
                [SVProgressHUD showInfoWithStatus:object[@"msg"]];
            }
        }
        [self updateBalance];
        
    } fail:^(id object) {
        [[FunctionManager sharedInstance]handleFailResponse:object];
    }];
}
#pragma mark - 接龙群信息
// 接龙群信息
- (void)solitaireInfo
{
    [NET_REQUEST_MANAGER  getSolitaireInfoDict:@{@"chatId":self.messageItem.groupId} success:^(id response) {
        if (NET_REQUEST_SUCCESS(response)) {
            // 主线程刷新UI
            [self performSelectorOnMainThread:@selector(solitaireQunContent:) withObject:response waitUntilDone:YES];
        }
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
    
    [self updateBalance];
}
// 接龙
- (void)solitaireQunContent:(NSDictionary *)dict
{
    FYSolitaireInfoModel *modelOfSolitaire = [FYSolitaireInfoModel mj_objectWithKeyValues:dict[@"data"]];
    if (modelOfSolitaire == nil || [dict[@"data"] mj_JSONString].length == 0) {
        return;
    }
    if(self.delegate_keyboard && [self.delegate_keyboard respondsToSelector:@selector(didUpdateChatKeyboardCustomButtonWithSolitaireInfoModel:)]){
        [self.delegate_keyboard didUpdateChatKeyboardCustomButtonWithSolitaireInfoModel:modelOfSolitaire];
    }
    self.sinfoModel = modelOfSolitaire;
    if (modelOfSolitaire.gameList.count > 0) { // 更新list里面用户余额
        [modelOfSolitaire.gameList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[NSString stringWithFormat:@"%@",obj] isEqualToString:[AppModel shareInstance].userInfo.userId]) {
                [self updateBalance];
            }
        }];
    }
}
// 接龙
- (void)didNotificationSolitaireContent:(NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    NSString *groupId = [NSString stringWithFormat:@"%@",dict[@"data"][@"chatId"]];
    if (![self.messageItem.groupId isEqualToString:groupId]) {
        return;
    }
    NSDictionary *dataDict = [dict[@"data"][@"content"] mj_JSONObject];
    [self performSelectorOnMainThread:@selector(solitaireQunContent:) withObject:dataDict waitUntilDone:YES];
}

#pragma mark - 包包彩
- (void)getBegLotteryInfo{
    NSDictionary *dict =@{
        @"groupId":self.messageItem.groupId,
        @"userId":[AppModel shareInstance].userInfo.userId
    };
    [NET_REQUEST_MANAGER getBegLotteryInfoDict:dict success:^(id object) {
       RobNiuNiuQunModel *modelOfRobNiuNiu = [RobNiuNiuQunModel mj_objectWithKeyValues:object[@"data"]];
        [self performSelectorOnMainThread:@selector(bagLotteryQunContent:) withObject:object waitUntilDone:YES];
        self.nperHaederView.dict = @{//包包彩数据
                   @"gameNumber":@(modelOfRobNiuNiu.gameNumber),
                   @"groupId": self.messageItem.groupId,
                   @"userId": [AppModel shareInstance].userInfo.userId
               };
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
    [self updateBalance];
}
// 包包彩
- (void)didNotificationBagLotteryContent:(NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    NSString *groupId = [NSString stringWithFormat:@"%@",dict[@"data"][@"chatId"]];
    if (![self.messageItem.groupId isEqualToString:groupId]) {
        return;
    }
    NSDictionary *dataDict = [dict[@"data"][@"content"] mj_JSONObject];
    if ([dataDict[@"type"] integerValue] == 1) {//更新群状态
        [self performSelectorOnMainThread:@selector(bagLotteryQunContent:) withObject:dataDict waitUntilDone:YES];
    }
}
//包包彩更新群状态
-(void)bagLotteryQunContent:(NSDictionary *)dict
{
    RobNiuNiuQunModel *modelOfRobNiuNiu = [RobNiuNiuQunModel mj_objectWithKeyValues:dict[@"data"]];
    // 刷新投注页面群信息
    if(self.delegate_bet && [self.delegate_bet respondsToSelector:@selector(didUpdateLotteryGameGroupInfoModel:)]){
        [self.delegate_bet didUpdateLotteryGameGroupInfoModel:modelOfRobNiuNiu];
    }
    // 刷新走势图页面倒计时信息
    if(self.delegate_lottery && [self.delegate_lottery respondsToSelector:@selector(didUpdateLotteryGameGroupInfoModel:)]){
        [self.delegate_lottery didUpdateLotteryGameGroupInfoModel:modelOfRobNiuNiu];
    }
    // 刷新键盘群信息
    if(self.delegate_keyboard && [self.delegate_keyboard respondsToSelector:@selector(didUpdateChatKeyboardCustomButtonWithRobNiuNiuQunModel:)]){
        [self.delegate_keyboard didUpdateChatKeyboardCustomButtonWithRobNiuNiuQunModel:modelOfRobNiuNiu];
    }
    [NOTIF_CENTER postNotificationName:kNotificationGroupStatusMessage object:dict];
    if (modelOfRobNiuNiu.status == 3 || modelOfRobNiuNiu.status == 6) {//投注和结算更新余额
          [self updateBalance];
      }
    // 解决刷新开奖不及时的问题
    self.countdownView.modelOfNiuNiu = modelOfRobNiuNiu;
    if (self.bagLotteryModel.gameNumber == modelOfRobNiuNiu.gameNumber) {
        return;
    } else {
        self.bagLotteryModel = modelOfRobNiuNiu;
        self.nperHaederView.dict = @{ //包包彩数据
            @"gameNumber":@(self.bagLotteryModel.gameNumber),
            @"groupId": self.messageItem.groupId,
            @"userId": [AppModel shareInstance].userInfo.userId
        };
    }
}

#pragma mark - 包包牛
- (void)getBegBagCowInfo
{
    self.nperHaederView.itemType = GroupTemplate_N11_BagBagCow;
    self.nperHaederView.dict = @{//包包牛数据
        @"chatId": self.messageItem.groupId,
        @"userId": [AppModel shareInstance].userInfo.userId
    };
    [NET_REQUEST_MANAGER getBegBagCowInfoDict:@{@"chatId":self.messageItem.groupId,} success:^(id object) {
        if ([object[@"code"] integerValue] == 0) {
             [self performSelectorOnMainThread:@selector(bagBagCowQunContent:) withObject:object waitUntilDone:YES];
        }
    } fail:^(id object) {
        [[FunctionManager sharedInstance]handleFailResponse:object];
    }];
     [self updateBalance];
}
- (void)didNotificationBagBagCowContent:(NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    NSString *groupId = [NSString stringWithFormat:@"%@",dict[@"data"][@"chatId"]];
    if (![self.messageItem.groupId isEqualToString:groupId]) {
        return;
    }
    NSDictionary *dataDict = [dict[@"data"][@"content"] mj_JSONObject];
    if ([dataDict[@"type"] integerValue] == 1) {//更新群状态
        [self performSelectorOnMainThread:@selector(bagBagCowQunContent:) withObject:dataDict waitUntilDone:YES];
    }
}
- (void)bagBagCowQunContent:(NSDictionary *)dict
{
    RobNiuNiuQunModel *modelOfRobNiuNiu = [RobNiuNiuQunModel mj_objectWithKeyValues:dict[@"data"]];
    // 刷新投注页面群信息
    if(self.delegate_bet && [self.delegate_bet respondsToSelector:@selector(didUpdateLotteryGameGroupInfoModel:)]){
        [self.delegate_bet didUpdateLotteryGameGroupInfoModel:modelOfRobNiuNiu];
    }
    // 刷新走势图页面倒计时信息
    if(self.delegate_lottery && [self.delegate_lottery respondsToSelector:@selector(didUpdateLotteryGameGroupInfoModel:)]){
        [self.delegate_lottery didUpdateLotteryGameGroupInfoModel:modelOfRobNiuNiu];
    }
    // 刷新键盘群信息
    if(self.delegate_keyboard && [self.delegate_keyboard respondsToSelector:@selector(didUpdateChatKeyboardCustomButtonWithRobNiuNiuQunModel:)]){
        [self.delegate_keyboard didUpdateChatKeyboardCustomButtonWithRobNiuNiuQunModel:modelOfRobNiuNiu];
    }
    // 解决刷新开奖不及时的问题
    self.countdownView.modelOfNiuNiu = modelOfRobNiuNiu;
    if (modelOfRobNiuNiu.status == 3 || modelOfRobNiuNiu.status == 6) {//投注和结算更新余额
        [self updateBalance];
    }
    if (self.bagLotteryModel.gameNumber == modelOfRobNiuNiu.gameNumber) {
        return;
    } else {
        self.bagLotteryModel = modelOfRobNiuNiu;
        self.nperHaederView.itemType = GroupTemplate_N11_BagBagCow;
        self.nperHaederView.dict = @{ // 包包牛数据
            @"chatId": self.messageItem.groupId,
            @"userId": [AppModel shareInstance].userInfo.userId
        };
    }
}

#pragma mark - 百人牛牛
- (void)getBestNiuNiuInfo
{
    [NET_REQUEST_MANAGER requestWithAct:ActRequestBestNiuNiuInfo parameters:@{@"groupId": self.messageItem.groupId} success:^(id object) {
        NSDictionary *dict = [object mj_JSONObject];
        if ([dict[@"code"] integerValue] == 0) {
            FYBestWinsLossesFlopResult *result = [FYBestWinsLossesFlopResult mj_objectWithKeyValues:dict[@"data"][@"resultDTO"]];
            self.wlHaederView.result = result;
            [self performSelectorOnMainThread:@selector(bestNiuNiuContent:) withObject:object waitUntilDone:YES];
        }
    } failure:^(id object) {
        [[FunctionManager sharedInstance]handleFailResponse:object];
    }];
    [self updateBalance];
}
- (void)didNotificationBestNiuNiuContent:(NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    NSString *groupId = [NSString stringWithFormat:@"%@",dict[@"data"][@"chatId"]];
    if (![self.messageItem.groupId isEqualToString:groupId]) {
        return;
    }
    NSDictionary *dataDict = [dict[@"data"][@"content"] mj_JSONObject];
    if ([dataDict[@"type"] integerValue] == 1) {//更新群状态
        [self performSelectorOnMainThread:@selector(bestNiuNiuContent:) withObject:dataDict waitUntilDone:YES];
    }
}
- (void)bestNiuNiuContent:(NSDictionary*)dict
{
    RobNiuNiuQunModel *modelOfRobNiuNiu = [RobNiuNiuQunModel mj_objectWithKeyValues:dict[@"data"]];
    // 刷新投注页面群信息
    if(self.delegate_bet && [self.delegate_bet respondsToSelector:@selector(didUpdateLotteryGameGroupInfoModel:)]){
        [self.delegate_bet didUpdateLotteryGameGroupInfoModel:modelOfRobNiuNiu];
    }
    // 刷新走势图页面倒计时信息
    if(self.delegate_lottery && [self.delegate_lottery respondsToSelector:@selector(didUpdateLotteryGameGroupInfoModel:)]){
        [self.delegate_lottery didUpdateLotteryGameGroupInfoModel:modelOfRobNiuNiu];
    }
    // 刷新键盘群信息
    if(self.delegate_keyboard && [self.delegate_keyboard respondsToSelector:@selector(didUpdateChatKeyboardCustomButtonWithRobNiuNiuQunModel:)]){
        [self.delegate_keyboard didUpdateChatKeyboardCustomButtonWithRobNiuNiuQunModel:modelOfRobNiuNiu];
    }
    // 解决刷新开奖不及时的问题
    self.countdownView.modelOfNiuNiu = modelOfRobNiuNiu;
    if (self.bagLotteryModel.gameNumber == modelOfRobNiuNiu.gameNumber) {
        return;
    } else {
        self.bagLotteryModel = modelOfRobNiuNiu;
        self.wlHaederView.dict = @{
            @"gameNumber":@(modelOfRobNiuNiu.gameNumber),
            @"groupId":self.messageItem.groupId,
            @"userId":[AppModel shareInstance].userInfo.userId
        };
        [NOTIF_CENTER postNotificationName:kNotificationGroupStatusMessage object:dict];
    }
}

#pragma mark - 抢庄 抢庄牛牛投注
/// 抢庄
/// @param money 抢庄金额
- (void)robNiuNiuBankeer:(NSString *)money
{
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER robNiuNiuBankeerChatId:self.messageItem.groupId money:money success:^(id response) {
        PROGRESS_HUD_DISMISS
        if (!NET_REQUEST_SUCCESS(response)) {
            NSString *msg = [(NSDictionary *)response stringForKey:@"msg"];
            if ([msg containsString:NSLocalizedString(@"余额不足", nil)]) {
                [self checkShowBalanceView:msg];
            } else {
                ALTER_INFO_MESSAGE(msg)
            }
        }
        [self updateBalance];
    } fail:^(id error) {
        PROGRESS_HUD_DISMISS
        if ([error isKindOfClass:[NSDictionary class]]) {
            NSString *msg = [(NSDictionary *)error stringForKey:@"alterMsg"];
            if ([msg containsString:NSLocalizedString(@"余额不足", nil)]) {
                [self checkShowBalanceView:msg];
            } else {
                ALTER_HTTP_ERROR_MESSAGE(error)
            }
        } else {
            [[FunctionManager sharedInstance] handleFailResponse:error];
        }
    }];
}
/// 抢庄牛牛投注
/// @param money 投注金额
- (void)robNiuNiuBett:(NSString *)money betAttr:(NSInteger)betAttr
{
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER robNiuNiuBettChatId:self.messageItem.groupId money:money betAttr:betAttr success:^(id response) {
        PROGRESS_HUD_DISMISS
        if (!NET_REQUEST_SUCCESS(response)) {
            NSString *msg = [(NSDictionary *)response stringForKey:@"msg"];
            if ([msg containsString:NSLocalizedString(@"余额不足", nil)]) {
                [self checkShowBalanceView:msg];
            } else {
                ALTER_INFO_MESSAGE(msg)
            }
        }
        [self updateBalance];
    } fail:^(id error) {
        PROGRESS_HUD_DISMISS
        if ([error isKindOfClass:[NSDictionary class]]) {
            NSString *msg = [(NSDictionary *)error stringForKey:@"alterMsg"];
            if ([msg containsString:NSLocalizedString(@"余额不足", nil)]) {
                [self checkShowBalanceView:msg];
            } else {
                ALTER_HTTP_ERROR_MESSAGE(error)
            }
        } else {
            [[FunctionManager sharedInstance] handleFailResponse:error];
        }
    }];
}

#pragma mark - 更新余额

- (void)updateBalance
{
    [NET_REQUEST_MANAGER getRobFinanceSuccess:^(id object) {
        if (![object isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        if (([object[@"code"] integerValue] == 0)) {
            FYBalanceInfoModel *model = [FYBalanceInfoModel mj_objectWithKeyValues:object[@"data"]];
            self.groupHearderView.balance = [NSString stringWithFormat:@"%.2lf",model.balance];
        } else {
            [SVProgressHUD showErrorWithStatus:object[@"msg"]];
        }
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}
#pragma mark - 百人牛牛 包包彩cell事件处理
-(void)didChatBagbagBetCell:(FYMessage *)model row:(NSInteger)row{
    if (model.messageType == FYMessageTypeBagLotteryBet) { //包包彩投注
        [self bagLotteryBetEvent:model row:row];
    }else if (model.messageType == FYMessageTypeBestNiuNiuBett){//百人牛牛
        NSDictionary *textDict = [model.text mj_JSONObject];
        NSString *money = [NSString stringWithFormat:@"%@",textDict[@"bettVO"][@"singleMoney"]];
        NSString *totalMoney = [NSString stringWithFormat:@"%@",textDict[@"bettVO"][@"totalMoney"]];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"FYBestNiuNIuBetOdds"];
        if (dict.count == 0) {
            return;
        }
        NSArray *hudArr = [FYBettingDetailsProcessing getBestNiuNiuBettingDetailsWithDict:dict textDict:textDict];
        MJWeakSelf
        if (row == 1) {//详情
            [FYBagLotteryBetHudView showBetHubWithList:hudArr singleMoney:money determineBtnText:@"" title:NSLocalizedString(@"投注详情",nil) block:^{}];
        }else{//跟投
            [FYBagLotteryBetHudView showBetHubWithList:hudArr singleMoney:money determineBtnText:NSLocalizedString(@"跟单", nil) title:NSLocalizedString(@"投注确认", nil) block:^{
                [weakSelf getBestNiuNiuSingleMoney:money totalMoney:totalMoney bettOneLevel:(NSArray*)textDict[@"bettVO"][@"bettOneLevel"]];
            }];
        }
    }
   
}
#pragma mark - 百人牛牛投注cell事件处理
- (void)getBestNiuNiuSingleMoney:(NSString *)singleMoney totalMoney:(NSString *)totalMoney bettOneLevel:(NSArray*)bettOneLevel{
    NSDictionary *dict = @{
        @"chatId":self.messageItem.groupId,
        @"bettOneLevel":bettOneLevel,
        @"userId":[AppModel shareInstance].userInfo.userId,
        @"singleMoney": singleMoney,//单注金额
        @"totalMoney": totalMoney//投注总额
    };
    MJWeakSelf
    [NET_REQUEST_MANAGER requestWithAct:ActRequestBestNiuNiuBett parameters:dict success:^(id object) {
        if ([object[@"code"] integerValue] == 0) {
            [weakSelf updateBalance];
        }
    } failure:^(id object) {
        [[FunctionManager sharedInstance]handleFailResponse:object];
    }];
}
#pragma mark - 包包彩投注cell事件处理
///包包彩投注事件
- (void)bagLotteryBetEvent:(FYMessage *)model row:(NSInteger)row{
    if (row == 1 || row == 2) {//详情 跟投
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"FYBagLotteryBetOdds"];
        if (dict.count == 0) {
            return;
        }
        NSDictionary *textDict = [model.text mj_JSONObject];
        NSString *money = [NSString stringWithFormat:@"%@",textDict[@"bettVO"][@"singleMoney"]];
        NSString *totalMoney = [NSString stringWithFormat:@"%@",textDict[@"bettVO"][@"totalMoney"]];
        NSArray *hudArr = [FYBettingDetailsProcessing getBagLotteryBettingDetailsWithDict:dict textDict:textDict];
        if (row == 1) {
            [FYBagLotteryBetHudView showBetHubWithList:hudArr singleMoney:money determineBtnText:@"" title:NSLocalizedString(@"投注详情",nil) block:^{}];
        }else if (row == 2){
            MJWeakSelf
            [FYBagLotteryBetHudView showBetHubWithList:hudArr singleMoney:money determineBtnText:NSLocalizedString(@"跟单", nil) title:NSLocalizedString(@"投注确认", nil) block:^{
                [weakSelf getBagLotterySingleMoney:money totalMoney:totalMoney bettOneLevel:(NSArray*)textDict[@"bettVO"][@"bettOneLevel"]];
            }];
        }
    }else if (row == 3){//复制
        SSChatBagLotteryBetModel *winModel = [SSChatBagLotteryBetModel mj_objectWithKeyValues:[model.text mj_JSONObject]];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"%@ : %zd  %@ : %@", NSLocalizedString(@"投注", nil),winModel.bettVO.singleMoney, NSLocalizedString(@"压", nil),winModel.text];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"复制成功", nil)];
    }
}
///包包彩投注
- (void)getBagLotterySingleMoney:(NSString *)singleMoney totalMoney:(NSString *)totalMoney bettOneLevel:(NSArray*)bettOneLevel{
    NSDictionary *dict = @{
        @"chatId": self.messageItem.groupId,
        @"singleMoney": singleMoney,
        @"totalMoney": totalMoney,
        @"userId": [AppModel shareInstance].userInfo.userId,
        @"bettOneLevel":bettOneLevel
    };
    MJWeakSelf
    [NET_REQUEST_MANAGER getBegLotteryBettDict:dict success:^(id object) {
        if ([object[@"code"] integerValue] == 0) {
            [weakSelf updateBalance];
        }
    } fail:^(id object) {
        if([object isKindOfClass:[NSError class]]){
            [[FunctionManager sharedInstance]handleFailResponse:object];
        }else{
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",object[@"msg"]]];
        }
    }];
}

- (void)didBagBagCowBetCell:(FYMessage *)model row:(NSInteger)row{
    NSDictionary *dict = [model.text mj_JSONObject];
    if (row == 1) {
        [self bagBagCowBet:@{
            @"betAttr":dict[@"betAttr"],
            @"money":dict[@"money"],
            @"chatId":dict[@"chatId"],
            @"gameNumber":dict[@"gameNumber"],
            @"userId":[AppModel shareInstance].userInfo.userId
        }];
    }else{
        NSString *text = [NSString string];
        switch ([dict[@"betAttr"] intValue]) {
            case 0:
                text = NSLocalizedString(@"庄", nil);
                break;
            case 1:
                text = NSLocalizedString(@"闲", nil);
                break;
            case 2:
                text = NSLocalizedString(@"和", nil);
                break;
            default:
                break;
        }
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:NSLocalizedString(@"投注 : %@  压 : %@", nil),dict[@"money"],text];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"复制成功", nil)];
    }
}
- (void)bagBagCowBet:(NSDictionary *)dict{
    [NET_REQUEST_MANAGER requestWithAct:ActRequestBagBagCowBett requestType:RequestType_post parameters:dict success:^(id object) {
        if ([object[@"code"] intValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@",object[@"msg"]]];
            [self updateBalance];
        }
    } fail:^(id object) {
        [[FunctionManager sharedInstance]handleFailResponse:object];
    }];
}
- (void)bagBagCowBetKeyboardButtonEvent{
    MJWeakSelf
    [NET_REQUEST_MANAGER requestWithAct:ActRequestBagBagCowAppConfig parameters:@{@"chatId":self.messageItem.groupId} success:^(id object) {
        if ([object[@"code"] intValue] == 0) {
            NSString *list = [NSString stringWithFormat:@"%@",object[@"data"][@"bettMoneyList"]];
            [FYBagBagCowBetHubView showHubViewWithList:list block:^(NSInteger betAttr, NSString * _Nonnull money, BOOL isPay) {
                if (!isPay) {
                    NSDictionary *dict = @{@"userId":[AppModel shareInstance].userInfo.userId,
                                           @"chatId":self.messageItem.groupId,
                                           @"money":money,
                                           @"betAttr":@(betAttr),
                                           @"gameNumber":@(self.bagLotteryModel.gameNumber)
                    };
                    [weakSelf bagBagCowBet:dict];
                }else{
                    FYRechargeMainViewController *VC = [[FYRechargeMainViewController alloc] initWithIsPush:YES];
                    [weakSelf.navigationController pushViewController:VC animated:YES];
                }
            }];
        }
    } failure:^(id object) {
        [[FunctionManager sharedInstance]handleFailResponse:object];
    }];
}
/**
 *  判断当前时间是否处于某个时间段内
 *
 *  @param startTime        开始时间
 *  @param endTime       结束时间
 */

- (BOOL)validateWithStartTime:(NSInteger )startTime withEndTime:(NSInteger )endTime {
    NSDate *today = [NSDate date];
    
    NSDate *start = [NSDate dateWithTimeIntervalSince1970:startTime/1000];
    NSDate *end = [NSDate dateWithTimeIntervalSince1970:endTime/1000];
    if ([today compare:start] == NSOrderedDescending && [today compare:end] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

@end
