//
//  FYSuperBombSendPacketVC.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/11/7.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "FYSuperBombSendPacketVC.h"
#import "FYSuperBombHeaderSectionView.h"
#import "FYSuperBombFooterSectionView.h"
#import "FYSuperBombPacketTableViewCell.h"
#import "FYSuperBombNumberTableViewCell.h"
#import "FYSuperBombAttrModel.h"
#import "FYSuperBombRequest.h"
#import "FYSegmentedView.h"
#import "SendRedCheckBalanceHelper.h"

static NSString *const kHeaderSectionIdentifier = @"kHeaderSectionIdentifier";
static NSString *const kFooterSectionIdentifier = @"kFooterSectionIdentifier";
static NSString *const kSuperBombPacketCellIdentifier = @"kSuperBombPacketCellIdentifier";
static NSString *const kSuperBombNumberCellIdentifier = @"kSuperBombNumberCellIdentifier";

@interface FYSuperBombSendPacketVC ()
<UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,
FYSegmentedViewDelegate, FYSuperBombPacketCellDelegate, FYSuperBombNumberCellDelegate>

@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FYSegmentedView *segmentView;
@property (nonatomic , strong) UILabel *moneyLab;
@property (nonatomic , strong) UILabel *tipsLabel;
@property (nonatomic, strong) NSMutableArray *packets;
@property (nonatomic, strong) NSMutableArray *modelList;
@property (nonatomic, strong) NSMutableArray *selectedBobms;

@property (nonatomic, assign) SendPackageType packageType;
@property (nonatomic, strong) FYSuperBombAttrModel *attrModel;
@property (nonatomic, strong) FYSuperBombRequest *bombRequest;

@end

@implementation FYSuperBombSendPacketVC

#pragma mark - Getter

- (FYSegmentedView *)segmentView {
    
    if (!_segmentView) {
        _segmentView = [[FYSegmentedView alloc] initWithOrigin:CGPointMake(0, 0)
                                                        height:44];
        _segmentView.delegate = self;
    }
    return _segmentView;
}

- (NSMutableArray *)packets {
    
    if (!_packets) {
        
        _packets = [NSMutableArray array];
    }
    return _packets;
}

- (NSMutableArray *)selectedBobms {
    
    if (!_selectedBobms) {
        
        _selectedBobms = [NSMutableArray array];
    }
    return _selectedBobms;
}

- (FYSuperBombAttrModel *)attrModel {
    
    if (!_attrModel) {
        
        _attrModel = [[FYSuperBombAttrModel alloc] init];
    }
    return _attrModel;
}

- (FYSuperBombRequest *)bombRequest {
    
    if (!_bombRequest) {
        _bombRequest = [[FYSuperBombRequest alloc] init];
        _bombRequest.sendType = self.messageItem.bombType;
    }
    return _bombRequest;
}
- (UILabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [[UILabel alloc]init];
        _moneyLab.font = [UIFont systemFontOfSize:48];
        _moneyLab.textColor = HexColor(@"#181818");
        _moneyLab.text = @"0.0";
        _moneyLab.textAlignment = NSTextAlignmentCenter;
        _moneyLab.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _moneyLab;
}
- (UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = NSLocalizedString(@"未领取的红包，将于5分钟后发起退款", nil);
        _tipsLabel.font = [UIFont systemFontOfSize:11];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.textColor = [UIColor colorWithHexString:@"#808080"];
    }
    return _tipsLabel;;
}
- (UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:NSLocalizedString(@"塞钱进红包", nil) forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont boldSystemFontOfSize2:16];
        _sendButton.backgroundColor = HexColor(@"#E16754");
        [_sendButton addRound:7];
        [_sendButton addTarget:self action:@selector(sendSuperBomb) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}
- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = HexColor(@"#EDEDED");
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorInset = UIEdgeInsetsMake(-15, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FYSuperBombHeaderSectionView class] forHeaderFooterViewReuseIdentifier:kHeaderSectionIdentifier];
        
        [_tableView registerClass:[FYSuperBombFooterSectionView class] forHeaderFooterViewReuseIdentifier:kFooterSectionIdentifier];
        
        [_tableView registerClass:[FYSuperBombPacketTableViewCell class] forCellReuseIdentifier:kSuperBombPacketCellIdentifier];
        
        [_tableView registerClass:[FYSuperBombNumberTableViewCell class] forCellReuseIdentifier:kSuperBombNumberCellIdentifier];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubview];
    [self initializes];
}

- (void)initializes {
    if (self.messageItem.bombType) {
        self.packageType = self.messageItem.bombType;
        
        switch (self.packageType) {
            case SinglePackage:
                self.navigationItem.title = NSLocalizedString(@"超级扫雷单雷发包", nil);
                self.segmentView.segmentTitles = @[NSLocalizedString(@"单雷", nil)];
                self.bombRequest.sendType = SinglePackage;
                [self reloadSendPacketTypeAtIndex:1 isRest:NO isSetCount:NO];
                break;
            case MultiplePackage:
                self.navigationItem.title = NSLocalizedString(@"超级扫雷多雷发包", nil);
                self.segmentView.segmentTitles = @[NSLocalizedString(@"多雷", nil)];
                self.bombRequest.sendType = MultiplePackage;
                [self reloadSendPacketTypeAtIndex:2 isRest:NO isSetCount:NO];
                break;
            default:
                self.navigationItem.title = NSLocalizedString(@"超级扫雷混合雷发包", nil);
                self.segmentView.segmentTitles = @[NSLocalizedString(@"单雷", nil), NSLocalizedString(@"多雷", nil)];
                [self reloadSendPacketTypeAtIndex:1 isRest:NO isSetCount:NO];
                self.bombRequest.sendType = SinglePackage;
                break;
        }
        
    }
}

- (void)setupSubview {
    self.view.backgroundColor = BaseColor;
    self.navigationController.delegate = self;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    button.titleLabel.font = [UIFont boldSystemFontOfSize2:15];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [button setTitleColor:HexColor(@"#CB332D") forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.tableView.tableFooterView = [self createFooterView];
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.tableView];
    
    CGFloat isHideSegmnet = self.messageItem.bombType == 3 ? NO : YES;
    self.segmentView.hidden = isHideSegmnet;
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(isHideSegmnet ? @0 : @44);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (UIView *)createFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 260)];
    [footerView addSubview:self.moneyLab];
    [footerView addSubview:self.sendButton];
    [footerView addSubview:self.tipsLabel];
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footerView);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.8);
    }];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footerView);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.4);
        make.top.equalTo(self.moneyLab.mas_bottom).offset(20);
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(footerView);
        make.top.equalTo(self.sendButton.mas_bottom).offset(50);
    }];
    return footerView;
}

#pragma mark - Action

- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/// 根据发包类型设置样式
- (void)reloadSendPacketTypeAtIndex:(NSInteger)index isRest:(BOOL)isRest isSetCount:(BOOL)isSetCount {
    NSString *key = [NSString stringWithFormat:@"%ld", index];
    if (self.messageItem.attr.length > 0) {
        NSDictionary *attr = [self.messageItem.attr mj_JSONObject];
        NSArray *list = [attr[key] mj_JSONObject];
        if (list.count > 0) {
            self.modelList = [FYSuperBombAttrModel mj_objectArrayWithKeyValuesArray:list];
            [self makePackets:self.modelList key:key isRest:isRest isSetCount:isSetCount];
        }
    }
}

