//
//  CreateGroupChatController.m
//  ProjectXZHB
//
//  Created by 汤姆 on 2019/7/25.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FYGroupTypeSettingViewController.h"
#import "CreateGroupChatController.h"
#import "CreateGroupInfoCell.h"
#import "FYCreateGroupModel.h"
#import "FYRedPacketListModel.h"
#import "FYCreateRequest.h"

#import "ModifyGroupController.h"
#import "GroupSettingRedPaperVC.h"
#import "FYGroupTypeAlertView.h"

static NSString *const kGroupCreateIdentifier = @"kGroupCreateIdentifier";

@interface CreateGroupChatController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIButton *createBtn;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isAddedRed; ///< 是否已选红包类型
@property (nonatomic, strong) FYCreateRequest *request;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) FYCreateRequest *packetModel; ///<红包配置项
@property (nonatomic, strong) FYRedPacketListModel *selectedModel;

@end

@implementation CreateGroupChatController


#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView setTableFooterView:[self tableFooterView]];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Action

- (void)pressConfirmButtonAction
{
    [self.view endEditing:YES];
    
    if (!self.request.type && !self.request.Id) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"请选择群类型", nil))
        return;
    }
    
    if (VALIDATE_STRING_EMPTY(self.request.chatgName)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"请输入群名称", nil))
        return;
    }
    
    if (self.request.type == GroupTemplate_N01_Bomb  // 扫雷
        || self.request.type == GroupTemplate_N02_NiuNiu  // 牛牛
        || self.request.type == GroupTemplate_N08_ErRenNiuNiu) {  // 二人牛牛
        if (!self.request.minCount.length && !self.request.maxCount.length) {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"请设置发包包数", nil))
            return;
        }
        if (!self.request.minMoney.length && !self.request.maxMoney.length) {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"请设置发包金额范围", nil))
            return;
        }
    } else if (self.request.type == GroupTemplate_N04_RobNiuNiu  // 抢庄牛牛
               || self.request.type == GroupTemplate_N05_ErBaGang) { // 二八杠
        if (!self.request.myAmount.length) {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"请设置抢庄加注金额", nil))
            return;
        }
        if (!self.request.myPayRatio.length) {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"请设置连续上庄支付比例", nil))
            return;
        }
    }
    
    [self startCreate];
}


/// 设置红包数量
- (void)setupRedPaperComplete:(void(^)(FYCreateRequest *setedModel))block
{
    if (self.request.type) {
        GroupSettingRedPaperVC *redPaperVC = [[GroupSettingRedPaperVC alloc] init];
        redPaperVC.groupType = self.request.type;
        if (self.packetModel) {
            redPaperVC.packetModel = self.packetModel;
        }
        [self.navigationController pushViewController:redPaperVC animated:YES];
        // 拿到红包配置
        redPaperVC.didSetedBlock = ^(FYCreateRequest * _Nullable result) {
            if (result == nil) {
                return;
            }
            
            self.packetModel = result;
            self.request.maxMoney = result.maxMoney;
            self.request.minMoney = result.minMoney;
            self.request.maxCount = result.maxCount;
            self.request.minCount = result.minCount;
            if (result.amount && result.amount != 0) {
                self.request.myAmount = [NSString stringWithFormat:@"%ld", result.amount];
            }
            if (result.payRatio && result.payRatio != 0) {
                self.request.myPayRatio = [NSString stringWithFormat:@"%ld", result.payRatio];
            }
            
            !block?:block(result);
        };
    }
}

#pragma mark - Request

- (void)loadGroupRedTypeListDidComplete:(void(^)(FYRedPacketListModel *model))complete
{
    WEAKSELF(weakSelf)
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requestGroupRedListSuccess:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"群类型 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
           ALTER_HTTP_MESSAGE(response)
        } else {
            NSArray *data = NET_REQUEST_DATA(response);
            NSMutableArray *list = [FYRedPacketListModel mj_objectArrayWithKeyValuesArray:data];
            [weakSelf showGroupRedTypeAlertWithList:list complete:complete];
        }
    } fail:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"群类型 => \n%@", nil), error);
    }];
}

/// 开始创建群
- (void)startCreate
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.request.userId forKey:@"userId"];
    [params setObject:@(self.request.officeFlag) forKey:@"officeFlag"];
