//
//  FYPrecisionManager.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FYGamesStatusModel;

#define FYAPP_PRECISION_MANAGER [FYPrecisionManager sharedInstance]
#define FYMSG_PRECISION_MANAGER [FYPrecisionManager sharedInstance]

NS_ASSUME_NONNULL_BEGIN

@interface FYPrecisionManager : NSObject

+ (instancetype)sharedInstance;


#pragma mark - 聊天群组

/// 进入群游戏
- (void)doTryToJoinGroupGame:(MessageItem *)msgItem
                        from:(UINavigationController *)navigationController;

/// 进入群游戏（自建）
- (void)doTryToJoinGroupOfficeNo:(MessageItem *)model
                            from:(UINavigationController *)navigationController;

/// 进入群游戏（官方）
- (void)doTryToJoinGroupOfficeYes:(MessageItem *)model
                         password:(NSString *)password
                             from:(UINavigationController *)navigationController;

/// 退出群游戏（官方）
- (void)doTryToQuitGroupOfficeYes:(MessageItem *)msgItem
                   isBackToRootVC:(BOOL)isBackToRootVC
                             from:(UINavigationController *)navigationController;


#pragma mark - 聊天会话

/// 是否已经置顶
- (BOOL)doTryGetChatSessionStickForSwitch:(NSString *)sessionId;
/// 置顶聊天记录（置顶）
- (void)doTryChatSessionForStickYes:(NSString *)sessionId then:(void(^)(BOOL success))then;
/// 置顶聊天记录（取消置顶）
- (void)doTryChatSessionForStickNO:(NSString *)sessionId then:(void(^)(BOOL success))then;


/// 是否已经读取
- (BOOL)doTryGetChatSessionFinishRead:(id)model;
/// 标记已读
- (void)doTryChatSessionForFinishRead:(id)model then:(void(^)(BOOL success))then;
/// 标记未读
- (void)doTryChatSessionForUnFinishRead:(id)model then:(void(^)(BOOL success))then;


/// 清空聊天记录
- (void)doTryChatSessionForRecordsClear:(NSString *)sessionId then:(void(^)(BOOL success))then;
/// 删除聊天记录
- (void)doTryChatSessionForRecordsDelete:(NSString *)sessionId then:(void(^)(BOOL success))then;


#pragma mark - 未读消息
- (void)doTryInitializeUnReadMessageThen:(void (^)(void))then;


#pragma mark - 系统消息 或 通知公告
- (void)doTryInitializeSystemMessageSession;
- (void)doTryGetSysMsgNoticeData:(NSString *)time then:(void (^)(BOOL success, NSMutableArray<FYSysMsgNoticeEntity *> *itemSysMsgNoticeModels))then;


#pragma mark - 游戏大厅
/// 游戏大厅 - WAY1 - 进入三方游戏
- (void)doTryWay1JoinQPGamesWithUrl:(NSString *)url title:(NSString *)title from:(UINavigationController *)navigationController;
/// 游戏大厅 - WAY2 - 进入三方游戏
- (void)doTryWay2JoinQPGamesWidthUrl:(NSString *)url gametype:(NSNumber *)gameType title:(NSString *)title from:(UINavigationController *)navigationController;
/// 游戏大厅 - 验证游戏状态（大厅模式2）
- (void)doTryCheckVerifyGamesStatus:(NSString *)parentId then:(void (^)(BOOL success, FYGamesStatusModel *gamesStatusModel))then;
/// 游戏大厅 - 三方游戏余额核实
- (void)doTryThirdPartyGamesVerifyBalanceAffirmThen:(void (^)(BOOL success))then;
/// 游戏大厅 - 三方游戏登录地址URL
- (void)doTryThirdPartyGamesLoginUrlWithGameId:(NSString *)gameId gameType:(NSNumber *)gameType walletId:(NSNumber *)walletId linkUrl:(NSString *)linkUrl then:(void (^)(NSString *url))then;


@end


NS_ASSUME_NONNULL_END

