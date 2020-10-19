//
//  EnvelopeNet.m
//  Project
//
//  Created by mac on 2018/8/20.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "EnvelopeNet.h"
#import "FYBagBagCowRedGrapResponse.h"
#import "FYBagLotteryRedGrapResponse.h"

static EnvelopeNet *instance = nil;
static dispatch_once_t predicate;

@implementation EnvelopeNet

+ (EnvelopeNet *)shareInstance{
    
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _dataList = [[NSMutableArray alloc]init];
        _page = 0;
        _pageSize = 15;
        _isMost = NO;
        _isEmpty = NO;
    }
    return self;
}

/**
 获取红包详情
 
 @param packetId 红包ID
 @param successBlock 成功block
 @param failureBlock 失败block
 */
-(void)getUnityRedpDetail:(id)packetId withType:(id)type successBlock:(void (^)(NSDictionary *))successBlock
           failureBlock:(void (^)(NSError *))failureBlock {
    NSDictionary *parameters = @{
                                 @"packetId":(NSString *)packetId,
                                 @"type":(NSString *)type
                                 };
    
    __weak __typeof(self)weakSelf = self;
    [NET_REQUEST_MANAGER getWaterDetail:parameters successBlock:^(NSDictionary *response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf processingData:response];
        successBlock(response);
    } failureBlock:^(NSError *failure) {
        failureBlock(failure);
    }];
}

/**
 获取红包详情
 
 @param packetId 红包ID
 @param successBlock 成功block
 @param failureBlock 失败block
 */
-(void)getRedpDetSendId:(id)packetId successBlock:(void (^)(NSDictionary *))successBlock
           failureBlock:(void (^)(NSError *))failureBlock {
    self.isGrabId = NO;
    
    NSDictionary *parameters = @{
                                 @"packetId":(NSString *)packetId
                                 };
    __weak __typeof(self)weakSelf = self;
    [NET_REQUEST_MANAGER redpacketDetail:parameters successBlock:^(NSDictionary *response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf processingData:response];
        successBlock(response);
    } failureBlock:^(NSError *failure) {
        failureBlock(failure);
    }];
}

