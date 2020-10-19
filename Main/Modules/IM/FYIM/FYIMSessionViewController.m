
#import "FYIMSessionViewController.h"
#import "FYIMSessionViewController+Extension.h"
#import "FYIMSessionViewController+TableView.h"
#import "SSAddImage.h"
#import "FYSystemBaseCell.h"
#import "SSChatGameAwardCell.h"
#import "NotificationMessageCell.h"
#import "SSChatLocationController.h"
#import "SSChatMapController.h"
#import "SSImageGroupView.h"
#import "SSChatDatas.h"
#import "FYSocketManager.h"
#import "WHC_ModelSqlite.h"
#import "NSTimer+SSAdd.h"
#import "PushMessageModel.h"
#import "MessageSingle.h"
#import <ZLPhotoBrowser/ZLPhotoBrowser.h>
#import "JJPhotoManeger.h"
#import "ZLAlbumListController.h"
#import "FYChatRobKeyboard.h"
#import "FYRobNiuNIuPromptView.h" // 牛牛提示
#import "FYBalanceInfoView.h"
#import "FYBankerView.h"
#import "SSChatKeyBoardInputView+Custom.h"
#import "FYNewRobChatKeyBord.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "FYVideoTool.h"
#import "FYVideoPlayController.h"
#import "FYBagLotteryBetController.h"
@interface FYIMSessionViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, SSChatKeyBoardInputViewDelegate, FYChatBaseCellDelegate, FYChatManagerDelegate, FYSystemBaseCellDelegate, JJPhotoDelegate, FYChatRobKeyboardDelegate, FYIMGroupChatHeaderViewDelegate,FYNewRobChatKeyboardDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

/// 承载表单的视图 视图原高度
@property(assign, nonatomic) CGFloat backViewH;
@property(strong, nonatomic) UIView *dropBackView;

@property(nonatomic, strong) UIButton *redPacketBtn;

/// 访问相册 摄像头
@property(nonatomic, strong) SSAddImage *mAddImage;
/// 当前页数
@property(nonatomic, assign) NSInteger page;
/// 是否最底部
@property(nonatomic, assign) BOOL isTableViewBottom;
/// 未查看消息数量
@property(nonatomic, assign) NSInteger unreadMessageNum;
@property(nonatomic, strong) UIButton *bottomMessageBtn;
@property(nonatomic, strong) UILabel *bottomMessageLabel;

@property(nonatomic, strong) NSArray *arrDataSources;
@property(nonatomic, strong) NSMutableArray *imagesSizeArr;
@property(nonatomic, strong) ZLPhotoActionSheet *photoActionSheet;

// 本地是否还有数据
@property(nonatomic, assign) BOOL isLocalData;

@end

@implementation FYIMSessionViewController

static FYIMSessionViewController *_chatVC;

+ (FYIMSessionViewController *)currentChat {
    return _chatVC;
}

/*!
 * 初始化会话页面
 * @param conversationType 会话类型
 * @param targetId 目标会话ID，即 sessionId
 * @return 会话页面对象
 */
- (id)initWithConversationType:(FYChatConversationType)conversationType targetId:(NSString *)targetId
{
    if(self = [super init]) {
        _sessionId = targetId;
        _chatType = conversationType;
        _dataSource = [NSMutableArray array];
        //
        _page = 1;
        _unreadMessageNum = 0;
        //
        [FYIMMessageManager shareInstance].delegate = self;
        self.delegate = self;
    }
    _chatVC = self;
    return self;
}


#pragma mark - Navigation
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// 不采用系统的旋转
- (BOOL)shouldAutorotate
{
    return NO;
}

// 用户退出当前页面
- (void)pressNavigationBarLeftButtonItem:(id)sender
{
    // 退出必须设置为空
    _chatVC = nil;
    // 销毁定时器
    [self.countdownView stopTimer];
}


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:UIColor.clearColor];
    
    [AppModel shareInstance].chatType = self.chatType;
    
    // 必须禁用侧滑返回，返回前需要做相关操作（_chatVC = nil;请求退群等操作）
    [self setFd_interactivePopDisabled:YES];
    [self setFd_interactivePopMaxAllowedInitialDistanceToLeftEdge:FULLSCREEN_POP_GESTURE_MAX_DISTANCE_TO_LEFT_EDGE];
    
    // 初始化数据
    self.isLocalData = YES;
    self.unreadMessageNum = 0;
    self.imagesSizeArr = [[NSMutableArray alloc] init];
    
    // 初始化UI
    {
        _sessionInputView = [[SSChatKeyBoardInputView alloc] initWithChatType:self.chatType messageItem:self.messageItem];
        _sessionInputView.delegate = self;
        [self setDelegate_keyboard:_sessionInputView];
        [self.view addSubview:_sessionInputView];
        [self viewDidMainUI];
        [self viewDidTableView];
        [self viewDidUnreadMessageView];
    }
    
    // 获取未读消息数量
    self.unreadMessageNum = [self getUnreadMessageNumber];
    NSInteger num = kMessagePageNumber - (self.unreadMessageNum % kMessagePageNumber);
    NSInteger numCount = self.unreadMessageNum + num;
    [self getHistoricalData:numCount > kMessagePageNumber ? numCount : kMessagePageNumber];
    
    // 滚动到底部，没有未读消息
    [self scrollToBottom];
    [self UpdateGroupInfo];
    // 通知 - 监听消息列表是否需要刷新
    {
        // 已清空聊天记录
        [NOTIF_CENTER addObserver:self
                         selector:@selector(didNotificationClearChatRecordsContent:)
                             name:kNotificationClearChatRecordsContent
                           object:nil];
    }
    
    // 自建群 - 进群默认访问群状态
    if (!self.messageItem.officeFlag) {
        [self reloadPlayGroupInfo];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self setSSChatKeyBoardInputViewEndEditing];
    // 将当前 session 未读消息数清空
    FYContacts *session = [IMSessionModule.sharedInstance getSessionWithSessionId:self.sessionId];
    if (session) {
        session.unReadMsgCount = 0;
        [IMSessionModule.sharedInstance updateSeesion:session];
        [NOTIF_CENTER postNotificationName:kNotificationMsgUnreadMessageNumberChange object:nil];
    }
}

