//
//  AllUserViewController.m
//  Project
//
//  Created by mini on 2018/8/16.
//  Copyright © 2018年 CDJay. All rights reserved.
//  群成员控制器

#import "AllUserViewController.h"
#import "UserTableViewCell.h"
#import "GroupInfoUserModel.h"
#import "GroupNet.h"

@interface AllUserViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) GroupNet *model;

@end

@implementation AllUserViewController

- (GroupNet *)model {
    
    if (!_model) {
        
        _model = [[GroupNet alloc] init];
    }
    return _model;
}

+ (AllUserViewController *)allUser:(id)obj {
    AllUserViewController *vc = [[AllUserViewController alloc]init];
    vc.model = obj;
    return vc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubview];
    [self makeLayout];
}

- (void)makeLayout {
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupSubview {
    self.view.backgroundColor = BaseColor;
    
    _tableView = [UITableView groupTable];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 73, 0, 0);
    _tableView.separatorColor = TBSeparaColor;
    _tableView.rowHeight = 70;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView reloadData];
    
    __weak GroupNet *weakModel = _model;
    __weak __typeof(self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        weakModel.page = 1;
        [strongSelf getGroupUsersData];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
       __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!weakModel.isMost) {
            if (weakModel.page < 1) {
                weakModel.page = 2;
            } else {
                weakModel.page++;
            }
            [strongSelf getGroupUsersData];
        }
    }];
}

#pragma mark - Request

/// 获取群组成员数据
- (void)getGroupUsersData {
    __weak __typeof(self)weakSelf = self;
    [self.model queryGroupUserGroupId:self.groupId successBlock:^(NSDictionary *info) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([info objectForKey:@"code"] && [[info objectForKey:@"code"] integerValue] == 0) {
            [strongSelf.tableView.mj_header endRefreshing];
            [strongSelf.tableView.mj_footer endRefreshing];
            [strongSelf.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
}


#pragma mark - <UITableViewDataSource && Delegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"user"];
    if (cell == nil) {
        cell = [[UserTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"user"];
    }
    cell.isDelete = self.isDelete;
    cell.obj = _model.dataList[indexPath.row];
    __weak __typeof(self)weakSelf = self;
    cell.deleteBtnBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf exit_group:[strongSelf.model.dataList[indexPath.row] objectForKey:@"userId"]];
        return;
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *object = _model.dataList[indexPath.row];
    GroupInfoUserModel *infoModel = [GroupInfoUserModel mj_objectWithKeyValues:object];
    if ([infoModel.userId isEqualToString:[AppModel shareInstance].userInfo.userId]) {
        return;
    }
    
    [PersonalSignatureVC pushFromVC:self requestParams:infoModel success:^(id data) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    return view;
}


#pragma mark - 移除群组确认
/**
 移除群组确认
 */
-(void)exit_group:(NSString *)userId {
    WEAK_OBJ(weakSelf, self);
    [[AlertViewCus createInstanceWithView:nil] showWithText:NSLocalizedString(@"确认移除该玩家？", nil) button1:NSLocalizedString(@"取消", nil) button2:NSLocalizedString(@"确认", nil) callBack:^(id object) {
        NSInteger tag = [object integerValue];
        if(tag == 1)
            [weakSelf action_exitGroup:userId];
    }];
}


#pragma mark - 删除群成员

- (void)action_exitGroup:(NSString *)userId {
    NSDictionary *parameters = @{
                                 @"chatGroupId":self.groupId,
                                 @"userId":@[userId],
                                 };
    
    __weak __typeof(self)weakSelf = self;
    [NET_REQUEST_MANAGER delgroupMember:parameters successBlock:^(NSDictionary *response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([response objectForKey:@"code"] && [[response objectForKey:@"code"] integerValue] == 0) {
            NSString *msg = [NSString stringWithFormat:@"%@",[response objectForKey:@"alterMsg"]];
            SVP_SUCCESS_STATUS(msg);
            strongSelf.model.page = 1;
            [strongSelf getGroupUsersData];
        } else {
            [[FunctionManager sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
