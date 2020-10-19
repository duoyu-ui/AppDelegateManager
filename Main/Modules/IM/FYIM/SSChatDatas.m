//
//  SSChatDatas.m
//  SSChatView
//
//  Created by soldoros on 2018/9/25.
//  Copyright © 2018年 soldoros. All rights reserved.
//


#import "SSChatDatas.h"
#import "EnvelopeMessage.h"
#import "NSTimer+SSAdd.h"

#define headerImg1  @"http://www.120ask.com/static/upload/clinic/article/org/201311/201311061651418413.jpg"
#define headerImg2  @"http://www.qqzhi.com/uploadpic/2014-09-14/004638238.jpg"
#define headerImg3  @"http://e.hiphotos.baidu.com/image/pic/item/5ab5c9ea15ce36d3b104443639f33a87e950b1b0.jpg"

@implementation SSChatDatas

// 处理接收的消息数组
+ (NSMutableArray *)receiveMessages:(NSArray *)messages
{
    NSMutableArray *array = [NSMutableArray new];
    for(NSDictionary *dic in messages){
        FYMessagelLayoutModel *layout = [SSChatDatas getMessageWithData:dic];
        [array addObject:layout];
    }
    return array;
}

// 接受一条消息
+ (FYMessagelLayoutModel *)receiveMessage:(id)message
{
    return [SSChatDatas getMessageWithData:message];
}

