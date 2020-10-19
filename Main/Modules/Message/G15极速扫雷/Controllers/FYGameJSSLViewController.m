//
//  FYGameJSSLViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGameJSSLViewController.h"
#import "FYGameJSSLHeadRecordView.h"
#import "FYJSSLFooterView.h"
#import "FYBagLotteryBetCountdownView.h"
#import "FYBalanceInfoModel.h"
#import "FYJSSLGameOddsModel.h"
#import "FYBalanceInfoView.h"
#import "FYJSSLDataSource.h"
#import "FYJSSLGameCell.h"
#import "FYJSSLMachineSelecteView.h"
#import "FYGameJSSLCollectionHeadView.h"
#import "FYJSSLGameBetOddsUtil.h"
#import "FYJSSLBettHUDView.h"
#import "FYActivityMainViewController.h"
#import "FYJSSLGameTrendViewController.h"
#import "FYJSSLGameRecordViewController.h"

static NSString *const FYJSSLGameCellID = @"FYJSSLGameCellID";
@interface FYGameJSSLViewController ()<FYIMGroupChatHeaderViewDelegate,FYJSSLFooterDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,JSSLMachineSelecteDelegate>
/* 群聊头部面板 - 控件 */
@property(nonatomic, strong) FYIMGroupChatHeaderView *groupHearderView;
///头部记录
@property (nonatomic , strong) FYGameJSSLHeadRecordView *headRecordView;
@property (nonatomic , strong) FYJSSLFooterView *footerView;
///倒计时
@property (nonatomic , strong) FYBagLotteryBetCountdownView *countdownView;
@property (nonatomic , strong) RobNiuNiuQunModel *jsslQunInfo;

@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) UICollectionViewFlowLayout *layout;
@property (nonatomic , strong) NSArray <FYJSSLDataSource*>*dataSource;
@property (nonatomic , strong) FYGameJSSLCollectionHeadView *collectionHeadView;
@property (nonatomic , strong) FYJSSLMachineSelecteView *machineSelecteView;
@property (nonatomic , strong) FYJSSLMachineSelecteView *otherGamedataView;
@property (nonatomic , strong) FYJSSLGameOddsModel *oddsModel;
@property (nonatomic , strong) UIView *jsslBgView;
@property (nonatomic , strong) UIButton *lastBtn;
@property (nonatomic , strong) UILabel *lastLab;
///上次投注的金额
@property (nonatomic , copy) NSString *lastMoney;
///上次投注的数据
@property (nonatomic , strong) NSArray <FYJSSLDataSource*>* lastBettDataSource;
///是否可以投注
@property (nonatomic , assign) BOOL isBett;
@property (nonatomic , strong) RobNiuNiuQunModel *bagLotteryModel;

@end

