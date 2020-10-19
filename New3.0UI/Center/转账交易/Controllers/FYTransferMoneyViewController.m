//
//  FYTransferMoneyViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYTransferMoneyViewController.h"
#import "FYHTTPResponseModel.h"
#import "FYMobileContactInformation.h"
#import "FYNearlySelectUserCell.h"
#import "FYTransferActionView.h"
#import "FYContactSelectViewController.h"
#import "FYTransferMoneyInputViewController.h"
#import "FYScannerQRCodeViewController.h"

@interface FYTransferMoneyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) FYTransferActionView *contactView;
@property (nonatomic, strong) FYTransferActionView *qrCodeView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableDataSource;

@property (nonatomic, strong) FYContactSimpleModel *currentSelectedUser;

@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) NSInteger minMoney;
@property (nonatomic, assign) NSInteger maxMoney;

@end

@implementation FYTransferMoneyViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT;
    
    [self HTTPToGetHistory];
    
    [self.contactView addTarget:self selector:@selector(tapAction:)];
    self.contactView.imageView.image=[UIImage imageNamed:@"icon_transfer_contact"];
    self.contactView.labelName.text=NSLocalizedString(@"通讯录联系人", nil);
    
    [self.qrCodeView addTarget:self selector:@selector(tapAction:)];
    self.qrCodeView.imageView.image =[UIImage imageNamed:@"icon_transfer_scan"];
    self.qrCodeView.labelName.text=NSLocalizedString(@"扫码添加", nil);
}

-(void)tapAction:(UITapGestureRecognizer *)sender{
    NSLog(@"tag:%ld",sender.view.tag);
    if (sender.view.tag == 1) {
        FYContactSelectViewController *subView=[FYContactSelectViewController new];
        __weak typeof(self) tempVC = self;
        [subView setSelectViewResult:^(FYContactMainModel * _Nonnull model) {
            FYContactSimpleModel *tempUser=[FYContactSimpleModel new];
            tempUser.userId = model.userId;
            tempUser.nick = model.nick;
            tempUser.avatar = model.avatar;
            tempVC.currentSelectedUser = tempUser;
            [tempVC toTransferViewController];
        }];
        [self.navigationController pushViewController:subView animated:YES];
    } else if (sender.view.tag == 2) {
#if TARGET_IPHONE_SIMULATOR
        ALTER_INFO_MESSAGE(NSLocalizedString(@"模拟器不能使用此功能", nil))
#elif TARGET_OS_IPHONE
        FYScannerQRCodeViewController *VC = [[FYScannerQRCodeViewController alloc] initWithType:FYQRCodeTypeTransferMoney];
        [self.navigationController pushViewController:VC animated:YES];
#endif
    }
}

-(void)buttonTransferAction:(UIButton *)sender{
    if (self.currentSelectedUser) {
        [self toTransferViewController];
    } else {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"请选择你要转账的联系人", nil))
    }
}

-(void)toTransferViewController{
    if (self.currentSelectedUser == nil) {
        return;
    }
    FYTransferMoneyInputViewController *subView=[FYTransferMoneyInputViewController new];
    subView.toUser=self.currentSelectedUser;
    subView.maxCount = self.maxCount;
    subView.maxMoney = self.maxMoney;
    subView.minMoney = self.minMoney;
    [self.navigationController pushViewController:subView animated:YES];
}

-(UIView *)topView{
    if (!_topView) {
        _topView=[UIView new];
        _topView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.height.mas_equalTo(120);
            make.top.mas_equalTo(self.view.mas_topMargin);
        }];
    }
    return _topView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.sectionHeaderHeight = 40;
        _tableView.backgroundColor = self.view.backgroundColor;
        [_tableView registerClass:[FYNearlySelectUserCell class] forCellReuseIdentifier:@"FYNearlySelectUserCell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(self.topView.mas_bottom).mas_offset(10);
            make.bottom.mas_equalTo(self.bottomView.mas_top);
        }];
    }
    return _tableView;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView=[UIView new];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bottomView];
        
        UIButton *button=[UIButton new];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT;
        [button setTitle:NSLocalizedString(@"转账", nil) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [_bottomView addSubview:button];
        [button addTarget:self action:@selector(buttonTransferAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.view);
            make.height.mas_equalTo(120+TAB_BAR_DANGER_HEIGHT);
        }];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0).offset(-TAB_BAR_DANGER_HEIGHT*0.5F);
            make.centerX.mas_equalTo(0);
            make.left.mas_equalTo(20);
            make.height.mas_equalTo(SYSTEM_GLOBAL_BUTTON_HEIGHT);
        }];
    }
    return _bottomView;
}