- (void)processingData:(NSDictionary *)response {
    if ([response objectForKey:@"code"] && ([[response objectForKey:@"code"] integerValue] == 0)) {
        NSDictionary *data = [response objectForKey:@"data"];
        if (data != NULL) {
            
            self.redPackedInfoDetail = [[NSMutableDictionary alloc] initWithDictionary: [response objectForKey:@"data"][@"detail"]];
            [self.dataList removeAllObjects];
            self.redPackedListArray = [[NSMutableArray alloc] initWithArray:[response objectForKey:@"data"][@"skRedbonusGrabModels"]];
            
            //庄家赢得个数
            NSInteger bankWinInteger = [self.redPackedInfoDetail[@"bankWin"] integerValue];
            //闲家赢得个数
            if (self.redPackedListArray != nil) {
                NSInteger otherWinInteger = self.redPackedListArray.count - bankWinInteger - 1;
                NSString *otherWinValue = [NSString stringWithFormat:@"%ld", otherWinInteger];
                [self.redPackedInfoDetail setValue:otherWinValue forKey:@"otherWin"];
            }
            
            NSInteger luckMaxIndex = 0;
            CGFloat moneyMax = 0.0;
            
            if ([self.redPackedInfoDetail[@"total"] integerValue] == self.redPackedListArray.count || [self.redPackedInfoDetail[@"overFlag"] boolValue]) {
                for (NSInteger i = 0; i < self.redPackedListArray.count; i++) {
                    // 计算手气最佳
                    NSMutableDictionary *objDict = [NSMutableDictionary dictionaryWithDictionary:self.redPackedListArray[i]];
                    NSString *strMoney = [objDict[@"money"] stringByReplacingOccurrencesOfString:@"*" withString:@"0"];
                    CGFloat money = [strMoney floatValue];
                    if (money > moneyMax) {
                        moneyMax = money;
                        luckMaxIndex = i;
                    }
                    
                    // 庄家点数+庄家money
                    if ([[self.redPackedInfoDetail objectForKey:@"type"] integerValue] == 2 ||
                        [[self.redPackedInfoDetail objectForKey:@"type"] integerValue] == 8) {
                        NSString *sendUserId = [NSString stringWithFormat:@"%@",[self.redPackedInfoDetail objectForKey:@"userId"]];
                        NSString *userId = [NSString stringWithFormat:@"%@",[objDict objectForKey:@"userId"]];
                        if ([sendUserId isEqualToString:userId]) {
                            [self.redPackedInfoDetail setObject:[objDict objectForKey:@"score"] forKey:@"bankerPointsNum"];
                            [self.redPackedInfoDetail setObject:[objDict objectForKey:@"money"] forKey:@"bankerMoney"];
                            [self.redPackedInfoDetail setObject:@(YES)forKey:@"isBanker"];
                        }
                        
                        if ([userId isEqualToString:[AppModel shareInstance].userInfo.userId]) {
                            [self.redPackedInfoDetail setObject:[objDict objectForKey:@"score"] forKey:@"itselfPointsNum"];
                        }
                    }
                }
                
            }

            for (NSInteger i = 0; i < self.redPackedListArray.count; i++) {
                
                CDTableModel *model = [CDTableModel new];
                model.className = @"RedPackedDetTableCell";
                
                NSMutableDictionary *objDict = [NSMutableDictionary dictionaryWithDictionary:self.redPackedListArray[i]];
                
                if ([self.redPackedInfoDetail[@"type"] integerValue] == 1) {
                    NSString *moneyLei = [objDict objectForKey:@"money"];
                    NSString *last = [moneyLei substringFromIndex:moneyLei.length-1];
                    NSDictionary *attrDict = [[self.redPackedInfoDetail objectForKey:@"attr"] mj_JSONObject];
                    NSString *bombNum = [NSString stringWithFormat:@"%ld", [attrDict[@"bombNum"] integerValue]];
                    if ([last isEqualToString:bombNum] && [self.redPackedInfoDetail[@"freerId"] integerValue] != [[objDict objectForKey:@"userId"] integerValue]) {
                        [objDict setValue:@(YES) forKey:@"isMine"];
                    } else {
                        [objDict setValue:@(NO) forKey:@"isMine"];
                    }
                } else if ([self.redPackedInfoDetail[@"type"] integerValue] == 3) {
                    // 禁抢老板说不标雷
//                    NSString *moneyLei = [objDict objectForKey:@"money"];
//                    NSString *last = [moneyLei substringFromIndex:moneyLei.length-1];
//                    NSDictionary *attrDict = [[self.redPackedInfoDetail objectForKey:@"attr"] mj_JSONObject];
//
//                    NSArray *bombListArray = (NSArray *)attrDict[@"bombList"];
//
//                    for (NSInteger index = 0; index < bombListArray.count; index++) {
//                        NSString *bombNum = [NSString stringWithFormat:@"%ld", [bombListArray[index] integerValue]];
//                        if ([last isEqualToString:bombNum]) {
//                            [objDict setValue:@(YES) forKey:@"isMine"];
//                            break;
//                        } else {
//                            [objDict setValue:@(NO) forKey:@"isMine"];
//                        }
//                    }
                }
                
                
                BOOL isItself = NO;
                NSString *userId = [NSString stringWithFormat:@"%@",[objDict objectForKey:@"userId"]];
                if ([userId isEqualToString:[AppModel shareInstance].userInfo.userId]) {
                    [self.redPackedInfoDetail setObject:[objDict objectForKey:@"money"] forKey:@"itselfMoney"];
                    [self.redPackedInfoDetail setObject:@(YES) forKey:@"isItself"];
                    isItself = YES;
                } else {
                    isItself = NO;
                }
                
                
                if ([self.redPackedInfoDetail[@"total"] integerValue] == self.redPackedListArray.count) {
                    // 手气最佳
                    if (luckMaxIndex == i) {
                        [objDict setValue:@(YES) forKey:@"isLuck"];
                    } else {
                        [objDict setValue:@(NO) forKey:@"isLuck"];
                    }
                }
                
                // 牛牛和二人牛牛
                if ([[self.redPackedInfoDetail objectForKey:@"type"] integerValue] == 2 ||
                    [[self.redPackedInfoDetail objectForKey:@"type"] integerValue] == 8) {  // 庄 闲
                    // 是
                    NSString *sendUserId = [NSString stringWithFormat:@"%@",[self.redPackedInfoDetail objectForKey:@"userId"]];
                    NSString *userId = [NSString stringWithFormat:@"%@",[objDict objectForKey:@"userId"]];
                    if ([sendUserId isEqualToString:userId]) {
                        [objDict setValue:@(YES) forKey:@"isBanker"];
                    } else {
                        [objDict setValue:@(NO) forKey:@"isBanker"];
                    }
                    
                    // 判断庄闲 输-赢
                    if ([[self.redPackedInfoDetail objectForKey:@"bankerPointsNum"] integerValue] > [[objDict objectForKey:@"score"] integerValue]) {
                        if (isItself) {
                            [self.redPackedInfoDetail setValue:@(NO) forKey:@"isItselfWin"];
                        }
                    } else if ([[self.redPackedInfoDetail objectForKey:@"bankerPointsNum"] integerValue] == [[objDict objectForKey:@"score"] integerValue]) {
                        
                        if ([[self.redPackedInfoDetail objectForKey:@"bankerMoney"] floatValue] >= [[objDict objectForKey:@"money"] floatValue] ) {
                            if (isItself) {
                                [self.redPackedInfoDetail setValue:@(NO) forKey:@"isItselfWin"];
                            }
                        } else {
                            if (isItself) {
                                [self.redPackedInfoDetail setValue:@(YES) forKey:@"isItselfWin"];
                            }
                        }
                    } else {
                        if (isItself) {
                            [self.redPackedInfoDetail setValue:@(YES) forKey:@"isItselfWin"];
                        }
                    }
                }
                
                
                [objDict setValue:self.redPackedInfoDetail[@"type"] forKey:@"redpType"];
                model.obj = objDict;
                [self.dataList addObject:model];
            }
            self.isEmpty = (self.dataList.count == 0)?YES:NO;
            self.isMost = ((self.dataList.count % self.pageSize == 0)&(self.redPackedListArray.count>0))?NO:YES;
            
        }
    } else {
        predicate = 0;
        instance =nil;
    }
}