- (void)viewDidMainUI
{
    // 群聊
    if (FYConversationType_GROUP == self.chatType) {
        // 抢庄牛牛、二八杠、龙虎斗,包包彩
        if (GroupTemplate_N04_RobNiuNiu == self.messageItem.type
            || GroupTemplate_N05_ErBaGang == self.messageItem.type
            || GroupTemplate_N06_LongHuDou == self.messageItem.type
            || GroupTemplate_N10_BagLottery == self.messageItem.type
            || GroupTemplate_N11_BagBagCow == self.messageItem.type
            || GroupTemplate_N14_BestNiuNiu == self.messageItem.type) {
            self.countdownView.hidden = NO;
        }else{
            self.countdownView.hidden = YES;
        }
        self.groupHearderView.hidden = NO;
        self.heightOfGroupHeaderView = 40;
        
    } else {
        self.groupHearderView.hidden = YES;
        self.heightOfGroupHeaderView = 0;
    }
    CGFloat nperHaederH = 0;
    if (self.messageItem.type == GroupTemplate_N10_BagLottery|| GroupTemplate_N11_BagBagCow == self.messageItem.type) {//包包彩头部期数记录
        self.nperHaederView.hidden = NO;
        self.wlHaederView.hidden = YES;
        nperHaederH = 40;
    }else if (self.messageItem.type == GroupTemplate_N14_BestNiuNiu){
        self.wlHaederView.hidden = NO;
        nperHaederH = pokerWinsLossesHeadViewHigh;
        self.nperHaederView.hidden = YES;
    } else{
        self.wlHaederView.hidden = YES;
        nperHaederH = 0;
        self.nperHaederView.hidden = YES;
    }
   
    self.backViewH = FYSCREEN_Height - SSChatKeyBoardInputViewH - STATUS_NAVIGATION_BAR_HEIGHT - TAB_BAR_DANGER_HEIGHT - self.heightOfGroupHeaderView - nperHaederH;
    
    self.dropBackView = [UIView new];
    [self.view addSubview:self.dropBackView];
    [self.view addSubview:self.groupHearderView];
    [self.view addSubview:self.nperHaederView];
    [self.view addSubview:self.wlHaederView];
    [self.groupHearderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(self.heightOfGroupHeaderView);
        make.top.mas_equalTo(Height_NavBar);
    }];
     [self.nperHaederView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.right.equalTo(self.view);
         make.height.mas_equalTo(nperHaederH);
         make.top.equalTo(self.groupHearderView.mas_bottom);
     }];
    [self.wlHaederView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(nperHaederH);
        make.top.equalTo(self.groupHearderView.mas_bottom);
    }];
    [self.dropBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.groupHearderView.mas_bottom).offset(nperHaederH);
        make.height.mas_equalTo(self.backViewH);
    }];
}

- (void)viewDidTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.dropBackView addSubview:tableView];
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = HexColor(@"#EDEDED");
    tableView.backgroundView.backgroundColor = HexColor(@"#EDEDED");
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.scrollIndicatorInsets = tableView.contentInset;
    if (@available(iOS 11.0, *)){
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
    }
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.dropBackView);
    }];
    //
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapGesturedDetected:)];
    [tableView addGestureRecognizer:tapGesture];
    //
    __weak __typeof(self)weakSelf = self;
    tableView.mj_header = [CFCRefreshHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.page ++;
        if (self.chatType == FYConversationType_PRIVATE
            || self.chatType == FYConversationType_CUSTOMERSERVICE) {
            [strongSelf getHistoricalData:kMessagePageNumber];
            return;
        }
        NSString *queryId = [NSString stringWithFormat:@"%@-%@",self.sessionId,[AppModel shareInstance].userInfo.userId];
        PushMessageModel *pmModel = (PushMessageModel *)[MessageSingle shareInstance].allUnreadMessagesDict[queryId];
        if (pmModel.messageCountLeft > 0 || !self.isLocalData) {
            [strongSelf sendGetServerData];
            pmModel.messageCountLeft =  pmModel.messageCountLeft > 50 ? pmModel.messageCountLeft - 50 : 0;
        } else {
            [strongSelf getHistoricalData:kMessagePageNumber];
        }
    }];
    [self registeredCell];
}

- (void)dealloc
{
    _chatVC = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Notification

// 通知处理 - 刷新聊天内容
- (void)didNotificationClearChatRecordsContent:(NSNotificationCenter *)notification
{
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
}
/// 投注抢庄
/// @param Amount 投注金额
/// @param type 2:抢庄 ，3:投注
- (void)chatRobKeyboardaAmount:(NSString *)Amount type:(NSInteger)type betAttr:(NSInteger)betAttr
{
    switch (type) {
        case 2://抢庄
            [self robNiuNiuBankeer:Amount];
            break;
        case 3://投注
            [self robNiuNiuBett:Amount betAttr:betAttr];
            break;
        default:
            break;
    }
}
#pragma mark -- 抢庄,投注 FYNewRobChatKeyboardDelegate
- (void)chatRobKeyboardaAmount:(NSString *)Amount status:(NSInteger)status lhh:(NSInteger)lhh{
    switch (status) {
          case 2://抢庄
              [self robNiuNiuBankeer:Amount];
              break;
          case 3://投注
              [self robNiuNiuBett:Amount betAttr:lhh];
              break;
          default:
              break;
      }
}
- (void)goToPay{
    FYRechargeMainViewController *VC = [[FYRechargeMainViewController alloc] initWithIsPush:YES];
    [self.navigationController pushViewController:VC animated:YES];
}
/// 发包
- (void)chatRobRedpacket
{
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER robNiuNiuRedpacketChatId:self.messageItem.groupId success:^(id response) {
        PROGRESS_HUD_DISMISS
        if (!NET_REQUEST_SUCCESS(response)) {
            NSString *msg = [(NSDictionary *)response stringForKey:@"msg"];
            if ([msg containsString:NSLocalizedString(@"余额不足", nil)]) {
                [self checkShowBalanceView:msg];
            } else {
                ALTER_INFO_MESSAGE(msg)
            }
        }
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

/// 获取余额
- (void)checkShowBalanceView:(NSString *)title
{
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER getRobFinanceSuccess:^(id response) {
        PROGRESS_HUD_DISMISS
        if (NET_REQUEST_SUCCESS(response)) {
            NSDictionary *dict = NET_REQUEST_DATA(response);
            FYBalanceInfoModel *model = [FYBalanceInfoModel mj_objectWithKeyValues:dict];
            [FYBalanceInfoView showTitle:title balanceInfo:model block:^{
                FYRechargeMainViewController *VC = [[FYRechargeMainViewController alloc] initWithIsPush:YES];
                [self.navigationController pushViewController:VC animated:YES];
            }];
        } else {
            ALTER_HTTP_MESSAGE(response)
        }
    } fail:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
    }];
}

#pragma mark - 更新未读消息

/**
 更新未读消息
 */
- (void)updateUnreadMessage
{
    [[FYIMManager shareInstance] updateGroup:self.sessionId
                                      number:0
                                 lastMessage:NSLocalizedString(@"暂无未读消息", nil)
                                messageCount:0
                                        left:0
                                    chatType:self.chatType];
}

/**
 * 获取未读消息数量
 */
- (NSInteger)getUnreadMessageNumber
{
    NSString *queryId = [NSString stringWithFormat:@"%@-%@",self.sessionId,[AppModel shareInstance].userInfo.userId];
    PushMessageModel *pmModel = (PushMessageModel *)[MessageSingle shareInstance].allUnreadMessagesDict[queryId];
    self.unreadMessageNum = pmModel.number;
    return pmModel.number;
}


#pragma mark - 获取历史消息（下拉刷新获取数据）
- (void)getHistoricalData:(NSInteger)count
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *pageStr = [NSString stringWithFormat:@"%zd,%zd", (self.page -1)*count,count];
        NSString *whereStr = [NSString stringWithFormat:@"sessionId = '%@' and isDeleted = 0", self.sessionId];
        NSArray *messageArray = [WHC_ModelSqlite query:[FYMessage class] where:whereStr order:@"by timestamp desc,create_time desc" limit:pageStr];
        
        if (self.chatType == FYConversationType_PRIVATE
            || self.chatType == FYConversationType_CUSTOMERSERVICE) {
            if (messageArray.count == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView.mj_header endRefreshing];
                    self.tableView.mj_header.hidden = YES;
                });
                return;
            }
        } else {
            if (count != messageArray.count) {
                self.isLocalData = NO;
            }
            
            if (messageArray.count == 0) {
                [self sendGetServerData];
                [self.tableView.mj_header endRefreshing];
                return;
            }
        }
        [self controllerLoadData:messageArray];
    });
}