// 消息内容生成消息模型
+ (FYMessagelLayoutModel *)getMessageWithData:(id)data
{
    FYMessage *message;
    if ([data isKindOfClass:[FYMessage class]]) {
        message = data;
    } else {
        message = [FYMessage mj_objectWithKeyValues:data];
    }    
    if (message.messageFrom != FYChatMessageFromSystem) {
        
        if ([message.messageSendId isEqualToString:[AppModel shareInstance].userInfo.userId]) {
            message.messageFrom = FYMessageDirection_SEND;
        } else {
            message.messageFrom  = FYMessageDirection_RECEIVE;
        }
         
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *userKey = [NSString stringWithFormat:@"%@%@", message.sessionId, [AppModel shareInstance].userInfo.userId];
        if ([user valueForKey:userKey] == nil) {
            [user setValue:@(message.timestamp/1000) forKey:userKey];
            message.showTime = YES;
        } else {
            [message showTimeWithLastShowTime:[[user valueForKey:userKey] doubleValue] currentTime:message.timestamp/1000];
            if(message.showTime){
                [user setValue:@(message.timestamp/1000) forKey:userKey];
            }
        }
        
        // 默认气泡图片
        if(message.messageFrom == FYMessageDirection_SEND) {
            message.backImgString = @"icon_qipao0"; //发送者
        } else {
            message.backImgString = @"icon_qipao2"; // 接收者
        }
    }
  
    if ((message.messageType == FYMessageTypeText && message.messageFrom != FYChatMessageFromSystem)
       || message.messageType == FYMessageTypeReportAwardInfo) {
        message.cellString   = SSChatTextCellId;
    } else if (message.messageType == FYMessageTypeRedEnvelope) { // 红包
        message.cellString   = FYRedEnevlopeCellId;
//        if ([data isKindOfClass:[NSDictionary class]]) {
//            EnvelopeMessage *reMessage = [EnvelopeMessage mj_objectWithKeyValues:[message.text mj_JSONObject]];
//    
//            message.redEnvelopeMessage  = reMessage;
//        }
    } else if (message.messageType == FYMessageTypeNoticeRewardInfo) { // 牛牛报奖信息
        message.cellString   = CowCowVSMessageCellId;
        NSDictionary *dict = [message.text mj_JSONObject];
        message.cowcowRewardInfoDict  = dict;
    } else if (message.messageFrom == FYChatMessageFromSystem) { // 系统
        message.cellString   = NotificationMessageCellId;
        message.showTime = NO;
    }else if(message.messageType == FYMessageTypeVoice) {//语音
        message.cellString = SSChatVoiceCellId;
        if (message.isReceivedMsg) {
            NSDictionary *voiceDict = (NSDictionary *)[message.text mj_JSONObject];
            message.voiceRemotePath  = voiceDict[@"url"];
        }
        if(message.messageFrom == FYMessageDirection_SEND) {//自己
            message.voiceImgs = @[ [UIImage imageNamed:@"chat_animation_white1"], [UIImage imageNamed:@"chat_animation_white2"], [UIImage imageNamed:@"chat_animation_white3"]];
        }else{
            message.voiceImgs = @[ [UIImage imageNamed:@"chat_animation1"], [UIImage imageNamed:@"chat_animation2"], [UIImage imageNamed:@"chat_animation3"]];
        }
    } else if (message.messageType == FYMessageTypeImage) {  // 图片
        message.cellString   = SSChatImageCellId;
        if (message.isReceivedMsg) {
            NSDictionary *imageDict = (NSDictionary *)[message.text mj_JSONObject];
            message.imageUrl  = imageDict[@"url"];
        }
    }else if (message.messageType == FYMessageTypeVideo){
        message.cellString = SSChatVideoCellId;
        if (message.isReceivedMsg) {
            NSDictionary *videoDict = (NSDictionary *)[message.text mj_JSONObject];
            message.videoRemotePath  = videoDict[@"url"];
        }
    } else if (message.messageType == FYMessageTypeBett || message.messageType == FYMessageTypeRob) { // 投注
        message.cellString = SSChatRobBettingCellId;

    } else if (message.messageType == FYMessageTypeNotice) { // 提示

        if (message.text.length > 0 || message.text != nil) {
            RobNiuNiuMessageTypeModel *model = [RobNiuNiuMessageTypeModel mj_objectWithKeyValues:[message.text mj_JSONObject]];
            message.nnMessageModel = model;
            if (message.nnMessageModel.type == SolitaireGameAward) {
                message.cellString = SSChatGameAwardCellId;
            } else if (message.nnMessageModel.type == RobNiuNiuTypeSaoLeiResult){
                message.cellString = SSChatGameAwardCellId;
            } else {
                message.cellString  = SSChatNoticeCellId;
            }
        }
        
    } else if (message.messageType == FYMessageTypeRobReport){ // 抢庄报奖
        message.cellString  = SSChatNiuNiuReportCellId;
        NSDictionary *dict = [message.text mj_JSONObject];
        message.cowcowRewardInfoDict = dict;
    }else if (message.messageType == FYMessageTypeSystemWin){//系统报奖
        message.cellString = SSChatSystemWinCellId;
        NSDictionary *dict = [message.text mj_JSONObject];
        message.cowcowRewardInfoDict = dict;
    }else if (message.messageType == FYMessageTypeRopPrompt){//豹顺
        NSDictionary *dict = [message.text mj_JSONObject];
        if ([dict[@"type"] integerValue] == 1) {
            message.cellString = SSChatRopPromptCellId;
        } else if([dict[@"type"] integerValue] == 2){
            message.cellString = SSChatShimoshoCellId;
        }else if ([dict[@"type"] integerValue] == 3){
            message.cellString = SSChatRopSuccessfulID;
        }else if ([dict[@"type"] integerValue] == 4){
            message.cellString = SSChatRotaryHeaderCellID;
        }else if ([dict[@"type"] integerValue] == 5){
            message.cellString = SSChatDoZcontinCellID;
        }else if ([dict[@"type"] integerValue] == 6){
            message.cellString = SSChatUnderRemindCellID;
        }else if ([dict[@"type"] integerValue] == 7){//包包彩
            message.cellString = SSChatBagLotteryOrderPromptCellID;
        }else if ([dict[@"type"] integerValue] == 8){//包包牛封盘
            message.cellString = SSChatBagBagCowSealCellID;
        }else if ([dict[@"type"] integerValue] == 9){//包包彩个人报奖
            message.cellString = SSChatBagLotteryMeWinCellID;
        }else if ([dict[@"type"] integerValue] == 40){//包包牛某人的结算信息
            message.cellString = SSChatBagBagCowMeWinCellID;
        }else if ([dict[@"type"] integerValue] == 14){//百人牛牛
            message.cellString = SSChatBastNiuNiuWinCellID;
        }

    }else if (message.messageType == FYMessageTypeRobNiuNiu){//抢庄牛牛
        
        message.cellString  = SSChatRobNiuNiuCellId;
    } else if (message.messageType == FYMessageTypeGunControlWin){//禁抢报奖
        message.cellString = SSChatGunControlWinCellID;
    }else if (message.messageType == FYMessageTypeDeminingWin ||message.messageType == FYMessageTypeSuperDemining){//扫雷报奖
        message.cellString = SSChatDeminingWinCellID;
    }else if (message.messageType == FYMessageTypeNiuNiu){//牛牛报奖
        message.cellString = SSChatNiuNiuCellID;
    }else if (message.messageType == FYMessageTypeTwoNiuNiu){//二人牛牛报奖
        message.cellString = SSChatNiuNiuCellID;
    }else if (message.messageType == FYMessageTypeJieLong){//接龙
        message.cellString = SSChatJieLongCellID;
    }else if (message.messageType == FYMessageTypeBagBagCowWin){//包包牛报奖
        message.cellString = SSChatBagBagCowWinCellID;
    }else if (message.messageType == FYMessageTypeBagBagCowBet){//包包牛投注
        message.cellString = SSChatBagBagCowBetCellID;
    } else if (message.messageType == FYMessageTypeBagLotteryResults){//包包彩本期开奖结果
        message.cellString = SSChatBagLotteryResultsCellID;
    }else if (message.messageType == FYMessageTypeBagLotteryBet){//包包彩投注
        message.cellString = SSChatBagLotteryBetCellID;
    }else if (message.messageType == FYMessageTypeBestNiuNiuBett){//百人牛牛
        message.cellString = SSChatBagLotteryBetCellID;
    }

    FYMessagelLayoutModel *layout = [[FYMessagelLayoutModel alloc]initWithMessage:message];
    return layout;
    
}