- (void)destroyData {
    [self.dataList removeAllObjects];
    [self.redPackedInfoDetail removeAllObjects];
    [self.redPackedListArray removeAllObjects];
    instance = nil;
    predicate = 0;
}



- (void)getRedPacketDetailBagBagCowWithId:(NSString *)uuid then:(void (^)(BOOL success, NSString *status))then
{
    // 红包状态 0没有点击(红包没抢)  1已点击(红包已抢)  2已点击(红包已抢完） 3已点击(红包已过期)
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requesGamesBagBagCowWithId:uuid success:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"包包牛红包 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
           !then ?: then(NO,@"0");
        } else {
            FYBagBagCowRedGrapResponse *redEnvelopeResponse = [FYBagBagCowRedGrapResponse mj_objectWithKeyValues:response];
            if (redEnvelopeResponse.data.items.count >= 3) {
                !then ?: then(YES,@"2");
            } else {
                !then ?: then(NO,@"0");
            }
        }
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"获取包包牛红包出错 => \n%@", nil), error);
        !then ?: then(NO,@"0");
    }];
}

- (void)getRedPacketDetailBagBagLotteryWithId:(NSString *)uuid then:(void (^)(BOOL success, NSString *status))then;
{
    WEAKSELF(weakSelf)
    // 0:查看红包 1:红包已领取 2:红包已被领完 3:红包已过期
    // 红包状态 0没有点击(红包没抢)  1已点击(红包已抢)  2已点击(红包已抢完） 3已点击(红包已过期)
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requesGamesBagBagLotteryWithId:uuid success:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"包包彩红包 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
           !then ?: then(NO,@"0");
            ALTER_HTTP_MESSAGE(response)
        } else {
            FYBagLotteryRedGrapResponse *redEnvelopeResponse = [FYBagLotteryRedGrapResponse mj_objectWithKeyValues:response];
            FYBagLotteryRedGrapData *redEnvelopeData = redEnvelopeResponse.data;
            //
            weakSelf.redPackedInfoDetail = [NSMutableDictionary dictionary];
            [weakSelf.redPackedInfoDetail setObj:redEnvelopeData.uuid forKey:@"id"];
            [weakSelf.redPackedInfoDetail setObj:@(redEnvelopeData.type) forKey:@"type"];
            [weakSelf.redPackedInfoDetail setObj:redEnvelopeData.userId forKey:@"userId"];
            [weakSelf.redPackedInfoDetail setObj:redEnvelopeData.nickName forKey:@"nick"];
            [weakSelf.redPackedInfoDetail setObj:redEnvelopeData.avatar forKey:@"avatar"];
            [weakSelf.redPackedInfoDetail setObj:@(redEnvelopeData.left) forKey:@"left"];
            [weakSelf.redPackedInfoDetail setObj:@(redEnvelopeData.exceptOverdueTime) forKey:@"exceptOverdueTime"];
            if (redEnvelopeResponse.data.items.count >= 6) {
                [weakSelf.redPackedInfoDetail setObj:@"2" forKey:@"status"];
                [weakSelf.redPackedInfoDetail setObj:@(YES) forKey:@"overFlag"];
                !then ?: then(YES,@"2");
            } else {
                !then ?: then(YES,@"0");
                [weakSelf.redPackedInfoDetail setObj:@"0" forKey:@"status"];
                [weakSelf.redPackedInfoDetail setObj:@(NO) forKey:@"overFlag"];
            }
        }
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"获取包包彩红包出错 => \n%@", nil), error);
        !then ?: then(NO,@"0");
    }];
}








@end