- (void)controllerLoadData:(NSArray *)messageArray
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSInteger indexCount = 0;
        for (NSInteger index = 0; index < messageArray.count; index++) {
            FYMessage *message = (FYMessage *)messageArray[index];
            // 如果这条消息被标记删除 则过滤掉 并且判断时间是否超过七天 如果是 直接从数据库删除
            if (message.isDeleted) {
                NSTimeInterval nowStamp = [NSDate new].timeIntervalSince1970 * 1000;
                if (message.timestamp * 7 < nowStamp ) {
                    [[IMMessageModule sharedInstance] removeLocalMessageWithMessageId:message.messageId];
                }
                continue;
            }
            
            if (self.dataSource.count == 0) {
                indexCount++;
                [self.dataSource insertObject:[SSChatDatas receiveMessage:message] atIndex:0];
            } else {
                // 去重复
                BOOL isRepeat = NO;
                for (FYMessagelLayoutModel *layout in self.dataSource) {
                    if([message.messageId isEqualToString:layout.message.messageId]) {
                        isRepeat = YES;
                        break;
                    }
                }
                if (!isRepeat) {
                    indexCount++;
                    [self.dataSource insertObject:[SSChatDatas receiveMessage:message] atIndex:0];
                }
            }
        }
        
        if (self.page > 0 && self.dataSource.count > 0) {
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexCount > 0 ? indexCount -1 : 0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            
        }
    });
}

/**
 下拉获取服务器返回的消息
 
 @param messageArray 消息数组
 */
- (void)downPullGetMessageArray:(NSArray *)messageArray
{
    NSInteger indexCount = 0;
    for (NSInteger index = 0; index < messageArray.count; index++) {
        FYMessage *message = (FYMessage *)messageArray[messageArray.count - 1 -index];
        if (self.dataSource.count == 0) {
            indexCount++;
            [self.dataSource insertObject:[SSChatDatas receiveMessage:message] atIndex:0];
        } else {
            // 去重复
            BOOL isRepeat = NO;
            for (FYMessagelLayoutModel *layout in self.dataSource) {
                if([message.messageId isEqualToString:layout.message.messageId]) {
                    isRepeat = YES;
                    break;
                }
            }
            if (!isRepeat) {
                indexCount++;
                [self.dataSource insertObject:[SSChatDatas receiveMessage:message] atIndex:0];
            }
        }
    }
    
    [self.tableView.mj_header endRefreshing];
    
    if (messageArray.count > 0) {
        [self.tableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexCount > 0 ? indexCount -1 : 0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    if (messageArray.count == 0) {
        self.tableView.mj_header.hidden = YES;
    }
    
}

- (void)sendGetServerData
{
    // 群聊（自建群）
    if (self.messageItem.officeFlag == NO && self.chatType == FYConversationType_GROUP){
        FYMessagelLayoutModel *fyMessageLayout = self.dataSource.firstObject;
        NSTimeInterval endTime = self.dataSource.count == 0 ? [[NSDate new] timeIntervalSince1970] : fyMessageLayout.message.timestamp;
        [self sendDropdownRequest:self.sessionId endTime:endTime chartType:self.chatType];
        return;
    } else {
        // 群聊（官方群）
        FYMessagelLayoutModel *fyMessageLayout = self.dataSource.firstObject;
        [self sendDropdownRequest:self.sessionId endTime:self.dataSource.count == 0 ? -1 : fyMessageLayout.message.timestamp chartType:self.chatType];
    }
}

#pragma mark 下拉请求的数据发送的参数

- (void)sendDropdownRequest:(NSString *)sessionId endTime:(NSTimeInterval)endTime chartType:(FYChatConversationType)type
{
    // 固定返回50条
    NSDictionary *parameters = @{@"chatType": @(type),
                                 @"cmd":@"19",
                                 @"endTime":endTime == -1 ? @"" : @(endTime),
                                 @"chatId":sessionId,
                                 @"userId":[AppModel shareInstance].userInfo.userId
                                 };
    [[FYIMMessageManager shareInstance] sendMessageServer:parameters];
}


#pragma mark - 未读消息 和 未读新消息视图

- (void)viewDidUnreadMessageView
{
    UIButton *bottomMessageBtn = [[UIButton alloc] init];
    [bottomMessageBtn setHidden:YES];
    [bottomMessageBtn addTarget:self action:@selector(onNewMessageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomMessageBtn setBackgroundImage:[UIImage imageNamed:@"mess_bubble"] forState:UIControlStateNormal];
    [self.view addSubview:bottomMessageBtn];
    _bottomMessageBtn = bottomMessageBtn;
    
    [bottomMessageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.tableView.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.dropBackView.mas_bottom).offset(-15);
        make.size.equalTo(@(37.5));
    }];
    
    UILabel *bottomMessageLabel = [[UILabel alloc] init];
    bottomMessageLabel.font = [UIFont systemFontOfSize:14];
    bottomMessageLabel.textColor = [UIColor whiteColor];
    bottomMessageLabel.textAlignment = NSTextAlignmentCenter;
    [bottomMessageBtn addSubview:bottomMessageLabel];
    _bottomMessageLabel = bottomMessageLabel;
    
    [bottomMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomMessageBtn.mas_centerX);
        make.centerY.mas_equalTo(bottomMessageBtn.mas_centerY).offset(-3);
    }];
}

- (void)onNewMessageBtnClick
{
    [self scrollToBottom];
    [self hidBottomUnreadMessageView];
}

- (void)hidBottomUnreadMessageView
{
    self.unreadMessageNum = 0;
    self.bottomMessageLabel.text = 0;
    self.bottomMessageBtn.hidden = YES;
}


#pragma mark - FYChatManagerDelegate

#pragma mark 接收消息
/*!
 * 即将在会话页面插入消息的回调
 * @param message 消息实体
 * @return 修改后的消息实体
 *
 * @discussion 此回调在消息准备插入数据源的时候会回调，您可以在此回调中对消息进行过滤和修改操作。
 * 如果此回调的返回值不为nil，SDK会将返回消息实体对应的消息Cell数据模型插入数据源，并在会话页面中显示。
*/
- (FYMessage *)willAppendAndDisplayMessage:(FYMessage *)message
{
    // 系统消息类型
    if (message.messageFrom == FYChatMessageFromSystem) {
        message.sessionId = self.sessionId;
    }
    
    // 如果是群聊，并且群id和接收消息的群id不同，则不往下执行
    if (self.chatType == FYConversationType_GROUP
        && ![self.messageItem.groupId isEqualToString:message.sessionId]) {
        return nil;
    }
    
    if (message.messageType == FYMessageTypeImage || message.messageType == FYMessageTypeVoice || message.messageType == FYMessageTypeVideo ) {
        if ([message.messageSendId isEqualToString:[AppModel shareInstance].userInfo.userId]) {
            for (NSInteger index = 0; index < self.dataSource.count; index++) {
                FYMessagelLayoutModel *modelLa = self.dataSource[index];
                if (modelLa.message.isReceivedMsg == NO) {
                    NSTimeInterval timestamp = [message.extras[@"timestamp"] doubleValue];
                    if (timestamp == modelLa.message.timestamp) {
                        if (message.deliveryState == FYMessageDeliveryStateFailed) {
                            modelLa.message.deliveryState = FYMessageDeliveryStateFailed;
                            break;
                        } else if (message.deliveryState == FYMessageDeliveryStateDeliveried) {
                            [self.dataSource removeObject:modelLa];
                            break;
                        }
                    }
                }
            }
        }
    }
    
    WEAKSELF(weakSelf)
    dispatch_main_async_safe(^{
        // 更新数据源
        FYMessagelLayoutModel *msg = [SSChatDatas receiveMessage:message];
        [weakSelf.dataSource addObject:msg];
        // UI更新代码
        [weakSelf delayReload];
    });
    
    return message;
}

