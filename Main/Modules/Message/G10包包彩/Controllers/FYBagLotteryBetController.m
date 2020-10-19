//
//  FYBagLotteryBetController.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/17.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagLotteryBetController.h"
#import "FYBagLotteryTableViewCell.h"
#import "FYBagLotteryBetCollectionViewCell.h"
#import "FYBagLotteryHeaderView.h"
#import "FYBagLotteryBetModel.h"
#import "FYBagLotteryLayout.h"
#import "GroupInfoViewController.h"
#import "FYBalanceInfoModel.h"
#import "FYBalanceInfoView.h"
#import "FYBagLotteryBetHeaderView.h"
#import "FYBagLotteryBetFooterView.h"
#import "FYBegLotteryHistoryModel.h"
#import "FYBagLotteryBetHudView.h"
#import "FYBagLotteryBetCountdownView.h"
#import "FYPokerWinsLossesHeadView.h"
#import "FYPermutationTool.h"
#import "FYBestWinsLossesModel.h"
static NSString *const FYBagLotteryTableViewCellID = @"FYBagLotteryTableViewCellID";

static NSString *const FYBagLotteryBetCollectionViewCellID = @"FYBagLotteryBetCollectionViewCellID";

static NSString *const FYBagLotteryHeaderViewID = @"FYBagLotteryHeaderViewID";

CGFloat tableViewW = 100;

#define collW (SCREEN_WIDTH - tableViewW - 8)
@interface FYBagLotteryBetController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FYBagLotteryBetHeaderDelegate,FYBagLotteryBetFooterDelegate>
@property (nonatomic , strong) FYBagLotteryBetHeaderView *headerView;
@property (nonatomic , strong) FYBagLotteryBetFooterView *footerView;
@property (nonatomic , strong) UITableView *tableView ;
///包包彩 - 百人牛牛
@property (nonatomic , strong) NSArray <FYBagLotteryBetListData*>*datasArr;
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) FYBagLotteryLayout *layout;
@property (nonatomic , assign) NSInteger selectedInx;
//导航栏
@property (nonatomic , strong) UIView *rightItem;
@property (nonatomic , strong) UIButton *navGroupInfo;
@property (nonatomic , strong) UIButton *navCustomer;

/// 期数
@property (nonatomic , strong) FYNperHaederView *nperView;
///扑克输赢对比
@property (nonatomic , strong) FYPokerWinsLossesHeadView *winsLossesHeadView;
///倒计时
@property (nonatomic , strong) FYBagLotteryBetCountdownView *countdownView;
@end

@implementation FYBagLotteryBetController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
    [self setRightNavItem];
    [self updateBalance];
    if (self.messageItem.type == GroupTemplate_N10_BagLottery){
        [self getBagLotteryGameOdds];
        [self getBegLotteryInfo];
    }else if (self.messageItem.type == GroupTemplate_N14_BestNiuNiu){
        [self getBestNiuNIuGameOdds];
        [self getBestNiuNiuInfo];
    }
    [NOTIF_CENTER addObserver:self selector:@selector(didNotificationGroupStatusMessage:)name:kNotificationGroupStatusMessage object:nil];
}

