//
//  GroupViewController.m
//  Project
//
//  Created by mini on 2018/7/31.
//  Copyright © 2018年 CDJay. All rights reserved.
//

//#import "GroupViewController.h"
//#import "MessageNet.h"
#import "ChatViewController.h"
#import "CreateGroupChatController.h"
#import "MessageItem.h"
//#import "SqliteManage.h"
#import "BANetManager_OC.h"

#import "FYMenu.h"

#import "Recharge2ViewController.h"
#import "ShareViewController.h"
#import "BecomeAgentViewController.h"
#import "HelpCenterWebController.h"
#import "SystemAlertViewController.h"
#import "VVAlertModel.h"
#import "AgentCenterViewController.h"


#import "MsgHeaderView.h"

#import "EnterPwdBoxView.h"
//#import "CWCarousel.h"
//#import "CWPageControl.h"
#import "UIImageView+WebCache.h"

//#import "SLMarqueeControl.h"
#import "GridCell.h"
#import "GameMainCell.h"
#import "PacketGameCell.h"
#import "gamepacketmodel.h"
#import "dywebviewvc.h"

#define kViewTag 666


@interface GroupViewController ()<UITableViewDelegate,UITableViewDataSource,CycleBannerDelegate>
@property (nonatomic, strong) NSMutableArray * runloopArray;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) MessageNet *model;

@property(nonatomic, strong) NSMutableArray *menuItems;
@property(nonatomic, strong) EnterPwdBoxView *entPwdView;
@property(nonatomic, assign) EnumActionTag clickTag;
@property(nonatomic, strong) GridCell *gridV;

@property (nonatomic, copy) NSArray<GamePacketModel *> *packetGames;
/*
 * The system message number view
 */
@property (nonatomic, strong) NotiItemView *notify;
/** 轮播图模块*/
@property (nonatomic, strong) FYBannerView *bannerView;

@property (nonatomic, strong) NSMutableArray *bannerList;

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initData];
    _clickTag = EnumActionTag0;
    _runloopArray = [NSMutableArray array];
    
    [self initSubviews];
    [self getBannerData];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFore) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add_r"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    self.notify = [NotiItemView new];
    [self.notify addTarget:self selector:@selector(leftBtnClick)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.notify];
    
}

- (void)leftBtnClick {
    
    NotificationVC *vc = [NotificationVC new];
    vc.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:vc animated:true];
    
}

-(void)getBannerData {
 
    [NET_REQUEST_MANAGER requestMsgBannerWithId:OccurBannerAdsTypeGroup WithPictureSpe:OccurBannerAdsPictureTypeNormal success:^(id object) {
        
        BannerModel* model = [BannerModel mj_objectWithKeyValues:object];
        NSMutableArray *lists = [NSMutableArray arrayWithCapacity:0];
        [model.data.skAdvDetailList enumerateObjectsUsingBlock:^(BannerItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.bannerList addObject:obj];
            [lists addObject:obj.advPicUrl];
        }];
        self.bannerView.bannerImages = lists;
        self.bannerView.cyclePagerView.autoScrollInterval = [model.data.carouselTime floatValue];
        
        
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
    [NET_REQUEST_MANAGER requestSystemNoticeWithType:0 success:^(id object) {
        NSArray <MarqueeRecords *>*models = [MarqueeRecords mj_objectArrayWithKeyValuesArray:object[@"data"][@"records"]];
        NSMutableArray <NSString *> *titls = [NSMutableArray arrayWithCapacity:0];
        [models enumerateObjectsUsingBlock:^(MarqueeRecords * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx < 20){
                [titls addObject:obj.title];
            }
        }];
        self.bannerView.marqueeList = titls;
    } fail:^(id object) {
        [self getMarqueeRecords];
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];


    
}
- (void)getMarqueeRecords{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSArray <MarqueeRecords *>*models = [MarqueeRecords mj_objectArrayWithKeyValuesArray:[user objectForKey:@"records"]];
    NSMutableArray <NSString *> *titls = [NSMutableArray arrayWithCapacity:0];
    [models enumerateObjectsUsingBlock:^(MarqueeRecords * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < 20) {
            [titls addObject:model.title];
        }
    }];
    self.bannerView.marqueeList = titls;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SVP_DISMISS;
//    [self.carousel controllerWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.carousel controllerWillDisAppear];
}