- (void)delayReload
{
    FYMessagelLayoutModel *message = [self.dataSource lastObject];
    [self.tableView reloadData];
    if ([message.message.messageSendId isEqualToString:[AppModel shareInstance].userInfo.userId] || self.isTableViewBottom) {
        [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.1];
    }
    
    // 未读新消息
    if (!self.isTableViewBottom) {
        self.unreadMessageNum ++;
        NSString *mgsStr = self.unreadMessageNum > 99 ? @"99+" : [NSString stringWithFormat:@"%zd", self.unreadMessageNum];
        self.bottomMessageLabel.text = mgsStr;
        self.bottomMessageBtn.hidden = NO;
    }
}

/**
 * 即将撤回消息（服务器已经发送回来撤回命令 客服端还未处理时）
 * @param messageId  消息ID
 */
- (void)willRecallMessage:(NSString *)messageId
{
    if (messageId.length > 0) {
        [self onDeleteLocalMessage:messageId];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}


#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FYMessagelLayoutModel *layoutModel = _dataSource[indexPath.row];

    // 处理 cellString 为空时闪退问题
//    if (VALIDATE_STRING_EMPTY(layoutModel.message.cellString)) {
//        layoutModel.message.cellString = SSChatNilCellId;
//    }
    
    if (layoutModel.message.messageFrom == FYChatMessageFromSystem
        || layoutModel.message.messageType == FYMessageTypeNoticeRewardInfo) {
        FYSystemBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:layoutModel.message.cellString forIndexPath:indexPath];
        if (cell != nil) {
            cell.delegate = self;
            cell.model = layoutModel;
            return cell;
        } else {
            FYChatBaseCell * cell = [tableView dequeueReusableCellWithIdentifier:SSChatNilCellId];
            if (cell == nil) {
                cell = [[FYChatBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SSChatNilCellId];
            }
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.model = layoutModel;
            return cell;
        }
    } else {
        FYChatBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:layoutModel.message.cellString forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[FYChatBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SSChatNilCellId];
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.model = layoutModel;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FYMessagelLayoutModel *layoutModel = (FYMessagelLayoutModel *)_dataSource[indexPath.row];
    if (VALIDATE_STRING_EMPTY(layoutModel.message.cellString)
        || [SSChatNilCellId isEqualToString:layoutModel.message.cellString]) {
        return FLOAT_MIN;
    }
    return [layoutModel cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:NO];

    // 视图归位
    [self setSSChatKeyBoardInputViewEndEditing];
}

- (void)tableViewTapGesturedDetected:(UITapGestureRecognizer *)recognizer

{
    // 视图归位
    [self setSSChatKeyBoardInputViewEndEditing];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
    
    if ((bottomOffset-200) <= height) {
        // 在最底部
        self.isTableViewBottom = YES;
        [self hidBottomUnreadMessageView];
    } else {
        self.isTableViewBottom = NO;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    UIMenuController *menu=[UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:NO];
    
    [self setSSChatKeyBoardInputViewEndEditing];
}


#pragma mark - SSChatKeyBoardInputViewDelegate

// 视图归位
- (void)setSSChatKeyBoardInputViewEndEditing
{
    [self.view endEditing:YES];
    [self.tableView endEditing:YES];
    [self.sessionInputView endEditing:YES];
    
    [_sessionInputView SetSSChatKeyBoardInputViewEndEditing];
}

// 点击按钮视图frame发生变化 调整当前列表frame
- (void)SSChatKeyBoardInputViewHeight:(CGFloat)keyBoardHeight changeTime:(CGFloat)changeTime
{
    CGFloat height = self.backViewH - keyBoardHeight;
    [UIView animateWithDuration:changeTime animations:^{
        [self.dropBackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
    } completion:^(BOOL finished) {
        if (self.dataSource.count > 0) {
            [self.tableView reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0];
            dispatch_main_async_safe(^{
                // 刷新完成
                [self.tableView scrollToRowAtIndexPath:indexPath
                                      atScrollPosition:UITableViewScrollPositionBottom
                                              animated:YES];
            });
        }
    }];
}

// 发送文本，列表滚动至底部
- (void)onChatKeyBoardInputViewSendText:(NSString *)text
{
    FYMessage *model = [[FYMessage alloc] init];
    model.text = text;
    model.deliveryState = FYMessageDeliveryStateDelivering;
    
    [self sendMessageAction:model];
}

// 多功能视图点击回调  图片10  视频11  位置12
-(void)fyChatFunctionBoardClickedItemWithTag:(NSInteger)tag
{
    [self setSSChatKeyBoardInputViewEndEditing];
    
    if (tag == 10 || tag == 11) {
        if(!_mAddImage) _mAddImage = [[SSAddImage alloc]init];
        if (tag==10) {
            [self fyCahtSendVideo];
        } else if (tag==11) {
            [self takePhoto];
        }
    } else {
        SSChatLocationController *vc = [SSChatLocationController new];
        vc.locationBlock = ^(NSDictionary *locationDic, NSError *error) {
            // [self sendMessage:locationDic messageType:FYMessageTypeMap];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - UIImagePickerController

- (void)fyCahtSendVideo
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    //这步一定要设置为YES，不然无法控制时长
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    //(以s为单位)
    imagePicker.videoMaximumDuration = 60;
    imagePicker.mediaTypes = @[(NSString*)kUTTypeMovie,(NSString *)kUTTypeImage];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.modalPresentationStyle=UIModalPresentationOverFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}


#pragma mark - 视频选择代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    //获取媒体类型
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //判断是静态图像还是视频
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        //获取视频文件的url
        NSURL* mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:mediaURL.path] options:nil];
        [FYVideoTool startExportMP4VideoWithVideoAsset:asset success:^(NSString * _Nonnull outputPath, NSString * _Nonnull fileName, UIImage * _Nonnull img) {
            NSData *videoData = [NSData dataWithContentsOfFile:outputPath];
            [self sendSelectVideo:videoData fileName:fileName image:img];
        } failure:^(NSString * _Nonnull errorMessage, NSError * _Nonnull error) {
            NSLog(@"%@",errorMessage);
        }];
        
    } else if([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [self sendSelectImage:@[image]];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 发送红包
- (void)fyChatKeyBoardClickedCustomButtonRedPacket:(UIButton *)sender
{
    // 在子类中进行处理
}

#pragma mark - 接龙游戏发包
- (void)fyChatKeyBoardClickedCustomButtonSolitaire
{
    if (self.sinfoModel.groupOwnerId == nil){
        return;
    }
    
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER getSolitaireSendDict:@{@"chatId":self.messageItem.groupId,@"userId":self.sinfoModel.groupOwnerId} success:^(id response) {
        PROGRESS_HUD_DISMISS
        if (!NET_REQUEST_SUCCESS(response)) {
            NSString *msg = [(NSDictionary *)response stringForKey:@"msg"];
            if ([msg containsString:NSLocalizedString(@"余额不足", nil)]) {
                [self checkShowBalanceView:msg];
            } else {
                ALTER_INFO_MESSAGE(msg)
            }
        }
    } fail:^(id error) {
        PROGRESS_HUD_DISMISS
        if ([error isKindOfClass:[NSDictionary class]]) {
            NSString *msg = [(NSDictionary *)error stringForKey:@"alterMsg"];
            if ([msg containsString:NSLocalizedString(@"余额不足", nil)]) {
                [self checkShowBalanceView:msg];
            } else {
                [[FunctionManager sharedInstance] handleFailResponse:error];
            }
        } else {
            [[FunctionManager sharedInstance] handleFailResponse:error];
        }
    }];
}

#pragma mark - 抢庄牛牛发包 包包彩投注
- (void)fyChatKeyBoardClickedCustomButtonRobNiuNiu:(NSInteger)statusOfRobNiuNiu
{
    if (self.messageItem.type == GroupTemplate_N10_BagLottery
        || self.messageItem.type == GroupTemplate_N14_BestNiuNiu) { // 包包彩,百人牛牛
        switch (statusOfRobNiuNiu) {
            case 3://投注
            {
                FYBagLotteryBetController *VC = [[FYBagLotteryBetController alloc] init];
                VC.messageItem = self.messageItem;
                VC.groupId = self.messageItem.groupId;
                VC.bagLotteryModel = self.bagLotteryModel;
                [self setDelegate_bet:VC];
                MJWeakSelf
                VC.block = ^{
                    [weakSelf updateBalance];
                };
                [self.navigationController pushViewController:VC animated:YES];
            }
                break;
            default:
                break;
        }
        return;
    } else if (self.messageItem.type == GroupTemplate_N11_BagBagCow) {
        [self bagBagCowBetKeyboardButtonEvent];
        return;
    }
    
    if (self.messageItem.robNiuniu != nil) {
        NSDictionary *dict = [self.messageItem.robNiuniu mj_JSONObject];
        NSString *money = @"";
        if (statusOfRobNiuNiu == 2) {
            money = [NSString stringWithFormat:@"+%zd",[dict[@"continueBankerPercent"] integerValue]];
        }else if (statusOfRobNiuNiu == 3){
            money = @".";
        }
        if ([self.messageItem isKindOfClass:[MessageItem class]]) {
            // 状态：1.连续上庄 2.抢庄 3.投注 4.发包 5.抢包 6.结算*/
            if (self.messageItem.robNiuniu != nil) {
                switch (statusOfRobNiuNiu) {
                    case 2: // 抢庄
                    case 3: // 投注
                    {
                        if (GroupTemplate_N07_JieLong != self.messageItem.type) {
                            if (statusOfRobNiuNiu == 3) {//投注
                                [NET_REQUEST_MANAGER requestWithAct:ActRequestRobNiuNiuBetAmount parameters:@{@"chatId":self.messageItem.groupId} success:^(id object) {
                                    if ([object[@"code"] intValue] == 0) {
                                        NSString *list = [NSString stringWithFormat:@"%@",object[@"data"]];
                                        [FYNewRobChatKeyBord showPayKeyboardViewAnimate:self moneyArr:[list componentsSeparatedByString:@","] money:money status:statusOfRobNiuNiu gameType:self.messageItem.type];
                                    }
                                } failure:^(id object) {
                                    [[FunctionManager sharedInstance]handleFailResponse:object];;
                                }];
                            }else{
                                
                                [FYNewRobChatKeyBord showPayKeyboardViewAnimate:self moneyArr:[self.messageItem.robNiuniu.rabBankerMoneyList componentsSeparatedByString:@","] money:money status:statusOfRobNiuNiu gameType:self.messageItem.type];
                            }
                            
                        }
                    }
                        break;
                    case 4: // 发包
                        [self chatRobRedpacket];
                        break;
                    default:
                        break;
                }
            }
        }
    }
}

- (void)startTyping
{
//    self.sessionInputView.hidden = YES;
}

#pragma mark - FYChatBaseCellDelegate
/// 包包彩投注点击
- (void)didChatBagLotteryBetCell:(FYMessage *)model row:(NSInteger)row{
    [self didChatBagbagBetCell:model row:row];
}
///包包牛投注点击
- (void)didChatBagBagCowBetCell:(FYMessage *)model row:(NSInteger)row{
    [self didBagBagCowBetCell:model row:row];
}
// 点击Cell消息背景视图
- (void)didTapMessageCell:(FYMessage *)model
{
}

- (void)didChatVoiceCell:(FYChatBaseCell*)cell model:(FYMessage *)model
{
    
}

// 撤回消息
- (void)onWithdrawMessageCell:(FYMessage *)model
{
    NSDictionary *parameters = @{
        @"id":model.messageId,  // 消息ID
        @"createTime":@(model.timestamp),
        @"chatId":model.sessionId,   // 群ID
        @"chatType":@(model.chatType),   // 会话类型
        @"cmd":@"15"      // 聊天命令
    };
    [[FYIMMessageManager shareInstance] sendMessageServer:parameters];
}

// 删除消息
-(void)onDeleteMessageCell:(FYMessage *)model indexPath:(NSIndexPath *)indexPath
{
    if (model.messageId.length > 0) {
        [self onDeleteLocalMessage:model.messageId];
        [self.tableView reloadData];
    }
}


#pragma 点击图片 点击短视频
- (void)didChatImageVideoCellIndexPatch:(NSIndexPath *)indexPath layout:(FYMessagelLayoutModel *)layout
{
    NSInteger currentIndex = 0;
    NSMutableArray *groupItems = [NSMutableArray new];
    UIImageView *seleedView;
    
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    
    NSMutableArray *picUrlArr = [[NSMutableArray alloc] init];
    if (layout.message.messageType == FYMessageTypeImage) {
        for(int i=0;i<self.dataSource.count;++i){
            
            NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
            FYChatBaseCell *cell = [self.tableView cellForRowAtIndexPath:ip];
            FYMessagelLayoutModel *mLayout = self.dataSource[i];
            
            if (cell == nil) {
                continue;
            }
            SSImageGroupItem *item = [SSImageGroupItem new];
            if(mLayout.message.messageType == FYMessageTypeImage && mLayout.message.messageFrom != FYChatMessageFromSystem){
                item.imageType = SSImageGroupImage;
                item.fromImgView = cell.mImgView;
                item.fromImage = cell.mImgView.image;
                [imageArr addObject:cell.mImgView];
                if (mLayout.message.imageUrl) {
                    [picUrlArr addObject:mLayout.message.imageUrl];
                }
            } else if (mLayout.message.messageType == FYMessageTypeVideo){
                item.imageType = SSImageGroupVideo;
                item.videoPath = mLayout.message.videoRemotePath;
                item.fromImgView = cell.mImgView;
                item.fromImage = cell.mImgView.image;
            } else {
                continue;
            }
            
            
            //        item.contentMode = mLayout.message.contentMode;
            item.itemTag = groupItems.count + 10;
            if([mLayout isEqual:layout]) {
                currentIndex = groupItems.count;
                seleedView = cell.mImgView;
            }
            [groupItems addObject:item];
            
        }
        JJPhotoManeger *mg = [JJPhotoManeger maneger];
        mg.delegate = self;
        [mg showNetworkPhotoViewer:imageArr urlStrArr:picUrlArr selecView:seleedView];
    }else if (layout.message.messageType == FYMessageTypeVideo){
        FYVideoPlayController *playVc = [[FYVideoPlayController alloc]init];
        playVc.message = layout.message;
        [self.navigationController pushViewController:playVc animated:YES];
    }
}

-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex
{
    NSLog(NSLocalizedString(@"最后一张观看的图片的index是:%zd", nil),selecedImageViewIndex);
}

// 点击定位Cell
- (void)didChatMapCellIndexPath:(NSIndexPath *)indexPath layout:(FYMessagelLayoutModel *)layout
{
    SSChatMapController *vc = [SSChatMapController new];
    vc.latitude = layout.message.latitude;
    vc.longitude = layout.message.longitude;
    [self.navigationController pushViewController:vc animated:YES];
}

// 聊天图片放大浏览
- (void)tap:(UITapGestureRecognizer *)tap
{
    //    UIImageView *view = (UIImageView *)tap.view;
    //    JJPhotoManeger *mg = [JJPhotoManeger maneger];
    //    mg.delegate = self;
    //    [mg showNetworkPhotoViewer:_imageArr urlStrArr:_picUrlArr selecView:view];
}


#pragma mark - FYIMGroupChatHeaderViewDelegate

// 群组头部事件 - 查看余额
- (void)groupHeaderView:(FYIMGroupChatHeaderView *)headerView didActionOfCheckBalance:(UILabel *)balanceLabel
{
    [self checkShowBalanceView:NSLocalizedString(@"余额", nil)];
}

// 群组头部事件 - 充值操作
- (void)groupHeaderView:(FYIMGroupChatHeaderView *)headerView didActionOfRecharge:(UIButton *)button
{
    // TODO: 在子类中进行操作
}

// 群组头部事件 - 玩法操作
- (void)groupHeaderView:(FYIMGroupChatHeaderView *)headerView didActionOfPlayRule:(UIButton *)button
{
    // TODO: 在子类中进行操作
}

// 群组头部事件 - 分享操作
- (void)groupHeaderView:(FYIMGroupChatHeaderView *)headerView didActionOfShare:(UIButton *)button
{
    // TODO: 在子类中进行操作
}


#pragma mark - 相册

- (void)loadImage
{
    [self showWithPreview:NO];
}

- (void)showWithPreview:(BOOL)preview
{
    ZLPhotoActionSheet *a = [self getPas];
    _photoActionSheet = a;
    if (preview) {
        [a showPreviewAnimated:YES];
    } else {
        [a showPhotoLibrary];
    }
}

- (ZLPhotoActionSheet *)getPas
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    actionSheet.configuration.allowTakePhotoInLibrary = YES;
    actionSheet.configuration.allowSelectOriginal = NO;
    actionSheet.configuration.showCaptureImageOnTakePhotoBtn = YES;
    actionSheet.configuration.maxPreviewCount = 20;
    actionSheet.configuration.maxSelectCount = 1;
    actionSheet.configuration.editAfterSelectThumbnailImage = NO;
    actionSheet.configuration.showSelectedMask = YES;
    actionSheet.configuration.shouldAnialysisAsset = YES;
    actionSheet.configuration.languageType = NO;

    // 注意：必须required
    // 如果调用的方法没有传sender，则该属性必须提前赋值
    actionSheet.sender = self;
    
    @zl_weakify(self);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        @zl_strongify(self);
        [self sendSelectImage:images];
    }];
    
    actionSheet.selectImageRequestErrorBlock = ^(NSArray<PHAsset *> * _Nonnull errorAssets, NSArray<NSNumber *> * _Nonnull errorIndex) {
        NSLog(NSLocalizedString(@"图片解析出错的索引为: %@, 对应assets为: %@", nil), errorIndex, errorAssets);
    };
    
    actionSheet.cancleBlock = ^{
        NSLog(NSLocalizedString(@"取消选择图片", nil));
    };
    
    return actionSheet;
}

