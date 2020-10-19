//
//  FYIMSessionViewController+TableView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYIMSessionViewController+TableView.h"
@interface FYIMSessionViewController ()
@end
@implementation FYIMSessionViewController (TableView)
#pragma mark 注册 tableViewCell
- (void)registeredCell{
    [self.tableView registerClass:NSClassFromString(@"SSChatNilCell") forCellReuseIdentifier:SSChatNilCellId];
    [self.tableView registerClass:NSClassFromString(@"SSChatTextCell") forCellReuseIdentifier:SSChatTextCellId];
    [self.tableView registerClass:NSClassFromString(@"SSChatImageCell") forCellReuseIdentifier:SSChatImageCellId];
    [self.tableView registerClass:NSClassFromString(@"SSChatVoiceCell") forCellReuseIdentifier:SSChatVoiceCellId];
    [self.tableView registerClass:NSClassFromString(@"SSChatMapCell") forCellReuseIdentifier:SSChatMapCellId];
    [self.tableView registerClass:NSClassFromString(@"SSChatVideoCell") forCellReuseIdentifier:SSChatVideoCellId];
    [self.tableView registerClass:NSClassFromString(@"FYRedEnevlopeCell") forCellReuseIdentifier:FYRedEnevlopeCellId];
    [self.tableView registerClass:NSClassFromString(@"CowCowVSMessageCell") forCellReuseIdentifier:CowCowVSMessageCellId];
    [self.tableView registerClass:NSClassFromString(@"NotificationMessageCell") forCellReuseIdentifier:NotificationMessageCellId];
    [self.tableView registerClass:NSClassFromString(@"SSChatNoticeCell") forCellReuseIdentifier:SSChatNoticeCellId];
    [self.tableView registerClass:NSClassFromString(@"SSChatRobBettingCell") forCellReuseIdentifier:SSChatRobBettingCellId];
    [self.tableView registerClass:NSClassFromString(@"SSChatNiuNiuReportCell") forCellReuseIdentifier:SSChatNiuNiuReportCellId];
    [self.tableView registerClass:NSClassFromString(@"SSChatRobNiuNiuCell") forCellReuseIdentifier:SSChatRobNiuNiuCellId];
    [self.tableView registerClass:NSClassFromString(@"SSChatGameAwardCell") forCellReuseIdentifier: SSChatGameAwardCellId];
    [self.tableView registerClass:NSClassFromString(@"SSChatRobZhuangCell") forCellReuseIdentifier:SSChatRobZhuangCellId];
    [self.tableView registerClass:NSClassFromString(@"SSChatSystemWinCell") forCellReuseIdentifier:SSChatSystemWinCellId];
    [self.tableView registerClass:NSClassFromString(@"SSChatRopPromptCell") forCellReuseIdentifier:SSChatRopPromptCellId];
    [self.tableView registerClass:NSClassFromString(@"SSChatShimoshoCell") forCellReuseIdentifier:SSChatShimoshoCellId];
    [self.tableView registerClass:NSClassFromString(@"SSChatGunControlWinCell") forCellReuseIdentifier:SSChatGunControlWinCellID];
    [self.tableView registerClass:NSClassFromString(@"SSChatDeminingWinCell") forCellReuseIdentifier: SSChatDeminingWinCellID];
    [self.tableView registerClass:NSClassFromString(@"SSChatNiuNiuCell") forCellReuseIdentifier: SSChatNiuNiuCellID];
    [self.tableView registerClass:NSClassFromString(@"SSChatRopSuccessfulCell") forCellReuseIdentifier:SSChatRopSuccessfulID];
    [self.tableView registerClass:NSClassFromString(@"SSChatRotaryHeaderCell") forCellReuseIdentifier:SSChatRotaryHeaderCellID];
    [self.tableView registerClass:NSClassFromString(@"SSChatUnderRemindCell") forCellReuseIdentifier:SSChatUnderRemindCellID];
    [self.tableView registerClass:NSClassFromString(@"SSChatDoZcontinCell") forCellReuseIdentifier:SSChatDoZcontinCellID];
    [self.tableView registerClass:NSClassFromString(@"SSChatJieLongCell") forCellReuseIdentifier:SSChatJieLongCellID];
    [self.tableView registerClass:NSClassFromString(@"SSChatBagLotteryOrderPromptCell") forCellReuseIdentifier:SSChatBagLotteryOrderPromptCellID];
    [self.tableView registerClass:NSClassFromString(@"SSChatBagLotteryBetCell") forCellReuseIdentifier:SSChatBagLotteryBetCellID];
    [self.tableView registerClass:NSClassFromString(@"SSChatBagLotteryResultsCell") forCellReuseIdentifier:SSChatBagLotteryResultsCellID];
    [self.tableView registerClass:NSClassFromString(@"SSChatBagBagCowWinCell") forCellReuseIdentifier:SSChatBagBagCowWinCellID];
    [self.tableView registerClass:NSClassFromString(@"FYBagBagCowBillingInfoCell") forCellReuseIdentifier:FYBagBagCowBillingInfoCellID];
    [self.tableView registerClass:NSClassFromString(@"SSChatBagBagCowBetCell") forCellReuseIdentifier:SSChatBagBagCowBetCellID];
    [self.tableView registerClass:NSClassFromString(@"SSChatBagBagCowSealCell") forCellReuseIdentifier:SSChatBagBagCowSealCellID];
    [self.tableView registerClass:NSClassFromString(@"SSChatBagBagCowMeWinCell") forCellReuseIdentifier:SSChatBagBagCowMeWinCellID];
    [self.tableView registerClass:NSClassFromString(@"SSChatBagLotteryMeWinCell") forCellReuseIdentifier:SSChatBagLotteryMeWinCellID];
    [self.tableView registerClass:NSClassFromString(@"SSChatBastNiuNiuWinCell") forCellReuseIdentifier:SSChatBastNiuNiuWinCellID];
//    [self.tableView registerClass:NSClassFromString(@"SSChatBestNiuNiuBettCell") forCellReuseIdentifier:SSChatBestNiuNiuBettCellID];
}


@end