#pragma mark ----- Data
- (void)initData{
//    _model = [MessageNet shareInstance];
//    kWeakly(self);
//    [NET_REQUEST_MANAGER requestSystemNoticeWithSuccess:^(id object) {
//
//        [self.scrollBarView richElementsInViewWithModel:[AppModel shareInstance].noticeAttributedString actionBlock:^(id data) {
//            [weakself scrollBarViewAction];
//        }];
//    } fail:^(id object) {
//        NSLog(@"%@",object);
//    }];
}

#pragma mark ----- Layout
//- (void)finishedPostBannerLayout:(CGFloat)changeY{
//    if (self.scrollBarView) {
//        [self.scrollBarView setSd_y:changeY+3];
//        [self initLayout];
//    }else{
//        [self.gridV setSd_y:changeY+3];
//        [self initLayout];
//    }
//}
- (void)initLayout{
//    [self.view layoutIfNeeded];
//    if (self.scrollBarView) {
//        [self.gridV setSd_y:CGRectGetMaxY(self.scrollBarView.frame)+3];
    
//    }else{
//        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
////            make.edges.equalTo(self.view);
//            make.left.right.bottom.equalTo(self.view);
//            make.top.equalTo(self.gridV.mas_bottom).offset(3);
//        }];
//    }
    
}

#pragma mark ----- subView
- (void)initSubviews {
    self.navigationItem.title = @"游戏";
    __weak MessageNet *weakModel = _model;
    [self.view addSubview:self.bannerView];
    self.view.backgroundColor = BaseColor;
//    [self initScrollBarView];
    
    CGFloat height = [GridCell cellHeightWithModel];
    self.gridV = [[GridCell alloc]initWithFrame: CGRectMake(0, 158, SCREEN_WIDTH, height)];
    [self.view addSubview:self.gridV];
    [self.gridV richElementsInCellWithModel:[FunctionManager findGamesGrids]];
    self.bannerView.frame = CGRectMake(0, 0, kScreenWidth, 158);
    [self.gridV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.bannerView.mas_bottom).offset(3);
        make.height.mas_equalTo(height);
    }];
   
    kWeakly(self);
    [self.gridV actionBlock:^(NSDictionary *dataModel) {
        if ([dataModel[kType] integerValue]==self->_clickTag) {
            return ;
        }else{
            self->_clickTag = [dataModel[kType] integerValue];
            weakModel.page = 1;
            [weakself getData];
        }
    }];
    
//    self.view.backgroundColor = BaseColor;
    self.tableView = [UITableView normalTable];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor hex:@"#d5d5d5"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.gridV.mas_bottom).offset(3);
    }];

    [self.tableView registerClass:[PacketGameCell class] forCellReuseIdentifier:@"packetCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

//    self.tableView.backgroundColor = [UIColor hex:@"#e3e3e3"];
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    __weak __typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        weakModel.page = 1;
        [strongSelf getData];
    }];
    
    self.tableView.StateView = [StateView StateViewWithHandle:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        weakModel.page = 1;
        [strongSelf getData];
    }];
  
    weakModel.page = 1;
   
    [self.tableView.mj_header beginRefreshing];
    
}


- (void)reloadTableState{
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];

    [self.tableView reloadData];
    if(_model.isNetError&&!_model.isEmpty){
        [self.tableView.StateView showNetError];
    }
    else if(!_model.isNetError&&_model.isEmpty){
        [self.tableView.StateView showEmpty];
    }
    else if(!_model.isNetError&&!_model.isEmpty){
        [self.tableView.StateView hidState];
    }
    
    
}

#pragma mark -  获取所有游戏列表
/**
 获取所有群组列表
 */
- (void)getData{
    __weak __typeof(self)weakSelf = self;
    if (_clickTag == EnumActionTag0) {
        [NET_REQUEST_MANAGER requestListRedBonusTypeSuccess:^(id object) {

            self.packetGames = [GamePacketModel mj_objectArrayWithKeyValuesArray:object[@"data"][@"list"]];

            [self reloadTableState];
        } fail:^(id object) {
            [self reloadTableState];
            [[FunctionManager sharedInstance] handleFailResponse:object];
        }];

    }else{
//        [_model getGameListWithRequestParams:@(_clickTag) successBlock:^(NSArray *arr) {
//            SVP_DISMISS;
//            __strong __typeof(weakSelf)strongSelf = weakSelf;
//            [strongSelf reloadTableState];
//        } failureBlock:^(id fail) {
//            __strong __typeof(weakSelf)strongSelf = weakSelf;
//            [strongSelf reloadTableState];
//        }];
    }


    
}