@implementation FYGameJSSLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
    [self getGameJSSLOdds];
    [self getGameJSSLInfo];
    [self updateBalance];
    [self setGameJSSLDate];
    [NOTIF_CENTER addObserver:self selector:@selector(didNotificationGroupStatusMessage:)name:kNotificationGroupOfRobNiuNiuContent object:nil];
   
}
- (void)setGameJSSLDate{
    self.dataSource = [FYJSSLDataSource setJSSLDataSource];
    [self.collectionView reloadData];
}
- (void)pressNavigationBarLeftButtonItem:(id)sender
{
    [super pressNavigationBarLeftButtonItem:sender];
    
    [self.countdownView stopTime];
    [NOTIF_CENTER removeObserver:self];
}
#pragma mark - 群信息
- (void)didNotificationGroupStatusMessage:(NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    NSString *groupId = [NSString stringWithFormat:@"%@",dict[@"data"][@"chatId"]];
    if (![self.messageItem.groupId isEqualToString:groupId]) {
        return;
    }
    NSDictionary *dataDict = [dict[@"data"][@"content"] mj_JSONObject];
    if ([dataDict[@"type"] integerValue] == 1) {//更新群状态
        [self performSelectorOnMainThread:@selector(jsslQunContent:) withObject:dataDict waitUntilDone:YES];
    }
}
///群信息
- (void)getGameJSSLInfo{
    [NET_REQUEST_MANAGER requestWithAct:ActRequestJsslInfo parameters:@{@"chatId":self.messageItem.groupId} success:^(id object) {
        NSDictionary *dict = [object mj_JSONObject];
        if ([dict[@"code"] integerValue] == 0) {
            self.jsslQunInfo = [RobNiuNiuQunModel mj_objectWithKeyValues:dict[@"data"]];
            self.bagLotteryModel = self.jsslQunInfo;
            [self performSelectorOnMainThread:@selector(jsslQunContent:) withObject:object waitUntilDone:YES];
        }
    } failure:^(id object) {
//        NSLog(@"%@",[object mj_JSONString]);
    }];
}
-(void)jsslQunContent:(NSDictionary *)dict{
    RobNiuNiuQunModel *model = [RobNiuNiuQunModel mj_objectWithKeyValues:dict[@"data"]];
    // 刷新走势图页面倒计时信息
    if(self.delegate_jsslgame && [self.delegate_jsslgame respondsToSelector:@selector(didUpdateJSSLGameGroupInfoModel:)]){
        [self.delegate_jsslgame didUpdateJSSLGameGroupInfoModel:model];
    }
    
    // 解决刷新开奖不及时的问题
    self.countdownView.model = model;
    if (model.status == 6) {//结算
        self.headRecordView.chatId = self.messageItem.groupId;
    }
    
    self.bagLotteryModel = model;
    ///判断是否可以投注
    self.isBett = [self judgeISBett:self.footerView.tf.text];
}
#pragma mark - 游戏基本信息
///赔率
- (void)getGameJSSLOdds{
    [NET_REQUEST_MANAGER requestWithAct:ActRequestJsslGameOdds parameters:@{@"chatId":self.messageItem.groupId} success:^(id object) {
        NSDictionary *dict = [object mj_JSONObject];
        if ([dict[@"code"] intValue] == 0) {
            self.oddsModel = [FYJSSLGameOddsModel mj_objectWithKeyValues:dict];
            self.footerView.singleMoneyTips = self.oddsModel.data.betList;

        }
    } failure:^(id object) {
        NSLog(@"%@",[object mj_JSONString]);
    }];
}