- (void)makePackets:(NSMutableArray *)list key:(NSString *)key isRest:(BOOL)isRest isSetCount:(BOOL)isSetCount {
    [self.packets removeAllObjects];
    for (FYSuperBombAttrModel *model in list) {
        [self.packets addObject:model.count];
    }
    
    // 默认选择包数
    if (isSetCount) {
        if (self.bombRequest.packetCount) {
            for (FYSuperBombAttrModel *model in list) {
                if ([model.count isEqualToString:self.bombRequest.packetCount]) {
                    self.attrModel.minMoney = model.minMoney;
                    self.attrModel.maxMoney = model.maxMoney;
                }
            }
            self.attrModel.packetCount = self.bombRequest.packetCount;
        }
    }else {
        FYSuperBombAttrModel *firstObject = [list firstObject];
        self.attrModel.minMoney = firstObject.minMoney;
        self.attrModel.maxMoney = firstObject.maxMoney;
        self.bombRequest.packetCount = firstObject.count;
        self.attrModel.packetCount = self.bombRequest.packetCount;
    }
    
    self.attrModel.isRestSelected = isRest;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - 发送红包

- (void)sendSuperBomb
{
    [self.view endEditing:YES];
    
    if (!self.bombRequest.sendMoney || [self.bombRequest.sendMoney isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"请设置发包金额", nil)];
        return;
    }
    if ([self.bombRequest.sendMoney integerValue] > [self.attrModel.maxMoney integerValue] ||
        [self.bombRequest.sendMoney integerValue] < [self.attrModel.minMoney integerValue]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"超出金额范围", nil)];
        return;
    }
    if (!self.selectedBobms.count) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"请选择雷号", nil)];
        return;
    }
    
    NSString *type = self.bombRequest.sendType == SinglePackage ? @"1" : @"2";
    NSDictionary *extBody = @{@"bombList": [self makeBombListIntArray:self.selectedBobms],
                              @"type": type};
    
    [self redpackedRequest:self.bombRequest.sendMoney
                 packetNum:self.bombRequest.packetCount
                       ext:extBody];
}

/// 设置雷号整型
- (NSArray *)makeBombListIntArray:(NSMutableArray *)list {
    NSMutableArray *results = [NSMutableArray new];
    if (list.count) {
        for (NSString *bomb in list) {
            NSNumber *number = [NSNumber numberWithInteger:[bomb integerValue]];
            [results addObject:number];
        }
    }
    return results;
}

- (void)redpackedRequest:(NSString *)money packetNum:(NSString *)packetNum ext:(NSDictionary *)ext {

    NSDictionary *parameters = @{
                                @"ext": ext,
                                @"groupId":self.messageItem.groupId,
                                @"userId":[AppModel shareInstance].userInfo.userId,
                                @"type": @(self.messageItem.type),
                                @"money": money,
                                @"count": self.bombRequest.packetCount
                                };
    
    WEAKSELF(weakSelf)
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER redpacketSend:parameters successBlock:^(NSDictionary *response) {
        PROGRESS_HUD_DISMISS
        if ([response objectForKey:@"code"] && [[response objectForKey:@"code"] integerValue] == 0) {
            [weakSelf backAction];
        } else {
            [[FunctionManager sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(id error) {
        PROGRESS_HUD_DISMISS
        if ([error isKindOfClass:[NSDictionary class]]) {
            NSString *msg = [(NSDictionary *)error stringForKey:@"alterMsg"];
            if ([msg containsString:NSLocalizedString(@"余额不足", nil)]) {
                [SendRedCheckBalanceHelper checkShowBalanceView:msg navigation:self.navigationController];
            } else {
                ALTER_HTTP_ERROR_MESSAGE(error)
            }
        } else {
            [[FunctionManager sharedInstance] handleFailResponse:error];
        }
    }];
}

// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    if (isShowHomePage) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorFromHex:@"#EDEDED"];
        self.navigationController.navigationBar.tintColor = [UIColor colorFromHex:@"#EDEDED"];
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init]forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }

}
#pragma mark - <FYSegmentedViewDelegate>

- (void)segmentView:(FYSegmentedView *)segmentView didSelectedAtIndex:(NSInteger)index {
    if (self.packageType == MixedPackage) { //混合雷
        [self clearLastBombs];
        self.bombRequest.sendType = index + 1;
        [self reloadSendPacketTypeAtIndex:self.bombRequest.sendType isRest:YES isSetCount:NO];
    }
}

- (void)clearLastBombs {
    self.attrModel.setedHandicap = @"";
    [self.selectedBobms removeAllObjects];
}