- (void)sendSelectImage:(NSArray *)images {
    self.arrDataSources = images;
    FYMessage *modelMessage = [[FYMessage alloc] init];
    modelMessage.messageType = FYMessageTypeImage;
    modelMessage.sessionId = self.sessionId;
    modelMessage.messageSendId = [AppModel shareInstance].userInfo.userId;
    modelMessage.user = [AppModel shareInstance].userInfo;
    modelMessage.create_time = [NSDate date];
    
    UIImage *image = (UIImage *)images.firstObject;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(image.size.width) forKey:@"width"];
    [dict setObject:@(image.size.height) forKey:@"height"];
    [dict setObject:image forKey:@"image"];
    modelMessage.selectPhoto = dict;
    
    [self sendMessage:modelMessage];
    [self uploadImage:modelMessage];
}
- (void)sendSelectVideo:(NSData *)videoData fileName:(NSString *)fileName image:(UIImage *)image{
    FYMessage *modelMessage = [[FYMessage alloc] init];
    modelMessage.messageType = FYMessageTypeVideo;
    modelMessage.sessionId = self.sessionId;
    modelMessage.messageSendId = [AppModel shareInstance].userInfo.userId;
    modelMessage.user = [AppModel shareInstance].userInfo;
    modelMessage.create_time = [NSDate date];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:fileName forKey:@"fileName"];
    [dict setObject:@(image.size.width) forKey:@"width"];
    [dict setObject:@(image.size.height) forKey:@"height"];
    [dict setObject:image forKey:@"image"];
    modelMessage.selectVideo = dict;
    modelMessage.videoimgData = UIImagePNGRepresentation(image);
    modelMessage.videoLocalPath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",fileName] stringByAppendingFormat:@".mov"];
    [self sendMessage:modelMessage];
    [self upLoadVideo:modelMessage];
}
- (void)upLoadVideo:(FYMessage*)message{
//    NSData *selectedVideo = (NSData *)message.selectVideo[@"data"];
    NSData *selectedVideo = [NSData dataWithContentsOfFile:message.videoLocalPath];
    NSString *fileName = [NSString stringWithFormat:@"%@",message.selectVideo[@"fileName"]];
    if (selectedVideo == nil && fileName.length == 0) {
        return;
    }
    MJWeakSelf
    [NET_REQUEST_MANAGER upLoadVideoObj:selectedVideo fileName:fileName success:^(id response) {
        NSLog(@"%@",[response mj_JSONString]);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([response objectForKey:@"code"] && [[response objectForKey:@"code"] integerValue] == 0) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if (message.selectVideo.count) {//成功
                [dict setObject:fileName forKey:@"fileName"];
                [dict setObject:@([message.selectVideo[@"width"] floatValue]) forKey:@"width"];
                [dict setObject:@([message.selectVideo[@"height"] floatValue]) forKey:@"height"];
            }
            if (![response objectForKey:@"data"] || [[response objectForKey:@"data"] isEqualToString:@""]) {
                message.deliveryState = FYMessageDeliveryStateFailed;
                [self updateMessage:message.messageId];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.tableView reloadData];
                });
                return;
            }
            [dict setObject:[response objectForKey:@"data"] forKey:@"url"];
            message.videoRemotePath = [response objectForKey:@"data"];
            NSString *dddd =  [dict mj_JSONString];
            message.text = dddd;
            [strongSelf sendMessageAction:message];
        }
    } fail:^(id object) {
        message.deliveryState = FYMessageDeliveryStateFailed;
        [self updateMessage:message.messageId];
        [[FunctionManager sharedInstance] handleFailResponse:object];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
}