//    [params setObject:@(self.request.isShutupFlag) forKey:@"shutupFlag"];
//    [params setObject:@(self.request.isShutPicFlag) forKey:@"shutPicFlag"];
    NSString *chatgName = [self removeSpaceAndNewline:self.request.chatgName];
    [params setObject:chatgName forKey:@"chatgName"];
    [params setObject:@(self.request.type) forKey:@"type"];
    if (self.request.notice.length > 0) {
        [params setObject:self.request.notice forKey:@"notice"];
    }
    
    // 福利红包（不需要红包配置）
    if (self.request.type == GroupTemplate_N01_Bomb ||
        self.request.type == GroupTemplate_N02_NiuNiu ||
        self.request.type == GroupTemplate_N08_ErRenNiuNiu) {
        [params setObject:self.request.minCount forKey:@"minCount"];
        [params setObject:self.request.maxCount forKey:@"maxCount"];
        [params setObject:self.request.minMoney forKey:@"minMoney"];
        [params setObject:self.request.maxMoney forKey:@"maxMoney"];
    }else if (self.request.type == GroupTemplate_N04_RobNiuNiu || self.request.type == GroupTemplate_N05_ErBaGang) {
        [params setObject:self.request.myAmount forKey:@"rabBankerMoney"];
        [params setObject:self.request.myPayRatio forKey:@"continueBankerPercent"];
    }
    
    [SVProgressHUD show];
    __weak typeof(self) tempVC = self;
    [[NetRequestManager sharedInstance] requestCreateSelfGroupWithGroupType:self.request.type params:params Success:^(id object) {
        [SVProgressHUD dismiss];
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSInteger code = [object[@"code"] integerValue];
            if (code == 0) {
                NSDictionary *responseData=object[@"data"];
                MessageItem *groupItem=[MessageItem mj_objectWithKeyValues:responseData];
                [tempVC toGroupChat:groupItem];
//                [self createSuccess];
                
                // 更新自己的群组信息
                [[IMGroupModule sharedInstance] handleUpdateAllGroupEntitys:^(BOOL success) {
                    [NOTIF_CENTER postNotificationName:kNotificationCreateOrDeleteSelfGroup object:nil];
                }];
            }
        }
    } fail:^(id object) {
        [SVProgressHUD dismiss];
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

- (void)toGroupChat:(MessageItem *)item
{
    [SVProgressHUD show];
    __weak typeof(self) tempVC = self;
    [NET_REQUEST_MANAGER getChatGroupJoinWithGroupId:item.groupId pwd:@"" success:^(id object) {
        [SVProgressHUD dismiss];
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *response=(NSDictionary *)object;
            NSInteger resultCode=[response[@"code"] integerValue];
            NSInteger errorCode=[response[@"errorcode"] integerValue];
            if (resultCode == 0) {
                ChatViewController *chatVC=[ChatViewController groupChatWithObj:item];
                chatVC.isBackToRootVC = YES;
                [tempVC.navigationController pushViewController:chatVC animated:YES];
            }else if (errorCode == 40001){
                [[AppModel shareInstance] isGuest];
            }else{
                NSString *alertMsg=response[@"alterMsg"];
                [SVProgressHUD showInfoWithStatus:alertMsg];
            }
        }
        
    } fail:^(id object) {
        [SVProgressHUD dismiss];
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *response=(NSDictionary *)object;
            NSInteger errorCode=[response[@"errorcode"] integerValue];
            if (errorCode == 40001) {
                [[AppModel shareInstance] isGuest];
                return;
            }
        }
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

- (NSString *)removeSpaceAndNewline:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

- (void)createSuccess
{
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"创建群成功", nil)];
    [[NSNotificationCenter defaultCenter] postNotificationName:kReloadMyMessageGroupList object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    });
}

#pragma mark - Getter

- (FYCreateRequest *)request
{
    if (!_request) {
        _request = [[FYCreateRequest alloc] init];
        _request.officeFlag = 0; // 默认自建群
        _request.isShutupFlag = NO;
        _request.isShutPicFlag = NO;
        _request.chatgName = @"";
        _request.notice = @"";
        _request.myAmount = @"";
        _request.myPayRatio = @"";
        _request.userId = AppModel.shareInstance.userInfo.userId;
    }
    return _request;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [tableView setEstimatedRowHeight:50.0f];
        [tableView setTableHeaderView:[UIView new]];
        [tableView setTableFooterView:[UIView new]];
        [tableView setSectionHeaderHeight:FLOAT_MIN];
        [tableView setSectionFooterHeight:FLOAT_MIN];
        [tableView setShowsVerticalScrollIndicator:NO];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, FLOAT_MIN)]];
        [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, FLOAT_MIN)]];
        
        UIView *backgroundView = [[UIView alloc] init];
        [backgroundView setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        [tableView setBackgroundView:backgroundView];
        [tableView setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];

        [tableView setSeparatorInset:UIEdgeInsetsMake(0, -15, 0, 0)];
        [tableView registerClass:[CreateGroupInfoCell class] forCellReuseIdentifier:kGroupCreateIdentifier];
        
        _tableView = tableView;
    }
    return _tableView;
}