#pragma mark - <FYSuperBombPacketCellDelegate - 包数选择>

- (void)cell:(FYSuperBombPacketTableViewCell *)cell didSelectedAtPacket:(NSString *)packet {
    [self clearLastBombs];
    self.bombRequest.packetCount = packet;
    [self reloadSendPacketTypeAtIndex:self.bombRequest.sendType isRest:YES isSetCount:YES];
}

#pragma mark - <FYSuperBombNumberCellDelegate - 雷号选择>

- (void)cell:(FYSuperBombNumberTableViewCell *)cell didSelectedAtNumber:(NSString *)number {
    if (self.packageType == SinglePackage) {
        [self singlePackageHandle:number];
    }else if (self.packageType == MultiplePackage) {
        [self multiplePackageHandle:number];
    }else if (self.packageType == MixedPackage) {
        if (self.bombRequest.sendType == SinglePackage) {
            [self singlePackageHandle:number];
        }else {
            [self multiplePackageHandle:number];
        }
    }
    
    if (self.modelList.count) {
        for (FYSuperBombAttrModel *model in self.modelList) {
            if (model.count == self.bombRequest.packetCount) {
                self.attrModel = model;
            }
        }
        
        self.attrModel.sendType = self.bombRequest.sendType;
        self.attrModel.packetCount = self.bombRequest.packetCount;
        self.attrModel.setedHandicap = [self configCurrentHandicap:self.attrModel];
        self.bombRequest.handicap = self.attrModel.setedHandicap;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

/// 单包处理
- (void)singlePackageHandle:(NSString *)number {
    if (self.selectedBobms.count) {
        [self.selectedBobms removeAllObjects];
    }
    
    [self.selectedBobms addObject:number];
}

- (void)multiplePackageHandle:(NSString *)number {
    for (NSString *num in self.selectedBobms) {
        if ([num isEqualToString:number]) {
            [self.selectedBobms removeObject:num];
            return;
        }
    }
    
    [self.selectedBobms addObject:number];
}

/// 设置当前赔率
- (NSString *)configCurrentHandicap:(FYSuperBombAttrModel *)model {
    if (!self.selectedBobms.count) {
        return @"";
    }
    
    if (self.selectedBobms.count == 1) {
        return [NSString stringWithFormat:@"%.1f", model.handicap];
    }else if (self.selectedBobms.count == 2) {
        return [NSString stringWithFormat:@"%.1f", model.handicap2];
    }else if (self.selectedBobms.count == 3) {
        return [NSString stringWithFormat:@"%.1f", model.handicap3];
    }else if (self.selectedBobms.count == 4) {
        return [NSString stringWithFormat:@"%.1f", model.handicap4];
    }else if (self.selectedBobms.count == 5) {
        return [NSString stringWithFormat:@"%.1f", model.handicap5];
    }else {
        return [NSString stringWithFormat:@"%.1f", model.handicap6];
    }
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        FYSuperBombPacketTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:kSuperBombPacketCellIdentifier];
        cell1.delegate = self;
        cell1.packets = self.packets;
        cell1.selectedPacket = self.bombRequest.packetCount;
        return cell1;
    }else {
        FYSuperBombNumberTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:kSuperBombNumberCellIdentifier];
        cell2.model = self.attrModel;
        cell2.delegate = self;
        return cell2;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MJWeakSelf
    FYSuperBombHeaderSectionView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeaderSectionIdentifier];
    headerView.model = self.attrModel;
    headerView.didEditBlock = ^(NSString * _Nonnull money) {
        weakSelf.bombRequest.sendMoney = money;
    };
    headerView.didEditChangeBlock = ^(NSString * _Nonnull money) {
        weakSelf.moneyLab.text = [NSString stringWithFormat:@"%@.0",money];
    };
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    FYSuperBombFooterSectionView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kFooterSectionIdentifier];
    footerView.model = self.attrModel;
    return footerView;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 140;
    }
    return 112;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
       return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}


@end