- (void)initSubView{
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.countdownView];
    [self.view addSubview:self.footerView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];
    CGFloat HeightBar = [UIApplication sharedApplication].statusBarFrame.size.height == 20 ? 0 : 34;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    if (self.messageItem.type == GroupTemplate_N10_BagLottery){
        self.title = NSLocalizedString(@"包包彩", nil);
        [self.view addSubview:self.nperView];
        [self.nperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(40);
            make.top.equalTo(self.headerView.mas_bottom);
        }];
        [self.countdownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(CHAT_MESSAGE_FLOAT_BUTTON_HEIGHT);
            make.top.equalTo(self.nperView.mas_bottom);
        }];
        
    } else if (self.messageItem.type == GroupTemplate_N14_BestNiuNiu){
        self.title = NSLocalizedString(@"百人牛牛", nil);
        [self.view addSubview:self.winsLossesHeadView];
        [self.winsLossesHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(pokerWinsLossesHeadViewHigh);
            make.top.equalTo(self.headerView.mas_bottom);
        }];
        [self.countdownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(CHAT_MESSAGE_FLOAT_BUTTON_HEIGHT);
            make.top.equalTo(self.winsLossesHeadView.mas_bottom);
        }];
    }
    
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.bottom.right.equalTo(self.view);
          make.height.mas_equalTo(120 + HeightBar);
      }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.countdownView.mas_bottom);
        make.bottom.equalTo(self.footerView.mas_top);
        make.width.mas_equalTo(tableViewW);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-4);
        make.top.equalTo(self.countdownView.mas_bottom);
        make.bottom.equalTo(self.footerView.mas_top);
        make.left.equalTo(self.tableView.mas_right).offset(4);
    }];
   
}
///获取游戏赔率
- (void)getBagLotteryGameOdds{
    self.selectedInx = 0;
    NSDictionary *dict = @{
        @"gameNumber": @(self.bagLotteryModel.gameNumber),
        @"groupId": self.groupId,
        @"userId": [AppModel shareInstance].userInfo.userId
        };

    [NET_REQUEST_MANAGER getBegLotteryGameOddsDict:dict success:^(id object) {
        [[NSUserDefaults standardUserDefaults] setObject:object forKey:@"FYBagLotteryBetOdds"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSDictionary *dict = [object mj_JSONObject];
        if ([dict[@"code"] integerValue] == 0) {
            FYBagLotteryBetModel *betModel = [FYBagLotteryBetModel mj_objectWithKeyValues:dict];
            self.footerView.singleMoneyTips = betModel.data.singleMoneyTips;
            FYBagLotteryBetListData *weiConfig = [[FYBagLotteryBetListData alloc]init];
            weiConfig.title = NSLocalizedString(@"尾数", nil);
            weiConfig.config = [self getCombiningDatas:betModel.data.weishuConfig];

            FYBagLotteryBetListData *lmConfig = [[FYBagLotteryBetListData alloc]init];
            lmConfig.title = NSLocalizedString(@"两面", nil);
            lmConfig.config = [self getCombiningDatas:betModel.data.liangmianConfig];
    
            FYBagLotteryBetListData *qhConfig = [[FYBagLotteryBetListData alloc]init];
            qhConfig.title = NSLocalizedString(@"前后组合", nil);
            qhConfig.config = [self getCombiningDatas:betModel.data.qianhouConfig];
            
            FYBagLotteryBetListData *qsConfig = [[FYBagLotteryBetListData alloc]init];
            qsConfig.title = NSLocalizedString(@"前三特码", nil);
            qsConfig.config = [self getCombiningDatas:betModel.data.qiansanConfig];

            FYBagLotteryBetListData *hsConfig = [[FYBagLotteryBetListData alloc]init];
            hsConfig.title = NSLocalizedString(@"后三特码", nil);
            hsConfig.config = [self getCombiningDatas:betModel.data.housanConfig];

            FYBagLotteryBetListData *tConfig = [[FYBagLotteryBetListData alloc]init];
            tConfig.title = NSLocalizedString(@"特殊", nil);
            tConfig.config = [self getCombiningDatas:betModel.data.teshuConfig];

            self.datasArr = @[weiConfig,lmConfig,qhConfig,qsConfig,hsConfig,tConfig];
            [self.tableView reloadData];
            [self.collectionView reloadData];
            //默认选中第一个
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}
///字典转模型
- (NSArray<FYBagLotteryBetConfig*>*)getCombiningDatas:(NSArray*)configs{
   NSArray<FYBagLotteryBetConfig*> *configArr = [FYBagLotteryBetConfig mj_objectArrayWithKeyValuesArray:configs];
    [configArr enumerateObjectsUsingBlock:^(FYBagLotteryBetConfig * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         configArr[idx].data = [self filterNameWithConfig:obj];
    }];
    return configArr;
}
///过滤name,bet,num字段没值的情况
- (NSArray <FYBagLotteryBetList*>*)filterNameWithConfig:(FYBagLotteryBetConfig*)config{
    NSArray <FYBagLotteryBetList*>*listArr = [FYBagLotteryBetList mj_objectArrayWithKeyValuesArray:config.data];
    NSMutableArray <FYBagLotteryBetList*>*dataArr = [NSMutableArray array];
    [listArr enumerateObjectsUsingBlock:^(FYBagLotteryBetList * _Nonnull list, NSUInteger idx, BOOL * _Nonnull stop) {
        if (list.name.length > 0 && list.bet.length > 0 && list.num.length > 0) {
            [dataArr addObj:list];
        }
    }];
    return dataArr;
}
- (void)dealloc{
    NSLog(NSLocalizedString(@"%@销毁了", nil),self);
}
- (void)didNotificationGroupStatusMessage:(NSNotification *)notification{
    NSDictionary *dict = notification.object;
   [self performSelectorOnMainThread:@selector(bagLotteryQunContent:) withObject:dict waitUntilDone:YES];
    
}

#pragma mark - 群状态
- (void)didUpdateWithGroupQunModel:(RobNiuNiuQunModel *)model
{
    self.countdownView.model = model;
    if (self.messageItem.type == GroupTemplate_N10_BagLottery) {
        if (self.bagLotteryModel.gameNumber != model.gameNumber) {
            self.nperView.dict = @{ // 包包彩数据
                @"gameNumber":@(model.gameNumber),
                @"groupId": self.messageItem.groupId,
                @"userId": [AppModel shareInstance].userInfo.userId
            };
        }
    } else if (self.messageItem.type == GroupTemplate_N14_BestNiuNiu) {
        if (self.bagLotteryModel.gameNumber != model.gameNumber) {
            self.winsLossesHeadView.dict = @{
                @"gameNumber":@(model.gameNumber),
                @"groupId":self.messageItem.groupId,
                @"userId":[AppModel shareInstance].userInfo.userId
            };
        }
    }
    
    self.bagLotteryModel = model;
    [self bagLotteryBetSeletWithMoney:self.footerView.tf.text]; // 投注按钮是可用
    
    if (model.gameNumber > self.bagLotteryModel.gameNumber) { //期数不一样,再获取一次赔率
//        self.bagLotteryModel.gameNumber = model.gameNumber;
//        [self getBagLotteryGameOdds];
    }
}


#pragma mark - 包包彩群状态
- (void)getBegLotteryInfo{
    NSDictionary *dict =@{
        @"groupId":self.messageItem.groupId,
        @"userId":[AppModel shareInstance].userInfo.userId
    };
    [NET_REQUEST_MANAGER getBegLotteryInfoDict:dict success:^(id object) {
        RobNiuNiuQunModel *model = [RobNiuNiuQunModel mj_objectWithKeyValues:dict[@"data"]];
        self.nperView.dict = @{//包包彩数据
            @"gameNumber":@(model.gameNumber),
            @"groupId": self.messageItem.groupId,
            @"userId": [AppModel shareInstance].userInfo.userId
        };
        [self performSelectorOnMainThread:@selector(bagLotteryQunContent:) withObject:object waitUntilDone:YES];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
   
}

//包包彩更新群状态
- (void)bagLotteryQunContent:(NSDictionary *)dict
{
    RobNiuNiuQunModel *model = [RobNiuNiuQunModel mj_objectWithKeyValues:dict[@"data"]];
    [self didUpdateWithGroupQunModel:model];
}

#pragma mark - 百人牛牛群状态
-(void)getBestNiuNiuInfo{
    [NET_REQUEST_MANAGER requestWithAct:ActRequestBestNiuNiuInfo parameters:@{@"groupId": self.messageItem.groupId} success:^(id object) {
        NSDictionary *dict = [object mj_JSONObject];
        if ([dict[@"code"] integerValue] == 0) {
            [self performSelectorOnMainThread:@selector(bagLotteryQunContent:) withObject:object waitUntilDone:YES];
            RobNiuNiuQunModel *model = [RobNiuNiuQunModel mj_objectWithKeyValues:dict[@"data"]];
            FYBestWinsLossesFlopResult *result = [FYBestWinsLossesFlopResult mj_objectWithKeyValues:dict[@"data"][@"resultDTO"]];
            self.winsLossesHeadView.result = result;
            //resultDTO
            self.winsLossesHeadView.dict = @{
                      @"gameNumber":@(model.gameNumber),
                      @"groupId":self.messageItem.groupId,
                      @"userId":[AppModel shareInstance].userInfo.userId
                  };
        }
    } failure:^(id object) {
        [[FunctionManager sharedInstance]handleFailResponse:object];
    }];
    [self updateBalance];
}

///百人牛牛赔率
- (void)getBestNiuNIuGameOdds{
    self.selectedInx = 0;
    [NET_REQUEST_MANAGER requestWithAct:ActRequestBestNiuNiuGameOdds parameters:@{@"groupId":self.messageItem.groupId} success:^(id object) {
        [[NSUserDefaults standardUserDefaults] setObject:object forKey:@"FYBestNiuNIuBetOdds"];
        [[NSUserDefaults standardUserDefaults] synchronize];
            NSDictionary *dict = [object mj_JSONObject];
           if ([dict[@"code"] integerValue] == 0) {
               FYBagLotteryBetModel *model = [FYBagLotteryBetModel mj_objectWithKeyValues:dict];
               self.footerView.singleMoneyTips = model.data.singleMoneyTips;
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
               self.datasArr = @[wConfig,tConfig,cConfig,pConfig];
               [self.tableView reloadData];
               [self.collectionView reloadData];
               //默认选中第一个
               NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
               [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
           }
       } failure:^(id object) {
           [[FunctionManager sharedInstance] handleFailResponse:object];
       }];
}

#pragma mark - 懒加载
- (FYNperHaederView *)nperView{
    if (!_nperView) {
        _nperView = [[FYNperHaederView alloc]init];
    }
    return _nperView;
}
- (FYPokerWinsLossesHeadView *)winsLossesHeadView{
    if (!_winsLossesHeadView) {
        _winsLossesHeadView = [[FYPokerWinsLossesHeadView alloc]init];
    }
    return _winsLossesHeadView;
}
- (FYBagLotteryBetCountdownView *)countdownView{
    if (!_countdownView) {
        _countdownView = [[FYBagLotteryBetCountdownView alloc] init];
    }
    return _countdownView;
}
- (FYBagLotteryBetHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[FYBagLotteryBetHeaderView alloc]init];
        _headerView.delegate = self;
    }
    return _headerView;
}
- (FYBagLotteryBetFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[FYBagLotteryBetFooterView alloc]init];
        _footerView.delegate = self;
    }
    return _footerView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = HexColor(@"#E6E6E6");
        [_tableView registerClass:[FYBagLotteryTableViewCell class] forCellReuseIdentifier:FYBagLotteryTableViewCellID];
        _tableView.backgroundColor = HexColor(@"#F8F8F8");
    }
    return _tableView;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.backgroundColor = HexColor(@"#F8F8F8");
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[FYBagLotteryBetCollectionViewCell class] forCellWithReuseIdentifier:FYBagLotteryBetCollectionViewCellID];
        [_collectionView registerClass:[FYBagLotteryHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FYBagLotteryHeaderViewID];
    }
    return _collectionView;
}
- (FYBagLotteryLayout *)layout{
    if (!_layout) {
        _layout = [[FYBagLotteryLayout alloc]init];
    }
    return _layout;
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

#pragma mark - FYBagLotteryBetHeaderDelegate
///查看余额
- (void)didActionOfCheckBalance{
    [self checkShowBalanceView:NSLocalizedString(@"余额", nil)];
}
///充值
- (void)didActionOfRecharge{
    FYRechargeMainViewController *VC = [[FYRechargeMainViewController alloc] initWithIsPush:YES];
    [self.navigationController pushViewController:VC animated:YES];
}
///玩法
- (void)didActionOfPlayRule{
    NSString *url = [FYLanguageModel palyLanguageConfigType:self.messageItem.type];
    WebViewController *VC = [[WebViewController alloc] initWithUrl:url];
    [VC setTitle:NSLocalizedString(@"玩法规则", nil)];
    [self.navigationController pushViewController:VC animated:YES];
}
///分享
- (void)didActionOfShare{
    ShareDetailViewController *viewController = [[ShareDetailViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

/// 更新余额
- (void)updateBalance{
    [NET_REQUEST_MANAGER getRobFinanceSuccess:^(id object) {
        if (![object isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        if (([object[@"code"] integerValue] == 0)) {
            FYBalanceInfoModel *model = [FYBalanceInfoModel mj_objectWithKeyValues:object[@"data"]];
            self.headerView.balance = [NSString stringWithFormat:@"%.2lf",model.balance];
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

///删除选中
- (void)deleteSelected{
    [self.datasArr enumerateObjectsUsingBlock:^(FYBagLotteryBetListData *listData, NSUInteger allIdx, BOOL * _Nonnull stop) {
        [listData.config enumerateObjectsUsingBlock:^(FYBagLotteryBetConfig *config, NSUInteger section, BOOL * _Nonnull stop) {
            [config.data enumerateObjectsUsingBlock:^(FYBagLotteryBetList *list, NSUInteger row, BOOL * _Nonnull stop) {
                self.datasArr[allIdx].config[section].data[row].selected = NO;
            }];
        }];
    }];
    [self.collectionView reloadData];
    self.footerView.moneyLab.text = @"0";
    self.footerView.betBtn.enabled = NO;
}
#pragma mark - FYBagLotteryBetFooterDelegate
///删除
- (void)bagLotteryBetDelete{
    [self deleteSelected];
    
}
///消失
- (void)bagLotteryBetDismiss{
    if (self.block != nil) {
        self.block();
    }
    [self performSelector:@selector(popViewController) withObject:nil afterDelay:0.25];
}
- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
///计算总投注金额
- (void)bagLotteryBetSeletWithMoney:(NSString *)money{
    if (self.messageItem.type == GroupTemplate_N10_BagLottery) {
        NSMutableArray *tmpArr = [NSMutableArray array];
        NSMutableArray *yiLists = [NSMutableArray array];
        NSMutableArray *erLists = [NSMutableArray array];
        NSMutableArray *sanLists = [NSMutableArray array];
        NSMutableArray *siLists = [NSMutableArray array];
        NSMutableArray *wuLists = [NSMutableArray array];
        NSMutableArray *sanWeiDuiZiLists = [NSMutableArray array];
        __block NSInteger yiWeiBet = 0;
        __block NSInteger erWeiBet = 0;
        __block NSInteger sanWeiBet = 0;
        __block NSInteger siWeiBet = 0;
        __block NSInteger wuWeiBet = 0;
        __block NSInteger sanWeiDuiZiBet = 0;
        __block BOOL isEnabled = YES;
        __block BOOL isCanBet = [self validateIsCanBetAction:self.bagLotteryModel];
        [self.datasArr enumerateObjectsUsingBlock:^(FYBagLotteryBetListData *listData, NSUInteger allIdx, BOOL * _Nonnull stop) {
            [listData.config enumerateObjectsUsingBlock:^(FYBagLotteryBetConfig *config, NSUInteger section, BOOL * _Nonnull stop) {
                [config.data enumerateObjectsUsingBlock:^(FYBagLotteryBetList *list, NSUInteger row, BOOL * _Nonnull stop) {
                    if (list.selected) {
                        if (allIdx == 0 && section == 0) {
                            [yiLists addObj:list];
                            yiWeiBet= [FYPermutationTool pickNum:section+1 totalNum:yiLists.count];
                            
                        }else if (allIdx == 0 && section == 1){
                            [erLists addObj:list];
                            erWeiBet = [FYPermutationTool pickNum:section+1 totalNum:erLists.count];
                            
                        }else if (allIdx == 0 && section == 2){
                            [sanLists addObj:list];
                            sanWeiBet = [FYPermutationTool pickNum:section+1 totalNum:sanLists.count];
                            
                        }else if (allIdx == 0 && section == 3){
                            [siLists addObj:list];
                            siWeiBet = [FYPermutationTool pickNum:section+1 totalNum:siLists.count];
                            
                        }else if (allIdx == 0 && section == 4){
                            [wuLists addObj:list];
                            wuWeiBet = [FYPermutationTool pickNum:section+1 totalNum:wuLists.count];
                            
                        }else if (allIdx == 5 && section == 3){
                            [sanWeiDuiZiLists addObj:list];
                            sanWeiDuiZiBet = sanWeiDuiZiLists.count * (sanWeiDuiZiLists.count - 1);
                        } else {
                            [tmpArr addObj:list];
                        }
                    }
                }];
            }];
        }];
        isEnabled = (yiWeiBet + erWeiBet + sanWeiBet + siWeiBet + wuWeiBet + sanWeiDuiZiBet + tmpArr.count) > 0 ? YES : NO;
        self.footerView.moneyLab.text = [NSString stringWithFormat:@"%zd",[money integerValue] * (tmpArr.count + yiWeiBet + erWeiBet + sanWeiBet + siWeiBet + wuWeiBet + sanWeiDuiZiBet) ];
        if (isCanBet && isEnabled && money.length > 0) {
            self.footerView.betBtn.enabled = YES;
        }else{
            self.footerView.betBtn.enabled = NO;
        }
    }else{
         NSMutableArray *tmpArr = [NSMutableArray array];
        [self.datasArr enumerateObjectsUsingBlock:^(FYBagLotteryBetListData *listData, NSUInteger allIdx, BOOL * _Nonnull stop) {
            [listData.config enumerateObjectsUsingBlock:^(FYBagLotteryBetConfig *config, NSUInteger section, BOOL * _Nonnull stop) {
                [config.data enumerateObjectsUsingBlock:^(FYBagLotteryBetList *list, NSUInteger row, BOOL * _Nonnull stop) {
                    if (list.selected) {
                        [tmpArr addObj:list];
                    }
                }];
            }];
        }];
        BOOL isCanBet = [self validateIsCanBetAction:self.bagLotteryModel];
        self.footerView.moneyLab.text = [NSString stringWithFormat:@"%zd",[money integerValue] * (tmpArr.count)];
        if (isCanBet && tmpArr.count > 0 && money.length > 0) {
            self.footerView.betBtn.enabled = YES;
        }else{
            self.footerView.betBtn.enabled = NO;
        }
    }
}
/// 投注
- (void)bagLotteryBetWithMoney:(NSString *)money{
    if (money.length == 0) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"请输入单注金额!", nil)];
        return;
    }
    if (self.messageItem.type == GroupTemplate_N10_BagLottery) {
        MJWeakSelf
        [self combinedBagLotteryBettingDataWithBlock:^(NSArray *bettOneLevel, NSArray *hudArr) {
            if (bettOneLevel.count == 0 || hudArr.count == 0) {
                return;
            }
           [FYBagLotteryBetHudView showBetHubWithList:hudArr singleMoney:money determineBtnText:NSLocalizedString(@"跟单", nil) title:NSLocalizedString(@"投注确认", nil) block:^{
                NSDictionary *dict = @{
                    @"chatId": weakSelf.groupId,
                    @"singleMoney": money,
                    @"totalMoney": weakSelf.footerView.moneyLab.text,
                    @"userId": [AppModel shareInstance].userInfo.userId,
                    @"bettOneLevel":bettOneLevel
                };
                [NET_REQUEST_MANAGER getBegLotteryBettDict:dict success:^(id object) {
                    if ([object[@"code"] integerValue] == 0) {
                        [weakSelf bagLotteryBetDismiss];
                    }
                } fail:^(id object) {
                    if([object isKindOfClass:[NSError class]]){
                        [[FunctionManager sharedInstance]handleFailResponse:object];
                    }else{
                        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",object[@"msg"]]];
                    }
                }];
                [weakSelf deleteSelected];
            }];
        }];
    }else{
        MJWeakSelf
        [self combinedBestNiuNiuBettingDataWithBlock:^(NSArray *bettOneLevel, NSArray *hudArr) {
            if (bettOneLevel.count == 0 || hudArr.count == 0) {
                return;
            }
            [FYBagLotteryBetHudView showBetHubWithList:hudArr singleMoney:money determineBtnText:NSLocalizedString(@"跟单", nil) title:NSLocalizedString(@"投注确认", nil) block:^{
                NSDictionary *dict = @{
                    @"chatId":weakSelf.groupId,
                    @"bettOneLevel":bettOneLevel,
                    @"userId":[AppModel shareInstance].userInfo.userId,
                    @"singleMoney": money,//单注金额
                    @"totalMoney": weakSelf.footerView.moneyLab.text//投注总额
                };
                [NET_REQUEST_MANAGER requestWithAct:ActRequestBestNiuNiuBett parameters:dict success:^(id object) {
                    if ([object[@"code"] integerValue] == 0) {
                        [weakSelf bagLotteryBetDismiss];
                    }
                } failure:^(id object) {
                    [[FunctionManager sharedInstance]handleFailResponse:object];
                }];
                [weakSelf deleteSelected];
            }];
        }];
    }
}
///组合百人牛牛投注数据
- (void)combinedBestNiuNiuBettingDataWithBlock:(void (^)(NSArray *bettOneLevel,NSArray *hudArr))block{
    //百人牛牛一级类型
    NSMutableArray *bettOneLevel = [NSMutableArray array];
    //弹窗数据
    NSMutableArray *hudArr = [NSMutableArray array];
    [self.datasArr enumerateObjectsUsingBlock:^(FYBagLotteryBetListData *listData, NSUInteger allIdx, BOOL * _Nonnull stop) {
        NSMutableArray *bettTwoLevel = [NSMutableArray array];
        __block NSString *oneLevelType = [[NSString alloc]init];
        [listData.config enumerateObjectsUsingBlock:^(FYBagLotteryBetConfig *config, NSUInteger section, BOOL * _Nonnull stop) {
            __block NSString *twoLevelType = [[NSString alloc]init];
            [config.data enumerateObjectsUsingBlock:^(FYBagLotteryBetList *list, NSUInteger row, BOOL * _Nonnull stop) {
                if (list.selected) {
                    twoLevelType = [NSString stringWithFormat:@"%zd",config.type];
                    oneLevelType = [NSString stringWithFormat:@"%zd",allIdx+1];
                    [bettTwoLevel addObj:@{@"bettName":list.name,@"bettOddsNums":list.bet,@"pokerNum":@(config.type),@"twoLevelType":list.num}];
                    [hudArr addObj:@{@"name":list.name,@"bet":list.bet,@"config":config.title}];
                }
            }];
        }];
        if (bettTwoLevel.count > 0) {
            [bettOneLevel addObj:@{@"oneLevelType":oneLevelType,@"bettTwoLevel":bettTwoLevel}];
        }
    }];
    if (bettOneLevel.count > 0) {
        block(bettOneLevel,hudArr);
    }
}
/// 组合包包彩投注数据
/// @param block 数据组合好的回调
- (void)combinedBagLotteryBettingDataWithBlock:(void (^)(NSArray *bettOneLevel,NSArray *hudArr))block{
    //包包彩一级类型 1:尾数 2:两面 3:前后组合 4:前三特码 5:后三特码 6:特殊
       NSMutableArray *bettOneLevel = [NSMutableArray array];
       //弹窗数据
       NSMutableArray *hudArr = [NSMutableArray array];
        __block BOOL isNumPermutation = YES;
       [self.datasArr enumerateObjectsUsingBlock:^(FYBagLotteryBetListData *listData, NSUInteger allIdx, BOOL * _Nonnull stop) {
           NSMutableArray *bettTwoLevel = [NSMutableArray array];
           __block NSString *oneLevelType = [[NSString alloc]init];
           [listData.config enumerateObjectsUsingBlock:^(FYBagLotteryBetConfig *config, NSUInteger section, BOOL * _Nonnull stop) {
               __block NSString *twoLevelType = [[NSString alloc]init];
               NSMutableArray *nums = [NSMutableArray array];
               NSMutableArray *betts = [NSMutableArray array];
               [config.data enumerateObjectsUsingBlock:^(FYBagLotteryBetList *list, NSUInteger row, BOOL * _Nonnull stop) {
                   if (list.selected) {
                       twoLevelType = [NSString stringWithFormat:@"%zd",config.type];
                       [nums addObj:list.num];
                       [betts addObj:list.bet];
                       if (allIdx != 0) {
                           if (allIdx == 5 && section == 3) {
                                oneLevelType = @"6";
                               return;
                           }
                           [hudArr addObj:@{@"name":list.name,@"bet":list.bet,@"config":config.title}];
                       }
                       if ([listData.title isEqualToString:NSLocalizedString(@"尾数", nil)]) {
                           oneLevelType = @"1";
                       }else if ([listData.title isEqualToString:NSLocalizedString(@"两面", nil)]){
                           oneLevelType = @"2";
                       }else if ([listData.title isEqualToString:NSLocalizedString(@"前后组合", nil)]){
                           oneLevelType = @"3";
                       }else if ([listData.title isEqualToString:NSLocalizedString(@"前三特码", nil)]){
                           oneLevelType = @"4";
                       }else if ([listData.title isEqualToString:NSLocalizedString(@"后三特码", nil)]){
                           oneLevelType = @"5";
                       }else if ([listData.title isEqualToString:NSLocalizedString(@"特殊", nil)]){
                           oneLevelType = @"6";
                       }
                   }
               }];
               if (nums.count > 0) {
                   NSMutableDictionary *bettOddsNums = [NSMutableDictionary dictionary];
                   if (allIdx == 0) {
                       NSArray *numPermutation = [FYPermutationTool pickPermutationWhitData:nums pickNum:section+1];
                       if (numPermutation.count == 0) {
                           [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:NSLocalizedString(@"%@,最少选择%zd个数字", nil),config.title,section+1]];
                           isNumPermutation = NO;
                           return;
                       }else {
                           [numPermutation enumerateObjectsUsingBlock:^(NSString *bett, NSUInteger idx, BOOL * _Nonnull stop) {
                               [hudArr addObj:@{@"name":bett,@"bet":config.data[section].bet,@"config":config.title}];
                           }];
                       }
                   }else if (allIdx == 5 && section == 3){//特殊,三尾对子
                       if (nums.count < 2) {
                           [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:NSLocalizedString(@"%@,最少选择2个数字", nil),config.title]];
                           isNumPermutation = NO;
                           return;
                       }
                       NSArray <NSString *>*numPermutation = [FYPermutationTool pickPermutationWhitData:nums pickNum:2];
                       [numPermutation enumerateObjectsUsingBlock:^(NSString *num, NSUInteger idx, BOOL * _Nonnull stop) {
                           [nums enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                               if ([num containsString:obj]) {
                                   NSString *name = [NSString stringWithFormat:@"%@,%@",num,obj];
                                   [hudArr addObj:@{@"name":name,@"bet":config.data[section].bet,@"config":config.title}];
                               }
                           }];
                       }];
                   }
                   [nums enumerateObjectsUsingBlock:^(NSString *bett, NSUInteger idx, BOOL * _Nonnull stop) {//组合投注和赔率
                       [bettOddsNums setObject:betts[idx] forKey:bett];
                   }];
                   [bettTwoLevel addObj:@{@"twoLevelType":twoLevelType,@"bettNums":nums,@"bettOddsNums":bettOddsNums}];
                   
               }
           }];
           if (bettTwoLevel.count > 0) {
               [bettOneLevel addObj:@{@"oneLevelType":oneLevelType,@"bettTwoLevel":bettTwoLevel}];
           }
       }];
    if (bettOneLevel.count > 0 && isNumPermutation) {
        block(bettOneLevel,hudArr);
    }
}


#pragma mark - FYIMSessionViewControllerLotteryGameGroupInfoDelegate

- (void)didUpdateLotteryGameGroupInfoModel:(RobNiuNiuQunModel *)groupInfoModel
{
    self.bagLotteryModel = groupInfoModel;
    
}


#pragma mark - 右边导航栏点击事件
/// 群信息（群聊）
- (void)pressNavActionGroupDetailInfo{
    [self.view endEditing:YES];
    GroupInfoViewController *vc = [GroupInfoViewController groupVc:self.messageItem];

    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
/// 在线客服（群聊）
- (void)pressNavActionCustomerService:(id)sender{
    [self.view endEditing:YES];
    NSString *urlString = [AppModel shareInstance].commonInfo[@"pop"];
    FYWebViewController *viewController = [[FYWebViewController alloc] initWithUrl:urlString];
    [viewController setTitle:NSLocalizedString(@"在线客服", nil)];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - 右边导航栏
- (void)setRightNavItem{
    UIBarButtonItem *infoItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightItem];
    self.navigationItem.rightBarButtonItem = infoItem;
}
- (UIView *)rightItem
{
    if (!_rightItem) {
        _rightItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, NAVIGATION_BAR_HEIGHT)];
        [_rightItem addSubview:self.navCustomer];
        [_rightItem addSubview:self.navGroupInfo];
    }
    return _rightItem;
}

- (UIButton *)navGroupInfo
{
    if (!_navGroupInfo) {
        _navGroupInfo =  [[UIButton alloc] initWithFrame:CGRectMake(40, (NAVIGATION_BAR_HEIGHT-25)*0.5f, 25, 25)];
        [_navGroupInfo setImage:[[UIImage imageNamed:@"group-info"] imageByScalingProportionallyToSize:CGSizeMake(22, 22)]
        forState:UIControlStateNormal];
        [_navGroupInfo addTarget:self action:@selector(pressNavActionGroupDetailInfo) forControlEvents:UIControlEventTouchUpInside];
        [_navGroupInfo setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }
    return _navGroupInfo;
}

- (UIButton *)navCustomer
{
    if (!_navCustomer) {
        _navCustomer = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, NAVIGATION_BAR_HEIGHT)];
        [_navCustomer setImage:[[UIImage imageNamed:ICON_NAV_BAR_BUTTON_CUSTOMER_SERVICE] imageByScalingProportionallyToSize:CGSizeMake(22, 22)]
        forState:UIControlStateNormal];
        [_navCustomer setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_navCustomer addTarget:self action:@selector(pressNavActionCustomerService:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navCustomer;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
/**cell样式*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FYBagLotteryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FYBagLotteryTableViewCellID];
    if (self.datasArr.count > indexPath.row) {
        cell.list = self.datasArr[indexPath.row];
    }
    return cell;
}
/**cell个数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasArr.count;
}
/**cell高*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
/**cell点击*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionView reloadData];
    self.selectedInx = indexPath.row;
}
#pragma mark - UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FYBagLotteryBetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FYBagLotteryBetCollectionViewCellID forIndexPath:indexPath];
    FYBagLotteryBetConfig *config = self.datasArr[self.selectedInx].config[indexPath.section];
    if (config.data.count > indexPath.row) {
        cell.list = config.data[indexPath.row];
    }
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.datasArr.count == 0 ? 0 : self.datasArr[self.selectedInx].config.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    FYBagLotteryBetConfig *config = self.datasArr[self.selectedInx].config[section];
    return config.data.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FYBagLotteryBetConfig *config = self.datasArr[self.selectedInx].config[indexPath.section];
    FYBagLotteryBetList *list = config.data[indexPath.row];
    list.selected = !list.selected;
    
    ///重新给模型赋值
    self.datasArr[self.selectedInx].config[indexPath.section].data[indexPath.row].selected = list.selected;
    //刷新单个cell
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects: selectedIndexPath, nil]];
    [self bagLotteryBetSeletWithMoney:self.footerView.tf.text];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    FYBagLotteryBetConfig *config = self.datasArr[self.selectedInx].config[indexPath.section];
    if (self.messageItem.type == GroupTemplate_N10_BagLottery) {
        if (config.data.count > 8) {
            return CGSizeMake(collW / 5 - 5 , 40);
        }else if (config.data.count == 4 || config.data.count == 8){
            return CGSizeMake(collW / 2 - 10 , 40);
        }
        return CGSizeMake(collW - 10, 40);
    }else{
        if (config.data.count % 2 == 0){
            return CGSizeMake(collW / 2 - 10 , 40);
        }else{
            return CGSizeMake(collW / 5 - 5 , 40);
        }
       
    }
}
///头部
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    FYBagLotteryHeaderView *tempview;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        FYBagLotteryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FYBagLotteryHeaderViewID forIndexPath:indexPath];
        tempview = headerView;
        FYBagLotteryBetListData *data = self.datasArr[self.selectedInx];
        FYBagLotteryBetConfig *config = [FYBagLotteryBetConfig mj_objectWithKeyValues:data.config[indexPath.section]];
        headerView.config = config;
        return headerView;
    }
    return tempview;
}

/// 设置头大小
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeMake(SCREEN_WIDTH - tableViewW - 8, 35);
    return size;
}
///组间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 0, 5);//分别为上、左、下、右
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.countdownView stopTime];
}
@end