- (UIButton *)createBtn
{
    if (!_createBtn) {
        CGFloat x = 20;
        _createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_createBtn defaultStyleButton];
        _createBtn.frame = CGRectMake(x, 25, SCREEN_WIDTH-x*2, 45);
        [_createBtn setTitle:NSLocalizedString(@"创建", nil) forState:UIControlStateNormal];
        _createBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:15.0f];
        _createBtn.noClickInterval = 3.0;
        [_createBtn addTarget:self action:@selector(pressConfirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createBtn;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.createBtn.maxY + 15, SCREEN_WIDTH, 25)];
        _tipsLabel.textColor = COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(12.0)];
        _tipsLabel.text = NSLocalizedString(@"提示：每个用户只允许创建一个群", nil);
    }
    return _tipsLabel;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        NSArray *list = @[
            [FYCreateGroupModel createModelWithTitle:STR_CELL_TITLE_GROUP_TYPE
                                            subtitle:NSLocalizedString(@"选择群类型", nil)
                                               style:CreateAllTitleAndArrow],
            [FYCreateGroupModel createModelWithTitle:STR_CELL_TITLE_GROUP_NAME
                                            subtitle:NSLocalizedString(@"请输入1-20个字符", nil)
                                               style:CreateTitleOrTextField],
            [FYCreateGroupModel createModelWithTitle:NSLocalizedString(@"群公告(选填)", nil)
                                            subtitle:NSLocalizedString(@"设置", nil)
                                               style:CreateAllTitleAndArrow]];
        _dataSource = [NSMutableArray arrayWithArray:list];
    }
    return _dataSource;
}

- (UIView *)tableFooterView
{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
    UIView *footerView = [[UIView alloc] initWithFrame:frame];
    [footerView addSubview:self.createBtn];
    [footerView addSubview:self.tipsLabel];
    return footerView;
}


#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf
    CreateGroupInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kGroupCreateIdentifier];
    if (self.dataSource.count > indexPath.row) {
        FYCreateGroupModel *dataModel = self.dataSource[indexPath.row];
        cell.model = dataModel;
        if (indexPath.row == 1) {
            cell.textEditEndBlock = ^(NSString * _Nonnull text) {
                weakSelf.request.chatgName = text;
            };
        }
    }
    return cell;
}


