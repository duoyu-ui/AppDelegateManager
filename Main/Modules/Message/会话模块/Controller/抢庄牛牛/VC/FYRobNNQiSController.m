//
//  FYRobNNQiSController.m
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/3.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FYRobNNQiSController.h"
#import "FYRobNNJILuCell.h"
#import "FYRobNNJiLuModel.h"
#import "FYNNJiLuController.h"
@interface FYRobNNQiSController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray <FYRobNNJiLuRecords*>*dataSoure;
/** 页码 */
@property (nonatomic, assign) NSInteger page;

@end

@implementation FYRobNNQiSController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
    [self buidRefreshing];
}

- (void)buidRefreshing {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataSoure removeAllObjects];
        self.page = 1;
        [self loadRecordData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self loadRecordData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)makeUI {
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = NSLocalizedString(@"期数记录", nil);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Request

- (void)loadRecordData {
    
    [NET_REQUEST_MANAGER getRobPeriodRecordChatId:self.chatId page:self.page type:self.type success:^(id object) {
        if ([object[@"code"] integerValue] == 0) {
            NSArray <FYRobNNJiLuRecords*>*lists = [FYRobNNJiLuRecords mj_objectArrayWithKeyValuesArray:object[@"data"][@"records"]];
            [lists enumerateObjectsUsingBlock:^(FYRobNNJiLuRecords * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.dataSoure addObject:obj];
            }];
            if (lists.count < 40) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } fail:^(id object) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [[FunctionManager sharedInstance]handleFailResponse:object];
    }];
}

#pragma mark - Getter

- (NSMutableArray <FYRobNNJiLuRecords*>*)dataSoure {
    
    if (!_dataSoure) {
        
        _dataSoure = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSoure;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[FYRobNNJILuCell class] forCellReuseIdentifier:kFYRobNNJILuCellId];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
       
        }
    }
    
    return _tableView;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSoure.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    FYRobNNJILuCell *cell = [tableView dequeueReusableCellWithIdentifier:kFYRobNNJILuCellId forIndexPath:indexPath];
    if (self.dataSoure.count > indexPath.row){
        cell.model = self.dataSoure[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FYRobNNJiLuRecords *model = self.dataSoure[indexPath.row];
    if (model.period != nil) {
        FYNNJiLuController *vc = [[FYNNJiLuController alloc]init];
        vc.period = model.period;
        vc.type = self.type;
        vc.chatId = self.chatId;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]init];
    header.layer.shadowColor = UIColor.blackColor.CGColor;
    header.layer.shadowOffset = CGSizeMake(0, 1);
    header.layer.shadowOpacity = 0.2;
    header.backgroundColor = UIColor.whiteColor;
    NSArray *titles = @[NSLocalizedString(@"期数", nil),NSLocalizedString(@"庄家", nil),NSLocalizedString(@"点数", nil),NSLocalizedString(@"结果", nil)];
    CGFloat w = SCREEN_WIDTH / 4;
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lab = [[UILabel alloc]init];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = UIColor.blackColor;
        lab.textAlignment = NSTextAlignmentCenter;
        [header addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(w * idx);
            make.centerY.equalTo(header);
            make.width.mas_equalTo(w);
        }];
        lab.text = obj;
    }];
    
    return header;
}

@end