#pragma mark UITableViewDataSource
#pragma mark - SectonHeader
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_clickTag == EnumActionTag0) {
        return  self.packetGames.count;
    }
    return _model.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_clickTag == EnumActionTag0) {
        PacketGameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"packetCell" forIndexPath:indexPath];
        cell.model = self.packetGames[indexPath.row];
        kWeakly(self);
        cell.OtherClickFlag = ^(GamePacketModel * _Nonnull model, NSInteger flag) {
            if (flag == 1001) {
                //查看游戏规则
                DYWebViewVC *vc = [[DYWebViewVC alloc] init];
                vc.url = model.ruleImage;
                [weakself.navigationController pushViewController:vc animated:YES];
            }
            
        };
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return cell;
    }
  
//    NSString *cellIdentifier =@"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([_model.dataList[indexPath.row] isKindOfClass:[BannerItem class]]) {
        GameMainCell *cell = [GameMainCell cellWith:tableView];
        BannerItem* itemData = _model.dataList[indexPath.row];
        [cell richElementsInCellWithModel:itemData];
        [cell actionBlock:^(id data) {
            if ([data isKindOfClass:[BannerItem class]]) {
                [self handleGameCell:data];
            }
        }];
        return cell;
    }
    return nil;
}

- (void)handleGameCell:(BannerItem*)item{
    if (_clickTag == EnumActionTag5) {
        NSInteger tag = [item.advLinkUrl integerValue];
        if(tag == 1){
            NSString *urlHead = [AppModel shareInstance].commonInfo[@"big.wheel.lottery.url"];
            if(urlHead.length > 0){
                NSString *url = [NSString stringWithFormat:@"%@?token=%@&publickey=%@&userAccount=%@&tenant=%@",urlHead,[AppModel shareInstance].userInfo.token,[AppModel shareInstance].publicKey,GetUserDefaultWithKey(@"mobile"),kNewTenant];
                WebViewController *vc = [[WebViewController alloc] initWithUrl:url];
                vc.navigationItem.title = item.name;
                vc.hidesBottomBarWhenPushed = YES;
                //[vc loadWithURL:url];
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            //        WheelViewController *vc = [[WheelViewController alloc] init];
            //        vc.hidesBottomBarWhenPushed = YES;
            //        [self.navigationController pushViewController:vc animated:YES];
        }else if(tag == 2){
            NSString *urlHead = [AppModel shareInstance].commonInfo[@"fruit.slot.url"];
            if(urlHead.length > 0){
                NSString *url = [NSString stringWithFormat:@"%@?token=%@&publickey=%@&userAccount=%@&tenant=%@",urlHead,[AppModel shareInstance].userInfo.token,[AppModel shareInstance].publicKey,GetUserDefaultWithKey(@"mobile"),kNewTenant];
                WebViewController *vc = [[WebViewController alloc] initWithUrl:url];
                vc.navigationItem.title = item.name;
                vc.hidesBottomBarWhenPushed = YES;
                //[vc loadWithURL:url];
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
        }
    }else{
        AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
        [view showWithText:@"等待更新，敬请期待" button:@"好的" callBack:nil];
    }
    
    
}
#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (_clickTag) {
        case EnumActionTag0:
            return 80;
            break;
            
        default:
        {
            return (_model.isNetError||_model.isEmpty)?0.1f:[GameMainCell cellHeightWithModel];
            
        }
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_clickTag==0) {
        
        GameSearchVC *vc = [GameSearchVC new];
        vc.type = self.packetGames[indexPath.row].type;
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
    
        
    }
}

