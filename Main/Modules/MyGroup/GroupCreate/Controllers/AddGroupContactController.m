//
//  AddGroupContactController.m
//  ProjectXZHB
//
//  Created by 汤姆 on 2019/7/30.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "AddGroupContactController.h"
#import "AddGroupContactCell.h"
#import "AddGroupContactHeadeerView.h"
#import "AddGroupSearchView.h"
#import "ContactModel.h"
#import "GroupNet.h"


static NSString *const kAddGroupContactCellID = @"kAddGroupContactCellID";

@interface AddGroupContactController ()
<UITableViewDelegate, UITableViewDataSource, AddGroupSearchDelegate,
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate>

/** 请求页码*/
@property (nonatomic, assign) NSInteger page;
/** 列表*/
@property (nonatomic, strong) UITableView *tableView;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 搜索*/
@property (nonatomic, strong) AddGroupSearchView *searchView;
/** 选择*/
@property (nonatomic, strong) NSMutableArray <ContactModel*>*selectedSource;
/** 头部*/
@property (nonatomic, strong) AddGroupContactHeadeerView *headerView;

@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation AddGroupContactController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BaseColor;
    
    [self setupNavItem];
    [self setupSubview];
}

- (void)setupNavItem {
    [self setupNavTitle];
    
    self.confirmBtn = [[UIButton alloc] init];
    [self.confirmBtn setTitle:NSLocalizedString(@"   确认  ", nil) forState:UIControlStateNormal];
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize2:13];
    self.confirmBtn.layer.masksToBounds = YES;
    self.confirmBtn.layer.cornerRadius = 6;
    self.confirmBtn.backgroundColor = COLOR_SYSTEM_MAIN_BUTTON_BACKGROUND_SELECT_DEFAULT;
    self.confirmBtn.width = 60;
    [self.confirmBtn addTarget:self action:@selector(addContact) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.confirmBtn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setupNavTitle {
    if (AppModel.shareInstance.isGroupOwner) {
        if (self.type == ControllerType_add) {
            self.navigationItem.title = NSLocalizedString(@"添加群成员", nil);
        }else {
            self.navigationItem.title = NSLocalizedString(@"删除群成员", nil);
        }
    }else {
        self.navigationItem.title = NSLocalizedString(@"添加群成员", nil);
    }
}

- (void)setupSubview {
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.left.right.equalTo(self.view);
       make.height.mas_equalTo(50);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    WeakSelf
    self.page = 1;
    [self loadGroupContact:@""];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [weakSelf loadGroupContact:@""];
    }];
}


#pragma mark - Request

- (void)loadGroupContact:(NSString *)userId {
    [SVProgressHUD show];
    if (self.type == ControllerType_delete) {
        NSDictionary *sender=@{
        @"queryParam": @{
                @"id": self.groupId,
                @"userIdOrNick": userId
                },
        @"current": @(self.page),
        @"size": @(20)
        };
        [NET_REQUEST_MANAGER querySelfDeleteGroupUsers:sender successBlock:^(NSDictionary *success) {
            [SVProgressHUD dismiss];
            NSArray *records = success[@"data"][@"records"];
            NSMutableArray *modelArray = [ContactModel mj_objectArrayWithKeyValuesArray:records];
            [self.dataSource addObjectsFromArray:modelArray];
            
            if (modelArray.count < 20) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.tableView.mj_footer endRefreshing];
            }
            
            [self.tableView reloadData];
        } failureBlock:^(NSError *failure) {
            [self.tableView.mj_footer endRefreshing];
            [[FunctionManager sharedInstance] handleFailResponse:failure];
        }];
        
    }else {
        NSDictionary *dict = @{@"current":@(self.page),
                               @"size": @20,
                               @"chatGroupId":self.groupId,
                               @"userIdOrNick":userId};
        [NET_REQUEST_MANAGER getNotIntoGroupPage:dict successBlock:^(NSDictionary *success) {
            [SVProgressHUD dismiss];
            NSArray *records = success[@"data"][@"records"];
            NSMutableArray *modelArray = [ContactModel mj_objectArrayWithKeyValuesArray:records];
            if (modelArray.count == 0) {
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [modelArray enumerateObjectsUsingBlock:^(ContactModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (self.selectedSource.count > 0) {
                        for (ContactModel *model in self.selectedSource) {
                            if ([obj.userId isEqualToString:model.userId]) {
                                obj.isSelected = model.isSelected;
                            }
                        }
                        
                        [self.dataSource addObject:obj];
                        
                    }else {
                        
                        [self.dataSource addObject:obj];
                    }
                }];
                
                if (modelArray.count < 20) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
                
                [self.tableView reloadData];
            }
            
        } failureBlock:^(NSError *failure) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            [[FunctionManager sharedInstance] handleFailResponse:failure];
        }];
    }
}