/**
 点击重发
 
 @param model 消息模型
 */
-(void)onErrorBtnCell:(FYMessage *)model {
    
    [self onDeleteLocalMessage:model.messageId];
    [self sendMessage:model];
    
    if (model.imageUrl.length > 0) {
        [self sendMessageAction:model];
    } else {
        [self uploadImage:model];
    }
    
}

// 发送消息
-(void)sendMessage:(FYMessage *)message {
    
    __weak __typeof(self)weakSelf = self;
    [SSChatDatas sendMessage:message messageBlock:^(FYMessagelLayoutModel *model, NSError *error, NSProgress *progress) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.dataSource addObject:model];
        [strongSelf.tableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:strongSelf.dataSource.count-1 inSection:0];
        [strongSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [WHC_ModelSqlite insert:message];
        });
    }];
}

#pragma mark -- 发送语音
- (void)uploadVoice:(FYMessage*)model{
    if (model.voice == nil) {
        return;
    }
    __weak __typeof(self)weakSelf = self;
    [NET_REQUEST_MANAGER upLoadVoiceObj:model.voice success:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([response objectForKey:@"code"] && [[response objectForKey:@"code"] integerValue] == 0) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if (![response objectForKey:@"data"] || [[response objectForKey:@"data"] isEqualToString:@""]) {
                model.deliveryState = FYMessageDeliveryStateFailed;
                [self updateMessage:model.sessionId];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.tableView reloadData];
                });
                return;
            }
            [dict setObject:[response objectForKey:@"data"] forKey:@"url"];
            [dict setObject:model.voiceTime forKey:@"time"];
            [dict setBool:NO forKey:@"unRead"];
            model.text = [dict mj_JSONString];
            [strongSelf sendMessageAction:model];
        }else{
            model.deliveryState = FYMessageDeliveryStateFailed;
            [self updateMessage:model.sessionId];
            [[FunctionManager sharedInstance] handleFailResponse:response];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
            });
        }
    } fail:^(id object) {
        model.deliveryState = FYMessageDeliveryStateFailed;
        [self updateMessage:model.messageId];
        [[FunctionManager sharedInstance] handleFailResponse:object];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
}
// 发送语音
-(void)SSChatKeyBoardInputViewBtnClick:(SSChatKeyBoardInputView *)view sendVoice:(NSData *)voice time:(NSInteger)second{
    FYMessage *model = [[FYMessage alloc] init];
    model.messageType = FYMessageTypeVoice;
    model.voice = voice;
    model.voiceTime = [NSString stringWithFormat:@"%zd",second];
    model.sessionId = self.sessionId;
    model.messageSendId = [AppModel shareInstance].userInfo.userId;
    model.user = [AppModel shareInstance].userInfo;
    model.create_time = [NSDate date];
    [self sendMessage:model];
    [self uploadVoice:model];
    
    
}

