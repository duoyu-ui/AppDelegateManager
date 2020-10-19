
#import "FYBaseCoreViewController.h"
#import "FYMessagelLayoutModel.h"
#import "FYIMManager.h"
#import "SSChatKeyBoardInputView.h"
#import "FYIMMessageManager.h"
#import "FYContacts.h"
#import "MessageItem.h"
#import "FYIMGroupChatHeaderView.h"
#import "FYCountdownHeaderView.h"
#import "FYNperHaederView.h"
#import "FYChatBaseCell.h"
#import "FYPokerWinsLossesHeadView.h"

@protocol FYIMSessionViewControllerDelegate <NSObject>
// 抢庄牛牛
- (void)didUpdateChatKeyboardCustomButtonWithRobNiuNiuQunModel:(RobNiuNiuQunModel *)robNiuNiuModel;
// 接龙游戏
- (void)didUpdateChatKeyboardCustomButtonWithSolitaireInfoModel:(FYSolitaireInfoModel *)solitaireInfoModel;

@end

@protocol FYIMSessionViewControllerLotteryGameGroupInfoDelegate <NSObject>
- (void)didUpdateLotteryGameGroupInfoModel:(RobNiuNiuQunModel *)groupInfoModel;
@end


@interface FYIMSessionViewController : FYBaseCoreViewController

/* 会话ID */
@property(nonatomic, copy) NSString *sessionId;
/* 会话名字 */
@property(nonatomic, copy) NSString *titleString;
/* 会话类型（单聊、群聊） */
@property(nonatomic, assign) FYChatConversationType chatType;

/* 会话表单 */
@property(nonatomic,strong) UITableView *tableView;
/* 会话数据源 */
@property(nonatomic,strong) NSMutableArray <FYMessagelLayoutModel*>*dataSource;
/* 底部输入框，携带表情视图和多功能视图 */
@property(nonatomic, strong) SSChatKeyBoardInputView *sessionInputView;
///接龙群状态模型
@property(nonatomic, strong) FYSolitaireInfoModel *sinfoModel;
/// 包包彩群状态模型
@property (nonatomic , strong) RobNiuNiuQunModel *bagLotteryModel;
/* */
@property(nonatomic, strong) MessageItem *messageItem;
/* 单聊 接受者用户信息 */
@property(nonatomic, strong) FYContacts *toContactsModel;
/*  */
@property(nonatomic, weak) id<FYChatManagerDelegate> delegate;
/* 群聊头部面板 - 高度 */
@property(nonatomic, assign) CGFloat heightOfGroupHeaderView;
/* 群聊头部面板 - 控件 */
@property(nonatomic, strong) FYIMGroupChatHeaderView *groupHearderView;
///包包彩头部游戏记录
@property (nonatomic , strong) FYNperHaederView *nperHaederView;
@property (nonatomic , strong) FYPokerWinsLossesHeadView *wlHaederView;
///倒计时控件
@property(nonatomic, strong) FYCountdownHeaderView *countdownView;
/* 键盘区域代理 */
@property (nonatomic, weak) id<FYIMSessionViewControllerDelegate> delegate_keyboard;
/* 投注页面代理 */
@property (nonatomic, weak) id<FYIMSessionViewControllerLotteryGameGroupInfoDelegate> delegate_bet;
/* 彩票游戏代理 */
@property (nonatomic, weak) id<FYIMSessionViewControllerLotteryGameGroupInfoDelegate> delegate_lottery;

+ (FYIMSessionViewController *)currentChat;

/*!
 * 初始化会话页面
 * @param conversationType 会话类型
 * @param targetId 目标会话ID，即 sessionId
 * @return 会话页面对象
 */
- (id)initWithConversationType:(FYChatConversationType)conversationType targetId:(NSString *)targetId;

/**
 * 聊天界面下拉请求数据
 */
- (void)sendDropdownRequest:(NSString *)sessionId endTime:(NSTimeInterval)endTime chartType:(FYChatConversationType)type;


// 发送文本，列表滚动至底部（SSChatKeyBoardInputViewDelegate）
- (void)onChatKeyBoardInputViewSendText:(NSString *)text;
// 多功能视图点击回调（SSChatKeyBoardInputViewDelegate）
-(void)fyChatFunctionBoardClickedItemWithTag:(NSInteger)tag;
// 视图归位
- (void)setSSChatKeyBoardInputViewEndEditing;


// 上传图片
- (void)loadImage;
// 更新未读消息
- (void)updateUnreadMessage;
// 点击消息Cell
- (void)didTapMessageCell:(FYMessage *)model;
//点击语音cell
- (void)didChatVoiceCell:(FYChatBaseCell*)cell model:(FYMessage *)model;
/// 获取余额
- (void)checkShowBalanceView:(NSString *)title;


// 群组头部事件 - 查看余额
- (void)groupHeaderView:(FYIMGroupChatHeaderView *)headerView didActionOfCheckBalance:(UILabel *)balanceLabel;
// 群组头部事件 - 充值操作
- (void)groupHeaderView:(FYIMGroupChatHeaderView *)headerView didActionOfRecharge:(UIButton *)button;
// 群组头部事件 - 玩法操作
- (void)groupHeaderView:(FYIMGroupChatHeaderView *)headerView didActionOfPlayRule:(UIButton *)button;
// 群组头部事件 - 分享操作
- (void)groupHeaderView:(FYIMGroupChatHeaderView *)headerView didActionOfShare:(UIButton *)button;


@end