/// 分页查询群组中的用户，不包含群主自己
- (void)querySelfGroupUsers:(NSString *)sort {
    if (!sort.length) {
        sort = @"";
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(20) forKey:@"size"];
    [params setObject:@(self.page) forKey:@"current"];
    [params setObject:@(false) forKey:@"isAsc"];
    [params setObject:sort forKey:@"sort"];
    [params setObject:@{@"id": self.groupId} forKey:@"queryParam"];
    
    [SVProgressHUD show];
    [NET_REQUEST_MANAGER querySelfGroupUsers:params successBlock:^(NSDictionary *success) {
        if (success && [success[@"code"] integerValue] == 0) {
            [SVProgressHUD dismiss];
            NSDictionary *JSONData = [success[@"data"] mj_JSONObject];
            NSArray *records = JSONData[@"records"];
            NSMutableArray *modeList = [ContactModel mj_objectArrayWithKeyValuesArray:records];
            if (self.dataSource.count) {
                [self.dataSource removeAllObjects];
            }
            
            [self.dataSource addObjectsFromArray:modeList];
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *failure) {
        
        [[FunctionManager sharedInstance] handleFailResponse:failure];
    }];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddGroupContactCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddGroupContactCellID];
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count < indexPath.row) {
        return;
    }
    
    ContactModel *model = self.dataSource[indexPath.row];
    model.isSelected = !model.isSelected;
    if (model.isSelected) {
        [self.selectedSource insertObject:model atIndex:0];
    }else {
        [self.selectedSource enumerateObjectsUsingBlock:^(ContactModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.userId isEqualToString:obj.userId]) {
                [self.selectedSource removeObjectAtIndex:idx];
            }
        }];
    }
    
    if (self.selectedSource.count == 0) {
        [self.tableView reloadData];
    }else {
        if (self.selectedSource.count == 1) {
            //1.传入要刷新的组数
            NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:0];
            //2.传入NSIndexSet进行刷新
            [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
    self.headerView.dataSource = self.selectedSource;
  
    if (self.selectedSource.count > 0) {
        if (self.selectedSource.count > 99) {
            [self.confirmBtn setTitle:[NSString stringWithFormat:NSLocalizedString(@"   确认(99+) ", nil)] forState:UIControlStateNormal];
        }else {
            [self.confirmBtn setTitle:[NSString stringWithFormat:@"%@(%zd)",NSLocalizedString(@"确认", nil), (unsigned long)self.selectedSource.count] forState:UIControlStateNormal];
            }
        self.confirmBtn.width = 80;
        [self.confirmBtn layoutIfNeeded];
        
    }else {
        [self.confirmBtn setTitle:[NSString stringWithFormat:NSLocalizedString(@"   确认  ", nil)] forState:UIControlStateNormal];
        self.confirmBtn.width = 80;
        [self.confirmBtn layoutIfNeeded];
    }
    NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    [tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.selectedSource.count > 0 ? 55 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}


//添加通讯录好友
- (void)addContact {
    if (self.selectedSource.count == 0) {
        SVP_ERROR_STATUS(NSLocalizedString(@"请选择好友!", nil));
        return;
    }
    
    NSMutableArray *ids = [NSMutableArray array];
    [self.selectedSource enumerateObjectsUsingBlock:^(ContactModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [ids addObject:obj.userId];
    }];
    
    if (ids.count == 0) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"请至少选择一个群成员", nil)];
        return;
    }
    
    if (self.type == ControllerType_delete) {
        // 踢出群
        [[GroupNet alloc] deleteGroupMembersWithGroupId:self.groupId userIds:ids successBlock:^(NSDictionary *success) {
            if ([success[@"code"] integerValue] == 0 ) {
                SVP_SUCCESS_STATUS(success[@"alterMsg"]);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"addGroupContact" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                SVP_ERROR_STATUS(success[@"alterMsg"]);
            }
        } failureBlock:^(NSError *error) {
            
            [[FunctionManager sharedInstance] handleFailResponse:error];
        }];
    } else {
        // 邀请加入自建群
        NSDictionary *sender = @{@"id":self.groupId,
                                 @"userIds": ids};
        [NET_REQUEST_MANAGER selfGroupInvite:sender successBlock:^(NSDictionary *responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[@"code"] integerValue] == 0) {
                    NSString *alterMsg = responseObject[@"alterMsg"];
                    [SVProgressHUD showSuccessWithStatus:alterMsg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"addGroupContact" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        } failureBlock:^(NSError *failure) {
            
            [[FunctionManager sharedInstance] handleFailResponse:failure];
        }];
    }
}


#pragma mark - <AddGroupSearchDelegate>

- (void)addGroupSearchTitle:(NSString *)title {
    // 创建一个字符集对象, 包含所有的空格和换行字符
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    // 从字符串中过滤掉首尾的空格和换行, 得到一个新的字符串
    NSString *trimmedStr = [title stringByTrimmingCharactersInSet:set];
    [self.dataSource removeAllObjects];
    [self loadGroupContact:trimmedStr];
    //[self querySelfGroupUsers:trimmedStr];
}


#pragma mark - DZNEmptyDataSetSource && DZNEmptyDataSetDelegate

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *buttonTitle = NSLocalizedString(@"暂无数据", nil);
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:17],
                                 NSForegroundColorAttributeName: [UIColor colorWithHexString:@"cccccc"]
                                 };
    return [[NSAttributedString alloc] initWithString:buttonTitle attributes:attributes];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.dataSource.count == 0;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"state_empty"];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    // Do something
    [self loadGroupContact:@""];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return 5;
}

#pragma mark - Getter Private

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        [_tableView registerClass:[AddGroupContactCell class] forCellReuseIdentifier:kAddGroupContactCellID];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
      
    }
    return _tableView;
}


- (AddGroupContactHeadeerView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[AddGroupContactHeadeerView alloc]init];
    }
    return _headerView;
}


- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataSource;
}


- (NSMutableArray <ContactModel *>*)selectedSource {
    
    if (!_selectedSource) {
        
        _selectedSource = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _selectedSource;
}


- (AddGroupSearchView *)searchView {
    
    if (!_searchView) {
        _searchView = [[AddGroupSearchView alloc]init];
        _searchView.searchDelegate = self;
    }
    return _searchView;
}

#pragma mark - dealloc

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
