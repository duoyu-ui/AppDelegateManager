//
//  FYMessageConstants.h
//  Project
//
//  Created by Mike on 2019/4/10.
//  Copyright © 2019 CDJay. All rights reserved.
//

#ifndef FYMessageConstants_h
#define FYMessageConstants_h

#pragma mark - Cell的一些设置

static NSString *const SSChatNilCellId = @"SSChatNilCellId";
static NSString *const SSChatDefaultCellId = @"SSChatDefaultCellId";
static NSString *const SSChatTextCellId = @"SSChatTextCellId";
static NSString *const SSChatImageCellId = @"SSChatImageCellId";
static NSString *const SSChatVoiceCellId = @"SSChatVoiceCellId";
static NSString *const SSChatMapCellId = @"SSChatMapCellId";
static NSString *const SSChatVideoCellId = @"SSChatVideoCellId";
static NSString *const SSChatNoticeCellId = @"SSChatNoticeCellId";
static NSString *const SSChatRobBettingCellId = @"SSChatRobBettingCellId";
static NSString *const SSChatGameAwardCellId = @"SSChatGameAwardCellId";
static NSString *const SSChatNiuNiuReportCellId = @"SSChatNiuNiuReportCellId";
static NSString *const SSChatRobNiuNiuCellId = @"SSChatRobNiuNiuCellId";
static NSString *const SSChatRobZhuangCellId = @"SSChatRobZhuangCellId";
///系统报奖
static NSString *const SSChatSystemWinCellId = @"SSChatSystemWinCellId";
///竟庄 - 提示
static NSString *const SSChatRopPromptCellId = @"SSChatRopPromptCellId";
///下庄提示
static NSString *const SSChatShimoshoCellId = @"SSChatShimoshoCellId";
///竞庄 成功
static NSString *const SSChatRopSuccessfulID = @"SSChatRopSuccessfulID";
///下庄提醒
static NSString *const SSChatUnderRemindCellID = @"SSChatUnderRemindCellID";
///连续做庄
static NSString *const SSChatDoZcontinCellID = @"SSChatDoZcontinCellID";
///封盘提醒
static NSString *const SSChatRotaryHeaderCellID = @"SSChatRotaryHeaderCellID";

// 红包Cell
static NSString *const FYRedEnevlopeCellId = @"FYRedEnevlopeCellId";
// 牛牛报奖信息
static NSString *const CowCowVSMessageCellId = @"CowCowVSMessageCellId";
// 系统消息
static NSString *const NotificationMessageCellId = @"NotificationMessageCellId";
///禁抢报奖
static NSString *const SSChatGunControlWinCellID = @"SSChatGunControlWinCellID";
///扫雷报奖
static NSString *const SSChatDeminingWinCellID = @"SSChatDeminingWinCellID";
///牛牛
static NSString *const SSChatNiuNiuCellID = @"SSChatNiuNiuCellID";
///接龙
static NSString *const SSChatJieLongCellID = @"SSChatJieLongCellID";
#pragma mark - 包包彩
///下注提示
static NSString *const SSChatBagLotteryOrderPromptCellID = @"SSChatBagLotteryOrderPromptCellID";
///个人报奖
static NSString *const SSChatBagLotteryMeWinCellID = @"SSChatBagLotteryMeWinCellID";
///下注
static NSString *const SSChatBagLotteryBetCellID = @"SSChatBagLotteryBetCellID";
///本期开奖结果
static NSString *const SSChatBagLotteryResultsCellID = @"SSChatBagLotteryResultsCellID";

#pragma mark - 包包牛
static NSString *const SSChatBagBagCowBetCellID = @"SSChatBagBagCowBetCellID";
static NSString *const SSChatBagBagCowWinCellID = @"SSChatBagBagCowWinCellID";
static NSString *const FYBagBagCowBillingInfoCellID = @"FYBagBagCowBillingInfoCellID";
static NSString *const SSChatBagBagCowSealCellID = @"SSChatBagBagCowSealCellID";
static NSString *const SSChatBagBagCowMeWinCellID = @"SSChatBagBagCowMeWinCellID";