#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf
    FYCreateGroupModel *dataModel = self.dataSource[indexPath.row];
    if (0 == indexPath.row) { // 群类型
        [self loadGroupRedTypeListDidComplete:^(FYRedPacketListModel *model) {
            dataModel.subtitle = model.showName;
            [weakSelf.tableView reloadData];
        }];
    } else if (1 == indexPath.row) { // 群名称
        
    } else if (2 == indexPath.row) { // 群公告
        ModifyGroupController *modifyVC = [[ModifyGroupController alloc] init];
        modifyVC.title = NSLocalizedString(@"设置群公告", nil);
        modifyVC.isSetting = YES;
        modifyVC.content = self.request.notice;
        modifyVC.type = ModifyGroupTypeMent;
        modifyVC.isSetting = YES;
        [self.navigationController pushViewController:modifyVC animated:YES];
        modifyVC.modifyGroupBlock = ^(NSString * _Nonnull text) {
            if (text.length) {
                weakSelf.request.notice = text;
                dataModel.subtitle = text;
                [weakSelf.tableView reloadData];
            }
        };
    } else if (3 == indexPath.row && self.isAddedRed) {
        // 红包设置
        [self setupRedPaperComplete:^(FYCreateRequest *setedModel) {
            if (weakSelf.request.type == GroupTemplate_N01_Bomb) {
                dataModel.subtitle = [NSString stringWithFormat:NSLocalizedString(@"%@包，%@-%@元", nil), setedModel.maxCount, setedModel.minMoney, setedModel.maxMoney];
            }
            if (weakSelf.request.type == GroupTemplate_N02_NiuNiu) {
                dataModel.subtitle = [NSString stringWithFormat:NSLocalizedString(@"%@-%@包，%@-%@元", nil), setedModel.minCount, setedModel.maxCount, setedModel.minMoney, setedModel.maxMoney];
            }
            if (weakSelf.request.type == GroupTemplate_N08_ErRenNiuNiu) {
                dataModel.subtitle = [NSString stringWithFormat:NSLocalizedString(@"%@-%@元", nil), setedModel.minMoney, setedModel.maxMoney];
            }
            if (weakSelf.request.type == GroupTemplate_N04_RobNiuNiu || weakSelf.request.type == GroupTemplate_N05_ErBaGang) {
                dataModel.subtitle = [NSString stringWithFormat:NSLocalizedString(@"%ld元，%ld%%", nil), setedModel.amount, setedModel.payRatio];
            }
            
            [weakSelf.tableView reloadData];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 10.0f)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}


#pragma mark - Configuration

- (void)showGroupRedTypeAlertWithList:(NSArray *)list complete:(void(^)(FYRedPacketListModel *model))complete
{
    /*
    WeakSelf
    if (list.count) {
        FYGroupTypeAlertView *alertView = [[FYGroupTypeAlertView alloc] initGroupTypeWithData:list
                                                                                selectedBlock:^(FYRedPacketListModel *result) {
            !complete?:complete(result);
            // 记录类型
            weakSelf.request.Id = result.Id;
            weakSelf.request.type = result.type;
            // clear
            weakSelf.selectedModel = result;
            [weakSelf clearLastRequest:result];
        }];
        if (self.selectedModel != nil) {
            alertView.selectedModel = self.selectedModel;
        }
        [alertView show];
    }
    */
    WEAKSELF(weakSelf)
    if (list.count <= 0) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"数据错误[群组类型数据为空]", nil))
    } else {
        FYGroupTypeSettingViewController *groupTypeVC = [[FYGroupTypeSettingViewController alloc] initWidthGroupTypeListModels:list selectedModel:self.selectedModel completeBlock:^(FYRedPacketListModel * _Nonnull result) {
            !complete?:complete(result);
            // 记录类型
            weakSelf.request.Id = result.Id;
            weakSelf.request.type = result.type;
            // clear
            weakSelf.selectedModel = result;
            [weakSelf clearLastRequest:result];
        } ];
        [self.navigationController pushViewController:groupTypeVC animated:YES];
    }
}

/// 如果更换类型（须清空配置）
- (void)clearLastRequest:(FYRedPacketListModel *)result
{
    // Configuration
    if (result.type == GroupTemplate_N00_FuLi) {
        [self removerRedSetting]; //福利群没有红包设置
    } else {
        [self addRedSetting];
    }
    
    if (self.packetModel.type && (self.packetModel.type != result.type)) {
        self.request.minCount = @"";
        self.request.maxMoney = @"";
        self.request.minMoney = @"";
        self.request.maxMoney = @"";
        self.request.myAmount = @"";
        self.request.myPayRatio = @"";
        
        self.packetModel = nil;
        [self replaceRedSetting];
    }
}

- (void)replaceRedSetting
{
    if (self.isAddedRed && (self.dataSource.count == 4)) {
        FYCreateGroupModel *redModel = [[FYCreateGroupModel alloc] init];
        redModel.title = STR_CELL_TITLE_GROUP_REDPACT;
        redModel.subtitle = NSLocalizedString(@"设置", nil);
        redModel.style = CreateAllTitleAndArrow;
        
        [self.dataSource replaceObjectAtIndex:self.dataSource.count - 1  withObject:redModel];
        [self.tableView reloadData];
    }
}

- (void)addRedSetting
{
    if (!self.isAddedRed) {
        FYCreateGroupModel *redModel = [[FYCreateGroupModel alloc] init];
        redModel.title = STR_CELL_TITLE_GROUP_REDPACT;
        redModel.subtitle = NSLocalizedString(@"设置", nil);
        redModel.style = CreateAllTitleAndArrow;
        [self.dataSource addObject:redModel];
        [self.tableView reloadData];
        self.isAddedRed = YES;
    }
}

- (void)removerRedSetting
{
    if (self.isAddedRed && (self.dataSource.count == 4)) {
        [self.dataSource removeLastObject];
        [self.tableView reloadData];
        self.isAddedRed = NO;
    }
}

@end