- (void)initSubView{
    self.view.backgroundColor = HexColor(@"#F8F8F8");
    [self.view addSubview:self.groupHearderView];
    [self.view addSubview:self.headRecordView];
    [self.view addSubview:self.countdownView];
    [self.view addSubview:self.footerView];
    [self.view addSubview:self.jsslBgView];
    [self.jsslBgView addSubview:self.collectionView];
    [self.jsslBgView addSubview:self.collectionHeadView];
    [self.view addSubview:self.machineSelecteView];
    [self.view addSubview:self.otherGamedataView];
    [self.view addSubview:self.lastBtn];
    [self.view addSubview:self.lastLab];
    self.groupHearderView.hidden = NO;
    [self.groupHearderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    [self.headRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(40));
        make.top.equalTo(self.groupHearderView.mas_bottom);
    }];
    [self.countdownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(CHAT_MESSAGE_FLOAT_BUTTON_HEIGHT);
        make.top.equalTo(self.headRecordView.mas_bottom);
    }];
    CGFloat HeightBar = [UIApplication sharedApplication].statusBarFrame.size.height == 20 ? 0 : 34;
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(120 + HeightBar));
    }];
    [self.jsslBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.countdownView.mas_bottom);
        make.bottom.equalTo(self.footerView.mas_top);
        make.width.mas_equalTo(kScreenWidth * 0.7);
    }];
    [self.collectionHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jsslBgView);
        make.centerX.equalTo(self.jsslBgView);
        make.width.equalTo(self.jsslBgView.mas_width).offset(-2);
        make.height.equalTo(@(30));
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.equalTo(self.jsslBgView);
        make.width.equalTo(self.collectionHeadView.mas_width);
        make.top.equalTo(self.collectionHeadView.mas_bottom);
    }];
    [self.machineSelecteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.jsslBgView.mas_left);
        make.bottom.equalTo(self.footerView.mas_top);
        make.left.equalTo(self.view);
        make.height.equalTo(@([FYJSSLMachineSelecteView headerViewHeight]));
    }];
    [self.otherGamedataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jsslBgView.mas_right);
        make.top.equalTo(self.countdownView.mas_bottom).offset(20);
        make.right.equalTo(self.view);
        make.height.equalTo(@([FYJSSLMachineSelecteView headerViewHeight]));
    }];
    [self.lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(35);
        make.bottom.equalTo(self.footerView.mas_top).offset(-30);
        make.centerX.equalTo(self.otherGamedataView);
    }];
    [self.lastLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.lastBtn);
        make.top.equalTo(self.lastBtn.mas_bottom).offset(4);
    }];
}
- (void)lastBetting:(UIButton*)sender{
    if (self.lastBettDataSource.count > 0){
        self.dataSource = self.lastBettDataSource;
        self.footerView.tf.text = self.lastMoney;
        self.footerView.moneyLab.text = self.lastMoney;
        self.footerView.odds = [FYJSSLGameBetOddsUtil getBetOddsValue:self.dataSource oddsTableData:self.oddsModel oddsP:self.jsslQunInfo.oddsP];
        [self.collectionView reloadData];
    }else{
        [SVProgressHUD showInfoWithStatus:@"还未开始投注!"];
    }
}
#pragma mark - JSSLMachineSelecteDelegate
- (void)gameJSSLMachineSelecteWithView:(FYJSSLMachineSelecteView *)selecteView row:(NSInteger)row{
    if (selecteView == self.machineSelecteView) {//机选
        switch (row) {
            case 0://3x1
                self.dataSource = [FYJSSLDataSource multiSelectWithData:self.dataSource num:3 rando:(arc4random() % 3)];
                break;
            case 1://1x3
                self.dataSource = [FYJSSLDataSource singleSelect:self.dataSource];
                break;
            case 2://5x1
                self.dataSource = [FYJSSLDataSource multiSelectWithData:self.dataSource num:5 rando:0];
                break;
            default:
                break;
        }
        [self.collectionView reloadData];
        self.isBett = [self judgeISBett:self.footerView.tf.text];
        self.footerView.odds = [FYJSSLGameBetOddsUtil getBetOddsValue:self.dataSource oddsTableData:self.oddsModel oddsP:self.jsslQunInfo.oddsP];
    }else{
        switch (row) {
            case 0: { //活动
                FYActivityMainViewController *VC = [[FYActivityMainViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
                break;
            }
            case 1: { //走势
                FYJSSLGameTrendViewController *VC = [[FYJSSLGameTrendViewController alloc] initWithMessageItem:self.messageItem];
                [self setDelegate_jsslgame:VC];
                [self.navigationController pushViewController:VC animated:YES];
                break;
            }
            case 2: { //记录
                FYJSSLGameRecordViewController *VC = [[FYJSSLGameRecordViewController alloc] initWithMessageItem:self.messageItem];
                [self.navigationController pushViewController:VC animated:YES];
                break;
            }
            default:
                break;
        }
    }
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
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FYJSSLGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FYJSSLGameCellID forIndexPath:indexPath];
    if (self.dataSource.count > indexPath.row) {
        cell.list = self.dataSource[indexPath.row];
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellW = (kScreenWidth * 0.7 - 2) / 5 - 1;
    return CGSizeMake(cellW, cellW-10);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FYJSSLDataSource *list = self.dataSource[indexPath.row];
    NSMutableArray *arr = [NSMutableArray array];
    [self.dataSource enumerateObjectsUsingBlock:^(FYJSSLDataSource *lists, NSUInteger idx, BOOL * _Nonnull stop) {
        if (list.digits == lists.digits && lists.isSelected) {
            [arr addObj:lists];
        }
    }];
    //限制每位上最大只能选择9个
    if (arr.count == 9) {
        list.isSelected = NO;
    }else{
        list.isSelected = !list.isSelected;
    }
    self.dataSource[indexPath.row].isSelected = list.isSelected;
    ///判断是否可以投注
    self.isBett = [self judgeISBett:self.footerView.tf.text];
    //防止刷新item闪屏
    [UIView animateWithDuration:0 animations:^{
        [collectionView performBatchUpdates:^{
            [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:indexPath.row inSection:0]]];
        } completion:nil];
    }];
   self.footerView.odds = [FYJSSLGameBetOddsUtil getBetOddsValue:self.dataSource oddsTableData:self.oddsModel oddsP:self.jsslQunInfo.oddsP];
}
///判断是否可以投注
- (BOOL)judgeISBett:(NSString *)money{
    NSMutableArray *bettArr = [NSMutableArray array];
    [self.dataSource enumerateObjectsUsingBlock:^(FYJSSLDataSource *lists, NSUInteger idx, BOOL * _Nonnull stop) {
        if (lists.isSelected) {
            [bettArr addObj:lists];
        }
    }];
    ///判断是否可以投注
    return money.length > 0 && bettArr.count > 2 && [self validateIsCanBetAction:self.bagLotteryModel];
}
- (void)setIsBett:(BOOL)isBett{
    _isBett = isBett;
    self.footerView.betBtn.enabled = isBett;
}