-(FYTransferActionView *)contactView{
    if (!_contactView) {
        _contactView = [FYTransferActionView new];
        _contactView.tag = 1;
        _contactView.backgroundColor = [UIColor whiteColor];
        [self.topView addSubview:_contactView];
        [_contactView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(0);
            make.right.mas_equalTo(self.view.mas_centerX);
        }];
    }
    return _contactView;
}

-(FYTransferActionView *)qrCodeView{
    if (!_qrCodeView) {
        _qrCodeView=[FYTransferActionView new];
        _qrCodeView.tag = 2;
        _qrCodeView.backgroundColor = [UIColor whiteColor];
        [self.topView addSubview:_qrCodeView];
        [_qrCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(0);
            make.left.mas_equalTo(self.view.mas_centerX);
        }];
    }
    return _qrCodeView;
}


#pragma mark UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableDataSource.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *tempView=[UIView new];
    tempView.backgroundColor = [UIColor whiteColor];
    UILabel *labelHeader=[UILabel new];
    labelHeader.frame=CGRectMake(20, 10, 200, 20);
    labelHeader.textColor = [UIColor blackColor];
    labelHeader.font = [UIFont systemFontOfSize:14];
    labelHeader.text = NSLocalizedString(@"最近收款人", nil);
    [tempView addSubview:labelHeader];
    return tempView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FYNearlySelectUserCell *cell=[tableView dequeueReusableCellWithIdentifier:@"FYNearlySelectUserCell"];
    FYContactSimpleModel *model=[self.tableDataSource objectAtIndex:indexPath.row];
    cell.labelName.text = APP_USER_REMARK_NAME(model.userId);
    cell.labelDetail.text = [NSString stringWithFormat:@"ID:%@", model.userId];
    [cell.imageAvatar sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    [cell updateUseSelected:[model.userId isEqualToString:self.currentSelectedUser.userId]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FYContactSimpleModel *model=[self.tableDataSource objectAtIndex:indexPath.row];
    self.currentSelectedUser = model;
    [tableView reloadData];
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_TRANSFER_MONEY;
}


#pragma mark - HTTP Method

- (void)HTTPToGetHistory
{
    WEAKSELF(weakSelf)
    PROGRESS_HUD_SHOW
    NSString *userID = [AppModel shareInstance].userInfo.userId;
    [NET_REQUEST_MANAGER requestWithAct:ActRequestTransferMoneyNearRecord parameters:@{ @"userId":userID } success:^(id resonse) {
        PROGRESS_HUD_DISMISS
        FYLog(@"Transfer History:%@", resonse);
        FYHTTPResponseModel *response=[FYHTTPResponseModel mj_objectWithKeyValues:resonse];
        if (response.data) {
            NSArray *historyData = [response.data valueForKey:@"transferRecordS"];
            NSArray *currentDatas = [FYContactSimpleModel mj_objectArrayWithKeyValuesArray:historyData];
            weakSelf.tableDataSource = currentDatas;
            [weakSelf.tableView reloadData];
            NSDictionary *ruleDict = [response.data valueForKey:@"transferSettingDTO"];
            if (ruleDict) {
                weakSelf.maxCount = [[ruleDict valueForKey:@"numberTimes"] integerValue];
                weakSelf.minMoney=[[ruleDict valueForKey:@"singleTransferMin"] integerValue];
                weakSelf.maxMoney=[[ruleDict valueForKey:@"singleTransferMax"] integerValue];
            }
        }
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
}

@end