#pragma mark -  上传图片
/**
 上传图片
 */
- (void)uploadImage:(FYMessage *)model {
    
    UIImage *selectedImage = (UIImage *)model.selectPhoto[@"image"];
    if (selectedImage == nil) {
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    [NET_REQUEST_MANAGER upLoadImageObj:selectedImage success:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([response objectForKey:@"code"] && [[response objectForKey:@"code"] integerValue] == 0) {
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if (model.selectPhoto.count) {
                [dict setObject:@([model.selectPhoto[@"width"] floatValue]) forKey:@"width"];
                [dict setObject:@([model.selectPhoto[@"height"] floatValue]) forKey:@"height"];
            }
            if (![response objectForKey:@"data"] || [[response objectForKey:@"data"] isEqualToString:@""]) {
                model.deliveryState = FYMessageDeliveryStateFailed;
                [self updateMessage:model.messageId];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.tableView reloadData];
                });
                return;
            }
            [dict setObject:[response objectForKey:@"data"] forKey:@"url"];
            model.imageUrl = [response objectForKey:@"data"];
            NSString *dddd =  [dict mj_JSONString];
            model.text = dddd;
            [strongSelf sendMessageAction:model];
        } else {
            
            model.deliveryState = FYMessageDeliveryStateFailed;
            [self updateMessage:model.messageId];
            [[FunctionManager sharedInstance] handleFailResponse:response];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
            });
            
        }
    } fail:^(id error) {
        model.deliveryState = FYMessageDeliveryStateFailed;
        [self updateMessage:model.messageId];
        [[FunctionManager sharedInstance] handleFailResponse:error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
}

- (void)updateMessage:(NSString *)messageId
{
    FYMessage *fyMessage = [[IMMessageModule sharedInstance] getMessageWithMessageId:messageId];
    fyMessage.deliveryState = FYMessageDeliveryStateFailed;
    [[IMMessageModule sharedInstance] updateMessage:fyMessage];
}


#pragma mark - Getter

- (FYIMGroupChatHeaderView *)groupHearderView
{
    if (!_groupHearderView) {
        _groupHearderView = [[FYIMGroupChatHeaderView alloc] initWithGroupTemplateType:self.messageItem.type];
        _groupHearderView.delegate = self;
    }
    return _groupHearderView;
}

- (FYCountdownHeaderView *)countdownView{
    if (!_countdownView) {
        _countdownView = [[FYCountdownHeaderView alloc]init];
    }
    return _countdownView;
}
- (FYNperHaederView *)nperHaederView{
    if (!_nperHaederView) {
        _nperHaederView = [[FYNperHaederView alloc]init];
    }
    return _nperHaederView;
}
- (FYPokerWinsLossesHeadView *)wlHaederView{
    if (!_wlHaederView) {
        _wlHaederView = [[FYPokerWinsLossesHeadView alloc]init];
    }
    return _wlHaederView;
}
#pragma mark - Private

// 滚动到最底部 https://www.jianshu.com/p/03c478adcae7
-(void)scrollToBottom
{
    if (self.dataSource.count > 0) {
        if ([self.tableView numberOfRowsInSection:0] > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.tableView numberOfRowsInSection:0]-1) inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    self.unreadMessageNum = 0;
    self.isTableViewBottom = YES;
}

/**
 * 发送消息所有方法
 */
- (void)sendMessageAction:(FYMessage *)model
{
    if ([FYIMMessageManager shareInstance].isConnectFY) {
        
        if (self.chatType == FYConversationType_GROUP) {  // 群聊
            
            NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
            [userDict setObject:[AppModel shareInstance].userInfo.userId forKey:@"userId"];  // 用户ID
            [userDict setObject:[AppModel shareInstance].userInfo.nick forKey:@"nick"];   // 用户昵称
            [userDict setObject:[AppModel shareInstance].userInfo.avatar forKey:@"avatar"];  // 用户头像
            
            NSMutableDictionary *extrasDict = [[NSMutableDictionary alloc] init];
            [extrasDict setObject:[AppModel shareInstance].userInfo.userId forKey:@"userId"];  // 用户ID
            [extrasDict setObject:self.sessionId forKey:@"sessionId"];
            [extrasDict setObject:@(model.timestamp) forKey:@"timestamp"];
            
            NSDictionary *parameters = @{
                @"user":userDict,  // 发送者用户信息
                @"extras":extrasDict,
                @"from":[AppModel shareInstance].userInfo.userId, // 发送者ID
                @"cmd":@"11",      // 聊天命令
                @"chatId":self.sessionId,   // 会话id
                @"chatType":@(self.chatType),  // 1 群聊  2表示私聊
                @"msgType":@(model.messageType),   // 0 文本 6 红包  7 报奖信息
                @"content":model.text // 消息内容
            };
            
            [self sendMessageServerDict:parameters];
            
        } else if (self.chatType == FYConversationType_PRIVATE
                   || self.chatType == FYConversationType_CUSTOMERSERVICE) {  // 单聊
            
            NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
            [userDict setObject:[AppModel shareInstance].userInfo.userId forKey:@"userId"];  // 用户ID
            [userDict setObject:[AppModel shareInstance].userInfo.nick forKey:@"nick"];   // 用户昵称
            [userDict setObject:[AppModel shareInstance].userInfo.avatar forKey:@"avatar"];  // 用户头像
            
            NSMutableDictionary *extrasDict = [[NSMutableDictionary alloc] init];
            [extrasDict setObject:[AppModel shareInstance].userInfo.userId forKey:@"userId"];  // 用户ID
            [extrasDict setObject:self.sessionId forKey:@"sessionId"];
            [extrasDict setObject:@(model.timestamp) forKey:@"timestamp"];
            
            NSMutableDictionary *receiverDict = [[NSMutableDictionary alloc] init];
            [receiverDict setObject:self.toContactsModel.userId forKey:@"userId"];
            [receiverDict setObject:self.toContactsModel.nick forKey:@"nick"];
            [receiverDict setObject:self.toContactsModel.avatar forKey:@"avatar"];
            
            NSDictionary *parameters = @{
                @"user":userDict,  // 发送者用户信息
                @"from":[AppModel shareInstance].userInfo.userId, // 发送者ID
                @"cmd":@"11", // 聊天命令
                @"chatId":self.sessionId, // 会话id
                @"to": self.toContactsModel.userId, // 接收人
                @"chatType":@(self.chatType),  // 1 群聊 2表示私聊
                @"msgType":@(model.messageType),   // 0 文本 1 图片
                @"content":model.text, // msgType为1图片时，存图片地址等参数，由发送端自定义
                @"receiver":receiverDict, // 对方用户信息
                @"extras":extrasDict
            };
            
            [self sendMessageServerDict:parameters];
            
        } else {
            
            NSLog(NSLocalizedString(@"没有这个聊天类型", nil));
            
        }
        
    } else {
        if (model.messageType == FYMessageTypeImage || model.messageType == FYMessageTypeVideo || model.messageType == FYMessageTypeVideo) {
            model.deliveryState = FYMessageDeliveryStateFailed;
            [self updateMessage:model.messageId];
        }
        NSLog(NSLocalizedString(@"🔴🔴🔴🔴🔴🔴 没有连接上 Socket 🔴🔴🔴🔴🔴🔴", nil));
    }
}

- (void)sendMessageServerDict:(NSDictionary *)dictPar
{
    FYMessage *message = [FYMessage mj_objectWithKeyValues:dictPar];
    
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:dictPar];
    if (self.delegate && [self.delegate respondsToSelector:@selector(willSendMessage:)]) {
        message = [self.delegate willSendMessage:message];
        if (message != nil) {
            [tempDict setObject:message.text forKey:@"content"];
        } else {
            [tempDict setObject:@"" forKey:@"content"];
        }
    }
    
    // 测试
    // [self testUse:tempDict text:message.text];
    
    [[FYIMMessageManager shareInstance] sendMessageServer:tempDict];
}