- (void)joinGroup:(MessageItem *)item password:(NSString *)password {
    // 加入群组
    SVP_SHOW;
    __weak __typeof(self)weakSelf = self;
    [NET_REQUEST_MANAGER getChatGroupJoinWithGroupId:item.groupId pwd:password success:^(id dict) {
        SVP_DISMISS;
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([[dict objectForKey:@"code"] integerValue] == 0) {
            [strongSelf groupChat:item isNew:YES];
        } else {
            if ([[dict objectForKey:@"errorcode"] integerValue] == 19) {
                NSString *msg = [NSString stringWithFormat:@"%@",[dict objectForKey:@"alterMsg"]];
                SVP_ERROR_STATUS(msg);
                [strongSelf groupChat:item isNew:YES];
            } else if ([[dict objectForKey:@"errorcode"] integerValue] == 25) {
                NSString *msg = [NSString stringWithFormat:@"%@",[dict objectForKey:@"alterMsg"]];
                SVP_ERROR_STATUS(msg);
                [strongSelf getData];
            } else {
                [[FunctionManager sharedInstance] handleFailResponse:dict];
            }
            
        }
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
//    [[MessageNet shareInstance] joinGroup:item.groupId password:password successBlock:^(NSDictionary *dict) {
//        SVP_DISMISS;
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        if ([[dict objectForKey:@"code"] integerValue] == 0) {
//            [strongSelf groupChat:item isNew:YES];
//        } else {
//            if ([[dict objectForKey:@"errorcode"] integerValue] == 19) {
//                NSString *msg = [NSString stringWithFormat:@"%@",[dict objectForKey:@"alterMsg"]];
//                SVP_ERROR_STATUS(msg);
//                [strongSelf groupChat:item isNew:YES];
//            } else if ([[dict objectForKey:@"errorcode"] integerValue] == 25) {
//                NSString *msg = [NSString stringWithFormat:@"%@",[dict objectForKey:@"alterMsg"]];
//                SVP_ERROR_STATUS(msg);
//                [strongSelf getData];
//            } else {
//                [[FunctionManager sharedInstance] handleFailResponse:dict];
//            }
//
//        }
//
//    } failureBlock:^(NSError *error) {
//        [[FunctionManager sharedInstance] handleFailResponse:error];
//    }];
}

#pragma mark - 输入密码框
- (void)passwordBoxView:(MessageItem *)item {
    EnterPwdBoxView *entPwdView = [[EnterPwdBoxView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    __weak __typeof(self)weakSelf = self;
    _entPwdView = entPwdView;
    
    // 查看详情
    entPwdView.joinGroupBtnBlock = ^(NSString *password){
        [weakSelf enterPwdView:item password:password];
    };
    
    [entPwdView showInView:self.view];
}

- (void)enterPwdView:(MessageItem *)item password:(NSString *)password {
    if (password.length == 0) {
        SVP_ERROR_STATUS(@"请输入密码");
        return;
    }
    [self.entPwdView disMissView];
    [self joinGroup:item password:password];
}



- (void)groupChat:(id)obj isNew:(BOOL)isNew{
    ChatViewController *vc = [ChatViewController groupChatWithObj:obj];
    vc.isNewMember = isNew;
    vc.chatType = FYConversationType_GROUP;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//-(void)initScrollBarView{
//    UIView *view = [UIView new];
//    view.layer.shadowRadius = 1;
//    view.layer.shadowColor = UIColor.grayColor.CGColor;
//    view.layer.shadowOpacity = 0.3;
//    view.layer.shadowOffset = CGSizeMake(0, 1);
//    view.backgroundColor = UIColor.whiteColor;
//    [self.view addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.offset(0);
//        make.height.offset(30);
//        make.top.offset(122);
//    }];
//    if([AppModel shareInstance].noticeArray.count > 0 &&
//       [AppModel shareInstance].noticeAttributedString.length>0){
//
//        kWeakly(self);
//        SLMarqueeControl *control = [[SLMarqueeControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 32)];
//        [control richElementsInViewWithModel:[AppModel shareInstance].noticeAttributedString actionBlock:^(id data) {
//            [weakself scrollBarViewAction];
//        }];
////        [control.marqueeLabel setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
////        control.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
//        [self.view addSubview:control];
//        [control mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.offset(0);
//            make.height.offset(30);
//            make.top.offset(122);
//        }];
////        _scrollBarView = control;
//
//    }
//}

#pragma mark - 下拉菜单
- (NSMutableArray *)menuItems {
    if (!_menuItems) {
        __weak __typeof(self)weakSelf = self;
        _menuItems = [[NSMutableArray alloc] initWithObjects:
                      
                      [FYMenuItem itemWithImage:[UIImage imageNamed:@"nav_agent"]
                                          title:@"代理中心"
                                         action:^(FYMenuItem *item) {
                                             AgentCenterViewController *vc = [[AgentCenterViewController alloc] init];
                                             vc.hidesBottomBarWhenPushed = YES;
                                             [weakSelf.navigationController pushViewController:vc animated:YES];
                                             
                                         }],
                      [FYMenuItem itemWithImage:[UIImage imageNamed:@"nav_help"]
                                          title:@"新手教程"
                                         action:^(FYMenuItem *item) {
                                             HelpCenterWebController *vc = [[HelpCenterWebController alloc] initWithUrl:nil];
                                             vc.hidesBottomBarWhenPushed = YES;
                                             [weakSelf.navigationController pushViewController:vc animated:YES];
                                             
                                         }],
                      [FYMenuItem itemWithImage:[UIImage imageNamed:@"nav_redp_play"]
                                          title:@"玩法规则"
                                         action:^(FYMenuItem *item) {
                                             WebViewController *vc = [[WebViewController alloc] initWithUrl:[AppModel shareInstance].ruleString];
                                             vc.navigationItem.title = @"玩法规则";
                                             vc.hidesBottomBarWhenPushed = YES;
                                             //[vc loadWithURL:url];
                                             [self.navigationController pushViewController:vc animated:YES];
                                         }],
                      [FYMenuItem itemWithImage:[UIImage imageNamed:@"nav_createGroupIcon"]
                                          title:@"创建群组"
                                         action:^(FYMenuItem *item) {
                                             CreateGroupChatController *vc = [[CreateGroupChatController alloc]
                                                                              init];
                                             vc.hidesBottomBarWhenPushed = YES;
                                             
                                             [self.navigationController pushViewController:vc animated:YES];
                                         }],

                      
                      nil];
    }
    return _menuItems;
}


//导航栏弹出
- (void)rightBarButtonDown:(UIBarButtonItem *)sender{
    FYMenu *menu = [[FYMenu alloc] initWithItems:self.menuItems];
    menu.menuCornerRadiu = 5;
    menu.showShadow = NO;
    menu.minMenuItemHeight = 48;
    menu.titleColor = [UIColor darkGrayColor];
    menu.menuBackGroundColor = [UIColor whiteColor];
    [menu showFromNavigationController:self.navigationController WithX:[UIScreen mainScreen].bounds.size.width-32];
}

#pragma mark - 系统公告栏

- (void)didSelectedLineWithIndex:(NSInteger)index{
    BannerItem *item = self.bannerList[index];
    NSLog(@"%@",item.advLinkUrl);
    UIViewController *vc = [[NSClassFromString(item.advLinkUrl) alloc]init];
//    guard let className = NSClassFromString(self.bannerModels[index].advLinkUrl!) as? UIViewController.Type else{
//        return
//    }
    [self.navigationController pushViewController:vc animated:YES];
//    self.navigationController?.pushViewController(className.init(), animated: true)
}
- (void)didSelectedMarquee{
    NotificationVC *vc = [[NotificationVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//- (void)announcementBar {
//    NSMutableArray *announcementArray = [NSMutableArray array];
//    if([AppModel shareInstance].noticeArray.count > 0){
//        for (NSDictionary *dic in [AppModel shareInstance].noticeArray) {
//            NSString *title = dic[@"title"];
//            NSString *content = dic[@"content"];
//            VVAlertModel *model = [[VVAlertModel alloc] init];
//            model.name = title;
//            if (content.length > 0) {
//                model.friends = @[content];
//            }
//            [announcementArray addObject:model];
//        }
//    } else {
//        return;
//    }
//    SystemAlertViewController *alertVC = [SystemAlertViewController alertControllerWithTitle:@"公告" dataArray:announcementArray];
//    [self presentViewController:alertVC animated:NO completion:nil];
//}

- (void)scrollBarViewAction {
    
    NotificationVC *vc = [NotificationVC new];
    
    [self.navigationController pushViewController:vc animated:true];
}
#pragma mark - 广告栏
//- (UIView *)animationView {

//    if (!_animationView) {
//        _animationView = [UIView new];
//        self.animationView.tag = 200;
//        [self.view addSubview:self.animationView];
//        if(self.carousel) {
//            [self.carousel releaseTimer];
//            [self.carousel removeFromSuperview];
//            self.carousel = nil;
//        }
//        CWFlowLayout *flowLayout = [[CWFlowLayout alloc] initWithStyle:CWCarouselStyle_Normal];
//        CWCarousel *carousel = [[CWCarousel alloc] initWithFrame:CGRectZero
//                                                        delegate:self
//                                                      datasource:self
//                                                      flowLayout:flowLayout];
//        carousel.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.animationView addSubview:carousel];
//        [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.offset(0);
//            make.height.offset(122);
//        }];
//        [carousel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.offset(0);
//        }];
//        carousel.isAuto = YES;
//        carousel.endless = YES;
//        carousel.backgroundColor = BaseColor;
//
//        [carousel registerViewClass:[UICollectionViewCell class] identifier:@"cellId"];
//        self.carousel = carousel;
//        [self finishedPostBannerLayout:CGRectGetMaxY(self.animationView.frame)];
//    }
//    return _animationView;
    
//}
- (FYBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[FYBannerView alloc]init];
        _bannerView.delegate = self;
    }
    return _bannerView;
}
- (NSMutableArray *)bannerList{
    if (!_bannerList) {
        _bannerList = [[NSMutableArray alloc]init];
    }
    return _bannerList;
}
@end