#pragma mark - 百人牛牛
static NSString *const SSChatBastNiuNiuWinCellID = @"SSChatBastNiuNiuWinCellID";
//static NSString *const SSChatBestNiuNiuBettCellID = @"SSChatBestNiuNiuBettCellID";
static const CGFloat   SSChatCellTopOrBottom             = 10;  //顶部距离cell or 底部距离cell
static const CGFloat   FYChatNameWidth             = 120;  //原型昵称尺寸宽度
static const CGFloat   FYChatNameSpacingHeight     = 16;  //名称+间隔
static const CGFloat   SSChatIconWH             = 40;  //原型头像尺寸

#pragma mark - 显示时间

static const CGFloat   FYChatNameHeight             = 44;  //原型头像尺寸
static const CGFloat   FYChatIconLeftOrRight             = 10;  //头像与左边or右边距离
static const CGFloat   SSChatDetailLeft             = 10;  //详情与左边距离
static const CGFloat   SSChatDetailRight     = 10;  //详情与右边距离
static const CGFloat   SSChatTextTop             = 10;  //文本距离详情顶部
static const CGFloat   SSChatTextBottom             = 10;  //文本距离详情底部
static const CGFloat   SSChatTextLRS             = 8;  //文本左右短距离
static const CGFloat   SSChatTextLRB             = 15;  //文本左右长距离


//显示时间
static const CGFloat   SSChatTimeWidth             = 180;  //时间宽度
static const CGFloat   SSChatTimeHeight             = 20;  //时间高度
static const CGFloat   SSChatTimeTopOrBottom             = 12.5;  //时间距离顶部或者底部


static const CGFloat   SSChatAirTop             = 35;  //气泡距离详情顶部
static const CGFloat   SSChatAirLRS             = 10;  //气泡左右短距离
static const CGFloat   SSChatAirBottom             = 10;  //气泡距离详情底部
static const CGFloat   SSChatAirLRB             = 22;  //气泡左右长距离
static const CGFloat   SSChatTimeFont             = 12;  //时间字体
static const CGFloat   SSChatTextFont             = 17;  //内容字号


static const CGFloat   SSChatTextLineSpacing             = 5;  //文本行高
static const CGFloat   SSChatTextRowSpacing             = 0;  //文本间距


#define bgWidth (UIScreen.mainScreen.bounds.size.width - (CD_WidthScal(60, 320) * 2))//
#define bgRate 0.45

#define CowBackImageHeight bgWidth * bgRate


// 红包宽度
#define   FYRedEnvelopeBackWidth              (UIScreen.mainScreen.bounds.size.width - (CD_WidthScal(60, 320) * 2))  //200 红包宽度
// 红包高度
#define   FYRedEnvelopeBackHeight              bgWidth*85/200  // 红包高度

//文本颜色
#define SSChatTextColor         [UIColor blackColor]

//右侧头像的X坐标
#define SSChatIcon_RX            FYSCREEN_Width-FYChatIconLeftOrRight-SSChatIconWH

//文本自适应限制宽度
#define SSChatTextInitWidth    FYSCREEN_Width*0.62-SSChatTextLRS-SSChatTextLRB

//图片最大尺寸(正方形)
static const CGFloat   SSChatImageMaxSize             = 150;

//音频的最小宽度  最大宽度   高度
#define SSChatVoiceMinWidth     100
#define SSChatVoiceMaxWidth        FYSCREEN_Width*2/3-SSChatTextLRS-SSChatTextLRB
#define SSChatVoiceHeight       45
//音频时间字体
#define SSChatVoiceTimeFont     14
//音频波浪图案尺寸
#define SSChatVoiceImgSize      20

// 消息分页数量
#define kMessagePageNumber     20

//地图位置宽度 高度
static const CGFloat   SSChatMapWidth             = 240;
static const CGFloat   SSChatMapHeight             = 150;

//短视频位置宽度 高度
static const CGFloat   SSChatVideoWidth             = 200;
static const CGFloat   SSChatVideoHeight             = 150;


#endif /* ChatMessageConstants_h */