// 注意：只能测试时用
- (void)testUse:(NSMutableDictionary *)muDict text:(NSString *)text
{
    for (NSInteger index = 0; index < 100; index++) {
        [muDict setObject:[NSString stringWithFormat:@"%@-%zd", text,index] forKey:@"content"];
        [[FYIMMessageManager shareInstance] sendMessageServer:muDict];
    }
}


/**
 * 删除本地消息方法
 * @param messageId 消息ID
 */
- (void)onDeleteLocalMessage:(NSString *)messageId
{
    for (FYMessagelLayoutModel *modelLayout in self.dataSource) {
        if ([messageId isEqualToString:modelLayout.message.messageId]) {
            [self.dataSource removeObject:modelLayout];
            [self deleteMessageUpdateSql:messageId];
            break;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

/**
 * 删除本地消息方法
 * @param messageId 消息ID
*/
- (void)deleteMessageUpdateSql:(NSString *)messageId
{
    NSString *whereStr = [NSString stringWithFormat:@"messageId='%@'", messageId];
    FYMessage *fyMessage = [[WHC_ModelSqlite query:[FYMessage class] where:whereStr] firstObject];
    fyMessage.isDeleted = YES;
    if (fyMessage != nil) {
        [WHC_ModelSqlite update:fyMessage where:whereStr];
    }
    // 处理上一条消息的显示
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [IMSessionModule.sharedInstance handleMessageForRecallOrDeletedWithSessionId:fyMessage.sessionId];
    });
}


- (void)takePhoto
{
//    ZLPhotoActionSheet *photoActionSheet = [self getPas];
    if (![ZLPhotoManager haveCameraAuthority]) {
        NSString *message = [NSString stringWithFormat:GetLocalLanguageTextValue(ZLPhotoBrowserNoCameraAuthorityText), kAPPName];
        ShowAlert(message, self);
        return;
    }
    if (![ZLPhotoManager haveMicrophoneAuthority]) {
        NSString *message = [NSString stringWithFormat:GetLocalLanguageTextValue(ZLPhotoBrowserNoMicrophoneAuthorityText), kAPPName];
        ShowAlert(message, self);
        return;
    }
    
    ZLCustomCamera *camera = [[ZLCustomCamera alloc] init];
    camera.allowTakePhoto = YES;
    camera.allowRecordVideo = NO;
    camera.sessionPreset = ZLCaptureSessionPreset1280x720;
    camera.videoType = ZLExportVideoTypeMov;
    camera.circleProgressColor = kRGB(80, 180, 234);;
    camera.maxRecordDuration = 10;
    @zl_weakify(self);
    
    camera.doneBlock = ^(UIImage *image, NSURL *videoUrl) {
        @zl_strongify(self);
        //        [photoActionSheet saveImage:image videoUrl:videoUrl];
        if (image) {
            [self sendSelectImage:@[image]];
        }
        
    };
    [self showDetailViewController:camera sender:nil];
}

@end

