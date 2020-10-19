//
//  FYNNJiLuController.m
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/4.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FYNNJiLuController.h"
#import "FYNNGameJiLuCell.h"
#import "FYNNGameJiLuList.h"
static NSString * const kFYNNJILuCellId = @"kFYNNJILuCellId";
@interface FYNNJiLuController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <FYNNGameJiLuList *>*dataSoure;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *titleView;
@end

@implementation FYNNJiLuController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self setRefreshing];
}
- (void)setRefreshing{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataSoure removeAllObjects];
        [self getDatas];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getDatas];
    }];
}

- (void)initUI{
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.titleView = self.titleView;
    [self.titleView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.titleView);
    }];
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"游戏详情\n(%@期)", nil),self.period];
    [self.view addSubview:self.tableView];
    //富文本,改变期数文字的大小
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:title];
    [att addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:NSMakeRange(4, title.length - 4)];
    self.titleLab.attributedText = att;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)getDatas{
    [NET_REQUEST_MANAGER getRobGameDetailsChatId:self.chatId period:self.period type:self.type success:^(id object) {
        if ([object[@"code"] integerValue] == 0) {
            NSArray <FYNNGameJiLuList*>*lists = [FYNNGameJiLuList mj_objectArrayWithKeyValuesArray:object[@"data"]];
            [lists enumerateObjectsUsingBlock:^(FYNNGameJiLuList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.dataSoure addObject:obj];
            }];
        }
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } fail:^(id object) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [[FunctionManager sharedInstance]handleFailResponse:object];
    }];
}

#pragma mark - TableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[FYNNGameJiLuCell class] forCellReuseIdentifier:kFYNNJILuCellId];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc]init];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
     
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
// //返回列表每个分组section拥有cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSoure.count;
}

//配置每个cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 2.从缓存池中取出cell
    FYNNGameJiLuCell *cell = [tableView dequeueReusableCellWithIdentifier:kFYNNJILuCellId];
    if (self.dataSoure.count > indexPath.row) {
        cell.list = self.dataSoure[indexPath.row];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]init];
    header.layer.shadowColor = UIColor.blackColor.CGColor;
    header.layer.shadowOffset = CGSizeMake(0, 1);
    header.layer.shadowOpacity = 0.2;
    header.backgroundColor = UIColor.whiteColor;
    NSArray *titles = @[NSLocalizedString(@"昵称", nil),NSLocalizedString(@"抢包", nil),NSLocalizedString(@"点数", nil),NSLocalizedString(@"投注", nil),NSLocalizedString(@"盈亏", nil)];
    CGFloat w = SCREEN_WIDTH / 5;
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
- (NSMutableArray <FYNNGameJiLuList*>*)dataSoure{
    if (!_dataSoure) {
        _dataSoure = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSoure;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = UIColor.whiteColor;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont boldSystemFontOfSize:16];
        _titleLab.numberOfLines = 0;
    }
    return _titleLab;
}
- (UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2, 0, 200, 40)];
//        _titleView.backgroundColor = UIColor.whiteColor;
        if (@available(iOS 11.0, *)){
            _titleView.translatesAutoresizingMaskIntoConstraints = NO;
//            _titleView.intrinsicContentSize = CGSizeMake(200, 45);
//            _titleView.intrinsicContentSize = CGSizeMake(200, 45);
        }
    }
    return _titleView;
}
@end