// 发送一条消息
+ (void)sendMessage:(FYMessage *)message messageBlock:(MessageBlock)messageBlock
{
    NSMutableDictionary *messageDic = [NSMutableDictionary dictionary];
    
    long time = [NSTimer getLocationTimeStamp];
    
    switch (message.messageType) {
        case FYMessageTypeText:{
            message.timestamp = time*1000;
            message.isDeleted = NO;
            message.isRecallMessage = NO;
            message.isReceivedMsg = NO;
            message.deliveryState = FYMessageDeliveryStateDelivering;
            message.messageFrom = FYMessageDirection_SEND;
            message.messageId = [NSString stringWithFormat:@"%.f", message.timestamp];
        }
            break;
        case FYMessageTypeImage:{
            message.timestamp = time*1000;
            message.isDeleted = NO;
            message.isRecallMessage = NO;
            message.isReceivedMsg = NO;
            message.deliveryState = FYMessageDeliveryStateDelivering;
            message.messageFrom = FYMessageDirection_SEND;
            message.messageId = [NSString stringWithFormat:@"%.f", message.timestamp];
            
        }
            break;
        case FYMessageTypeVoice:{
            message.timestamp = time*1000;
            message.isDeleted = NO;
            message.isRecallMessage = NO;
            message.isReceivedMsg = NO;
            message.deliveryState = FYMessageDeliveryStateDelivering;
            message.messageFrom = FYMessageDirection_SEND;
            message.messageId = [NSString stringWithFormat:@"%.f", message.timestamp];
        }
            break;
        case FYMessageTypeMap:{
            [messageDic setObject:@"1" forKey:@"from"];
            [messageDic setValue:@(time) forKey:@"date"];
            //            [messageDic setValue:@(messageType) forKey:@"type"];
            //            [messageDic setValue:messageId forKey:@"messageId"];
            //            [messageDic setValue:sessionId forKey:@"sessionId"];
            [messageDic setValue:headerImg1 forKey:@"headerImg"];
        }
            break;
        case FYMessageTypeVideo:{
            message.timestamp = time*1000;
            message.isDeleted = NO;
            message.isRecallMessage = NO;
            message.isReceivedMsg = NO;
            message.deliveryState = FYMessageDeliveryStateDelivering;
            message.messageFrom = FYMessageDirection_SEND;
            message.messageId = [NSString stringWithFormat:@"%.f", message.timestamp];
        }
            break;
        case FYMessageTypeRedEnvelope:{
            [messageDic setValue:@(time) forKey:@"createTime"]; // 时间
            //            [messageDic setValue:dict[@"chatType"] forKey:@"chatType"];  // 1 群聊   2  p2p
            //            [messageDic setValue:@(messageType) forKey:@"msgType"];
            //            [messageDic setValue:messageId forKey:@"id"];  // 消息ID
            //            [messageDic setValue:sessionId forKey:@"chatId"];  // 群ID
        }
            break;
            
        default:
            break;
    }
    
    FYMessagelLayoutModel *layout = [SSChatDatas getMessageWithData:message];
    NSProgress *pre = [[NSProgress alloc]init];
    
    messageBlock(layout,nil,pre);
}


@end
