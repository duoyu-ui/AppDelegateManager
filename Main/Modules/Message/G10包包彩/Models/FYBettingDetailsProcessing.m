//
//  FYBettingDetailsProcessing.m
//  ProjectCSHB
//
//  Created by Tom on 2020/8/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBettingDetailsProcessing.h"
//包包彩
#import "FYBagLotteryBetModel.h"
#import "SSChatBagLotteryBetModel.h"
#import "FYPermutationTool.h"
//百人牛牛

@implementation FYBettingDetailsProcessing
///包包彩投注详情
+ (NSArray*)getBagLotteryBettingDetailsWithDict:(NSDictionary*)dict textDict:(NSDictionary *)textDict{
//    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"FYBagLotteryBetOdds"];
    if (dict.count == 0) {
        return nil;
    }
    FYBagLotteryBetModel *betModel = [FYBagLotteryBetModel mj_objectWithKeyValues:dict];
    FYBagLotteryBetListData *weiConfig = [[FYBagLotteryBetListData alloc]init];
    weiConfig.title = NSLocalizedString(@"尾数", nil);
    weiConfig.config = [FYBagLotteryBetConfig mj_objectArrayWithKeyValuesArray:betModel.data.weishuConfig];
    [weiConfig.config enumerateObjectsUsingBlock:^(FYBagLotteryBetConfig * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        weiConfig.config[idx].data = [FYBagLotteryBetList mj_objectArrayWithKeyValuesArray:obj.data];
    }];
    FYBagLotteryBetListData *lmConfig = [[FYBagLotteryBetListData alloc]init];
    lmConfig.title = NSLocalizedString(@"两面", nil);
    lmConfig.config = [FYBagLotteryBetConfig mj_objectArrayWithKeyValuesArray:betModel.data.liangmianConfig];
    [lmConfig.config enumerateObjectsUsingBlock:^(FYBagLotteryBetConfig * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        lmConfig.config[idx].data = [FYBagLotteryBetList mj_objectArrayWithKeyValuesArray:obj.data];
    }];
    
    
    FYBagLotteryBetListData *qhConfig = [[FYBagLotteryBetListData alloc]init];
    qhConfig.title = NSLocalizedString(@"前后组合", nil);
    qhConfig.config = [FYBagLotteryBetConfig mj_objectArrayWithKeyValuesArray:betModel.data.qianhouConfig];
    [qhConfig.config enumerateObjectsUsingBlock:^(FYBagLotteryBetConfig * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        qhConfig.config[idx].data = [FYBagLotteryBetList mj_objectArrayWithKeyValuesArray:obj.data];
    }];
    
    FYBagLotteryBetListData *qsConfig = [[FYBagLotteryBetListData alloc]init];
    qsConfig.title = NSLocalizedString(@"前三特码", nil);
    qsConfig.config = [FYBagLotteryBetConfig mj_objectArrayWithKeyValuesArray:betModel.data.qiansanConfig];
    [qsConfig.config enumerateObjectsUsingBlock:^(FYBagLotteryBetConfig * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        qsConfig.config[idx].data = [FYBagLotteryBetList mj_objectArrayWithKeyValuesArray:obj.data];
    }];
    
    FYBagLotteryBetListData *hsConfig = [[FYBagLotteryBetListData alloc]init];
    hsConfig.title = NSLocalizedString(@"后三特码", nil);
    hsConfig.config = [FYBagLotteryBetConfig mj_objectArrayWithKeyValuesArray:betModel.data.housanConfig];
    [hsConfig.config enumerateObjectsUsingBlock:^(FYBagLotteryBetConfig * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        hsConfig.config[idx].data = [FYBagLotteryBetList mj_objectArrayWithKeyValuesArray:obj.data];
    }];
    
    FYBagLotteryBetListData *tConfig = [[FYBagLotteryBetListData alloc]init];
    tConfig.title = NSLocalizedString(@"特殊", nil);
    tConfig.config = [FYBagLotteryBetConfig mj_objectArrayWithKeyValuesArray:betModel.data.teshuConfig];
    [tConfig.config enumerateObjectsUsingBlock:^(FYBagLotteryBetConfig * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        tConfig.config[idx].data = [FYBagLotteryBetList mj_objectArrayWithKeyValuesArray:obj.data];
    }];
    NSArray *odds = @[weiConfig,lmConfig,qhConfig,qsConfig,hsConfig,tConfig];
    NSArray <SSChatBagLotteryBetBettOneLevel*>*bettOneLevel = [SSChatBagLotteryBetBettOneLevel mj_objectArrayWithKeyValuesArray:textDict[@"bettVO"][@"bettOneLevel"]];
    NSMutableArray *hudArr = [NSMutableArray array];
    [bettOneLevel enumerateObjectsUsingBlock:^(SSChatBagLotteryBetBettOneLevel *oneLevel, NSUInteger idx, BOOL * _Nonnull stop) {
        FYBagLotteryBetListData *listData = odds[oneLevel.oneLevelType - 1];
        NSArray <SSChatBagLotteryBetBettTwoLevel*>* bettTwoLevel = [SSChatBagLotteryBetBettTwoLevel mj_objectArrayWithKeyValuesArray:oneLevel.bettTwoLevel];
        [bettTwoLevel enumerateObjectsUsingBlock:^(SSChatBagLotteryBetBettTwoLevel *twoLevel, NSUInteger idx, BOOL * _Nonnull stop) {
            FYBagLotteryBetConfig *config = listData.config[twoLevel.twoLevelType - 1];
            if (oneLevel.oneLevelType == 1) {//尾数
                NSArray *bettNumsPermutation =  [FYPermutationTool pickPermutationWhitData:twoLevel.bettNums pickNum:twoLevel.twoLevelType];
                [bettNumsPermutation enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [hudArr addObj:@{@"name":obj,@"bet":twoLevel.bettOddsNums.allValues.firstObject,@"config":config.title}];
                }];
            }else{
                [twoLevel.bettOddsNums enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *bet, BOOL * _Nonnull stop) {
                    [config.data enumerateObjectsUsingBlock:^(FYBagLotteryBetList * keyList, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (keyList.num == key) {
                            [hudArr addObj:@{@"name":keyList.name,@"bet":bet,@"config":config.title}];
                            return;
                        }
                    }];
                }];
            }
        }];
    }];
    return hudArr;
}
+ (NSArray*)getBestNiuNiuBettingDetailsWithDict:(NSDictionary*)dict textDict:(NSDictionary *)textDict{
    FYBagLotteryBetModel *model = [FYBagLotteryBetModel mj_objectWithKeyValues:dict];
    FYBagLotteryBetListData *wConfig = [[FYBagLotteryBetListData alloc]init];
    wConfig.title = NSLocalizedString(@"猜胜负", nil);
    NSArray<FYBagLotteryBetList *> *winLoseListConfig = [FYBagLotteryBetList mj_objectArrayWithKeyValuesArray:model.data.winLoseConfig];
    FYBagLotteryBetConfig *winLoseList = [[FYBagLotteryBetConfig alloc]init];
    winLoseList.title = NSLocalizedString(@"猜胜负", nil);
    winLoseList.type = 1;
    winLoseList.data = winLoseListConfig;
    wConfig.config = @[winLoseList];
    
    FYBagLotteryBetListData *tConfig = [[FYBagLotteryBetListData alloc]init];
    tConfig.title = NSLocalizedString(@"猜两面", nil);
    NSMutableArray <FYBagLotteryBetConfig*>*twoSidesArrconfig = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        NSArray<FYBagLotteryBetList *> *twoSidesListConfig = [FYBagLotteryBetList mj_objectArrayWithKeyValuesArray:model.data.twoSidesConfig];
        FYBagLotteryBetConfig *twoSidesList = [[FYBagLotteryBetConfig alloc]init];
        twoSidesList.title = [NSString stringWithFormat:NSLocalizedString(@"胜方第%@张",nil),[NSString translationArabicNum:i+1]];
        twoSidesList.type = i+1;
        twoSidesList.data = twoSidesListConfig;
        [twoSidesArrconfig addObj:twoSidesList];
    }
    tConfig.config = twoSidesArrconfig;
    
    FYBagLotteryBetListData *cConfig = [[FYBagLotteryBetListData alloc]init];
    cConfig.title = NSLocalizedString(@"猜牛牛", nil);
    NSArray<FYBagLotteryBetList *> *cattleListConfig = [FYBagLotteryBetList mj_objectArrayWithKeyValuesArray:model.data.cattleConfig];
    FYBagLotteryBetConfig *cattleList = [[FYBagLotteryBetConfig alloc]init];
    cattleList.title = NSLocalizedString(@"胜方牛牛",nil);
    cattleList.type = 1;
    cattleList.data = cattleListConfig;
    cConfig.config = @[cattleList];
    
    FYBagLotteryBetListData *pConfig = [[FYBagLotteryBetListData alloc]init];
    pConfig.title = NSLocalizedString(@"猜牌面",nil);
    NSMutableArray <FYBagLotteryBetConfig*>*pokerSideArrconfig = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        NSArray<FYBagLotteryBetList *> *pokerSideListConfig = [FYBagLotteryBetList mj_objectArrayWithKeyValuesArray:model.data.pokerSideConfig];
        FYBagLotteryBetConfig *pokerSideList = [[FYBagLotteryBetConfig alloc]init];
        pokerSideList.title = [NSString stringWithFormat:NSLocalizedString(@"胜方第%@张",nil),[NSString translationArabicNum:i+1]];
        pokerSideList.type = i+1;
        pokerSideList.data = pokerSideListConfig;
        [pokerSideArrconfig addObj:pokerSideList];
    }
    pConfig.config = pokerSideArrconfig;
    NSArray *odds = @[wConfig,tConfig,cConfig,pConfig];
    
    NSArray <FYBestNiuNiuBettOneLevel*>*bettOneLevel = [FYBestNiuNiuBettOneLevel mj_objectArrayWithKeyValuesArray:textDict[@"bettVO"][@"bettOneLevel"]];
    NSMutableArray *hudArr = [NSMutableArray array];
    [bettOneLevel enumerateObjectsUsingBlock:^(FYBestNiuNiuBettOneLevel *oneLevel, NSUInteger idx, BOOL * _Nonnull stop) {
        FYBagLotteryBetListData *listData = odds[oneLevel.oneLevelType - 1];
        NSArray <FYBestNiuNiuBettTwoLevel*>* bettTwoLevel = [FYBestNiuNiuBettTwoLevel mj_objectArrayWithKeyValuesArray:oneLevel.bettTwoLevel];
        [bettTwoLevel enumerateObjectsUsingBlock:^(FYBestNiuNiuBettTwoLevel *twoLevel, NSUInteger idx, BOOL * _Nonnull stop) {
            //胜方第几张模型
            FYBagLotteryBetConfig *betConfig = listData.config[twoLevel.pokerNum - 1];
            [betConfig.data enumerateObjectsUsingBlock:^(FYBagLotteryBetList *list, NSUInteger idx, BOOL * _Nonnull stop) {
                if (twoLevel.twoLevelType ==  [list.num integerValue]) {
                    [hudArr addObj:@{@"name":twoLevel.bettName,@"bet":list.bet,@"config":betConfig.title}];
                }
            }];
        }];
    }];
    return hudArr;
}
@end
@implementation FYBestNiuNiuBettTwoLevel

@end

@implementation FYBestNiuNiuBettOneLevel

@end
@implementation FYBestNiuNiuBettVO

@end
@implementation FYBestNiuNiuModel

@end