- (BOOL)validateIsCanBetAction:(RobNiuNiuQunModel *)qunModel
{
    // 1.连续上庄 2.抢庄 3.投注 4.发包 5.抢包 6.结算
    switch (qunModel.status) {
        case 1: // 连续上庄
            return NO;
            break;
        case 2: // 抢庄
            return NO;
            break;
        case 3: // 投注
            return YES;
            break;
        case 4: // 发包
            return NO;
            break;
        case 5: // 抢包
            return NO;
            break;
        case 6: // 结算
            return NO;
            break;
        default:
            return NO;
            break;
    }
}

#pragma mark - FYJSSLFooterDelegate
///删除
- (void)jsslBetDelete{
    self.footerView.betBtn.enabled = NO;
    self.footerView.odds = @"0.00";
    self.footerView.moneyLab.text = @"0";
    self.dataSource = [FYJSSLDataSource setJSSLDataSource];
    [self.collectionView reloadData];
}
/// 投注
- (void)jsslBetWithMoney:(NSString *)money{
    NSMutableArray <FYJSSLDataSource*>*bettArr = [NSMutableArray array];
    [self.dataSource enumerateObjectsUsingBlock:^(FYJSSLDataSource *list, NSUInteger idx, BOOL * _Nonnull stop) {
        if (list.isSelected) {
            [bettArr addObj:list];
        }
    }];
    self.footerView.moneyLab.text = money;
    MJWeakSelf
    [FYJSSLBettHUDView showJJSLBetHubWithList:bettArr money:money odds:self.footerView.odds block:^{
        [weakSelf jsslBettingWithMoney:money];
    }];
   
}
- (void)jsslBettingWithMoney:(NSString *)money{
    NSMutableArray *myriadBet = [NSMutableArray array];//万位
       NSMutableArray *thousandBet = [NSMutableArray array];//千位
       NSMutableArray *hundredBet = [NSMutableArray array];//百位
       NSMutableArray *tenBet = [NSMutableArray array];//十位
       NSMutableArray *individualBet = [NSMutableArray array];//个位
       [self.dataSource enumerateObjectsUsingBlock:^(FYJSSLDataSource *list, NSUInteger idx, BOOL * _Nonnull stop) {
           if (list.isSelected && list.digits == 0) {//万位
               [myriadBet addObj:@(list.num)];
           }else if (list.isSelected && list.digits == 1){
               [thousandBet addObj:@(list.num)];
           }else if (list.isSelected && list.digits == 2){
               [hundredBet addObj:@(list.num)];
           }else if (list.isSelected && list.digits == 3){
               [tenBet addObj:@(list.num)];
           }else if (list.isSelected && list.digits == 4){
               [individualBet addObj:@(list.num)];
           }
       }];
      NSDictionary *dict =  @{
          @"chatId": self.messageItem.groupId,
           @"hundredBet": hundredBet,//百位投注号码
           @"individualBet":individualBet,//个位投注号码
           @"money": money,
           @"myriadBet": myriadBet,//万位投注号码
           @"tenBet": tenBet,//十位投注号码
           @"thousandBet": thousandBet,//千位投注号码
           @"userId": [AppModel shareInstance].userInfo.userId
      };
       [NET_REQUEST_MANAGER requestWithAct:ActRequestJsslGameBett parameters:dict success:^(id object) {
           NSDictionary *dict = [object mj_JSONObject];
           if ([dict[@"code"] intValue] == 0) {
               self.lastBettDataSource = self.dataSource;
               self.lastMoney = money;
               [self jsslBetDelete];
               [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@",dict[@"msg"]]];
           }
       } failure:^(id object) {
           [[FunctionManager sharedInstance] handleFailResponse:object];
       }];
}
/// 选择money
- (void)jsslBetSeletWithMoney:(NSString *)money{
    self.footerView.moneyLab.text = money;
    self.isBett = [self judgeISBett:money];
}
#pragma mark - FYIMGroupChatHeaderViewDelegate
// 余额
- (void)groupHeaderView:(FYIMGroupChatHeaderView *)headerView didActionOfCheckBalance:(UILabel *)balanceLabel{
   [self checkShowBalanceView:NSLocalizedString(@"余额", nil)];
}

// 充值
- (void)groupHeaderView:(FYIMGroupChatHeaderView *)headerView didActionOfRecharge:(UIButton *)button{
    FYRechargeMainViewController *VC = [[FYRechargeMainViewController alloc] initWithIsPush:YES];
    [self.navigationController pushViewController:VC animated:YES];
}
// 玩法
- (void)groupHeaderView:(FYIMGroupChatHeaderView *)headerView didActionOfPlayRule:(UIButton *)button{
    NSString *url = [FYLanguageModel palyLanguageConfigType:self.messageItem.type];
    WebViewController *VC = [[WebViewController alloc] initWithUrl:url];
    [VC setTitle:NSLocalizedString(@"玩法规则", nil)];
    [self.navigationController pushViewController:VC animated:YES];
}
// 分享
- (void)groupHeaderView:(FYIMGroupChatHeaderView *)headerView didActionOfShare:(UIButton *)button{
    ShareDetailViewController *viewController = [[ShareDetailViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - 懒加载
- (FYIMGroupChatHeaderView *)groupHearderView
{
    if (!_groupHearderView) {
        _groupHearderView = [[FYIMGroupChatHeaderView alloc] initWithGroupTemplateType:self.messageItem.type];
        _groupHearderView.delegate = self;
    }
    return _groupHearderView;
}
- (FYGameJSSLHeadRecordView *)headRecordView{
    if (!_headRecordView) {
        _headRecordView = [[FYGameJSSLHeadRecordView alloc]init];
        _headRecordView.chatId = self.messageItem.groupId;
    }
    return _headRecordView;
}
- (FYBagLotteryBetCountdownView *)countdownView{
    if (!_countdownView) {
        _countdownView = [[FYBagLotteryBetCountdownView alloc] init];
    }
    return _countdownView;
}
- (FYJSSLFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[FYJSSLFooterView alloc]init];
        _footerView.delegate = self;
        _footerView.odds = @"0.00";
    }
    return _footerView;
}
- (FYGameJSSLCollectionHeadView *)collectionHeadView{
    if (!_collectionHeadView) {
        _collectionHeadView = [[FYGameJSSLCollectionHeadView alloc]init];
    }
    return _collectionHeadView;
}
- (UIView *)jsslBgView{
    if (!_jsslBgView) {
        _jsslBgView = [[UIView alloc]init];
        [_jsslBgView addShadowWithOffset:CGSizeZero opacity:0.3 andRadius:3];
    }
    return _jsslBgView;;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        [_collectionView registerClass:[FYJSSLGameCell class] forCellWithReuseIdentifier:FYJSSLGameCellID];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.minimumLineSpacing = 0.5;
        _layout.minimumInteritemSpacing = 0.5;
    }
    return _layout;
}
- (FYJSSLMachineSelecteView *)machineSelecteView{
    if (!_machineSelecteView) {
        _machineSelecteView = [[FYJSSLMachineSelecteView alloc]init];
        _machineSelecteView.delegate = self;
        _machineSelecteView.model = [FYJSSLSelecteModel setMachineSelecte];
    }
    return _machineSelecteView;
}
- (FYJSSLMachineSelecteView *)otherGamedataView{
    if (!_otherGamedataView) {
        _otherGamedataView = [[FYJSSLMachineSelecteView alloc]init];
        _otherGamedataView.delegate = self;
        _otherGamedataView.model = [FYJSSLSelecteModel setGamedataModel];
    }
    return _otherGamedataView;
}
- (UIButton *)lastBtn{
    if (!_lastBtn) {
        _lastBtn = [[UIButton alloc]init];
        [_lastBtn setBackgroundImage:[UIImage imageNamed:@"jssl_last_bett_icon"] forState:UIControlStateNormal];
        [_lastBtn addTarget:self action:@selector(lastBetting:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lastBtn;
}
- (UILabel *)lastLab{
    if (!_lastLab) {
        _lastLab = [[UILabel alloc]init];
        _lastLab.font = FONT_PINGFANG_REGULAR(12);
        _lastLab.textColor = HexColor(@"#1A1A1A");
        _lastLab.text = NSLocalizedString(@"上次投注", nil);
    }
    return _lastLab;
}
@end
